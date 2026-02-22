    MODULE Panel

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
        jp Utils.printChar

    ENDMODULE
