    MODULE Code


textGameOver:  ; #cd19
        db "GAME OVER"C

; Used by c_cc25.
showGameOver:  ; #cd22
        call clearScreenPixels
        ld a, Colour.brWhite    ; bright white ink, black paper
        call fillScreenAttrs
        ld hl, #0A0B
        ld de, textGameOver
        ld c, Colour.brYellow
        call printString
.l_0:
        ld a, (controlState)
        bit Key.fire, a
        jr NZ, .l_0
        ld bc, 30000
.l_1:
        ld a, (controlState)
        bit Key.fire, a
        jr NZ, .l_3
        exx
        ld b, #C8
.l_2:
        djnz .l_2
        exx
        dec bc
        ld a, b
        or c
        jr NZ, .l_1
.l_3:
        ret


textPaused:  ; #cd52
        db "  PAUSED  "C

; Pause the game
; Used by c_cc25.
pauseGameIfPressed:  ; #cd5c
        call checkPauseKey
        ret NZ
.l_0:
        call checkPauseKey
        jr Z, .l_0
        ld hl, #1700            ; at 23, 0
        ld de, textPaused
        ld c, Colour.brWhite
        call printString
.l_1:
        call checkPauseKey
        jr NZ, .l_1
        call checkCheatKey
        jr NZ, .l_2
        ld a, (controlState)
        bit Key.up, a
        jr Z, .l_2
        ld a, #22
        ld (State.maxEnergy), a
        ld a, #32
        call addEnergy
.l_2:
        call checkPauseKey
        jr Z, .l_2
        ld hl, scrTileUpd.row23 + 4
        ld b, 10
.l_3:
        ld (hl), 1
        inc hl
        djnz .l_3
        ret


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
        call setScrTileUpd
        jp fillAllScrTiles


; Scroll the screen an add new objects to the scene
; Used by c_cc25.
advanceInMap:  ; #cdae
        ld hl, scrTileUpd
        ld de, scrTileUpd + 1
        ld (hl), 0
        ld bc, scrTileUpd.length - 1
        ldir

        call drawObjectsUnchecked
        call cleanUpObjTiles
        ld c, 3
        call waitFrames
        ld hl, scrTiles.row1 + 4
        exx
        ld hl, scrTiles.row1 + 6
        ld de, scrTileUpd.row1 + 6
        call moveScreenTiles
        ld c, 1
        call waitFrames
        ld hl, scrTiles.row1 + 6
        exx
        ld hl, scrTiles.row1 + 10
        ld de, scrTileUpd.row1 + 10
        call moveScreenTiles
        ld c, 5
        call waitFrames
        ld hl, scrTiles.row1 + 10
        exx
        ld hl, scrTiles.row1 + 12
        ld de, scrTileUpd.row1 + 12
        call moveScreenTiles
        call advanceObjectsInMap
        ld hl, (State.screenX)
        ld de, 8
        add hl, de
        ld (State.screenX), hl
        call scrollScrTiles
        call fillNextScrTiles

        ld hl, scrTileUpd
        ld de, scrTileUpd + 1
        ld (hl), 0
        ld bc, scrTileUpd.length - 1
        ldir

        call drawObjectsChecked
        call updateScreenTiles
        ld de, scoreTable.walk
        jp addScoreRaw


; Mark object tiles to be updated during screen scrolling
; Used by c_cdae.
cleanUpObjTiles:  ; #ce23
        ld de, -3
        ld hl, scrTileUpd.row1
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
; Used by c_cdae.
scrollScrTiles:  ; #ce57
        ld de, scrTiles.row0
        ld hl, scrTiles.row0 + 8
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


; Fills right off-screen area of scrTiles with tiles form level map
; Used by c_cdae.
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
        ld de, scrTiles.row0 + 36
        ld b, 2
        jp fillScrTiles

; Fills entire scrTiles with tiles form level map
; Used by c_cd9b.
fillAllScrTiles:  ; #cecc
        ld hl, (State.screenX)
        ld e, l
        ld d, h
        sra h
        rr l
        add hl, de
        ld de, Level.blockMap
        add hl, de
        ld de, scrTiles.row0 + 4
        ld b, 10

; Fills some area in scrTiles with tiles form level map
;   `hl`: start addr in blockMap
;   `de`: start addr in scrTiles
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


; Advance scene objects in map
; Used by c_cdae.
advanceObjectsInMap:  ; #cf17
        ld b, 8                 ; object count
        ld ix, scene
.object:
        ld l, (ix+Obj.x+0)
        ld h, (ix+Obj.x+1)      ; `hl`: x coord in pixels
        ld de, -64
        add hl, de
        bit 7, h
        jr Z, .skip             ; if x >= 64, skip
        ld (ix+Obj.flags), 0    ; else, remove object
.skip:
        ld (ix+Obj.x+0), l
        ld (ix+Obj.x+1), h

        ld a, (ix+Obj.motion)
        cp Motion.bullet
        jr NZ, .nextObject

        ld l, (ix+Obj.aim.curX+0)
        ld h, (ix+Obj.aim.curX+1)
        add hl, de
        ld (ix+Obj.aim.curX+0), l
        ld (ix+Obj.aim.curX+1), h

.nextObject:
        ld de, Obj              ; object size
        add ix, de
        djnz .object
        ret


    ENDMODULE
