    MODULE Tiles

; In Klondike, Orient, Bermuda, rolls top and bottom pixel rows
; of the conveyor tiles in opposite directions
; Used by c_cc25.
rollConveyorTiles:  ; #c884
        ld a, (State.level)
        cp Level.amazon
        ret Z
        cp Level.iceland
        ret Z
        ld a, (Tiles.conveyorTileIndices.left)
        or a
        call NZ, .left
        ld a, (Tiles.conveyorTileIndices.right)
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
