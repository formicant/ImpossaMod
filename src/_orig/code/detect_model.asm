    MODULE Code


; 48K/128K detection
; Used by c_cc25.
detectSpectrumModel:  ; #5e00
        di
        ld a, (#C000)
        ld e, a
        ld bc, Port.memory
        ld a, 1
        out (c), a
        ld a, e
        inc a
        ld d, a
        ld (#C000), a
        xor a
        out (c), a
        ld a, (#C000)
        cp e
        jp Z, moveAyCode
        ld a, e
        ld (#C000), a
        ld a, #FF
        ld (is48k), a
        ei
        ret


; Moves AY-related code from #5E80 to RAM page 1 #C000
moveAyCode:
        exx
        ld bc, Port.memory
        ld hl, #5E80
        ld de, #C000
        exx
        ld a, #01
        exa
        ld bc, #0D78
.l_0:
        exx
        ld a, (hl)
        exa
        ld a, 1
        out (c), a
        exa
        ld (de), a
        xor a
        out (c), a
        inc de
        inc hl
        exx
        dec bc
        ld a, b
        or c
        jr NZ, .l_0

        ; add a `call` instruction to interrupt routine
        ld a, #CD  ; `call` instruction
        ld (Interrupt.routine.callAySound), a
        ld hl, #BDF4
        ld (Interrupt.routine.callAySound + 1), hl
        ret


    ENDMODULE
