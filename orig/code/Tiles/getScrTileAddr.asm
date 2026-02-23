    MODULE Tiles

; Get addr in `Tables.scrTiles` for object
;   arg `ix`: object
;   ret `hl`: tile addr in `Tables.scrTiles`
;   spoils `af`
; Used by c_dce1, c_dd09, c_dd46, c_dd73, c_df85, c_f1d7, c_f2e7 and  c_f618.
getScrTileAddr:  ; #d460
        push bc
        push de
        ld a, (ix+Obj.y)
        cp 32
        jr NC, .l_0
        ld a, 33
        jr .l_1
.l_0:
        cp 224
        jr C, .l_1
        ld a, 223
.l_1:
        and %11111000           ; `a`: y coord clamped and floored to tiles
        ld l, a
        ld h, 0
        ld e, a
        ld d, h
        srl d
        rr e
        ld c, a
        ld b, h
    .2  add hl, hl
        add hl, bc
        add hl, de
        ld (.hl), hl            ; `a`/ 8 * 44 (row offset in Tables.scrTiles)

        ld l, (ix+Obj.x+0)
        ld h, (ix+Obj.x+1)
        ld a, (ix+Obj.objType)
        cp ObjType.pressPlatf
        jr Z, .divideBy8        ; (why?)
.checkLeftBound
        ld de, 32
        xor a
        sbc hl, de
        jr NC, .checkRightBound
        ld hl, 32
        jr .divideBy8
.checkRightBound:
        ld de, 256
        xor a
        sbc hl, de
        jp P, .l_3
        ld l, (ix+Obj.x+0)
        ld h, (ix+Obj.x+1)
        jr .divideBy8
.l_3:
        ld hl, 288
        ; `hl`: x coord clamped to visible screen
.divideBy8:
    DUP 3
        srl h
        rr l
    EDUP
        ex de, hl
        ; `de` x coord in tiles
.hl+*   ld hl, -0               ; row offset in Tables.scrTiles
        add hl, de
        ld de, Tables.scrTiles
        add hl, de
        ; `hl`: tile addr in `Tables.scrTiles`
        pop de
        pop bc
        ret

    ENDMODULE
