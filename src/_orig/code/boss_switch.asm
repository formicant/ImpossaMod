    MODULE Code


; Boss logic switch by level
; Used by c_cc25.
bossLogic:  ; #f8cb
        ld a, (State.bossFight)
        or a
        ret Z

        ld a, (State.level)
        or a
        jp Z, bossLogicKlondike
        cp 1
        jp Z, bossLogicOrient
        cp 2
        jp Z, bossLogicAmazon
        cp 3
        jp Z, bossLogicIceland
        cp 4
        jp Z, bossLogicBermuda
        ret


    ENDMODULE
