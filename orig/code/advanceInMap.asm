    MODULE Code

; Scroll the screen an add new objects to the scene
; Used by c_cc25.
advanceInMap:  ; #cdae
        _DEBUG_BORDER Colour.yellow
        ld hl, Tables.scrTileUpd
        ld de, Tables.scrTileUpd + 1
        ld (hl), 0
        ld bc, Tables.scrTileUpd.length - 1
        ldir
        call Drawing.drawObjectsUnchecked
        call Tiles.cleanUpObjTiles
        _DEBUG_BORDER Colour.black
        ld c, 3
        call Interrupt.waitFrames
        _DEBUG_BORDER Colour.cyan
        ld hl, Tables.scrTiles.row1 + 4
        exx
        ld hl, Tables.scrTiles.row1 + 6
        ld de, Tables.scrTileUpd.row1 + 6
        call Drawing.moveScreenTiles
        _DEBUG_BORDER Colour.black
        ld c, 1
        call Interrupt.waitFrames
        _DEBUG_BORDER Colour.green
        ld hl, Tables.scrTiles.row1 + 6
        exx
        ld hl, Tables.scrTiles.row1 + 10
        ld de, Tables.scrTileUpd.row1 + 10
        call Drawing.moveScreenTiles
        _DEBUG_BORDER Colour.black
        ld c, 5
        call Interrupt.waitFrames
        _DEBUG_BORDER Colour.magenta
        ld hl, Tables.scrTiles.row1 + 10
        exx
        ld hl, Tables.scrTiles.row1 + 12
        ld de, Tables.scrTileUpd.row1 + 12
        call Drawing.moveScreenTiles
        _DEBUG_BORDER Colour.red
        call advanceObjectsInMap
        ld hl, (State.screenX)
        ld de, 8
        add hl, de
        ld (State.screenX), hl
        call Tiles.scrollScrTiles
        call Tiles.fillNextScrTiles

        ld hl, Tables.scrTileUpd
        ld de, Tables.scrTileUpd + 1
        ld (hl), 0
        ld bc, Tables.scrTileUpd.length - 1
        ldir

        _DEBUG_BORDER Colour.blue
        call Drawing.drawObjectsChecked
        call Drawing.updateScreenTiles
        ld de, Panel.scoreTable.walk
        jp Panel.addScoreRaw

    ENDMODULE
