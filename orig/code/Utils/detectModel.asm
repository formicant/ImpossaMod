    MODULE Utils

slot3   EQU #C000               ; start address of the RAM slot 3


; Detect which ZX Spectrum model the programme is running on (48K or 128K)
; returns:
;   `State.is48k`: #FF if 48K, #00 if 128K
; disables interrupts
detectSpectrumModel:
        di
        ld a, (slot3)
        ld e, a
        ld bc, Port.memory
        ld a, 1
        out (c), a              ; set RAM page 1
        ld a, e
        inc a
        ld d, a
        ld (slot3), a
        xor a
        out (c), a              ; set RAM page 0 again
        ld a, (slot3)
        cp e
        jp Z, moveAyCode        ; 128K

        ; 48K
        ld a, e
        ld (slot3), a
        ld a, #FF
        ld (State.is48k), a
        ei
        ret


; Moves AY-related code from is loading address to RAM page 1
moveAyCode:
        exx
        ld bc, Port.memory
        ld hl, #5E80            ; TODO: use label
        ld de, slot3
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

        ; add `call Sound.callAySoundFrame` instruction to the interrupt routine
        ld a, Asm.call
        ld (Interrupt.routine.callAySound), a
        ld hl, Sound.callAySoundFrame
        ld (Interrupt.routine.callAySound + 1), hl
        ret


    ENDMODULE
