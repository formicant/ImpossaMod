    MODULE Interrupt


    DISP #FEFE

; In the original, stored at #BED4 and moved to #FEFE by `initInterrupts`
routine:  ; #fefe
        di
        push af, bc, de, hl, ix, iy

        ld a, (frames)
        inc a
        ld (frames), a

        call Utils.incrementTime
        call Control.pollKeys
.callAySound:
    .3  nop

        pop iy, ix, hl, de, bc, af
        ei
        ret

; Wait for `c` frames
waitFrames:  ; #ff21
        ei
.l_0:   ld a, (frames)
        cp c
        jp C, .l_0
        xor a
        ld (frames), a
        ret

; measures frames inside one game progression unit
frames:  ; #ff2e
        db -0

length EQU $ - routine

    ENT


    ENDMODULE
