    MODULE Code


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
        add a
        add l
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
        add 20
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
