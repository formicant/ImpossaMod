    MODULE Panel

; Life indicator attributes (3 red, 4 green, 10 blue)
lifeIndicatorAttrs:  ; #c660
        dh 42 42 42 44 44 44 44 41 41 41 41 41 41 41 41 41 41

; Copy life indicator attributes to the screen
applyLifeIndicatorAttrs:  ; #c671
        ld hl, lifeIndicatorAttrs
        ld de, Screen.attrs + 15
        ld bc, 17
        ldir
        ret

    ENDMODULE
