    MODULE Tiles

; Find conveyors among the screen tiles
; Used by c_cecc.
findConveyors:  ; #d213
        ld a, (conveyorTileIndices.left)
        ld (Tables.scrTiles.stop + 1), a   ; stop-value
        ld hl, Tables.scrTiles.row1 + 3    ; before first visible tile
        ld de, (conveyorTileIndices)
        ld ix, State.conveyors
.scan:
        inc hl
        ld a, (hl)
        cp d
        jp Z, .rightConveyor
        cp e
        jp NZ, .scan
.leftConveyor:
        ld bc, Tables.scrTiles.stop + 1
        push hl
        xor a
        sbc hl, bc
        pop hl
        jp Z, .end
        ld (ix+Conveyor.start+0), l
        ld (ix+Conveyor.start+1), h
        ld b, 0
.leftNext:
        inc b
        inc hl
        ld a, (hl)
        cp e
        jp Z, .leftNext
        ld (ix+Conveyor.length), b
    .3  inc ix                  ; next conveyor
        jp .scan
.rightConveyor:
        ld (ix+Conveyor.start+0), l
        ld (ix+Conveyor.start+1), h
        ld b, 0
.rightNext:
        inc b
        inc hl
        ld a, (hl)
        cp d
        jp Z, .rightNext
        ld (ix+Conveyor.length), b
    .3  inc ix                  ; next conveyor
        jp .scan
.end:
        ld (ix+Conveyor.start+0), 0
        ld (ix+Conveyor.start+1), 0
        ret


; Mark all conveyor screen tiles to be updated
; Used by c_cc25.
updateConveyors:  ; #d278
        ld de, Tables.scrTileUpd - Tables.scrTiles
        ld ix, State.conveyors
.conveyor:
        ld l, (ix+Conveyor.start+0)
        ld h, (ix+Conveyor.start+1)
        ld a, h
        or l
        ret Z

        ld b, (ix+Conveyor.length)
        add hl, de              ; conveyor addr in `Tables.scrTileUpd`
.tile:
        ld (hl), 1              ; update
        inc hl
        djnz .tile

    .3  inc ix                  ; next conveyor
        jp .conveyor

    ENDMODULE
