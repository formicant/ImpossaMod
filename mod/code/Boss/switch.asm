    MODULE Boss


; Boss logic switch by level
switch:
        ld a, (State.bossFight)
        or a
        ret Z

        ld hl, (Level.bossLogicAddr)
        jp hl


    ENDMODULE
