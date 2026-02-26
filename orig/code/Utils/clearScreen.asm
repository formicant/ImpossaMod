    MODULE Utils

; Clears screen pixels, leaves attributes untouched
clearScreenPixels:  ; #c869
        ld hl, Screen.pixels
        ld de, Screen.pixels + 1
        ld bc, Screen.pixLength - 1
        ld (hl), 0
        ldir
        ret


; Fills screen attributes with value `a`
fillScreenAttrs:  ; #c877
        ld hl, Screen.attrs
        ld de, Screen.attrs + 1
        ld bc, Screen.attrLength - 1
        ld (hl), a
        ldir
        ret

    ENDMODULE
