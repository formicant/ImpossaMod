    MODULE Code


c_beb3      EQU #BEB3
c_beb4      EQU #BEB4

; (Draw 8 objects?)

; Used by c_cc25 and c_cdae.
c_c044:  ; #c044
        ld ix, c_beb4
        ld a, #02
        ld (c_beb3), a
        ld b, #08
.l_0:
        push bc
        push ix
        call c_c07c
        pop ix
        ld bc, #0032
        add ix, bc
        pop bc
        djnz .l_0
        ret

; (Draw 8 objects?)

; Used by c_cdae.
c_c060:  ; #c060
        ld ix, c_beb4
        ld a, #02
        ld (c_beb3), a
        ld b, #08
.l_0:
        push bc
        push ix
        call c_c07c.l_3
        pop ix
        ld bc, #0032
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
        ld bc, #FFF0
        add hl, bc
        ret NC
        ld bc, #FEF0
        add hl, bc
        ret C
        jr .l_1
.l_0:
        ld bc, #FFF8
        add hl, bc
        ret NC
        ld bc, #FEE8
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
        add a, c
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
        and #F8
        ld b, #00
        ld c, a
        srl c
        ld e, a
        ld d, #00
        ld l, a
        ld h, #00
        add hl, hl
        add hl, hl
        add hl, de
        add hl, bc
        ld e, (ix+0)
        ld d, (ix+1)
        srl d
        rr e
        srl d
        rr e
        srl d
        rr e
        ld bc, #5B00
        add hl, bc
        add hl, de
        ex de, hl
        ld a, (c_beb3)
        ld l, a
        ld h, #00
        add hl, hl
        add hl, hl
        add hl, hl
        ld bc, #6600
        add hl, bc
        push hl
        pop iy
        ld a, (ix+2)
        and #07
        ld c, a
        ld b, #00
        add iy, bc
        ex de, hl
        ld bc, #0303
        bit 1, (ix+5)
        jr NZ, .l_5
        ld bc, #0202
.l_5:
        ld a, (ix+0)
        and #07
        jr Z, .l_6
        inc b
.l_6:
        ld a, (ix+2)
        bit 1, (ix+5)
        jr NZ, .l_7
        and #07
        jp Z, .l_9
        jp .l_8
.l_7:
        and #07
        cp #04
        jr C, .l_9
.l_8:
        inc c
.l_9:
        push hl
        push de
        push bc
        ld a, (ix+9)
        ld (#C153), a
        exx
        ld a, (c_beb3)
        ld l, a
        ld h, #6B
        exx
.l_10:
        push hl
        push bc
.l_11:
        ld a, (hl)
        ld e, a
        ld d, #74
        ld a, (de)
        exx
        and #38
        ld c, a
        ld a, #00
        and #47
        or c
        ld (hl), a
        inc l
        exx
        ld de, #002C
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
        ld b, #75
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
        ld bc, #0580
        add hl, bc
        ld a, (hl)
        ld c, a
        cp #02
        jr C, .l_15
        ld a, (c_beb3)
        ld (hl), a
        inc a
        ld (c_beb3), a
        ld l, c
        ld h, #00
        ld bc, #6600
        jp .l_16
.l_15:
        ld a, (c_beb3)
        ld (hl), a
        inc a
        ld (c_beb3), a
        ld bc, #FA80
        add hl, bc
        ld l, (hl)
        ld h, #00
        ld bc, Level.start
.l_16:
        add hl, hl
        add hl, hl
        add hl, hl
        add hl, bc
        ldi
        ldi
        ldi
        ldi
        ldi
        ldi
        ldi
        ldi
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
        ld hl, #0000
        ld (#C21D), hl
        bit 1, (ix+21)
        jr NZ, .l_18
        bit 6, (ix+5)
        jr NZ, .l_18
        ld hl, #0A18
        ld (#C21D), hl
.l_18:
        ld c, #18
        ld a, (ix+2)
        and #07
        jr NZ, .l_19
        ld c, #10
.l_19:
        ld a, c
        ld (#C233), a
        ld (#C238), a
        call c_e47a
        di
        ld (#C241), sp
        ld sp, hl
        ld h, #6A
        ld a, #10
.l_20:
        exa
        pop de
        pop bc
        jr .l_21
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
        ld a, (iy+0)
        and e
        or c
        ld (iy+0), a
        inc iy
        exa
        dec a
        jp NZ, .l_20
        ld sp, #0000
        ei
        ret

; (Preparing sprite drawing?)

; Used by c_c07c.
c_c245:  ; #c245
        ld b, a
        add a, a
        add a, a
        add a, a
        add a, b
        ld (#C2A4), a
        ld hl, #0000
        ld (#C28E), hl
        bit 1, (ix+21)
        jr NZ, .l_0
        bit 6, (ix+5)
        jr NZ, .l_0
        ld hl, #0F18
        ld (#C28E), hl
.l_0:
        ld c, #18
        ld a, (ix+2)
        and #07
        jr NZ, .l_1
        ld c, #10
.l_1:
        ld a, c
        ld (#C2FA), a
        ld (#C2FF), a
        add a, a
        ld (#C302), a
        ld (#C307), a
        call c_e47a
        di
        ld (#C310), sp
        ld sp, hl
        ld h, #6A
        ld ixh, #10
.l_2:
        pop de
        pop hl
        jr .l_3
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
        jr .l_4
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        exa
        sll e
        rl d
        rla
        exa
        add hl, hl
        rla
        exa
        sll e
        rl d
        rla
        exa
        add hl, hl
        rla
        exa
        sll e
        rl d
        rla
        exa
        add hl, hl
        rla
        exa
        sll e
        rl d
        rla
        exa
        add hl, hl
        rla
        exa
        sll e
        rl d
        rla
        exa
        add hl, hl
        rla
        exa
        sll e
        rl d
        rla
        exa
        add hl, hl
        rla
        exa
        sll e
        rl d
        rla
        exa
        add hl, hl
        rla
        ld b, (iy+0)
        exa
        and b
        ld b, a
        exa
        or b
        ld (iy+0), a
        ld a, (iy+0)
        and d
        or h
        ld (iy+0), a
        ld a, (iy+0)
        and e
        or l
        ld (iy+0), a
        inc iy
        dec ixh
        jp NZ, .l_2
        ld sp, #0000
        ei
        ret

; (Sprite drawing?)

; Used by c_c07c.
c_c314:  ; #c314
        ld a, (ix+0)
        and #07
        jp NZ, c_c3ac
        ld hl, #0000
        bit 1, (ix+21)
        jr NZ, .l_0
        bit 6, (ix+5)
        jr NZ, .l_0
        ld hl, #2718
.l_0:
        ld (#C35F), hl
        ld c, #20
        ld a, (ix+2)
        and #07
        cp #04
        jr NC, .l_1
        ld c, #18
.l_1:
        ld a, c
        ld (#C392), a
        ld (#C397), a
        add a, a
        ld (#C39A), a
        ld (#C39F), a
        call c_e47a
        di
        ld (#C3A8), sp
        ld sp, hl
        exx
        ld h, #6A
        exx
        ld ixh, #15
.l_2:
        pop de
        pop bc
        pop hl
        jr .l_3
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
        ld a, (iy+0)
        and d
        or h
        ld (iy+0), a
        ld a, (iy+0)
        and e
        or l
        ld (iy+0), a
        inc iy
        dec ixh
        jp NZ, .l_2
        ld sp, #0000
        ei
        ret

; (Preparing sprite drawing?)

; Used by c_c314.
c_c3ac:  ; #c3ac
        ld b, a
        add a, a
        add a, a
        ld c, a
        add a, b
        ld b, a
        ld a, c
        add a, a
        add a, b
        ld (#C421), a
        ld hl, #0000
        ld (#C405), hl
        bit 1, (ix+21)
        jr NZ, .l_0
        bit 6, (ix+5)
        jr NZ, .l_0
        ld hl, #1418
        ld (#C405), hl
.l_0:
        ld c, #20
        ld a, (ix+2)
        and #07
        cp #04
        jr NC, .l_1
        ld c, #18
.l_1:
        ld a, c
        ld (#C49B), a
        ld (#C4A0), a
        add a, a
        ld (#C4A7), a
        ld (#C4AB), a
        add a, c
        ld (#C4AF), a
        ld (#C4B3), a
        call c_e47a
        di
        ld (#C4BC), sp
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
        jr .l_3
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
        jr .l_4
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        exx
        sll e
        rl d
        adc hl, hl
        exx
        add hl, hl
        ex de, hl
        adc hl, hl
        ex de, hl
        exx
        sll e
        rl d
        adc hl, hl
        exx
        add hl, hl
        ex de, hl
        adc hl, hl
        ex de, hl
        exx
        sll e
        rl d
        adc hl, hl
        exx
        add hl, hl
        ex de, hl
        adc hl, hl
        ex de, hl
        exx
        sll e
        rl d
        adc hl, hl
        exx
        add hl, hl
        ex de, hl
        adc hl, hl
        ex de, hl
        exx
        sll e
        rl d
        adc hl, hl
        exx
        add hl, hl
        ex de, hl
        adc hl, hl
        ex de, hl
        exx
        sll e
        rl d
        adc hl, hl
        exx
        add hl, hl
        ex de, hl
        adc hl, hl
        ex de, hl
        exx
        sll e
        rl d
        adc hl, hl
        exx
        add hl, hl
        ex de, hl
        adc hl, hl
        ex de, hl
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
        ld a, (iy+0)
        and l
        or b
        ld (iy+0), a
        ld a, e
        exa
        ld a, d
        exx
        and (iy+0)
        or h
        ld (iy+0), a
        exa
        and (iy+0)
        or l
        ld (iy+0), a
        inc iy
        dec ixh
        jp NZ, .l_2
        ld sp, #0000
        ei
        ret

; Tile drawing?

; Used by c_cdae.
c_c4c0:  ; #c4c0
        exx
        ld de, #4020
        exx
        ld ix, #5820
        ld b, #03
.l_0:
        push bc
        ld a, b
        cp #03
        ld a, #08
        jp NZ, .l_1
        dec a
.l_1:
        exa
        ld b, #20
.l_2:
        ld a, (de)
        and a
        jp Z, .l_3
        dec a
        jp NZ, .l_7
        ld a, (hl)
        exx
        jp .l_5
.l_3:
        ld a, (hl)
        exx
        cp (hl)
        jp NZ, .l_5
.l_4:
        inc hl
        inc e
        exx
        inc de
        inc hl
        inc ix
        djnz .l_2
        ld bc, #000C
        add hl, bc
        ex de, hl
        add hl, bc
        ex de, hl
        exx
        ld bc, #000C
        add hl, bc
        exx
        exa
        dec a
        jp NZ, .l_1
        exx
        ld bc, #0800
        ex de, hl
        add hl, bc
        ex de, hl
        exx
        pop bc
        djnz .l_0
        ret
.l_5:
        push hl
        ld l, a
        ld h, #74
        ld a, (hl)
        ld (ix+0), a
        ld h, #00
        add hl, hl
        add hl, hl
        add hl, hl
        ld a, h
        add a, #6C
        ld h, a
.l_6:
        push de
        ldi
        dec de
        inc d
        ldi
        dec de
        inc d
        ldi
        dec de
        inc d
        ldi
        dec de
        inc d
        ldi
        dec de
        inc d
        ldi
        dec de
        inc d
        ldi
        dec de
        inc d
        ldi
        pop de
        pop hl
        jp .l_4
.l_7:
        push hl
        ld l, a
        inc l
        ld h, #6B
        ld l, (hl)
        ld (ix+0), l
        pop hl
        exx
        push hl
        ld l, a
        ld h, #00
        add hl, hl
        add hl, hl
        add hl, hl
        ld bc, #6608
        add hl, bc
        jp .l_6

; Tile drawing?

; Used by c_cc25 and c_cdae.
c_c561:  ; #c561
        ld bc, #18FF
        ld hl, #6180
        ld de, #002C
.l_0:
        ld (hl), c
        add hl, de
        djnz .l_0
        ld a, #FE
        ld (#6288), a
        ld (#63E8), a
        ld a, #FD
        ld (#6548), a
        ld de, #401F
        ld hl, #615F
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
        add a, #08
        ld d, a
        add hl, bc
        xor a
        jp .l_3
.l_5:
        cp #FF
        ret Z
        cp #03
        jp Z, .l_6
        ld (hl), #01
        push de
        push hl
        ld l, a
        ld h, #00
        add hl, hl
        add hl, hl
        add hl, hl
        ld bc, #65F0
        add hl, bc
        ldi
        dec de
        inc d
        ldi
        dec de
        inc d
        ldi
        dec de
        inc d
        ldi
        dec de
        inc d
        ldi
        dec de
        inc d
        ldi
        dec de
        inc d
        ldi
        dec de
        inc d
        ldi
        pop hl
        pop de
        push de
        ld b, #6B
        dec a
        dec a
        ld c, a
        ld a, (bc)
        exa
        ld a, d
        and #18
        rrca
        rrca
        rrca
        add a, #58
        ld d, a
        exa
        ld (de), a
        pop de
        jp .l_1
.l_6:
        ld (hl), #00
        push hl
        push de
        ld bc, #FA80
        add hl, bc
        ld a, (hl)
        ld l, a
        exa
        ld h, #00
        add hl, hl
        add hl, hl
        add hl, hl
        ld bc, Level.start
        add hl, bc
        ldi
        dec de
        inc d
        ldi
        dec de
        inc d
        ldi
        dec de
        inc d
        ldi
        dec de
        inc d
        ldi
        dec de
        inc d
        ldi
        dec de
        inc d
        ldi
        dec de
        inc d
        ldi
        pop de
        push de
        ld a, d
        and #18
        rrca
        rrca
        rrca
        add a, #58
        ld d, a
        exa
        ld l, a
        ld h, #74
        ld a, (hl)
        ld (de), a
        pop de
        pop hl
        jp .l_1

; Fill buffer at #6080 with 1408 ones

; Used by c_cd9b.
c_c636:  ; #c636
        di
        ld (#C65C), sp
        ld sp, #6600
        ld hl, #0101
        ld b, #20
.l_0:
        push hl
        push hl
        push hl
        push hl
        push hl
        push hl
        push hl
        push hl
        push hl
        push hl
        push hl
        push hl
        push hl
        push hl
        push hl
        push hl
        push hl
        push hl
        push hl
        push hl
        push hl
        push hl
        djnz .l_0
        ld sp, #0000
        ei
        ret

; Life indicator attrs
c_c660:  ; #c660
        db #42, #42, #42, #44, #44, #44, #44, #41
        db #41, #41, #41, #41, #41, #41, #41, #41
        db #41

; Copy life indicator attrs to the screen

; Used by c_d04e.
c_c671:  ; #c671
        ld hl, c_c660
        ld de, #580F
        ld bc, #0011
        ldir
        ret


; Print string
;   `de`: string address
;   `h`: y, `l`: x
;   `c`: attribute
; Used by c_c76f, c_c9ac, c_cd22, c_cd5c, c_cf85, c_cfe6, c_d026,
; c_d04e, c_d553, c_d62c, c_d6c0 and c_e9b1.
printString:  ; #c67d
        push bc
        ld a, h
        and %00011000
        or  high(Screen.start)
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
        add a, high(Screen.attrs)
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


; Attribute address of active menu item
c_c6d3:  ; #c6d3
        dw #592B

; Game menu
; Used by c_cc25.
c_c6d5:  ; #c6d5
        xor a
        call callPlayMenuMusic
        call clearScreenPixels
        ld a, #47
        call fillScreenAttrs
        ld a, #00
        out (#FE), a
        call c_c76f
        call c_c7e1
.l_0:
        call c_bdfa
        jr NZ, .l_1
        xor a
        call callPlayMenuMusic
.l_1:
        ld a, (c_c8f6)
        exa
        ld bc, #F7FE
        in a, (c)
        and #1F
        bit 0, a
        jr NZ, .l_2
        exa
        or a
        jr Z, .l_6
        ld hl, #592B
        xor a
        jr .l_5
.l_2:
        bit 1, a
        jr NZ, .l_3
        exa
        cp #01
        jr Z, .l_6
        ld hl, #594B
        ld a, #01
        jr .l_5
.l_3:
        bit 2, a
        jr NZ, .l_4
        exa
        cp #02
        jr Z, .l_6
        ld hl, #596B
        ld a, #02
        jr .l_5
.l_4:
        bit 3, a
        jr NZ, .l_6
        exa
        cp #03
        jr Z, .l_6
        ld hl, #598B
        ld a, #03
.l_5:
        ld (c_c6d3), hl
        ld (c_c8f6), a
        call c_c76f
        call c_c7e1
.l_6:
        ld hl, (c_c6d3)
        ld b, #0C
.l_7:
        ld a, (hl)
        inc a
        cp #48
        jr C, .l_8
        ld a, #41
.l_8:
        ld (hl), a
        inc l
        djnz .l_7
        ld bc, #0014
        call delay
        call c_c8d2
        jp NZ, .l_0
.l_9:
        call c_c8d2
        jr Z, .l_9
        ld a, 1
        call callPlayMenuMusic
        ret

; Print game menu text

; Used by c_c6d5.
c_c76f:  ; #c76f
        ld hl, #040A
        ld de, c_c7f2
        ld c, #47
        call printString
        ld hl, #1605
        inc de
        ld c, #45
        call printString
        ld hl, #0809
        inc de
        ld c, #47
        call printString
        ld hl, #0909
        inc de
        ld c, #46
        call printString
        ld hl, #0A09
        inc de
        ld c, #43
        call printString
        ld hl, #0B09
        inc de
        ld c, #44
        call printString
        ld hl, #0C09
        inc de
        ld c, #45
        call printString
        ld hl, #1305
        inc de
        ld c, #44
        call printString
        ld hl, #5929
        ld b, #05
.l_0:
        ld (hl), #47
        ld de, #0020
        add hl, de
        djnz .l_0
        ld hl, #0F07
        ld de, #C85F
        ld c, #43
        call printString
        ld hl, #0F12
        ld (#CFCB), hl
        call c_cf85.l_4
        ld hl, #0000
        ld (#CFCB), hl
        ret

; Clamp attributes of active menu item?

; Used by c_c6d5.
c_c7e1:  ; #c7e1
        ld hl, (c_c6d3)
        ld b, #0C
        ld a, (hl)
        cp #48
        jr C, .l_0
        ld a, #41
.l_0:
        ld (hl), a
        inc l
        djnz .l_0
        ret

; Game menu text
c_c7f2:  ; #c7f2
        db "IMPOSSAMOLE"C
        db "@ 1990 GREMLIN GRAPHICS"C
        db "0 START GAME"C
        db "1 KEYBOARD"C
        db "2 KEMPSTON"C
        db "3 CURSOR"C
        db "4 INTERFACE 2"C
        db "WRITTEN BY CORE DESIGN"C
        db "LAST SCORE"C


; Clears screen pixels, leaves attributes untouched
; Used by c_c6d5, c_c9ac, c_cc25, c_cd22, c_d553 and c_d62c.
clearScreenPixels:  ; #c869
        ld hl, Screen.start
        ld de, Screen.start + 1
        ld bc, Screen.pixLength - 1
        ld (hl), 0
        ldir
        ret


; Fills screen attributes with value `a`
; Used by c_c6d5, c_cc25, c_cd22 and c_d553.
fillScreenAttrs:  ; #c877
        ld hl, Screen.attrs
        ld de, Screen.attrs + 1
        ld bc, Screen.attrLength - 1
        ld (hl), a
        ldir
        ret


; In Klondike, Orient, Bermuda, rolls top and bottom pixel rows
; of the conveyor tiles in opposite directions
; Used by c_cc25.
rollConveyorTiles:  ; #c884
        ld a, (#FE1E)
        cp #02
        ret Z
        cp #03
        ret Z
        ld a, (conveyorTileIndices.left)
        or a
        call NZ, .left
        ld a, (conveyorTileIndices.right)
        or a
        call NZ, .right
        ret
.left:
        ld l, a
        ld h, 0
    .3  add hl, hl
        ld de, Level.tilePixels
        add hl, de
        rlc (hl)
        ld bc, 7
        add hl, bc
        rrc (hl)
        ret
.right:
        ld l, a
        ld h, 0
    .3  add hl, hl
        ld de, Level.tilePixels
        add hl, de
        rrc (hl)
        ld bc, 7
        add hl, bc
        rlc (hl)
        ret

; Detect pressing [C]

; Used by c_cd5c.
c_c8c2:  ; #c8c2
        ld bc, #FEFE
        in a, (c)
        bit 3, a
        ret

; Detect pressing [Q]

; Used by c_cc25.
c_c8ca:  ; #c8ca
        ld bc, #FBFE
        in a, (c)
        bit 0, a
        ret

; Detect pressing [0]

; Used by c_c6d5.
c_c8d2:  ; #c8d2
        ld bc, #EFFE
        in a, (c)
        bit 0, a
        ret

; Detect pressing [H]

; Used by c_cd5c.
c_c8da:  ; #c8da
        ld bc, #BFFE
        in a, (c)
        bit 4, a
        ret

; Detect pressing [Space]

; Used by c_d4e5.
c_c8e2:  ; #c8e2
        ld bc, #7FFE
        in a, (c)
        bit 0, a
        ret

; Wait until all keys released
c_c8ea:  ; #c8ea
        ld bc, #00FE
        in a, (c)
        and #1F
        xor #1F
        jr NZ, c_c8ea
        ret

; Keyboard vars
c_c8f6:  ; #c8f6
        db #00                ; control type
        db #00                ; control key state

; Get control key state

; Used by c_bed4.
pollControlKeys:  ; #c8f8
        push hl
        ld hl, #C8F7
        ld (hl), #00
        ld a, (c_c8f6)
        or a
        jr NZ, .l_5
        ld bc, #DFFE
        in a, (c)
        bit 1, a
        jr NZ, .l_0
        set 3, (hl)
        jr .l_1
.l_0:
        ld bc, #BFFE
        in a, (c)
        bit 2, a
        jr NZ, .l_1
        set 2, (hl)
.l_1:
        ld bc, #FEFE
        in a, (c)
        bit 1, a
        jr NZ, .l_2
        set 1, (hl)
        jr .l_3
.l_2:
        ld bc, #FEFE
        in a, (c)
        bit 2, a
        jr NZ, .l_3
        set 0, (hl)
.l_3:
        ld bc, #EFFE
        in a, (c)
        bit 0, a
        jr NZ, .l_4
        set 4, (hl)
.l_4:
        pop hl
        ret
.l_5:
        dec a
        jr NZ, .l_6
        in a, (#1F)
        and #1F
        ld (hl), a
        pop hl
        ret
.l_6:
        dec a
        jr NZ, .l_12
        ld bc, #EFFE
        in a, (c)
        bit 0, a
        jr NZ, .l_7
        set 4, (hl)
.l_7:
        bit 2, a
        jr NZ, .l_8
        set 0, (hl)
.l_8:
        bit 3, a
        jr NZ, .l_9
        set 3, (hl)
        jr .l_10
.l_9:
        bit 4, a
        jr NZ, .l_10
        set 2, (hl)
.l_10:
        bit 0, (hl)
        jr NZ, .l_11
        ld bc, #F7FE
        in a, (c)
        bit 4, a
        jr NZ, .l_11
        set 1, (hl)
.l_11:
        pop hl
        ret
.l_12:
        ld bc, #EFFE
        in a, (c)
        and #1F
        bit 0, a
        jr NZ, .l_13
        set 4, (hl)
.l_13:
        bit 4, a
        jr NZ, .l_14
        set 1, (hl)
.l_14:
        bit 3, a
        jr NZ, .l_15
        set 0, (hl)
.l_15:
        bit 1, a
        jr NZ, .l_16
        set 3, (hl)
        jr .l_17
.l_16:
        bit 2, a
        jr NZ, .l_17
        set 2, (hl)
.l_17:
        pop hl
        ret

; "FOUND"
c_c9a7:  ; #c9a7
        db "FOUND"C

; Load level from tape

; Used by c_d62c.
c_c9ac:  ; #c9ac
        di
        ld ix, Level.start
        ld de, #0001
        scf
        ld a, #80
        call c_c9fb
        jr C, .l_0
        ei
        ret
.l_0:
        call clearScreenPixels
        ld hl, #0C09
        ld de, c_c9a7
        ld c, #47
        call printString
        ld a, (Level.start)
        add a, a
        add a, a
        add a, a
        ld l, a
        ld h, #00
        ld de, c_d52b
        add hl, de
        ex de, hl
        ld hl, #0C0F
        ld c, #46
        call printString
        ld a, (Level.start)
        ld b, a
        ld a, (#FE1E)
        cp b
        jr NZ, c_c9ac
        ld ix, Level.start
        ld de, #51DF
        scf
        ld a, #FF
        call c_c9fb
        ei
        ret

; Load block from tape

; Used by c_c9ac.
c_c9fb:  ; #c9fb
        inc d
        exa
        dec d
        di
        ld a, #0F
        out (#FE), a
        in a, (#FE)
        rra
        and #20
        or #02
        ld c, a
        cp a
.l_0:
        ret NZ
.l_1:
        call c_ca84.l_0
        jr NC, .l_0
        ld hl, #0415
.l_2:
        djnz .l_2
        dec hl
        ld a, h
        or l
        jr NZ, .l_2
        call c_ca84
        jr NC, .l_0
.l_3:
        ld b, #9C
        call c_ca84
        jr NC, .l_0
        ld a, #C6
        cp b
        jr NC, .l_1
        inc h                   ; () #CA2D
        jr NZ, .l_3
.l_4:
        ld b, #C9
        call c_ca84.l_0
        jr NC, .l_0
        ld a, b
        cp #D4
        jr NC, .l_4
        call c_ca84.l_0
        ret NC
        ld a, c
        xor #03
        ld c, a
        ld h, #00
        ld b, #B0
        jr c_ca69

; (some tape loading subroutine?)

; Used by c_ca69.
c_ca4a:  ; #ca4a
        exa
        jr NZ, .l_0
        jr NC, .l_1
        ld (ix+0), l
        jr .l_2
.l_0:
        rl c
        xor l
        ret NZ
        ld a, c
        rra
        ld c, a
        inc de
        jr .l_3
.l_1:
        ld a, (ix+0)
        xor l
        ret NZ
.l_2:
        inc ix
.l_3:
        dec de
        exa
        ld b, #B2

; (some tape loading subroutine?)

; Used by c_c9fb.
c_ca69:  ; #ca69
        ld l, #01
.l_0:
        call c_ca84
        ret NC
        ld a, #CB
        cp b
        rl l
        ld b, #B0
        jp NC, .l_0
        ld a, h
        xor l
        ld h, a
        ld a, d
        or e
        jr NZ, c_ca4a
        ld a, h
        cp #01
        ret

; (some tape loading subroutine?)

; Used by c_c9fb and c_ca69.
c_ca84:  ; #ca84
        call .l_0
        ret NC
; This entry point is used by c_c9fb.
.l_0:
        ld a, #16
.l_1:
        dec a
        jr NZ, .l_1
        and a
.l_2:
        inc b
        ret Z
        ld a, #7F
        in a, (#FE)
        rra
        xor c
        and #20
        jr Z, .l_2
        ld a, c
        cpl
        ld c, a
        and #07
        or #08
        out (#FE), a
        scf
        ret


    ENDMODULE
