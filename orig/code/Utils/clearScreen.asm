    MODULE Utils

; Clear screen pixels, leaves attributes untouched
; spoils: `bc`, `de`, `hl`
clearScreenPixels:
        ld hl, Screen.pixels
        ld de, Screen.pixels + 1
        ld bc, Screen.pixLength - 1
        ld (hl), 0
        ldir
        ret


; Fill screen attributes with the given value
;   `a`: attribute value
; spoils: `bc`, `de`, `hl`
fillScreenAttrs:
        ld hl, Screen.attrs
        ld de, Screen.attrs + 1
        ld bc, Screen.attrLength - 1
        ld (hl), a
        ldir
        ret

    ENDMODULE
