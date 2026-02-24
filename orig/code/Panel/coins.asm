    MODULE Panel

; Print coins in the panel
; Used by c_d1c1, c_e6e1 and c_e9b1.
printCoinCount:  ; #cfe6
        ld a, (State.coins)
        ld hl, _ROW 0 _COL 11
        ld c, Colour.brYellow
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
        jp Utils.printString

    ENDMODULE
