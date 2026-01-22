    MODULE Code


; (Draw 8 objects?)
; Used by c_cc25 and c_cdae.
c_c044:  ; #c044
        ld ix, c_beb4
        ld a, 2
        ld (c_beb3), a
        ld b, 8
.l_0:
        push bc
        push ix
        call c_c07c
        pop ix
        ld bc, 50
        add ix, bc
        pop bc
        djnz .l_0
        ret

; (Draw 8 objects?)
; Used by c_cdae.
c_c060:  ; #c060
        ld ix, c_beb4
        ld a, 2
        ld (c_beb3), a
        ld b, 8
.l_0:
        push bc
        push ix
        call c_c07c.l_3
        pop ix
        ld bc, 50
        add ix, bc
        pop bc
        djnz .l_0
        ret

; (Drawing?)
; Used by c_c044.
c_c07c:  ; #c07c
        ld l, (ix+0)
        ld h, (ix+1)
        bit 1, (ix+5)
        jr NZ, .l_0
        ld bc, -16
        add hl, bc
        ret NC
        ld bc, -272
        add hl, bc
        ret C
        jr .l_1
.l_0:
        ld bc, -8
        add hl, bc
        ret NC
        ld bc, -280
        add hl, bc
        ret C
.l_1:
        ld a, (ix+2)
        cp #E0
        ret NC
        ld c, #15
        bit 1, (ix+5)
        jr NZ, .l_2
        ld c, #10
.l_2:
        add c
        sub #20
        ret C
        ret Z

; This entry point is used by c_c060.
.l_3:
        bit 0, (ix+5)
        ret Z
        bit 4, (ix+5)
        jr Z, .l_4
        res 4, (ix+5)
        ret
.l_4:
        ld a, (ix+2)
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
        ; `hl = (ix+2) * 5.5`
        ld e, (ix+0)
        ld d, (ix+1)
    DUP 3
        srl d
        rr e
    EDUP
        ld bc, scrTiles
        add hl, bc
        add hl, de
        ex de, hl
        ld a, (c_beb3)
        ld l, a
        ld h, 0
   .3   add hl, hl
        ld bc, b_6600
        add hl, bc
        push hl
        pop iy
        ld a, (ix+2)
        and %00000111
        ld c, a
        ld b, 0
        add iy, bc
        ex de, hl
        ld bc, #0303
        bit 1, (ix+5)
        jr NZ, .l_5
        ld bc, #0202
.l_5:
        ld a, (ix+0)
        and %00000111
        jr Z, .l_6
        inc b
.l_6:
        ld a, (ix+2)
        bit 1, (ix+5)
        jr NZ, .l_7
        and %00000111
        jp Z, .l_9
        jp .l_8
.l_7:
        and %00000111
        cp %00000100
        jr C, .l_9
.l_8:
        inc c
.l_9:
        push hl
        push de
        push bc
        ld a, (ix+9)
        ld (.a), a
        exx
        ld a, (c_beb3)
        ld l, a
        ld h, high(b_6b00)
        exx
.l_10:
        push hl
        push bc
.l_11:
        ld a, (hl)
        ld e, a
        ld d, high(Level.tileAttrs)
        ld a, (de)
        exx
        and #38                 ; paper
        ld c, a
.a+*    ld a, -0
        and #47                 ; bright and ink
        or c
        ld (hl), a
        inc l
        exx
        ld de, 44
        add hl, de
        dec c
        jr NZ, .l_11
        pop bc
        pop hl
        inc hl
        djnz .l_10
        pop bc
        pop de
        pop hl
.l_12:
        push bc
        push hl
.l_13:
        push bc
        push hl
        ld c, (hl)
        ld b, high(Level.tileTypes)
        ld a, (bc)
        and a
        jp P, .l_14
        ld bc, #0008
        ex de, hl
        add hl, bc
        ex de, hl
        ld a, (c_beb3)
        inc a
        ld (c_beb3), a
        jp .l_17
.l_14:
        ld bc, scrTileUpd - scrTiles
        add hl, bc
        ld a, (hl)
        ld c, a
        cp 2
        jr C, .l_15
        ld a, (c_beb3)
        ld (hl), a
        inc a
        ld (c_beb3), a
        ld l, c
        ld h, 0
        ld bc, b_6600
        jp .l_16
.l_15:
        ld a, (c_beb3)
        ld (hl), a
        inc a
        ld (c_beb3), a
        ld bc, scrTiles - scrTileUpd
        add hl, bc
        ld l, (hl)
        ld h, 0
        ld bc, Level.tilePixels
.l_16:
    .3  add hl, hl
        add hl, bc
    .8  ldi
.l_17:
        pop hl
        ld bc, #002C
        add hl, bc
        pop bc
        dec c
        jp NZ, .l_13
        pop hl
        inc hl
        pop bc
        djnz .l_12
        bit 1, (ix+5)
        jp NZ, c_c314
        ld a, (ix+0)
        and #07
        jr NZ, c_c245
        ld hl, #0000            ; `nop : nop`
        ld (.jr), hl
        bit 1, (ix+21)
        jr NZ, .l_18
        bit 6, (ix+5)
        jr NZ, .l_18
        ld hl, #0A18            ; `jr .l_21`
        ld (.jr), hl
.l_18:
        ld c, #18
        ld a, (ix+2)
        and #07
        jr NZ, .l_19
        ld c, #10
.l_19:
        ld a, c
        ld (.iy1), a
        ld (.iy2), a
        call c_e47a
        di
        ld (.sp), sp
        ld sp, hl
        ld h, #6A
        ld a, #10
.l_20:
        exa
        pop de
        pop bc
.jr:    jr .l_21
        ld a, e
        ld l, d
        ld e, (hl)
        ld l, a
        ld d, (hl)
        ld a, c
        ld l, b
        ld c, (hl)
        ld l, a
        ld b, (hl)
.l_21:
        ld a, (iy+0)
        and d
        or b
        ld (iy+0), a
.iy1+2  ld a, (iy-0)
        and e
        or c
.iy2+2  ld (iy-0), a
        inc iy
        exa
        dec a
        jp NZ, .l_20
.sp+*   ld sp, -0
        ei
        ret

; (Preparing sprite drawing?)
; Used by c_c07c.
c_c245:  ; #c245
        ld b, a
    .3  add a
        add b
        ld (.jr2), a
        ld hl, #0000            ; `nop : nop`
        ld (.jr1), hl
        bit 1, (ix+21)
        jr NZ, .l_0
        bit 6, (ix+5)
        jr NZ, .l_0
        ld hl, #0F18            ; `jr .l_3`
        ld (.jr1), hl
.l_0:
        ld c, #18
        ld a, (ix+2)
        and #07
        jr NZ, .l_1
        ld c, #10
.l_1:
        ld a, c
        ld (.iy1), a
        ld (.iy2), a
        add a
        ld (.iy3), a
        ld (.iy4), a
        call c_e47a
        di
        ld (.sp), sp
        ld sp, hl
        ld h, #6A
        ld ixh, #10
.l_2:
        pop de
        pop hl
.jr1:   jr .l_3
        ld b, h
        ld c, l
        ld h, #6A
        ld a, e
        ld l, d
        ld e, (hl)
        ld l, a
        ld d, (hl)
        ld a, c
        ld l, b
        ld c, (hl)
        ld l, a
        ld h, (hl)
        ld l, c
.l_3:
        ld a, #FF
        exa
        xor a
.l_4:
.jr2+1  jr .l_4
    .9  nop
    DUP 7
        exa
        sll e
        rl d
        rla
        exa
        add hl, hl
        rla
    EDUP
        ld b, (iy+0)
        exa
        and b
        ld b, a
        exa
        or b
        ld (iy+0), a
.iy1+2  ld a, (iy-0)
        and d
        or h
.iy2+2  ld (iy-0), a
.iy3+2  ld a, (iy-0)
        and e
        or l
.iy4+2  ld (iy-0), a
        inc iy
        dec ixh
        jp NZ, .l_2
.sp+*   ld sp, -0
        ei
        ret

; (Sprite drawing?)
; Used by c_c07c.
c_c314:  ; #c314
        ld a, (ix+0)
        and #07
        jp NZ, c_c3ac
        ld hl, #0000            ; `nop : nop`
        bit 1, (ix+21)
        jr NZ, .l_0
        bit 6, (ix+5)
        jr NZ, .l_0
        ld hl, #2718            ; `jr .l_3`
.l_0:
        ld (.jr), hl
        ld c, #20
        ld a, (ix+2)
        and #07
        cp #04
        jr NC, .l_1
        ld c, #18
.l_1:
        ld a, c
        ld (.iy1), a
        ld (.iy2), a
        add a
        ld (.iy3), a
        ld (.iy4), a
        call c_e47a
        di
        ld (.sp), sp
        ld sp, hl
        exx
        ld h, #6A
        exx
        ld ixh, #15
.l_2:
        pop de
        pop bc
        pop hl
.jr:    jr .l_3
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
.l_3:
        ld a, (iy+0)
        and c
        or b
        ld (iy+0), a
.iy1+2  ld a, (iy-0)
        and d
        or h
.iy2+2  ld (iy-0), a
.iy3+2  ld a, (iy-0)
        and e
        or l
.iy4+2  ld (iy-0), a
        inc iy
        dec ixh
        jp NZ, .l_2
.sp+*   ld sp, -0
        ei
        ret

; (Preparing sprite drawing?)
; Used by c_c314.
c_c3ac:  ; #c3ac
        ld b, a
        add a
        add a
        ld c, a
        add b
        ld b, a
        ld a, c
        add a
        add b
        ld (.jr2), a
        ld hl, #0000            ; `nop : nop`
        ld (.jr1), hl
        bit 1, (ix+21)
        jr NZ, .l_0
        bit 6, (ix+5)
        jr NZ, .l_0
        ld hl, #1418            ; `jr .l_3`
        ld (.jr1), hl
.l_0:
        ld c, #20
        ld a, (ix+2)
        and #07
        cp #04
        jr NC, .l_1
        ld c, #18
.l_1:
        ld a, c
        ld (.iy1), a
        ld (.iy2), a
        add a
        ld (.iy3), a
        ld (.iy4), a
        add c
        ld (.iy5), a
        ld (.iy6), a
        call c_e47a
        di
        ld (.sp), sp
        ld sp, hl
        ld ixh, #15
.l_2:
        pop de
        pop hl
        ld a, h
        exx
        pop hl
        ld e, a
        exx
.jr1:   jr .l_3
        ld h, #6A
        ld a, (hl)
        ld l, d
        ld d, (hl)
        ld l, e
        ld l, (hl)
        ld e, a
        exx
        ld b, h
        ld h, #6A
        ld a, (hl)
        ld l, b
        ld b, (hl)
        ld l, e
        ld l, (hl)
        ld e, a
        ld h, b
        exx
.l_3:
        ld h, #FF
        exx
        ld d, #00
.l_4:
.jr2+1  jr .l_4
    .13 nop
    DUP 7
        exx
        sll e
        rl d
        adc hl, hl
        exx
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
        ld a, (iy+0)
        and h
        or b
        ld (iy+0), a
        exa
        ld b, a
.iy1+2  ld a, (iy-0)
        and l
        or b
.iy2+2  ld (iy-0), a
        ld a, e
        exa
        ld a, d
        exx
.iy3+2  and (iy-0)
        or h
.iy4+2  ld (iy-0), a
        exa
.iy5+2  and (iy-0)
        or l
.iy6+2  ld (iy-0), a
        inc iy
        dec ixh
        jp NZ, .l_2
.sp+*   ld sp, -0
        ei
        ret


; Move screen tiles
;   `hl'`: old visible area position in scrTiles
;   `hl`: new visible area position in in scrTiles
;   `de`: new visible area position in in scrTileUpd
; Used by c_cdae.
c_c4c0:  ; #c4c0
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
        ld a, (de)
        and a
        jp Z, .l_3
        dec a
        jp NZ, .l_7
        ld a, (hl)
        exx
        jp .drawTile
.l_3:
        ld a, (hl)
        exx
        cp (hl)
        jp NZ, .drawTile
.back:
        inc hl
        inc e
        exx
        inc de
        inc hl
        inc ix
        djnz .tile
        
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
        ; apply attr
        ld l, a
        ld h, high(Level.tileAttrs)
        ld a, (hl)
        ld (ix), a
        
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
        jp .back
        
.l_7:
        push hl
        ld l, a
        inc l                   ; restore after `dec`
        ld h, high(b_6b00)
        ld l, (hl)              ; get attr
        ld (ix), l              ; apply attr
        pop hl
        exx
        push hl
        ld l, a
        ld h, 0
    .3  add hl, hl
        ld bc, b_6600 + 8
        add hl, bc
        jp .copyPixels


; Tile drawing?
; Used by c_cc25 and c_cdae.
c_c561:  ; #c561
        ; mark row ends with -1
        ld bc, #18FF            ; `b`: 24, `c`: -1
        ld hl, scrTileUpd.row1 + 36
        ld de, 44
.l_0:
        ld (hl), c
        add hl, de
        djnz .l_0
        
        ; mark screen third ends with -2
        ld a, -2
        ld (scrTileUpd.row7 + 36), a
        ld (scrTileUpd.row15 + 36), a
        ; mark screen end with -3
        ld a, -3
        ld (scrTileUpd.row23 + 36), a
        ld de, Screen.pixels.row1 - 1
        ld hl, scrTileUpd.row1 + 3
.l_1:
        ld bc, #000C
        xor a
.l_2:
        inc e
        inc hl
.l_3:
        or (hl)
        jp Z, .l_2
        inc a
        jp NZ, .l_4
        add hl, bc
        xor a
        jp .l_3
.l_4:
        inc a
        jp NZ, .l_5
        ld a, d
        add #08
        ld d, a
        add hl, bc
        xor a
        jp .l_3
.l_5:
        cp #FF
        ret Z
        cp 3
        jp Z, .l_6
        ld (hl), 1
        push de
        push hl
        ld l, a
        ld h, 0
    .3  add hl, hl
        ld bc, b_6600 - 16
        add hl, bc
    DUP 7
        ldi
        dec de
        inc d
    EDUP
        ldi
        pop hl
        pop de
        push de
        ld b, high(b_6b00)
        dec a
        dec a
        ld c, a
        ld a, (bc)
        exa
        ld a, d
        and #18
    .3  rrca
        add #58
        ld d, a
        exa
        ld (de), a
        pop de
        jp .l_1
.l_6:
        ld (hl), #00
        push hl
        push de
        ld bc, scrTiles - scrTileUpd
        add hl, bc
        ld a, (hl)
        ld l, a
        exa
        ld h, 0
        add hl, hl
        add hl, hl
        add hl, hl
        ld bc, Level.tilePixels
        add hl, bc
    DUP 7
        ldi
        dec de
        inc d
    EDUP
        ldi
        pop de
        push de
        ld a, d
        and #18
    .3  rrca
        add high(Screen.attrs)
        ld d, a
        exa
        ld l, a
        ld h, high(Level.tileAttrs)
        ld a, (hl)
        ld (de), a
        pop de
        pop hl
        jp .l_1


; Fills buffer at #6080 with 1408 ones
; Used by c_cd9b.
c_c636:  ; #c636
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

; Life indicator attributes (3 red, 4 green, 10 blue)
lifeIndicatorAttrs:  ; #c660
        dh 42 42 42 44 44 44 44 41 41 41 41 41 41 41 41 41 41

; Copies life indicator attributes to the screen
; Used by c_d04e.
applyLifeIndicatorAttrs:  ; #c671
        ld hl, lifeIndicatorAttrs
        ld de, Screen.attrs + 15
        ld bc, 17
        ldir
        ret


; Prints string
;   `de`: string address
;   `h`: y, `l`: x
;   `c`: attribute
; Used by c_c76f, c_c9ac, c_cd22, c_cd5c, c_cf85, c_cfe6, c_d026,
; c_d04e, c_d553, c_d62c, c_d6c0 and c_e9b1.
printString:  ; #c67d
        push bc
        ld a, h
        and %00011000
        or  high(Screen.pixels)
        ld b, h
        ld h, a
        ; `h`: screen pixel addr high byte

        ld a, b
        and %00000111
    .3  rrca
        or l
        ld l, a
        ; `l`: screen pixel and attr addr low byte

        push hl
        exx
        pop hl
        ld a, h
        and %00011000
    .3  rrca
        add high(Screen.attrs)
        ld h, a
        pop bc
        exx
        ; `h'`: screen attr addr high byte

.l_0:
        push de, hl
        ld a, (de)
        res 7, a
        ; `a`: ASCII char code

        ex de, hl
        cp ' '
        jr NZ, .l_1
        xor a
        jr .l_2
.l_1:
        sub 39
        cp 21
        jr C, .l_2
        sub 5
.l_2:
        ; `a`: font char code
        ld l, a
        ld h, 0
    .3  add hl, hl
        ld de, Common.font
        add hl, de
        ex de, hl
        ; `de`: addr in font

        pop hl
        push hl

        ; draw char
        ld b, 8
.l_3:
        ld a, (de)
        ld (hl), a
        inc h
        inc de
        djnz .l_3

        ; set attr
        exx
        ld (hl), c

        ; next char
        inc hl
        exx
        pop hl
        inc hl
        pop de
        ld a, (de)
        bit 7, a
        ret NZ
        inc de
        jr .l_0


    ENDMODULE
