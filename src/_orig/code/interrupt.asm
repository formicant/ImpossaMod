    MODULE Code


    DISP #FEFE

; In the original, stored at #BED4 and moved to #FEFE by `initInterrupts`
interruptRoutine:  ; #fefe
        di
        push af, bc, de, hl, ix, iy
        
        ld a, (shortFrameCounter)
        inc a
        ld (shortFrameCounter), a
        
        call incrementLongFrameCounter
        call pollControlKeys
.callAySound:
    .3  nop
        
        pop iy, ix, hl, de, bc, af
        ei
        ret

; Wait for `c` frames
waitFrames:  ; #ff21
        ei
.l_0:   ld a, (shortFrameCounter)
        cp c
        jp C, .l_0
        xor a
        ld (shortFrameCounter), a
        ret

; measures frames inside one game progression unit
shortFrameCounter:  ; #ff2e
        db -0

interruptLength EQU $ - interruptRoutine

    ENT


    ENDMODULE
