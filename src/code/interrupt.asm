    MODULE Code


interruptRoutine:
    ASSERT low($) == high($)
        push af, hl

        ; poll control keys
        ld l, 1                 ; const
        ; actual instructions are inserted here in `setControlKeys`
.keyPollInstructions:
    DUP 8
        nop ; for keyboard:     ; for Kempston:
        nop ;   ld a, <halfRow> ;   xor a
        nop ;   in a, (#FE)     ;   in a, (#1F)
        nop ;                   ;   cpl
        and -0                  ; bit mask placeholder
        sub l                   ; flag `C` is set iff the key is pressed
        rl h                    ; add bit to the control state
    EDUP
        ld a, h
        ld (controlState), a
        
        ; increment short frame counter
        ld a, (shortFrameCounter)
        inc a
        ld (shortFrameCounter), a

        ; increment long frame counter
        ld hl, (longFrameCounter.low)
        inc hl
        ld (longFrameCounter.low), hl
        ld a, l
        or h
        jr Z, .incLongFrameHigh

        pop hl, af
        ei
        ret

.incLongFrameHigh:
        ld hl, (longFrameCounter.high)
        inc hl
        ld (longFrameCounter.high), hl

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
longFrameCounter:
.low:   dw 0
.high:  dw 0


    ENDMODULE
