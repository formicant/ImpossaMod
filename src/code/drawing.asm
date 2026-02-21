    MODULE Code


; Draw scene objects with coordinate checks
; Used by c_cc25 and c_cdae.
drawObjectsChecked:  ; #c044
        ld ix, scene
        ld a, 2
        ld (objTileIndex), a
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
; Used by c_cdae.
drawObjectsUnchecked:  ; #c060
        ld ix, scene
        ld a, 2
        ld (objTileIndex), a
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
; Used by c_c044.
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
; Used by c_c060.
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

        ld bc, scrTiles
        add hl, bc
        add hl, de
        ex de, hl
        ; `de`: addr in `scrTiles`
        ; `hl`: x coord in tiles

        ld a, (objTileIndex)
        ld l, a
        ld h, 0
   .3   add hl, hl
        ld bc, objTiles
        add hl, bc
        ; `hl`: tile addr in `objTiles`
        push hl : pop iy
        ; `iy`: tile addr in `objTiles`
        ld a, (ix+Obj.y)            ; y coord
        and %00000111
        ld c, a
        ld b, 0
        add iy, bc
        ; `iy`: pixel row addr in `objTiles`

        ex de, hl
        ; `de`: tile addr in `objTiles`
        ; `hl`: addr in `scrTiles`

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
        ld a, (objTileIndex)
        ld l, a
        ld h, high(objTileAttrs)
        ; `hl`: addr in `objTileAttrs`
        exx
        ; `hl`: addr in `scrTiles`
.attrTileColumn:
        push hl
        push bc
.attrTile:
        ld a, (hl)              ; tile in `scrTiles`
        ld e, a
        ld d, high(Level.tileAttrs)
        ld a, (de)              ; tile attr
        exx
        ; `hl`: addr in `objTileAttrs`
        and %00111000           ; paper
        ld c, a
.attr+* ld a, -0                ; (ix+Obj.o_9), object attr
        and %01000111           ; bright and ink
        or c
        ld (hl), a              ; set object tile attr
        inc l
        exx
        ; `hl`: addr in `scrTiles`
        ld de, 44
        add hl, de              ; one tile row down
        dec c                   ; dec height
        jr NZ, .attrTile

        pop bc
        pop hl
        inc hl                  ; one tile to the right
        djnz .attrTileColumn

        pop bc                  ; size in tiles
        pop de                  ; tile addr in `objTiles`
        pop hl                  ; addr in `scrTiles`

.pixelTileColumn:
        push bc
        push hl
.pixelTile:
        push bc
        push hl
        ld c, (hl)              ; tile in `scrTiles`
        ld b, high(Level.tileTypes)
        ld a, (bc)              ; tile type
        and a
        jp P, .isBackground

.isForeground:
        ; don't draw
        ld bc, 8
        ex de, hl
        add hl, bc
        ex de, hl               ; `de`: next tile addr in `objTiles`
        ld a, (objTileIndex)
        inc a
        ld (objTileIndex), a    ; next object tile index
        jp .skipPixels

.isBackground:
        ; draw background
        ld bc, scrTileUpd - scrTiles
        add hl, bc              ; `hl`: addr in `scrTileUpd`
        ld a, (hl)              ; upd value
        ld c, a
        cp 2
        jr C, .notObjTile

        ; there'a already an object there, draw on top
        ld a, (objTileIndex)
        ld (hl), a              ; set object tile index
        inc a
        ld (objTileIndex), a    ; next object tile index
        ld l, c                 ; upd value
        ld h, 0
        ld bc, objTiles
        jp .copyBgPixels

.notObjTile:
        ld a, (objTileIndex)
        ld (hl), a              ; set object tile index
        inc a
        ld (objTileIndex), a    ; next object tile index
        ld bc, scrTiles - scrTileUpd
        add hl, bc              ; `hl`: addr in `scrTiles`
        ld l, (hl)              ; tile
        ld h, 0
        ld bc, Level.tilePixels

.copyBgPixels:
    .3  add hl, hl
        add hl, bc
        ; `hl`: addr of background object tile pixels or background tile pixels
        ; `de`: new addr in `objTiles`
    .8  ldi

.skipPixels:
        pop hl                  ; addr in `scrTiles`
        ld bc, 44
        add hl, bc              ; one tile row down
        pop bc
        dec c                   ; dec height
        jp NZ, .pixelTile

        pop hl                  ; addr in `scrTiles`
        inc hl                  ; one tile to the right
        pop bc
        djnz .pixelTileColumn

        bit Flag.isBig, (ix+Obj.flags)
        jp NZ, drawBigSprite
        ; continue


; Draw a small (16×16) sprite into `objTiles`
;   `ix`: object addr in `scene`
;   `iy`: pixel row addr in `objTiles`
; (Disables interrupts!)
drawSmallSprite:
        ld a, (ix+Obj.x)
        and %00000111           ; x pixel shift
        jr NZ, drawShiftedSmallSprite

        ld hl, #0000            ; `nop : nop`
        ld (.jrMir), hl
        bit Dir.left, (ix+Obj.mo.direction)
        jr NZ, .skip
        bit Flag.mirror, (ix+Obj.flags)
        jr NZ, .skip

        ld hl, #0A18            ; `jr .skipMirror`
        ld (.jrMir), hl
.skip:

        ld c, 24
        ld a, (ix+Obj.y)
        and %00000111           ; y pixel shift
        jr NZ, .yShift
        ld c, 16
.yShift:
        ld a, c                 ; offset of the tile to the right (16 or 24)
        ld (.off1), a
        ld (.off2), a

        call getSpriteAddr      ; `hl`: sprite addr

        di
        ld (.sp), sp
        ld sp, hl
        ld h, high(mirrorTable)
        ld a, 16                ; sprite pixel height

.pixelRow:
        exa
        pop de                  ; `e`: msk1, `d`: msk0
        pop bc                  ; `c`: spr1, `b`: spr0

.jrMir: jr .skipMirror          ; `jr` or `nop`
.mirror:
        ld a, e                 ; msk1
        ld l, d                 ; msk0
        ld e, (hl)              ; mirror(msk0)
        ld l, a                 ; msk1
        ld d, (hl)              ; mirror(msk1)
        ld a, c                 ; spr1
        ld l, b                 ; spr0
        ld c, (hl)              ; mirror(spr0)
        ld l, a                 ; spr1
        ld b, (hl)              ; mirror(spr1)
.skipMirror:

        ld a, (iy)              ; left tile pixel row
        and d                   ; draw msk
        or b                    ; draw spr
        ld (iy), a

.off1+2 ld a, (iy-0)            ; right tile pixel row
        and e                   ; draw msk
        or c                    ; draw spr
.off2+2 ld (iy-0), a

        inc iy                  ; move one pixel row down
        exa
        dec a
        jp NZ, .pixelRow

.sp+*   ld sp, -0
        ei
        ret


; Draw a small (16×16) sprite into `objTiles` with pixel shift
;   `ix`: object addr in `scene`
;   `iy`: pixel row addr in `objTiles`
;   `a`: pixel shift (1..7)
; (Disables interrupts!)
drawShiftedSmallSprite:  ; #c245
        ld b, a
    .3  add a
        add b                   ; `a`: jump size = (pixel shift) * 9
        ld (.jrSh), a

        ld hl, #0000            ; `nop : nop`
        ld (.jrMir), hl
        bit Dir.left, (ix+Obj.mo.direction)
        jr NZ, .skip
        bit Flag.mirror, (ix+Obj.flags)
        jr NZ, .skip

        ld hl, #0F18            ; `jr .pixelShift`
        ld (.jrMir), hl
.skip:

        ld c, 24
        ld a, (ix+Obj.y)
        and %00000111           ; y pixel shift
        jr NZ, .yShift
        ld c, 16
.yShift:
        ld a, c                 ; offset of the middle tile
        ld (.of11), a
        ld (.of12), a
        add a                   ; offset of the right tile
        ld (.of21), a
        ld (.of22), a

        call getSpriteAddr      ; `hl`: sprite addr

        di
        ld (.sp), sp
        ld sp, hl
        ld h, high(mirrorTable)
        ld ixh, 16              ; sprite pixel height

.pixelRow:
        pop de                  ; `e`: msk1, `d`: msk0
        pop hl                  ; `l`: spr1, `h`: spr0

.jrMir: jr .pixelShift          ; `jr` or `nop`
.mirror:
        ld b, h                 ; spr0
        ld c, l                 ; spr1
        ld h, high(mirrorTable)
        ld a, e                 ; msk1
        ld l, d                 ; msk0
        ld e, (hl)              ; mirror(msk0)
        ld l, a                 ; msk1
        ld d, (hl)              ; mirror(msk1)
        ld a, c                 ; spr1
        ld l, b                 ; spr0
        ld c, (hl)              ; mirror(spr0)
        ld l, a                 ; spr1
        ld h, (hl)              ; mirror(spr1)
        ld l, c                 ; mirror(spr0)

.pixelShift:
        ld a, #FF               ; msk padding
        exa
        xor a                   ; spr padding

.jrSh+1 jr $-0
    .9  nop
    DUP 7
        exa                     ; msk
        sll e
        rl d
        rla
        exa                     ; spr
        add hl, hl
        rla
    EDUP

        ld b, (iy)              ; left tile pixel row
        exa
        and b
        ld b, a                 ; draw msk
        exa
        or b                    ; draw spr
        ld (iy), a

.of11+2 ld a, (iy-0)            ; middle tile pixel row
        and d                   ; draw msk
        or h                    ; draw spr
.of12+2 ld (iy-0), a

.of21+2 ld a, (iy-0)            ; right tile pixel row
        and e                   ; draw msk1
        or l                    ; draw spr1
.of22+2 ld (iy-0), a

        inc iy                  ; move one pixel row down
        dec ixh
        jp NZ, .pixelRow

.sp+*   ld sp, -0
        ei
        ret


; Draw a big (24×21) sprite into `objTiles`
;   `ix`: object addr in `scene`
;   `iy`: pixel row addr in `objTiles`
; (Disables interrupts!)
drawBigSprite:  ; #c314
        ld a, (ix+Obj.x)
        and %00000111           ; x pixel shift
        jp NZ, drawShiftedBigSprite

        ld hl, #0000            ; `nop : nop`
        bit Dir.left, (ix+Obj.mo.direction)
        jr NZ, .skip
        bit Flag.mirror, (ix+Obj.flags)
        jr NZ, .skip

        ld hl, #2718            ; `jr .skipMirror`
.skip:
        ld (.jrMir), hl

        ld c, 32
        ld a, (ix+Obj.y)
        and %00000111           ; y pixel shift
        cp 4
        jr NC, .yShift
        ld c, 24
.yShift:
        ld a, c                 ; offset of the middle tile
        ld (.of11), a
        ld (.of12), a
        add a                   ; offset of the right tile
        ld (.of21), a
        ld (.of22), a

        call getSpriteAddr      ; `hl`: sprite addr

        di
        ld (.sp), sp
        ld sp, hl
        exx
        ld h, high(mirrorTable)
        exx
        ld ixh, 21              ; sprite pixel height

.pixelRow:
        pop de                  ; `e`: msk2, `d`: msk1
        pop bc                  ; `c`: msk0, `b`: spr0
        pop hl                  ; `l`: spr2, `h`: spr1

.jrMir: jr .skipMirror          ; `jr` or `nop`
.mirror:
        ld a, d
        exa
        ld a, h
        exx
        ld l, a
        ld a, (hl)
        exa
        ld l, a
        ld a, (hl)
        exx
        ld d, a
        exa
        ld h, a
        ld a, c
        exa
        ld a, e
        exx
        ld l, a
        ld a, (hl)
        exa
        ld l, a
        ld a, (hl)
        exx
        ld e, a
        exa
        ld c, a
        ld a, b
        exa
        ld a, l
        exx
        ld l, a
        ld a, (hl)
        exa
        ld l, a
        ld a, (hl)
        exx
        ld l, a
        exa
        ld b, a
.skipMirror:

        ld a, (iy)              ; left tile pixel row
        and c                   ; draw msk
        or b                    ; draw spr
        ld (iy), a

.of11+2 ld a, (iy-0)            ; middle tile pixel row
        and d                   ; draw msk
        or h                    ; draw spr
.of12+2 ld (iy-0), a

.of21+2 ld a, (iy-0)            ; right tile pixel row
        and e                   ; draw msk
        or l                    ; draw spr
.of22+2 ld (iy-0), a

        inc iy                  ; move one pixel row down
        dec ixh
        jp NZ, .pixelRow

.sp+*   ld sp, -0
        ei
        ret


; Draw a big (24×21) sprite into `objTiles`
;   `ix`: object addr in `scene`
;   `iy`: pixel row addr in `objTiles`
;   `a`: pixel shift (1..7)
; (Disables interrupts!)
drawShiftedBigSprite:  ; #c3ac
        ld b, a
    .2  add a
        ld c, a
        add b
        ld b, a
        ld a, c
        add a
        add b
        ; `a`: jump size = (pixel shift) * 13
        ld (.jrSh), a

        ld hl, #0000            ; `nop : nop`
        ld (.jrMir), hl
        bit Dir.left, (ix+Obj.mo.direction)
        jr NZ, .skip
        bit Flag.mirror, (ix+Obj.flags)
        jr NZ, .skip

        ld hl, #1418            ; `jr .pixelShift`
        ld (.jrMir), hl
.skip:

        ld c, 32
        ld a, (ix+Obj.y)
        and %00000111           ; y pixel shift
        cp 4
        jr NC, .yShift
        ld c, 24
.yShift:
        ld a, c                 ; offset of the middle-left tile
        ld (.of11), a
        ld (.of12), a
        add a                   ; offset of the middle-right tile
        ld (.of21), a
        ld (.of22), a
        add c                   ; offset of the right tile
        ld (.of31), a
        ld (.od32), a

        call getSpriteAddr      ; `hl`: sprite addr

        di
        ld (.sp), sp
        ld sp, hl
        ld ixh, 21              ; sprite pixel height

.pixelRow:
        pop de                  ; `e`: msk2, `d`: msk1
        pop hl                  ; `l`: msk0, `h`: spr0
        ld a, h
        exx
        pop hl                  ; `l`: spr2, `h`: spr1
        ld e, a                 ; `e`: spr0
        exx

.jrMir: jr .pixelShift          ; `jr` or `nop`
.mirror:
        ld h, high(mirrorTable)
        ld a, (hl)
        ld l, d
        ld d, (hl)
        ld l, e
        ld l, (hl)
        ld e, a
        exx
        ld b, h
        ld h, high(mirrorTable)
        ld a, (hl)
        ld l, b
        ld b, (hl)
        ld l, e
        ld l, (hl)
        ld e, a
        ld h, b
        exx

.pixelShift:
        ld h, #FF               ; msk padding
        exx
        ld d, #00               ; spr padding

.jrSh+1  jr $-0
    .13 nop
    DUP 7
        exx                     ; msk
        sll e
        rl d
        adc hl, hl
        exx                     ; spr
        add hl, hl
        ex de, hl
        adc hl, hl
        ex de, hl
    EDUP

        ld a, e
        exa
        ld a, d
        exx
        ld b, a

        ld a, (iy)              ; left tile pixel row
        and h                   ; draw msk
        or b                    ; draw spr
        ld (iy), a
        exa
        ld b, a

.of11+2 ld a, (iy-0)
        and l                   ; draw msk
        or b                    ; draw spr
.of12+2 ld (iy-0), a
        ld a, e
        exa
        ld a, d
        exx
                                ; middle-right tile pixel row
.of21+2 and (iy-0)              ; draw msk
        or h                    ; draw spr
.of22+2 ld (iy-0), a
        exa
                                ; right tile pixel row
.of31+2 and (iy-0)              ; draw msk
        or l                    ; draw spr
.od32+2 ld (iy-0), a

        inc iy                  ; move one pixel row down
        dec ixh
        jp NZ, .pixelRow

.sp+*   ld sp, -0
        ei
        ret


; Move screen tiles
; (Used in screen scrolling)
;   `hl'`: old visible area position in scrTiles
;   `hl`: new visible area position in in scrTiles
;   `de`: new visible area position in in scrTileUpd
; Used by c_cdae.
moveScreenTiles:  ; #c4c0
        exx
        ld de, Screen.pixels.row1
        exx
        ld ix, Screen.attrs.row1
        ld b, 3
.scrThird:
        push bc
        ld a, b
        cp 3
        ld a, 8
        jp NZ, .row
        dec a
.row:
        exa
        ld b, 32
.tile:
        ld a, (de)              ; `a`: upd (value in `scrTileUpd`)
        and a
        jp Z, .noUpdate
        dec a                   ; `a`: upd - 1
        jp NZ, .objTile
.update:
        ; upd = 1 (update)
        ld a, (hl)              ; new tile
        exx
        jp .drawTile

.noUpdate:
        ld a, (hl)              ; new tile
        exx
        cp (hl)                 ; compare with old tile
        jp NZ, .drawTile

.nextTile:
        inc hl
        inc e
        exx
        inc de
        inc hl
        inc ix
        djnz .tile

.nextRow:
        ; skip off-screen scrTiles
        ld bc, 12
        add hl, bc
        ex de, hl
        add hl, bc
        ex de, hl
        exx
        ld bc, 12
        add hl, bc
        exx
        exa
        dec a
        jp NZ, .row

.nextThird:
        exx
        ld bc, #800
        ex de, hl
        add hl, bc
        ex de, hl
        exx
        pop bc
        djnz .scrThird

        ret

.drawTile:
        push hl
        ; apply attribute
        ld l, a
        ld h, high(Level.tileAttrs)
        ld a, (hl)
        ld (ix), a              ; apply attr

        ; draw pixels
        ld h, 0
    .3  add hl, hl
        ld a, h
        add high(Level.tilePixels)
        ld h, a
.copyPixels:
        push de
    DUP 7
        ldi
        dec de
        inc d
    EDUP
        ldi
        pop de
        pop hl
        jp .nextTile

.objTile:
        push hl
        ld l, a
        inc l                   ; `l`: objTileIndex
        ld h, high(objTileAttrs)
        ld l, (hl)              ; object tile attr
        ld (ix), l              ; apply attr
        pop hl
        exx
        push hl
        ld l, a                 ; `l`: objTileIndex - 1
        ld h, 0
    .3  add hl, hl
        ld bc, objTiles + 8     ; (index - 1) compensation
        add hl, bc
        jp .copyPixels


; Update all visible screen tiles which need updating
; Used by c_cc25 and c_cdae.
updateScreenTiles:  ; #c561
        ; mark row ends with -1
        ld bc, #18FF            ; `b`: 24, `c`: -1
        ld hl, scrTileUpd.row1 + 36
        ld de, 44
.rowEnd:
        ld (hl), c
        add hl, de
        djnz .rowEnd
        ; mark screen third ends with -2
        ld a, -2
        ld (scrTileUpd.row7 + 36), a
        ld (scrTileUpd.row15 + 36), a
        ; mark screen end with -3
        ld a, -3
        ld (scrTileUpd.row23 + 36), a
        ld de, Screen.pixels.row1 - 1
        ld hl, scrTileUpd.row1 + 3

        ; scan through screen tiles
.tile:
        ld bc, 12               ; gap between visible rows in srcTileUpd
        xor a
.nextTile:
        inc e
        inc hl
.checkUpd:
        or (hl)                 ; `a`: upd (value from srcTileUpd)
        ; `a`: upd
        jp Z, .nextTile         ; if upd = 0 (no update), go to next tile

        inc a                   ; `a`: upd + 1
        jp NZ, .skip1
        ; if upd = -1 (row end marker)
        add hl, bc
        xor a
        jp .checkUpd            ; go to next row
.skip1:
        inc a                   ; `a`: upd + 2
        jp NZ, .skip2

        ; if upd = -2 (third end)
        ld a, d
        add 8
        ld d, a
        add hl, bc
        xor a
        jp .checkUpd            ; go to next row
.skip2:
        cp #FF                  ; if upd = -3,
        ret Z                   ;   exit

        cp 3                    ; if upd = 1 (update)
        jp Z, .update

.objTile:
        ; if upd >= 2 (object tile)
        ; `a`: objTileIndex + 2
        ld (hl), 1              ; set upd = 1 (update)
        push de
        push hl
        ld l, a
        ld h, 0
    .3  add hl, hl
        ld bc, objTiles - 8 * 2 ; (index + 2) compensation
        add hl, bc
        ; copy pixels to the screen
    DUP 7
        ldi
        dec de
        inc d
    EDUP
        ldi
        pop hl
        pop de

        ; apply attribute
        push de
        ld b, high(objTileAttrs)
    .2  dec a                   ; `a`: objTileIndex
        ld c, a
        ld a, (bc)              ; object tile attr
        ; calculate attr addr from pixel addr
        exa
        ld a, d
        and %00011000
    .3  rrca
        add high(Screen.attrs)
        ld d, a
        exa
        ld (de), a              ; apply attr
        pop de
        jp .tile                ; go to next tile

.update:
        ld (hl), 0              ; set upd = 0 (no update)
        push hl
        push de
        ; get addr in `scrTiles
        ld bc, scrTiles - scrTileUpd
        add hl, bc
        ld a, (hl)              ; tile index
        ld l, a
        exa
        ld h, 0
    .3  add hl, hl
        ld bc, Level.tilePixels
        add hl, bc
        ; copy tile pixels to the screen
    DUP 7
        ldi
        dec de
        inc d
    EDUP
        ldi
        pop de

        ; apply attribute
        push de
        ld a, d
        and %00011000
    .3  rrca
        add high(Screen.attrs)
        ld d, a
        exa
        ld l, a
        ld h, high(Level.tileAttrs)
        ld a, (hl)              ; tile attr
        ld (de), a              ; apply attr
        pop de
        pop hl
        jp .tile


; Fill entire `scrTileUpd` buffer with 1's (needs updating)
; (Disables interrupts!)
; Used by c_cd9b.
setScrTileUpd:  ; #c636
        di
        ld (.sp), sp
        ld sp, scrTileUpd.end
        ld hl, #0101
        ld b, 32
.row:
    .22 push hl
        djnz .row
.sp+*   ld sp, -0
        ei
        ret


; Print string
;   `de`: string address
;   `h`: y, `l`: x
;   `c`: attribute
printString:
        push ix
        ld a, c
        ld (.attr), a

        ; coords to screen and attr address
        ld a, h
    .3  rrca
        ld b, a
        and %11100000
        or l
        ld l, a
        ld ixl, a
        ld a, b
        and %00000011
        add high(Screen.attrs)
        ld ixh, a
        ld a, h
        and %00011000
        add high(Screen.start)
        ld h, a
        ; `hl`: screen addr
        ; `ix`: attr addr

.char:
        ld a, (de)
        and %01111111           ; `a`: ASCII char code
        sub '0'                 ; `a`: font char code
        call printChar

        ; apply attr
.attr+* ld (ix), -0

        ; check string end
        ld a, (de)
        and %10000000
        jr NZ, .end

        ; next char
        inc l
        inc ixl
        inc de
        jp .char

.end:
        pop ix
        ret


; Print a single character without attrs
;   arg `hl`: screen address
;       `a`: font char code (ASCII - 48)
;           (space is printed if `a` >= #B0)
;   spoils `af`, `bc`
printChar:
        add a
        jr C, .space
    .2  add a
        ld c, a
        ld b, high(Font.start) / 2
        rl b
        ; `bc`: char addr in the font
    DUP 7
        ld a, (bc)
        ld (hl), a
        inc h
        inc c
    EDUP
        ld a, (bc)
.last:
        ld (hl), a
        ld a, h
        sub 7
        ld h, a
        ret

.space:
        xor a
    DUP 7
        ld (hl), a
        inc h
    EDUP
        jp .last


    ENDMODULE
