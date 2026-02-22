    MODULE Menu

textPaused:  ; #cd52
        db "  PAUSED  "C

; Pause the game
; Used by c_cc25.
pauseGameIfPressed:  ; #cd5c
        call Control.checkPauseKey
        ret NZ
.l_0:
        call Control.checkPauseKey
        jr Z, .l_0
        ld hl, #1700            ; at 23, 0
        ld de, textPaused
        ld c, Colour.brWhite
        call Utils.printString
.l_1:
        call Control.checkPauseKey
        jr NZ, .l_1
        call Control.checkCheatKey
        jr NZ, .l_2
        ld a, (Control.controlState)
        bit Key.up, a
        jr Z, .l_2
        ld a, #22
        ld (State.maxEnergy), a
        ld a, #32
        call Code.addEnergy
.l_2:
        call Control.checkPauseKey
        jr Z, .l_2
        ld hl, Tables.scrTileUpd.row23 + 4
        ld b, 10
.l_3:
        ld (hl), 1
        inc hl
        djnz .l_3
        ret

    ENDMODULE
