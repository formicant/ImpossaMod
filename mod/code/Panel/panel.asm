    MODULE Panel

; Attributes used for items on the panel
; (number of chars, colour)
panelAttrs:
        db  1, Colour.white     ; smart
        db  6, Colour.brWhite   ; score
        db  3, Colour.brMagenta ; soup cans
        db  4, Colour.brYellow  ; coins
        db  1, Colour.magenta   ; diary
.energ: db  3, Colour.brRed     ; energy
        db  4, Colour.brGreen   ; energy
        db 10, Colour.brBlue    ; energy
.end:   db  0


; Display all panel items
printPanel:
        ; set attributes
        ld de, Screen.attrs.row0
        ld hl, panelAttrs
.item:
        ld b, (hl)
        inc hl
        ld a, (hl)
        inc hl
.attr:
        ld (de), a
        inc e
        djnz .attr

        bit 5, e
        jr Z, .item             ; if `e` < 32

        ; print items
        call printScore
        call printSmart
        call printSoupCans
        call printCoinCount
        jp printEnergy

    ENDMODULE
