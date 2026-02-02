    MODULE Code


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
        ld c, #47               ; bright white
        jp printString

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


; Print coins in the panel
; Used by c_d1c1, c_e6e1 and c_e9b1.
printCoinCount:  ; #cfe6
        ld a, (State.coins)
        ld hl, #000B            ; at 0, 12
        ld c, #46               ; bright yellow
        jp printNumber

printNumber:
        push bc
        ld bc, 0
.hundreds:
        sub 100
        inc c
        jr NC, .hundreds
        add 100
        dec c
.tens:
        sub 10
        inc b
        jr NC, .tens
        add 10
        dec b
        add '0'|#80
        ld (State.coinDigits + 2), a
        ld a, b
        add '0'
        ld (State.coinDigits + 1), a
        ld a, c
        add '0'
        ld (State.coinDigits + 0), a
        pop bc
        ld de, State.coinDigits
        jp printString


soupCanStrings:
.one:   db "/  "C
.two:   db "// "C
.three: db "///"C

; Print soup cans in the panel
; Used by c_d1c1, c_e6e1 and c_e9b1.
printSoupCans:  ; #d026
        ld a, (State.soupCans)
        dec a
        ld l, a
        add a
        add l
        ld l, a
        ld h, #00
        ld de, soupCanStrings
        add hl, de
        ex de, hl
        ld hl, #0007
        ld c, #43
        jp printString


; Energy characters
energyChars:  ; #d03d
        db "(((****,,,,,,,,,,"  ; energy full, they look all the same

; Print energy in the panel
; Used by c_d09a, c_d0af, c_d1c1, c_e9b1 and c_f618.
printEnergy:  ; #d04e
        ld hl, State.energyText
        push hl
        ld b, 17
.l_0:
        ld (hl), " "
        inc hl
        djnz .l_0

        pop hl
        ld de, energyChars
        ld a, (State.energy)
        ld c, a
        cp 2
        jr C, .l_2

        srl a
        ld b, a
.l_1:
        ld a, (de)
        ld (hl), a
        inc hl
        inc de
        djnz .l_1
.l_2:
        bit 0, c
        jr Z, .l_3
        ld a, (de)
        inc a
        ld (hl), a
        inc hl
.l_3:
        ld a, (State.energy)
        ld b, a
        ld a, (State.maxEnergy)
        sub b
        srl a
        jr Z, .l_5

        ld b, a
.l_4:
        ld (hl), "."            ; energy empty
        inc hl
        djnz .l_4
.l_5:
        ld hl, State.energyText + 16
        set 7, (hl)

        ld hl, #000F            ; at 0, 15
        ld de, State.energyText
        call printString
        call applyLifeIndicatorAttrs
        ret


    ENDMODULE
