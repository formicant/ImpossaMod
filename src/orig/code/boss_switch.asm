    MODULE Code


; Boss logic switch by level
; Used by c_cc25.
boss_logic:  ; #f8cb
        ld a, (State.s_54)
        or a
        ret Z
        
        ld a, (State.level)
        or a
        jp Z, boss_logic_klondike
        cp 1
        jp Z, boss_logic_orient
        cp 2
        jp Z, boss_logic_amazon
        cp 3
        jp Z, boss_logic_iceland
        cp 4
        jp Z, boss_logic_bermuda
        ret


    ENDMODULE
