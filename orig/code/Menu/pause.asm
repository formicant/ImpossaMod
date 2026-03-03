    MODULE Menu

textPaused:
        db "  PAUSED  "C


; Pause the game if the pause key is pressed
pauseGameIfPressed:
        call Control.checkPauseKey
        ret NZ

.waitPauseRelease:
        call Control.checkPauseKey
        jr Z, .waitPauseRelease

        ; print "paused"
        ld hl, _ROW 23 _COL 0
        ld de, textPaused
        ld c, Colour.brWhite
        call Utils.printString

.waitPressAgain:
        call Control.checkPauseKey
        jr NZ, .waitPressAgain

        ; cheat is activated by [Pause]+[C]+[Up]
        call Control.checkCheatKey
        jr NZ, .waitReleaseAgain
        ld a, (Control.state)
        bit Key.up, a
        jr Z, .waitReleaseAgain

        ; cheat: max energy
        ld a, 34
        ld (State.maxEnergy), a
        ld a, 50
        call Hero.addEnergy

.waitReleaseAgain:
        call Control.checkPauseKey
        jr Z, .waitReleaseAgain

        ; update tiles under the "paused" text
        ld hl, Tables.scrTileUpd.row23 _COL 4
        ld b, 10                ; tile count
.tile:
        ld (hl), 1              ; update
        inc hl
        djnz .tile
        ret

    ENDMODULE
