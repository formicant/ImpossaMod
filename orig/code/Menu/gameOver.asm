    MODULE Menu

textGameOver:
        db "GAME OVER"C


; Show the Game Over screen
showGameOver:
        call Utils.clearScreenPixels
        ld a, Colour.brWhite    ; bright white ink, black paper
        call Utils.fillScreenAttrs

        ld hl, _ROW 10 _COL 11
        ld de, textGameOver
        ld c, Colour.brYellow
        call Utils.printString

.waitFirePress:
        ld a, (Control.state)
        bit Key.fire, a
        jr NZ, .waitFirePress

        ld bc, 30000
.waitFireRelease:
        ld a, (Control.state)
        bit Key.fire, a
        jr NZ, .end

        exx
        ld b, 200
.delay:
        djnz .delay
        exx

        dec bc
        ld a, b
        or c
        jr NZ, .waitFireRelease

.end:
        ret

    ENDMODULE
