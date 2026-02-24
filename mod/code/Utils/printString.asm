    MODULE Utils

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
;   `hl`: screen address
;   `a`: font char code (ASCII - 48), space is printed if `a` >= #B0
; spoils: `af`, `bc`
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
