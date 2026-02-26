    MODULE Drawing

; Move screen tiles
; (Used in screen scrolling)
;   `hl'`: old visible area position in Tables.scrTiles
;   `hl`: new visible area position in in Tables.scrTiles
;   `de`: new visible area position in in Tables.scrTileUpd
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
        ld a, (de)              ; `a`: upd (value in `Tables.scrTileUpd`)
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
        ; skip off-screen Tables.scrTiles
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
        ld h, high(Tables.objTileAttrs)
        ld l, (hl)              ; object tile attr
        ld (ix), l              ; apply attr
        pop hl
        exx
        push hl
        ld l, a                 ; `l`: objTileIndex - 1
        ld h, 0
    .3  add hl, hl
        ld bc, Tables.objTiles + 8     ; (index - 1) compensation
        add hl, bc
        jp .copyPixels


; Update all visible screen tiles which need updating
updateScreenTiles:  ; #c561
        ; mark row ends with -1
        ld bc, #18FF            ; `b`: 24, `c`: -1
        ld hl, Tables.scrTileUpd.row1 + 36
        ld de, 44
.rowEnd:
        ld (hl), c
        add hl, de
        djnz .rowEnd
        ; mark screen third ends with -2
        ld a, -2
        ld (Tables.scrTileUpd.row7 + 36), a
        ld (Tables.scrTileUpd.row15 + 36), a
        ; mark screen end with -3
        ld a, -3
        ld (Tables.scrTileUpd.row23 + 36), a
        ld de, Screen.pixels.row1 - 1
        ld hl, Tables.scrTileUpd.row1 + 3

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
        ld bc, Tables.objTiles - 8 * 2 ; (index + 2) compensation
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
        ld b, high(Tables.objTileAttrs)
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
        ; get addr in `Tables.scrTiles
        ld bc, Tables.scrTiles - Tables.scrTileUpd
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


; Fill entire `Tables.scrTileUpd` buffer with 1's (needs updating)
; (Disables interrupts!)
setScrTileUpd:  ; #c636
        di
        ld (.sp), sp
        ld sp, Tables.scrTileUpd.end
        ld hl, #0101
        ld b, 32
.row:
    .22 push hl
        djnz .row
.sp+*   ld sp, -0
        ei
        ret

    ENDMODULE
