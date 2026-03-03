    MODULE Utils

; Generate next random number
; returns:
;   `a`: random number (0..255)
; spoils: `f`
generateRandom:
        push hl, de

        ld hl, (randomSeed)
        ld de, (time.low)
        add hl, de
        ld de, 13
        add hl, de
        ld de, (time.high)
        adc hl, de
        xor l
        xor d
        xor e
        xor h
        ld l, a
        ld (randomSeed), hl

        pop de, hl
        ret

randomSeed:  ; #d11b
        dw 0


; 32-bit frame counter, used in random number generation
time:
.low:   dw 0
.high:  dw 0


    IFNDEF _MOD                 ; moved to the interrupt routine

; Increment the 32-bit frame counter
; Called in every interrupt
; spoils: `af`, `hl`
incrementTime:
        ld hl, (time.low)
        inc hl
        ld (time.low), hl
        ld a, l
        or h
        ret NZ

        ld hl, (time.high)
        inc hl
        ld (time.high), hl
        ret

    ENDIF

    ENDMODULE
