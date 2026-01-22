    MODULE Code


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


; In Klondike, Orient, Bermuda, rolls top and bottom pixel rows
; of the conveyor tiles in opposite directions
; Used by c_cc25.
rollConveyorTiles:  ; #c884
        ld a, (State.level)
        cp #02
        ret Z
        cp #03
        ret Z
        ld a, (conveyorTileIndices.left)
        or a
        call NZ, .left
        ld a, (conveyorTileIndices.right)
        or a
        call NZ, .right
        ret
.left:
        ld l, a
        ld h, 0
    .3  add hl, hl
        ld de, Level.tilePixels
        add hl, de
        rlc (hl)
        ld bc, 7
        add hl, bc
        rrc (hl)
        ret
.right:
        ld l, a
        ld h, 0
    .3  add hl, hl
        ld de, Level.tilePixels
        add hl, de
        rrc (hl)
        ld bc, 7
        add hl, bc
        rlc (hl)
        ret


    ENDMODULE
