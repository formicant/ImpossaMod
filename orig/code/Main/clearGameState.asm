    MODULE Main

; Clear the game state before the start of the game
; spoils: `af`, `bc`, `de`, `hl`
clearGameState:  ; #d133
        ld hl, State.start
        ld de, State.start + 1
        ld bc, State.length - 1
        ld (hl), 0
        ldir

        ld a, 18
        ld (State.maxEnergy), a

        call Panel.clearScore
        ld b, 5                 ; level count
        ld hl, State.levelsDone
.level:
        ld (hl), 0
        inc hl
        djnz .level
        ret

    ENDMODULE
