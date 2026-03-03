    MODULE Control

; Check if the cheat key [C] is pressed
; returns:
;   flag Z iff the key is pressed
; spoils: `af`, `bc`
checkCheatKey:  ; #c8c2
        ld bc, Port.keys_cZXCV
        in a, (c)
        bit Port.keyC, a
        ret


; Check if the quit key [Q] is pressed
; returns:
;   flag Z iff the key is pressed
; spoils: `af`, `bc`
checkQuitKey:  ; #c8ca
        ld bc, Port.keys_QWERT
        in a, (c)
        bit Port.keyQ, a
        ret


; Check if the start key [0] is pressed
; returns:
;   flag Z iff the key is pressed
; spoils: `af`, `bc`
checkStartKey:  ; #c8d2
        ld bc, Port.keys_67890
        in a, (c)
        bit Port.key0, a
        ret


; Check if the pause key [H] is pressed
; returns:
;   flag Z iff the key is pressed
; spoils: `af`, `bc`
checkPauseKey:  ; #c8da
        ld bc, Port.keys_HJKLe
        in a, (c)
        bit Port.keyH, a
        ret


; Check if the smart key [Space] is pressed
; returns:
;   flag Z iff the key is pressed
; spoils: `af`, `bc`
checkSmartKey:  ; #c8e2
        ld bc, Port.keys_BNMss
        in a, (c)
        bit Port.keySpace, a
        ret


; Wait until all keys released
; spoils: `af`, `bc`
waitKeyRelease:  ; #c8ea
        ld bc, Port.general     ; all keyboard half-rows together
        in a, (c)
        and Port.keyMask
        xor Port.keyMask
        jr NZ, waitKeyRelease
        ret

    ENDMODULE
