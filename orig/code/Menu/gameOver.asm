    MODULE Menu

textGameOver:  ; #cd19
        db "GAME OVER"C

showGameOver:  ; #cd22
        call Utils.clearScreenPixels
        ld a, Colour.brWhite    ; bright white ink, black paper
        call Utils.fillScreenAttrs
        ld hl, _ROW 10 _COL 11
        ld de, textGameOver
        ld c, Colour.brYellow
        call Utils.printString
.l_0:
        ld a, (Control.state)
        bit Key.fire, a
        jr NZ, .l_0
        ld bc, 30000
.l_1:
        ld a, (Control.state)
        bit Key.fire, a
        jr NZ, .l_3
        exx
        ld b, #C8
.l_2:
        djnz .l_2
        exx
        dec bc
        ld a, b
        or c
        jr NZ, .l_1
.l_3:
        ret

    ENDMODULE
