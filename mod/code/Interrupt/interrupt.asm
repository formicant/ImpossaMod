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
        ld (Control.state), a

        ; increment `frames` counter
        ld a, (frames)
        inc a
        ld (frames), a

        ; increment `time`
        ld hl, (Utils.time.low)
        inc hl
        ld (Utils.time.low), hl
        ld a, l
        or h
        jr Z, .incTimeHigh

        pop hl, af
        ei
        ret

.incTimeHigh:
        ld hl, (Utils.time.high)
        inc hl
        ld (Utils.time.high), hl

        pop hl, af
        ei
        ret


; Wait for `c` frames
waitFrames:
        ei
.l_0:   ld a, (frames)
        cp c
        jp C, .l_0
        xor a
        ld (frames), a
        ret

; measures frames inside one game progression unit
frames:
        db 0

    ENDMODULE
