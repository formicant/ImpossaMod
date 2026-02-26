    MODULE Drawing

; Draw scene objects with coordinate checks
drawObjectsChecked:  ; #c044
        ld ix, Scene.objects
        ld a, 2
        ld (State.objTileIndex), a
        ld b, 8
.object:
        push bc
        push ix
        call drawObjectChecked
        pop ix
        ld bc, Obj
        add ix, bc
        pop bc
        djnz .object
        ret


; Draw scene objects without coordinate checks
drawObjectsUnchecked:  ; #c060
        ld ix, Scene.objects
        ld a, 2
        ld (State.objTileIndex), a
        ld b, 8
.object:
        push bc
        push ix
        call drawObject
        pop ix
        ld bc, Obj
        add ix, bc
        pop bc
        djnz .object
        ret


; Draw an object with coordinate checks
drawObjectChecked:  ; #c07c
        ld l, (ix+Obj.x+0)
        ld h, (ix+Obj.x+1)            ; `hl`: x coord

        bit Flag.isBig, (ix+Obj.flags)
        jr NZ, .big

.small:
        ld bc, -16
        add hl, bc
        ret NC                  ; ret if < 16
        ld bc, -272
        add hl, bc
        ret C                   ; ret if >= 288
        jr .vertical

.big:   ; if big
        ld bc, -8
        add hl, bc
        ret NC                  ; ret if < 8
        ld bc, -280
        add hl, bc
        ret C                   ; ret if >= 288

.vertical:
        ld a, (ix+Obj.y)            ; y coord
        cp 224
        ret NC                  ; ret if y >= 224

        ld c, 21                ; big sprite height
        bit Flag.isBig, (ix+Obj.flags)
        jr NZ, .skip
        ld c, 16                ; small sprite height
.skip:
        add c                   ; `a`: bottom
        sub 32
        ret C
        ret Z                   ; ret if bottom <= 32
        ; continue


; Draw an object
drawObject:
        bit Flag.exists, (ix+Obj.flags)
        ret Z

        bit Flag.blink, (ix+Obj.flags)
        jr Z, .start
        res Flag.blink, (ix+Obj.flags)
        ret

.start:
        ld a, (ix+Obj.y)            ; y coord
        and %11111000
        ld b, 0
        ld c, a
        srl c
        ld e, a
        ld d, 0
        ld l, a
        ld h, 0
    .2  add hl, hl
        add hl, de
        add hl, bc
        ; `hl`: (y coord in tiles) * 44

        ld e, (ix+Obj.x+0)
        ld d, (ix+Obj.x+1)            ; `de`: x coord
    DUP 3
        srl d
        rr e
    EDUP
        ; `de`: x coord in tiles

        ld bc, Tables.scrTiles
        add hl, bc
        add hl, de
        ex de, hl
        ; `de`: addr in `Tables.scrTiles`
        ; `hl`: x coord in tiles

        ld a, (State.objTileIndex)
        ld l, a
        ld h, 0
   .3   add hl, hl
        ld bc, Tables.objTiles
        add hl, bc
        ; `hl`: tile addr in `Tables.objTiles`
        push hl : pop iy
        ; `iy`: tile addr in `Tables.objTiles`
        ld a, (ix+Obj.y)            ; y coord
        and %00000111
        ld c, a
        ld b, 0
        add iy, bc
        ; `iy`: pixel row addr in `Tables.objTiles`

        ex de, hl
        ; `de`: tile addr in `Tables.objTiles`
        ; `hl`: addr in `Tables.scrTiles`

        ld bc, #0303            ; big sprite size
        bit Flag.isBig, (ix+Obj.flags)
        jr NZ, .skip
        ld bc, #0202            ; small sprite size
.skip:
        ld a, (ix+Obj.x)
        and %00000111           ; `a`: x pixel shift
        jr Z, .skipWider
        inc b                   ; 1 tile wider
.skipWider:
        ld a, (ix+Obj.y)            ; y coord
        bit Flag.isBig, (ix+Obj.flags)
        jr NZ, .big
.small:
        and %00000111           ; `a`: y pixel shift
        jp Z, .skipTaller
        jp .taller
.big:
        and %00000111           ; `a`: y pixel shift
        cp 4
        jr C, .skipTaller
.taller:
        inc c                   ; 1 tile taller
.skipTaller:
        ; `bc`: sprite size in tiles (`b`: width, `c`: height)

        push hl
        push de
        push bc
        ld a, (ix+Obj.colour)            ; object attr
        ld (.attr), a
        exx
        ld a, (State.objTileIndex)
        ld l, a
        ld h, high(Tables.objTileAttrs)
        ; `hl`: addr in `Tables.objTileAttrs`
        exx
        ; `hl`: addr in `Tables.scrTiles`
.attrTileColumn:
        push hl
        push bc
.attrTile:
        ld a, (hl)              ; tile in `Tables.scrTiles`
        ld e, a
        ld d, high(Level.tileAttrs)
        ld a, (de)              ; tile attr
        exx
        ; `hl`: addr in `Tables.objTileAttrs`
        and %00111000           ; paper
        ld c, a
.attr+* ld a, -0                ; (ix+Obj.o_9), object attr
        and %01000111           ; bright and ink
        or c
        ld (hl), a              ; set object tile attr
        inc l
        exx
        ; `hl`: addr in `Tables.scrTiles`
        ld de, 44
        add hl, de              ; one tile row down
        dec c                   ; dec height
        jr NZ, .attrTile

        pop bc
        pop hl
        inc hl                  ; one tile to the right
        djnz .attrTileColumn

        pop bc                  ; size in tiles
        pop de                  ; tile addr in `Tables.objTiles`
        pop hl                  ; addr in `Tables.scrTiles`

.pixelTileColumn:
        push bc
        push hl
.pixelTile:
        push bc
        push hl
        ld c, (hl)              ; tile in `Tables.scrTiles`
        ld b, high(Level.tileTypes)
        ld a, (bc)              ; tile type
        and a
        jp P, .isBackground

.isForeground:
        ; don't draw
        ld bc, 8
        ex de, hl
        add hl, bc
        ex de, hl               ; `de`: next tile addr in `Tables.objTiles`
        ld a, (State.objTileIndex)
        inc a
        ld (State.objTileIndex), a    ; next object tile index
        jp .skipPixels

.isBackground:
        ; draw background
        ld bc, Tables.scrTileUpd - Tables.scrTiles
        add hl, bc              ; `hl`: addr in `Tables.scrTileUpd`
        ld a, (hl)              ; upd value
        ld c, a
        cp 2
        jr C, .notObjTile

        ; there'a already an object there, draw on top
        ld a, (State.objTileIndex)
        ld (hl), a              ; set object tile index
        inc a
        ld (State.objTileIndex), a    ; next object tile index
        ld l, c                 ; upd value
        ld h, 0
        ld bc, Tables.objTiles
        jp .copyBgPixels

.notObjTile:
        ld a, (State.objTileIndex)
        ld (hl), a              ; set object tile index
        inc a
        ld (State.objTileIndex), a    ; next object tile index
        ld bc, Tables.scrTiles - Tables.scrTileUpd
        add hl, bc              ; `hl`: addr in `Tables.scrTiles`
        ld l, (hl)              ; tile
        ld h, 0
        ld bc, Level.tilePixels

.copyBgPixels:
    .3  add hl, hl
        add hl, bc
        ; `hl`: addr of background object tile pixels or background tile pixels
        ; `de`: new addr in `Tables.objTiles`
    .8  ldi

.skipPixels:
        pop hl                  ; addr in `Tables.scrTiles`
        ld bc, 44
        add hl, bc              ; one tile row down
        pop bc
        dec c                   ; dec height
        jp NZ, .pixelTile

        pop hl                  ; addr in `Tables.scrTiles`
        inc hl                  ; one tile to the right
        pop bc
        djnz .pixelTileColumn

        bit Flag.isBig, (ix+Obj.flags)
        jp NZ, drawBigSprite
        ; continue

    ENDMODULE
