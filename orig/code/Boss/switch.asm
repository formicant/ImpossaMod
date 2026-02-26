    MODULE Boss

; Boss logic switch by level
switch:  ; #f8cb
        ld a, (State.bossFight)
        or a
        ret Z

        ld a, (State.level)
        or a
        jp Z, bossKlondike

        cp Level.orient
        jp Z, bossOrient

        cp Level.amazon
        jp Z, bossAmazon

        cp Level.iceland
        jp Z, bossIceland

        cp Level.bermuda
        jp Z, bossBermuda

        ret

    ENDMODULE
