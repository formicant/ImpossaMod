    MODULE Code


; Play sound (beeper or AY)
; Used by c_d0af, c_d7f6, c_df85, c_e6e1, c_ec00 and c_ed08.
playSound:  ; #bddf
        ld c, a
        ld a, (is48k)
        and a
        ld a, c
        jp NZ, playBeeperSound
        ld hl, playAySound      ; addr in RAM page 1
        jp callAyProcedure


; Used by c_c6d5.
callPlayMenuMusic:  ; #bdee
        ld hl, playMenuMusic    ; addr in RAM page 1
        jp callAyProcedure


; Used in the interrupt routine
callAySoundFrame:  ; #bdf4
        ld hl, aySoundFrame     ; addr in RAM page 1
        jp callAyProcedure


; (get something from memory page 1)
; This entry point is used by c_c6d5.
c_bdfa:  ; #bdfa
        ld a, (is48k)
        and a
        ret NZ
        
        di
        ld a, 1
        ld bc, #7FFD
        out (c), a
        ld a, (p_c9fa)
        ld e, a
        xor a
        ld bc, #7FFD
        out (c), a
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
        ld a, #01
        ld bc, #7FFD
        out (c), a
        ld de, .return
        push de
        ld (.addr), hl
.val+*  ld a, -0
.addr+* jp -0
.return:
        xor a
        ld bc, #7FFD
        out (c), a
        ei
        ret


; #FF if Spectrum 48K, #00 if Spectrum 128K
is48k:  db -0


    ENDMODULE
