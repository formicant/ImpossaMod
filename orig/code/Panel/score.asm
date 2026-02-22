    MODULE Panel

; Score string (6 decimal digits in ASCII with a stop bit)
scoreString:  ; #cf51
        block 6

; Score (6 decimal digits)
score:  ; #cf57
        block 6

; Score table (decimal)
; (sub-labels point to the last digit)
scoreTable:  ; #cf5d
.walk+4 db 0, 0, 0, 6, 3        ; advance in map
        db 0, 0, 1, 0, 0
        db 0, 0, 2, 0, 0
        db 0, 0, 4, 0, 0
        db 0, 0, 8, 0, 0
        db 0, 1, 6, 0, 0
        db 0, 3, 2, 0, 0
.done+4 db 2, 0, 0, 0, 0        ; level complete

; Add score by index
;   `a`: index in the score table (1..6)
; Used by c_e4fc and c_e6e1.
addScore:  ; #cf85
        or a
        ret Z
        ld l, a
    .2  add a
        add l
        ld l, a
        ld h, 0
        ld de, scoreTable
        add hl, de
        ld de, 4
        add hl, de
        ex de, hl
        jr addScoreRaw

; Add score by addr
;   `de`: addr of the last digit in the score table
; This entry point is used by c_cdae and c_ec00.
addScoreRaw:
        ld hl, score + 5
        or a
        ld b, 5
.l_0:
        ld a, (de)
        adc a, (hl)
        cp 10
        jp NC, addScoreSetCarry
        or a
.l_1:
        ld (hl), a
        dec hl
        dec de
        djnz .l_0
        ld a, (hl)
        adc a, 0
        cp 10
        jp C, .l_2
        xor a
.l_2:
        ld (hl), a

; Print score number
; This entry point is used by c_c76f and c_d1c1.
printScore:
        ld hl, score
        ld de, scoreString
        ld b, 6
.l_0:
        ld a, (hl)
        add '0'
        ld (de), a
        inc hl
        inc de
        djnz .l_0
        dec de
        ex de, hl
        set 7, (hl)
.yx+*   ld hl, -0               ; `h`: y coord, `l`: x coord
        ld de, scoreString
        ld c, Colour.brWhite
        jp Utils.printString

addScoreSetCarry:
        sub 10
        scf
        jp addScoreRaw.l_1

; Clear score at #CF57?
; Used by c_d133.
clearScore:  ; #cfdb
        ld hl, score
        ld b, #06
.l_0:
        ld (hl), #00
        inc hl
        djnz .l_0
        ret

    ENDMODULE
