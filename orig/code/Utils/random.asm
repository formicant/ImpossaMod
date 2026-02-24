    MODULE Utils

; Random number generation
; Used by c_e52d, c_ef72, c_f4e9, c_f670, c_f697, c_f8f4 and c_fa65.
generateRandom:  ; #d0fc
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
time:  ; #d11d
.low:   dw 0
.high:  dw 0

    IFNDEF _MOD                 ; moved to the interrupt routine

; Increment the 32-bit frame counter
; Called in every interrupt
incrementTime:  ; #d121
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
