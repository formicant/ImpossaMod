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

        call printScore
        call printSmart
        call printSoupCans
        call printCoinCount
        jp printEnergy


; Score (6 decimal digits)
score:
        block 5
.last:  db -0

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

        ld hl, Screen.pixels.row0 + 0
        ; continue

; Print score number in the panel
printScore:
        ld hl, Screen.pixels.row0 + 0
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
        call printChar
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


; print if there is smart capability
printSmart:
        ld hl, Screen.pixels.row0 + 6
        ld a, (State.hasSmart)
        or a
        ld a, -1                ; space
        jp Z, printChar
        ld a, ';' - '0'         ; smart (font char code)
        jp printChar


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


; Print item price in the shop (multiplied by 25) in the panel
;   `a`: item price
printPrice:
        ; TODO: set attrs
        ld hl, Screen.pixels.row0 + 27
        jr printCoinCountAt

; Print number of coins (multiplied by 25) in the panel
printCoinCount:
        ld hl, Screen.pixels.row0 + 10
        ld a, (State.coins)     ; 0 <= `a` < 128
        ; continue

; Print number of coins multiplied by 25
;   `a`: number of coins
;   `hl`: screen addr
printCoinCountAt:
        ; instead of multiplying by 25, we interpret `a` as a 6.2 fixed point
        ; and then, we interpret the decimal value as multiplied by 100
        ld b, a
        ; convert integer part to decimal
        rlca
        ld c, a
        xor a
        sla c : adc a
        sla c : adc a
        sla c : adc a
        sla c : adc a : daa
        sla c : adc a : daa
        ld d, a                 ; two digits in BCD

        ; convert fractional part to decimal
        ld a, b
        sla c : adc a
        and %00000111
        ld e, a
        sla c : adc a
        and %00000101
        ld c, a
        ; `e`, `c`: two fractional part digits
        
        xor a                   ; leading zero
        exa
        push bc
        ld a, d
    .4  rrca
        and %00001111           ; thousands
        call printDigitWithoutLeadingZeros
        inc l
        ld a, d
        and %00001111           ; hundreds
        call printDigitWithoutLeadingZeros
        inc l
        ld a, e                 ; tens
        call printDigitWithoutLeadingZeros
        inc l
        pop bc
        ld a, c                 ; units
        jp printChar


; Print energy in the panel
printEnergy:
        ld hl, Screen.pixels.row0 + 15
        ld e, 0

        ld a, (State.energy)
        ld d, a
.fullChar:
        ld a, e
        sub d
        jr Z, .empty
        inc a
        jr Z, .half

        ld a, '[' - '0'         ; energy full (font char code)
        call printChar
        inc l
    .2  inc e
        jp .fullChar

.half:
        ld a, '\' - '0'         ; energy half (font char code)
        call printChar
        inc l
    .2  inc e

.empty:
        ld a, (State.maxEnergy)
        ld d, a
.emptyChar:
        ld a, e
        cp d
        ret Z

        ld a, ']' - '0'         ; energy empty (font char code)
        call printChar
        inc l
    .2  inc e
        jp .emptyChar


; Print digit or space in case of a leading zero
;   arg `a`: digit (0..9)
;       `a'`: 0 if there were only leading zeros before
;   ret `a'`: 0 if leading zero
;   spoils `af`, `bc`
printDigitWithoutLeadingZeros:
        exa
        or a
        jr NZ, .significant
        exa
        or a
        jp NZ, .firstSignificant
        
        dec a                   ; space
        jp printChar
        
.firstSignificant:
        exa
        dec a                   ; not a leading zero
.significant:
        exa
        jp printChar

    ENDMODULE
