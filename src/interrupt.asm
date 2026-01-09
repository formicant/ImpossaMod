    MODULE Code


interruptRoutine:               ; #fefe
    ASSERT low(interruptRoutine) == high(interruptRoutine)
        push af, bc, hl
        
        ld a, (shortFrameCounter)
        inc a
        ld (shortFrameCounter), a

        call pollControlKeys
        
        ; increment long frame counter
        ld hl, (longFrameCounter.low)
        inc hl
        ld (longFrameCounter.low), hl
        ld a, l
        or h
        jr Z, .incLongFrameHigh
        
        pop hl, bc, af
        ei
        ret

.incLongFrameHigh:
        ld hl, (longFrameCounter.high)
        inc hl
        ld (longFrameCounter.high), hl
        
        pop hl, bc, af
        ei
        ret


; Wait for `c` frames
waitFrames:
        ei
.l_0:   ld a, (shortFrameCounter)
        cp c
        jp C, .l_0
        xor a
        ld (shortFrameCounter), a
        ret

; measures frames inside one game progression unit
shortFrameCounter:
        db -0


; AY stub
playAySound:
playMenuMusic:
aySoundFrame:
p_c9fa:
        ret

    ENDMODULE
