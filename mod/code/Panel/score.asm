    MODULE Panel

; Score (6 decimal digits)
score:
        block 5
.last:  db -0


; Score table (decimal)
; (sub-labels point to the last digit)
scoreTable:
.walk+4 db 0, 0, 0, 6, 3        ; advance in map
        db 0, 0, 1, 0, 0        ; 1
        db 0, 0, 2, 0, 0        ; 2
        db 0, 0, 4, 0, 0        ; 3
        db 0, 0, 8, 0, 0        ; 4
        db 0, 1, 6, 0, 0        ; 5
        db 0, 3, 2, 0, 0        ; 6
.done+4 db 2, 0, 0, 0, 0        ; level complete


; Add score by index
;   `a`: index in the score table (1..6)
addScore:
        or a
        ret Z
        ld e, a
    .2  add a
        add e
        add 4
        ld de, scoreTable
        _ADD_DE_A
        ; continue

; Add score by addr
;   `de`: addr of the last digit in the score table
addScoreRaw:
        ld hl, score.last       ; last digit
        or a
        ld b, 5
.l_0:
        ld a, (de)
        adc a, (hl)
        cp 10
        jr NC, addScoreSetCarry
        or a
.l_1:
        ld (hl), a
        ; next digit
        dec hl
        dec de
        djnz .l_0

        ld a, (hl)              ; first digit
        adc a, 0
        cp 10
        jp C, .l_2
        xor a                   ; overflow
        ; TODO: if overflow is possible, set 999999 here
        ;   if impossible, remove the check
.l_2:
        ld (hl), a
        ; continue

; Print score number in the panel
printScore:
        ld hl, Screen.pixels.row0 + 1
        ; continue

; Print score number
;   `hl`: screen address of the first digit
printScoreAt:
        ld de, score
        xor a                   ; leading zero
        exa
.digit:
        ld a, (de)
        call printDigitWithoutLeadingZeros
        inc l
        inc de
        ld a, e
        cp low(score.last)
        jr NZ, .digit

        ; last digit
        ld a, (de)
        call Utils.printChar
        ret

addScoreSetCarry:
        sub 10
        scf
        jp addScoreRaw.l_1


; Set score to zero
clearScore:
        ld hl, score
        ld b, 6
.digit:
        ld (hl), 0
        inc hl
        djnz .digit
        ret

    ENDMODULE
