    MODULE Utils

; Clears screen pixels, leaves attributes untouched
; Used by c_c6d5, c_c9ac, c_cc25, c_cd22, c_d553 and c_d62c.
clearScreenPixels:  ; #c869
        ld hl, Screen.pixels
        ld de, Screen.pixels + 1
        ld bc, Screen.pixLength - 1
        ld (hl), 0
        ldir
        ret


; Fills screen attributes with value `a`
; Used by c_c6d5, c_cc25, c_cd22 and c_d553.
fillScreenAttrs:  ; #c877
        ld hl, Screen.attrs
        ld de, Screen.attrs + 1
        ld bc, Screen.attrLength - 1
        ld (hl), a
        ldir
        ret

    ENDMODULE
