    MODULE Sound

; Play sound (beeper or AY)
playSound:  ; #bddf
        ld c, a
        ld a, (is48k)
        and a
        ld a, c
        jp NZ, playBeeperSound
        ld hl, AY.playAySound   ; addr in RAM page 1
        jp callAyProcedure


callPlayMenuMusic:  ; #bdee
        ld hl, AY.playMenuMusic ; addr in RAM page 1
        jp callAyProcedure


; Used in the interrupt routine
callAySoundFrame:  ; #bdf4
        ld hl, AY.aySoundFrame  ; addr in RAM page 1
        jp callAyProcedure


; Return Z if menu music has ended, NZ if it is playing or 48K
; (Reads memory page 1)
hasMusicEnded:  ; #bdfa
        ld a, (is48k)
        and a
        ret NZ

        di
        ld a, 1
        ld bc, Port.memory
        out (c), a              ; set RAM page 1
        ld a, (AY.isPlaying)
        ld e, a
        xor a
        ld bc, Port.memory
        out (c), a              ; set RAM page 0
        ld a, e
        and a
        ei
        ret


; Call an AY sound procedure in RAM page 1 by address in `hl`
; Possible call addresses: #CA84 (playMenuMusic), #CB0C (aySoundFrame), #CD25 (playAySound)
callAyProcedure:  ; #be15
        ld (.val), a
        ld a, (is48k)
        and a
        ret NZ

        di
        ld a, 1
        ld bc, Port.memory
        out (c), a              ; set RAM page 1
        ld de, .return
        push de
        ld (.addr), hl
.val+*  ld a, -0
.addr+* jp -0
.return:
        xor a
        ld bc, Port.memory
        out (c), a              ; set RAM page 0
        ei
        ret


; #FF if Spectrum 48K, #00 if Spectrum 128K
is48k:  db -0

    ENDMODULE
