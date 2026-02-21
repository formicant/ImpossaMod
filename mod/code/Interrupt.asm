    MODULE Interrupt


routine:
    ASSERT low($) == high($)
        push af, hl

        ; poll control keys
        ld l, 1                 ; const
        ; actual instructions are inserted here in `setControlKeys`
.keyPollInstructions:
    DUP 8
        nop ; for keyboard:         ; for Kempston:
        nop ;  ld a, <halfRow>      ;  xor a
        nop ;  in a, (Port.general) ;  in a, (Port.kempston)
        nop ;                       ;  cpl
        and -0                  ; bit mask placeholder
        sub l                   ; flag `C` is set iff the key is pressed
        rl h                    ; add bit to the control state
    EDUP
        ld a, h
        ld (Code.controlState), a

        ; increment short frame counter
        ld a, (shortFrameCounter)
        inc a
        ld (shortFrameCounter), a

        ; increment long frame counter
        ld hl, (Code.longFrameCounter.low)
        inc hl
        ld (Code.longFrameCounter.low), hl
        ld a, l
        or h
        jr Z, .incLongFrameHigh

        pop hl, af
        ei
        ret

.incLongFrameHigh:
        ld hl, (Code.longFrameCounter.high)
        inc hl
        ld (Code.longFrameCounter.high), hl

        pop hl, af
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
        db 0

; 32-bit frame counter, used in random number generation
@Code.longFrameCounter:
.low:   dw 0
.high:  dw 0


    ENDMODULE
