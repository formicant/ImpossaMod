    MODULE Control

; Set flag Z if [C] key is pressed
checkCheatKey:  ; #c8c2
        ld bc, Port.keys_cZXCV
        in a, (c)
        bit Port.keyC, a
        ret

; Set flag Z if [Q] key is pressed
checkQuitKey:  ; #c8ca
        ld bc, Port.keys_QWERT
        in a, (c)
        bit Port.keyQ, a
        ret

; Set flag Z if [0] key is pressed
checkStartKey:  ; #c8d2
        ld bc, Port.keys_67890
        in a, (c)
        bit Port.key0, a
        ret

; Set flag Z if [H] key is pressed
checkPauseKey:  ; #c8da
        ld bc, Port.keys_HJKLe
        in a, (c)
        bit Port.keyH, a
        ret

; Set flag Z if [space] is pressed
checkSmartKey:  ; #c8e2
        ld bc, Port.keys_BNMss
        in a, (c)
        bit Port.keySpace, a
        ret

; Wait until all keys released
waitKeyRelease:  ; #c8ea
        ld bc, Port.general     ; all keyboard half-rows together
        in a, (c)
        and Port.keyMask
        xor Port.keyMask
        jr NZ, waitKeyRelease
        ret

    ENDMODULE
