    MODULE Utils

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
        ld de, Font.start
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
