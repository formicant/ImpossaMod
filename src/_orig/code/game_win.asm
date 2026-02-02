    MODULE Code


; Game epilogue text
epilogueText:  ; #d679
        db "  GOOD WORK MONTY"C
        db "THE FIVE SCROLLS ARE"C
        db "SAFE  YOU HAVE SAVED"C
        db "    OUR PLANET"C

; Successful end of the game
; Used by c_d553.
gameWin:  ; #d6c0
        ld hl, #0806
        ld de, epilogueText
        ld c, #42
        ld b, #04
.l_0:
        push bc
        push hl
        call printString
        inc de
        pop hl
        inc h
        inc h
        pop bc
        inc c
        djnz .l_0
        ld bc, 30000
        call delay
.l_1:
        ld a, (controlState)
        or a
        jr Z, .l_1
        pop hl
        jp gameStart


    ENDMODULE
