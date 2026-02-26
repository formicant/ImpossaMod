    MODULE Tiles

; Mark object tiles to be updated during screen scrolling
cleanUpObjTiles:  ; #ce23
        ld de, -3
        ld hl, Tables.scrTileUpd.row1
        ld c, 4
        xor a
        ld b, a
.l_0:
        or (hl)
        jp NZ, .l_3
.l_1:
        inc hl
.l_2:
        djnz .l_0

        dec c
        jp NZ, .l_0
        ret

.l_3:
        cp 1
        ld a, 0
        jp Z, .l_1

    .2  inc hl
        ld a, (hl)
        and a
        jp NZ, .l_4
        ld (hl), 1
.l_4:
    .2  inc hl
        ld a, (hl)
        and a
        jp NZ, .l_5
        ld (hl), 1
.l_5:
        add hl, de
        xor a
        jp .l_2


; Move screen tiles to the left by 8 tiles
scrollScrTiles:  ; #ce57
        ld de, Tables.scrTiles.row0
        ld hl, Tables.scrTiles.row0 + 8
        ld a, 24
.row:
    .36 ldi

        ld bc, 8
        add hl, bc
        ex de, hl
        add hl, bc
        ex de, hl
        dec a
        jr NZ, .row
        ret


; Fills right off-screen area of Tables.scrTiles with tiles form level map
fillNextScrTiles:  ; #ceb2
        ld hl, (State.screenX)
        ld de, 32
        add hl, de
        ld e, l
        ld d, h
        sra h
        rr l
        add hl, de
        ld de, Level.blockMap
        add hl, de
        ld de, Tables.scrTiles.row0 + 36
        ld b, 2
        jp fillScrTiles

; Fills entire Tables.scrTiles with tiles form level map
fillAllScrTiles:  ; #cecc
        ld hl, (State.screenX)
        ld e, l
        ld d, h
        sra h
        rr l
        add hl, de
        ld de, Level.blockMap
        add hl, de
        ld de, Tables.scrTiles.row0 + 4
        ld b, 10

; Fills some area in Tables.scrTiles with tiles form level map
;   `hl`: start addr in blockMap
;   `de`: start addr in Tables.scrTiles
;   `b`: width in blocks
fillScrTiles:
.block_column:
        push bc
        push de
        ld b, 6
.block:
        push bc
        push hl
        ld l, (hl)
        ld h, 0
    .4  add hl, hl
        ld bc, Level.tileBlocks
        add hl, bc
        ld a, 4
.tileRow:
        ld bc, 44
    .4  ldi
        ex de, hl
        add hl, bc
        ex de, hl
        dec a
        jp NZ, .tileRow

        pop hl
        inc hl
        pop bc
        djnz .block

        pop de
        push hl
        ld hl, 4
        add hl, de
        ex de, hl
        pop hl
        pop bc
        djnz .block_column

        jp findConveyors

    ENDMODULE
