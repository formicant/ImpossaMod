    MODULE Sound

; Play sound (beeper or AY)
playSound:
        ld c, a
        ld a, (useBeeper)
        or a
        ld a, c
        jp NZ, playBeeperSound

        ret
        ; TODO:
        ; jp playAySound


callPlayMenuMusic:
        ld c, a
        ld a, (State.is48k)
        or a
        ret NZ
        ld a, (State.loadedLevel)
        cp -1
        ret NZ
        ld a, c
        jp AY.playMenuMusic

callAySoundFrame:
        push bc, de, ix, iy
        call AY.aySoundFrame
        pop iy, ix, de, bc
        ret


; Add AY sound frame call to the interrupt routine
; (Interrupts should be disabled!)
addAySoundFrame:
        ld hl, Interrupt.routine.aySoundCall
        ; `call callAySoundFrame`
        ld (hl), Asm.call
        inc hl
        ld (hl), low(callAySoundFrame)
        inc hl
        ld (hl), high(callAySoundFrame)
        ret

; Remove AY sound frame call from the interrupt routine
; (Interrupts should be disabled!)
removeAySoundFrame:
        ld hl, Interrupt.routine.aySoundCall
        ; 3 `nop`s
        ld (hl), a
        inc hl
        ld (hl), a
        inc hl
        ld (hl), a
        ret


; (get something from memory page 1)
hasMusicEnded:  ; #bdfa
        ; TODO !
        ret


useBeeper:
        db 1

; #FF if Spectrum 48K, #00 if Spectrum 128K
is48k:  db -0

    ENDMODULE
