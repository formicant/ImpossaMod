    MODULE Utils

; Print a string of characters
; (The last character should have its 7th bit set)
;   `de`: string address
;   `h`: y char coord (0..23)
;   `l`: x char coord (0..31)
;   `c`: attribute
; returns:
;   `de`: addr of the last string char
; spoils: `af`, `b`, `hl`, `bc'`, `hl'`
printString:
        push bc
        ld a, h
        and %00011000
        or  high(Screen.pixels)
        ld b, h
        ld h, a
        ; `h`: screen pixel addr (high)

        ld a, b
        and %00000111
    .3  rrca
        or l
        ld l, a
        ; `l`: screen pixel and attr addr (low)

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
        ; `h'`: screen attr addr (high)

.char:
        push de, hl
        ld a, (de)
        res 7, a
        ; `a`: ASCII char code

        ex de, hl
        cp ' '
        jr NZ, .decode
.space:
        xor a
        jr .getFromFont

.decode:
        sub 39
        cp 21
        jr C, .getFromFont
        sub 5

.getFromFont:
        ; `a`: font char code
        ld l, a
        ld h, 0
    .3  add hl, hl
        ld de, Font.start
        add hl, de
        ex de, hl
        ; `de`: char addr in the font

        pop hl
        push hl

        ; draw char
        ld b, 8
.pixelRow:
        ld a, (de)
        ld (hl), a
        inc h
        inc de
        djnz .pixelRow

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
        bit 7, a                ; check the last char marker bit
        ret NZ

        inc de
        jr .char

    ENDMODULE
