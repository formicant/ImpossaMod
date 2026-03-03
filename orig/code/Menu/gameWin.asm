    MODULE Menu

; Game epilogue text
epilogueText:
        db "  GOOD WORK MONTY"C
        db "THE FIVE SCROLLS ARE"C
        db "SAFE  YOU HAVE SAVED"C
        db "    OUR PLANET"C


; Successful end of the game
gameWin:
        ld hl, _ROW 8 _COL 6
        ld de, epilogueText
        ld c, Colour.brRed

        ld b, 4                 ; line count
.line:
        push bc
        push hl
        call Utils.printString
        inc de
        pop hl
    .2  inc h
        pop bc
        inc c
        djnz .line

        ld bc, 30000
        call Utils.delay
.waitKey:
        ld a, (Control.state)
        or a
        jr Z, .waitKey
        pop hl
        jp Main.gameStart

    ENDMODULE
