    MODULE Code


panelAttrs:
        db #47,  6              ; score  - bright white
        db #07,  1              ; smart  - dark white
        db #43,  3              ; soup   - bright magenta
        db #46,  4              ; coins  - bright yellow
        db #03,  1              ; diary  - dark magenta
        db #42,  3              ; energy - bright red
        db #44,  4              ; energy - bright green
        db #41, 10              ; energy - bright blue
        db 0

printPanel:
        ld de, Screen.attrs
        ld hl, panelAttrs
        ld a, (hl)
.part:
        inc hl
        ld b, (hl)
        inc hl
.attr:
        ld (de), a
        inc e
        djnz .attr
        
        ld a, (hl)
        or a
        jr NZ, .part
        
        ld hl, Screen.pixels.row0 + 0
        call printScore
        call printSoupCans
        call printCoinCount
        jp printEnergy


; Score (6 decimal digits)
score:
        block 6
.end:

; Score table (decimal)
; (sub-labels point to the last digit)
scoreTable:
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
        ld hl, score + 5        ; last digit
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

        ld hl, Screen.pixels.row0 + 0
        ; continue

; Print score number
;   `hl`: screen address
printScore:
        ld de, score
.digit:
        ld a, (de)
        call printChar
        inc de
        inc l
        ld a, e
        cp low(score.end)
        jr NZ, .digit
        ret

addScoreSetCarry:
        sub 10
        scf
        jp addScoreRaw.l_1


; Clear score at #CF57?
clearScore:
        ld hl, score
        ld b, 6
.digit:
        ld (hl), 0
        inc hl
        djnz .digit
        ret


; Print soup cans in the panel
printSoupCans:
        ld hl, Screen.pixels.row0 + 7
        ld a, (State.soupCans)
        ld e, a
.can:
        ld a, ':' - '0'         ; soup can char code
        call printChar
        inc l
        dec e
        jp NZ, .can
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


; Energy characters
energyChars:  ; #d03d
        db "[[[[[[[[[[[[[[[[["  ; energy full

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
        ld (hl), "]"            ; energy empty
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
