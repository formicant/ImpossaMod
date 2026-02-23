    MODULE Code

; Move to a new map span
;   `hl`: span start, tiles
;   `de`: span end, tiles
; Used by c_d1c1, c_e60a, c_e920 and c_e9b1.
moveToMapSpan:  ; #cd9b
        ld (State.screenX), hl
        ld hl, -32
        add hl, de
        ld (State.mapSpanEnd), hl
        call findAndPutObjectsToScene
        call Drawing.setScrTileUpd
        jp Tiles.fillAllScrTiles

    ENDMODULE
