    MODULE Location

; Move to a new map span
;   `hl`: span start, tiles
;   `de`: span end, tiles
moveToMapSpan:  ; #cd9b
        ld (State.screenX), hl
        ld hl, -32
        add hl, de
        ld (State.mapSpanEnd), hl
        call Scene.findAndPutObjectsToScene
        call Drawing.setScrTileUpd
        jp Tiles.fillAllScrTiles

    ENDMODULE
