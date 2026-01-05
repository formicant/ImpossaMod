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
        ld a, #01
        ld bc, #7FFD
        out (c), a
        ld a, (#C9FA)
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


; Beeper sounds (15 × 3 bytes)
beeperSounds:  ; #be3a
;       length period mode
        db  20,   20,  0        ; 
        db  20,   20,  0        ; 
        db  20,   20,  0        ; 
        db  10,   50,  2        ; 
        db  10,  220,  3        ; 
        db 100,  120,  0        ; 
        db  80,   80,  2        ; 
        db  20,   20,  1        ; 
        db  20,  200,  0        ; 
        db  20,   20,  2        ; 
        db  10,  180,  0        ; 
        db  20,  200,  3        ; 
        db  60,   30,  0        ; 
        db  20,  240,  3        ; 
        db  20,   20,  2        ; 


; Play beeper sound
;   `a`: sound index (0..14)
; Used by playSound.
playBeeperSound:  ; #be67
        ld l, a
        add a, a
        add a, l
        ld l, a
        ld h, 0
        ld de, beeperSounds
        add hl, de
        ld c, (hl)
        inc hl
        ld d, (hl)
        inc hl
        ld a, (hl)
        or a
        jr Z, .l_0
        dec a
        jr Z, .l_1
        dec a
        jr Z, .l_2
        jr .l_3
.l_0:
        call .l_4
        dec d
        dec c
        jr NZ, .l_0
        ret
.l_1:
        call .l_4
        inc d
        dec c
        jr NZ, .l_1
        ret
.l_2:
        call .l_4
        rrc d
        ld a, d
        add a, 20
        ld d, a
        dec c
        jr NZ, .l_2
        ret
.l_3:
        call .l_4
        dec c
        jr NZ, .l_3
        ret
.l_4:
        xor a
        out (#FE), a
        ld b, d
.l_5:
        djnz .l_5
        ld a, #10
        out (#FE), a
        ld b, d
.l_6:
        djnz .l_6
        ret


    ENDMODULE
