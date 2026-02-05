    MODULE Code


; Boss logic switch by level
boss_logic:
        ld a, (State.bossFight)
        or a
        ret Z

        ld hl, (Level.bossLogicAddr)
        jp hl


    ENDMODULE
