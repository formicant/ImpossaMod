    MODULE Boss

; Boss logic switch by level
; Used by c_cc25.
switch:  ; #f8cb
        ld a, (State.bossFight)
        or a
        ret Z

        ld a, (State.level)
        or a
        jp Z, bossLogicKlondike

        cp Level.orient
        jp Z, bossLogicOrient

        cp Level.amazon
        jp Z, bossLogicAmazon

        cp Level.iceland
        jp Z, bossLogicIceland

        cp Level.bermuda
        jp Z, bossLogicBermuda

        ret

    ENDMODULE
