    MODULE Code


; Entry point
entryPoint:  ; #cc25
        di
.lev+*  ld a, #FF
        ld (State.loadedLevel), a
        ld sp, 0
        call initInterrupts
        call detectSpectrumModel

        ; init mirroring table
        ld b, 0
        ld h, high(mirrorTable)
.byte:
        ld l, b
        ld a, b
        ld c, 0
    DUP 8
        rla
        rr c
    EDUP
        ld (hl), c
        djnz .byte

        jp gameStart

gameStart:  ; #cc5a
        call gameMenu
        call clearGameState
.l_2:
        call levelSelectionMenu
        call clearScreenPixels
        ld a, #47               ; bright white ink, black paper
        call fillScreenAttrs
        call clearScene
        call removeObjects      ; not needed
        call initLevel
        ; continue

.gameLoop:
        ld a, (State.s_57)      ; ?
        or a
        jr Z, .l_5

        ld ix, scene.obj1
        ld de, Obj
        ld b, 7
.l_4:
        bit 0, (ix+Obj.flags)
        jr NZ, .l_5

        add ix, de
        djnz .l_4

        ld bc, 5000
        call delay              ; 5 s delay
        jp .l_2

.l_5:
        call performSmartIfSmartKeyPressed
        call c_d4cd
        call c_f553
        call c_ecee             ; (time: long)
        call c_e56f             ; (time: medium)
        call putNextObjectsToScene  ; (time: medium)
        call boss_logic
        call c_e60a
        call decBlinkTime
        call c_e6e1             ; (time: medium)
        call c_d308
        call c_d709             ; (time: long)
        call c_e920
        call c_e9b1
        call c_df85             ; (time: medium)
        call updateConveyors
        call rollConveyorTiles
        call drawObjectsChecked ; (time: extreme)

        ld c, 3
        call waitFrames

        call updateScreenTiles  ; (time: extreme)

        ld a, (State.s_05)
        or a
        jr Z, .l_6

        xor a
        ld (State.s_05), a
        ld ix, scene.hero
        set 0, (ix+Obj.flags)           ; set that hero exists (why not?)

        call advanceInMap
        call putNextObjectsToScene
.l_6:
        call pauseGameIfPauseKeyPressed
        call checkQuitKey
        jp Z, gameStart

        ld a, (State.s_1F)
        or a
        jr Z, .l_8
        xor a
        ld (State.s_1F), a
        ld a, (State.s_20)
        or a
        jr Z, .l_7
        xor a
        ld (State.s_20), a
        ld a, #32
        call addEnergy
        jr .l_8
.l_7:
        call showGameOver
        jp gameStart
.l_8:
        jp .gameLoop


textGameOver:  ; #cd19
        db "GAME OVER"C

; Used by c_cc25.
showGameOver:  ; #cd22
        call clearScreenPixels
        ld a, #47
        call fillScreenAttrs
        ld hl, #0A0B
        ld de, textGameOver
        ld c, #46
        call printString
.l_0:
        ld a, (controlState)
        bit 4, a
        jr NZ, .l_0
        ld bc, 30000
.l_1:
        ld a, (controlState)
        bit 4, a
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
pauseGameIfPauseKeyPressed:  ; #cd5c
        call checkPauseKey
        ret NZ
.l_0:
        call checkPauseKey
        jr Z, .l_0
        ld hl, #1700            ; at 23, 0
        ld de, textPaused
        ld c, #47               ; bright white
        call printString
.l_1:
        call checkPauseKey
        jr NZ, .l_1
        call checkCheatKey
        jr NZ, .l_2
        ld a, (controlState)
        bit 3, a
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
        ld b, 8
        ld ix, scene
.object:
        ld l, (ix+Obj.x+0)
        ld h, (ix+Obj.x+1)            ; `hl`: x coord in pixels
        ld de, -64
        add hl, de
        bit 7, h
        jr Z, .skip             ; if x >= 64, skip
        ld (ix+Obj.flags), 0            ; else, mark as non-existent
.skip:
        ld (ix+Obj.x+0), l
        ld (ix+Obj.x+1), h

        ld a, (ix+Obj.o_23)           ; ? (possibly, horizontal moving)
        cp 1
        jr NZ, .l_2

        ld l, (ix+Obj.o_30+0)
        ld h, (ix+Obj.o_30+1)
        add hl, de
        ld (ix+Obj.o_30+0), l
        ld (ix+Obj.o_30+1), h
.l_2:
        ld de, Obj               ; next scene object
        add ix, de
        djnz .object
        ret


; Score string (6 decimal digits in ASCII with a stop bit)
scoreString:  ; #cf51
        block 6

; Score (6 decimal digits)
score:  ; #cf57
        block 6

; Score table (decimal)
; (sub-labels point to the last digit)
scoreTable:  ; #cf5d
.walk+4 db 0, 0, 0, 6, 3        ; advance in map
        db 0, 0, 1, 0, 0
        db 0, 0, 2, 0, 0
        db 0, 0, 4, 0, 0
        db 0, 0, 8, 0, 0
        db 0, 1, 6, 0, 0
        db 0, 3, 2, 0, 0
.done+4 db 2, 0, 0, 0, 0        ; level complete

; Add score by index
;   `a`: index in the score table (1..6)
; Used by c_e4fc and c_e6e1.
addScore:  ; #cf85
        or a
        ret Z
        ld l, a
    .2  add a
        add l
        ld l, a
        ld h, 0
        ld de, scoreTable
        add hl, de
        ld de, 4
        add hl, de
        ex de, hl
        jr addScoreRaw

; Add score by addr
;   `de`: addr of the last digit in the score table
; This entry point is used by c_cdae and c_ec00.
addScoreRaw:
        ld hl, score + 5
        or a
        ld b, 5
.l_0:
        ld a, (de)
        adc a, (hl)
        cp 10
        jp NC, addScoreSetCarry
        or a
.l_1:
        ld (hl), a
        dec hl
        dec de
        djnz .l_0
        ld a, (hl)
        adc a, 0
        cp 10
        jp C, .l_2
        xor a
.l_2:
        ld (hl), a

; Print score number
; This entry point is used by c_c76f and c_d1c1.
printScore:
        ld hl, score
        ld de, scoreString
        ld b, 6
.l_0:
        ld a, (hl)
        add '0'
        ld (de), a
        inc hl
        inc de
        djnz .l_0
        dec de
        ex de, hl
        set 7, (hl)
.yx+*   ld hl, -0               ; `h`: y coord, `l`: x coord
        ld de, scoreString
        ld c, #47               ; bright white
        jp printString

addScoreSetCarry:
        sub 10
        scf
        jp addScoreRaw.l_1

; Clear score at #CF57?
; Used by c_d133.
clearScore:  ; #cfdb
        ld hl, score
        ld b, #06
.l_0:
        ld (hl), #00
        inc hl
        djnz .l_0
        ret


; Print coins in the panel
; Used by c_d1c1, c_e6e1 and c_e9b1.
printCoinCount:  ; #cfe6
        ld a, (State.coins)
        ld hl, #000B            ; at 0, 12
        ld c, #46               ; bright yellow
        jp printNumber

printNumber:
        push bc
        ld bc, 0
.hundreds:
        sub 100
        inc c
        jr NC, .hundreds
        add 100
        dec c
.tens:
        sub 10
        inc b
        jr NC, .tens
        add 10
        dec b
        add '0'|#80
        ld (State.coinDigits + 2), a
        ld a, b
        add '0'
        ld (State.coinDigits + 1), a
        ld a, c
        add '0'
        ld (State.coinDigits + 0), a
        pop bc
        ld de, State.coinDigits
        jp printString


soupCanStrings:
.one:   db "/  "C
.two:   db "// "C
.three: db "///"C

; Print soup cans in the panel
; Used by c_d1c1, c_e6e1 and c_e9b1.
printSoupCans:  ; #d026
        ld a, (State.soupCans)
        dec a
        ld l, a
        add a
        add l
        ld l, a
        ld h, #00
        ld de, soupCanStrings
        add hl, de
        ex de, hl
        ld hl, #0007
        ld c, #43
        jp printString


; Energy characters
energyChars:  ; #d03d
        db "(((****,,,,,,,,,,"  ; energy full, they look all the same

; Print energy in the panel
; Used by c_d09a, c_d0af, c_d1c1, c_e9b1 and c_f618.
printEnergy:  ; #d04e
        ld hl, State.energyText
        push hl
        ld b, 17
.l_0:
        ld (hl), " "
        inc hl
        djnz .l_0

        pop hl
        ld de, energyChars
        ld a, (State.energy)
        ld c, a
        cp 2
        jr C, .l_2

        srl a
        ld b, a
.l_1:
        ld a, (de)
        ld (hl), a
        inc hl
        inc de
        djnz .l_1
.l_2:
        bit 0, c
        jr Z, .l_3
        ld a, (de)
        inc a
        ld (hl), a
        inc hl
.l_3:
        ld a, (State.energy)
        ld b, a
        ld a, (State.maxEnergy)
        sub b
        srl a
        jr Z, .l_5

        ld b, a
.l_4:
        ld (hl), "."            ; energy empty
        inc hl
        djnz .l_4
.l_5:
        ld hl, State.energyText + 16
        set 7, (hl)

        ld hl, #000F            ; at 0, 15
        ld de, State.energyText
        call printString
        call applyLifeIndicatorAttrs
        ret


; Add energy
; Used by c_cc25, c_cd5c, c_e6e1 and c_e9b1.
addEnergy:  ; #d09a
        exa
        ld a, (State.maxEnergy)
        ld b, a
        exa
        ld c, a
        ld a, (State.energy)
        add c
        cp b
        jr C, .l_0
        ld a, b
.l_0:
        ld (State.energy), a
        jp printEnergy

; Decrement energy
; Used by c_d709 and c_e6e1.
decEnergy:  ; #d0af
        ld a, (ix+Obj.blinkTime)
        or a
        ret NZ
        ld a, (State.energy)
        sub 1
        jr NC, .l_0
        ld a, #FF
        ld (State.s_1F), a
        xor a
.l_0:
        ld (State.energy), a
        ld (ix+Obj.blinkTime), #07
        ld a, #0C
        call playSound
        jp printEnergy


; Decrement blinking time for all scene objects
; Used by c_cc25.
decBlinkTime:  ; #d0d0
        ld ix, scene
        ld b, 8
        ld de, Obj
.object:
        ld a, (ix+Obj.blinkTime)           ; blink time
        or a
        jr Z, .skip

        dec a
        ld (ix+Obj.blinkTime), a
        and 1                   ; even/odd
        jr NZ, .skip
        set 4, (ix+Obj.flags)           ; blink flag
.skip:
        add ix, de
        djnz .object
        ret


; Delay for approximately `bc` milliseconds
; Used by c_c6d5, c_cc25, c_d553 and c_d6c0.
delay:  ; #d0f0
        push bc
        ld b, #FF
.loop:
        djnz .loop
        pop bc
        dec bc
        ld a, b
        or c
        jr NZ, delay
        ret


; Random number generation
; Used by c_e52d, c_ef72, c_f4e9, c_f670, c_f697, c_f8f4 and c_fa65.
generateRandom:  ; #d0fc
        push hl, de

        ld hl, (randomSeed)
        ld de, (longFrameCounter.low)
        add hl, de
        ld de, 13
        add hl, de
        ld de, (longFrameCounter.high)
        adc hl, de
        xor l
        xor d
        xor e
        xor h
        ld l, a
        ld (randomSeed), hl

        pop de, hl
        ret

; (possibly, rnd seed?)
randomSeed:  ; #d11b
        dw 0

; 32-bit frame counter, used in random number generation
longFrameCounter:  ; #d11d
.low:   dw 0
.high:  dw 0


; Increments the 32-bit frame counter
; Called in every interrupt
incrementLongFrameCounter:  ; #d121
        ld hl, (longFrameCounter.low)
        inc hl
        ld (longFrameCounter.low), hl
        ld a, l
        or h
        ret NZ

        ld hl, (longFrameCounter.high)
        inc hl
        ld (longFrameCounter.high), hl
        ret


; Clears something before the game
; Used by c_cc25.
clearGameState:  ; #d133
        ld hl, State.start
        ld de, State.start + 1
        ld bc, State.length - 1
        ld (hl), 0
        ldir

        ld a, 18
        ld (State.maxEnergy), a

        call clearScore
        ld b, 5
        ld hl, State.levelsDone
.l_0:
        ld (hl), 0
        inc hl
        djnz .l_0
        ret

; Initialize the hero object and place it to the start position
;   `bc`: hero's position (x, y), blocks
; Used by c_d1c1.
initHero:  ; #d153
        ld ix, scene.hero
        ld l, b
        ld h, 0
    .5  add hl, hl
        ld de, 32
        add hl, de              ; `hl` = `b` × 32 + 32
        ld (ix+Obj.x+0), l
        ld (ix+Obj.x+1), h            ; set x coord in pixels

        ld a, c
    .5  add a
        add 40                  ; `a` = `c` × 32 + 40
        ld (ix+Obj.y), a            ; set y coord in pixels

        ld hl, cS.heroStands
        ld a, (State.weapon)
        cp 2
        jr C, .noGun
        ld hl, cS.armedHeroStands
.noGun:
        ld (ix+Obj.sprite+0), l
        ld (ix+Obj.sprite+1), h            ; set sprite addr

        ld (ix+Obj.o_21), 1           ; mirror (?)
        ld (ix+Obj.flags), %00000011    ; flags: exists, big
        ld (ix+Obj.o_10), #10         ; ?
        ld (ix+Obj.o_11), #15         ; ?
        ld (ix+Obj.o_7), 0            ; ?
        ld (ix+Obj.color), #47          ; attr: bright white
        ld (ix+Obj.o_8), #FF          ; ?
        xor a
        ld (State.s_28), a      ; ?
        ld (State.s_41), a      ; ?
        ret


; Start position (x, y) and map span (start, end) by level
startPositions:  ; #d1ab
;          x  y start end
.lev0:  db 1, 4,  0,  54
.lev1:  db 1, 4,  0, 108
.lev2:  db 3, 4,  0, 138
.lev3:  db 2, 4,  0, 126
.lev4:  db 1, 3,  0,  40


; (used in #C884 and #D213)
conveyorTileIndices:  ; #d1bf
.left:  db #73
.right: db #74


; Init level / game state
; Used by c_cc25.
initLevel:  ; #d1c1
        ld a, 1
        ld (State.soupCans), a
        ld a, (State.maxEnergy)
        ld (State.energy), a
        xor a
        ld (State.coins), a
        ld (State.weapon), a

        ; panel info
        call printCoinCount
        call printScore
        call printEnergy
        call printSoupCans

        xor a
        ld (State.s_54), a
        ld (State.s_46), a
        ld (State.s_57), a
        inc a
        ld (State.hasSmart), a

        ; set hero's start position
        ld a, (State.level)
    .2  add a
        ld l, a
        ld h, 0
        ld de, startPositions
        add hl, de

        ld b, (hl)              ; start x coord, blocks
        inc hl
        ld c, (hl)              ; start y coord, blocks
        push bc
        inc hl
        ld a, (hl)              ; map span start, blocks
        inc hl
        ld l, (hl)              ; map span end, blocks
        ld h, 0
    .2  add hl, hl
        ex de, hl
        ld l, a
        ld h, 0
    .2  add hl, hl
        ; `hl`: map span start, tiles
        ; `de`: map span end, tiles
        call moveToMapSpan

        pop bc                  ; hero's start position, blocks
        call initHero
        ret


; Finds conveyors in the screen tiles
; Used by c_cecc.
findConveyors:  ; #d213
        ld a, (conveyorTileIndices.left)
        ld (scrTiles.stop + 1), a   ; stop-value
        ld hl, scrTiles.row1 + 3    ; before first visible tile
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
        ld bc, scrTiles.stop + 1
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
        ld de, scrTileUpd - scrTiles
        ld ix, State.conveyors
.conveyor:
        ld l, (ix+Conveyor.start+0)
        ld h, (ix+Conveyor.start+1)
        ld a, h
        or l
        ret Z

        ld b, (ix+Conveyor.length)
        add hl, de              ; conveyor addr in `scrTileUpd`
.tile:
        ld (hl), 1              ; update
        inc hl
        djnz .tile

    .3  inc ix                  ; next conveyor
        jp .conveyor


; Clear the `scene` in some crazy way
; Used by c_cc25.
clearScene:  ; #d29a
        ld hl, 0
        ld de, Obj
        ld b, 8
.l_0:
        add hl, de
        djnz .l_0
        ld c, l
        ld b, h
        ld hl, scene
.l_1:
        ld (hl), 0
        inc hl
        dec bc
        ld a, b
        or c
        jr NZ, .l_1
        ret


; (Some game logic?)
; Used by c_ec00.
c_d2b3:  ; #d2b3
        bit 1, (iy+Obj.flags)
        jr Z, .l_0
        res 1, (iy+Obj.flags)
        ld l, (iy+Obj.x+0)
        ld h, (iy+Obj.x+1)
        ld de, #0004
        add hl, de
        ld (iy+Obj.x+0), l
        ld (iy+Obj.x+1), h
        ld a, (iy+Obj.y)
        add #04
        ld (iy+Obj.y), a
.l_0:
        ld hl, cS.coin
        ld (iy+Obj.sprite+0), l
        ld (iy+Obj.sprite+1), h
        ld (iy+Obj.o_7), #00
        ld (iy+Obj.o_23), #06
        ld (iy+Obj.o_8), #06
        ld (iy+Obj.o_21), #00
        ld (iy+Obj.o_15), #00
        ld (iy+Obj.o_12), #FE
        ld (iy+Obj.color), #46
        res 5, (iy+Obj.flags)
        res 3, (iy+Obj.flags)
        res 2, (iy+Obj.flags)
        xor a
        ret

; (Some game logic?)
; Used by c_cc25.
c_d308:  ; #d308
        ld ix, scene
        bit 0, (ix+Obj.o_24)
        jp NZ, .l_3
        ld a, (State.s_28)
        cp #03
        jr Z, .l_0
        cp #02
        ret NZ
        ld a, (State.s_37)
        or a
        ret M
.l_0:
        ld iy, scene.obj2
        ld b, #06
.l_1:
        call c_d3bb
        jr NZ, .l_2
        ld de, Obj
        add iy, de
        djnz .l_1
        ret
.l_2:
        xor a
        ld (State.s_28), a
        ld (State.s_41), a
        ld (ix+Obj.o_19), #00
        set 0, (ix+Obj.o_24)
        push iy
        pop hl
        ld (ix+Obj.o_30+0), l
        ld (ix+Obj.o_30+1), h
.l_3:
        ld l, (ix+Obj.o_30+0)
        ld h, (ix+Obj.o_30+1)
        push hl
        pop iy
        call c_d3bb
        jr NZ, .l_4
        res 0, (ix+Obj.o_24)
        ret
.l_4:
        ld hl, cS.heroStands
        ld a, (State.weapon)
        cp 2
        jr C, .l_5
        ld hl, cS.armedHeroStands
.l_5:
        ld (ix+Obj.sprite+0), l
        ld (ix+Obj.sprite+1), h
        ld a, (iy+Obj.y)
        sub (ix+Obj.o_11)
        ld (ix+Obj.y), a
        ld c, (iy+Obj.o_21)
        ld a, (iy+Obj.o_23)
        cp #03
        jr Z, .l_6
        ld c, (iy+Obj.o_18)
.l_6:
        ld a, c
        and #03
        ret Z
        ld a, (iy+Obj.o_19)
        ld d, #00
        bit 0, c
        jr NZ, .l_7
        neg
        ld d, #FF
.l_7:
        ld e, a
        push de
        bit 0, c
        jr NZ, .l_8
        call c_de37
        pop de
        or a
        jr Z, .l_9
        ret
.l_8:
        call c_deb1
        pop de
        ret NZ
.l_9:
        ld l, (ix+Obj.x+0)
        ld h, (ix+Obj.x+1)
        add hl, de
        ld (ix+Obj.x+0), l
        ld (ix+Obj.x+1), h
        ret

; (Some game logic?)
; Used by c_d308.
c_d3bb:  ; #d3bb
        bit 0, (iy+Obj.flags)
        ret Z
        bit 0, (iy+Obj.o_24)
        ret Z
        ld a, (ix+Obj.y)
        add (ix+Obj.o_11)
        sub (iy+Obj.y)
        jp P, .l_0
        neg
.l_0:
        cp #05
        jr NC, .l_1
        ld l, (ix+Obj.x+0)
        ld h, (ix+Obj.x+1)
        ld de, #0014
        add hl, de
        ld e, (iy+Obj.x+0)
        ld d, (iy+Obj.x+1)
        xor a
        sbc hl, de
        jr C, .l_1
        ld l, (iy+Obj.o_10)
        ld h, #00
        add hl, de
        ld e, (ix+Obj.x+0)
        ld d, (ix+Obj.x+1)
        inc de
        inc de
        inc de
        inc de
        xor a
        sbc hl, de
        jr C, .l_1
        ld a, #FF
        or a
        ret
.l_1:
        xor a
        ret

; ?
; Used by c_ef72 and c_f37e.
c_d407:  ; #d407
        ld hl, #0160
        ld (.de), hl
        jr .l_1
; This entry point is used by c_df85 and c_f618.
.l_0:
        ld hl, #0120
        ld (.de), hl
.l_1:
        ld a, (ix+Obj.y)
        cp #E0
        jr NC, .l_2
        ld c, (ix+Obj.o_11)
        add c
        cp #20
        jr C, .l_2
        ld l, (ix+Obj.x+0)
        ld h, (ix+Obj.x+1)
        push hl
        ld d, #00
        ld e, (ix+Obj.o_10)
        add hl, de
        ld de, #0020
        xor a
        sbc hl, de
        pop hl
        jr C, .l_2
.de+*   ld de, #0120
        xor a
        sbc hl, de
        ret C
.l_2:
        xor a
        ret

; Subtracts constants from some object properies?
; Used by c_ec00 and c_ed08.
c_d443:  ; #d443
        ld l, (ix+Obj.x+0)
        ld h, (ix+Obj.x+1)
        ld de, -4
        add hl, de
        ld (ix+Obj.x+0), l
        ld (ix+Obj.x+1), h
        ld a, #FE
        add (ix+Obj.y)
        ld (ix+Obj.y), a
        set 1, (ix+Obj.flags)
        ret

; ?
; Used by c_dce1, c_dd09, c_dd46, c_dd73, c_df85, c_f1d7, c_f2e7 and
; c_f618.
c_d460:  ; #d460
        push bc
        push de
        ld a, (ix+Obj.y)
        cp #20
        jr NC, .l_0
        ld a, #21
        jr .l_1
.l_0:
        cp #E0
        jr C, .l_1
        ld a, #DF
.l_1:
        and #F8
        ld l, a
        ld h, #00
        ld e, a
        ld d, h
        srl d
        rr e
        ld c, a
        ld b, h
        add hl, hl
        add hl, hl
        add hl, bc
        add hl, de
        ld (.hl), hl
        ld l, (ix+Obj.x+0)
        ld h, (ix+Obj.x+1)
        ld a, (ix+Obj.o_8)
        cp #0E
        jr Z, .l_4
        ld de, #0020
        xor a
        sbc hl, de
        jr NC, .l_2
        ld hl, #0020
        jr .l_4
.l_2:
        ld de, #0100
        xor a
        sbc hl, de
        jp P, .l_3
        ld l, (ix+Obj.x+0)
        ld h, (ix+Obj.x+1)
        jr .l_4
.l_3:
        ld hl, #0120
.l_4:
        srl h
        rr l
        srl h
        rr l
        srl h
        rr l
        ex de, hl
.hl+*   ld hl, -0
        add hl, de
        ld de, scrTiles
        add hl, de
        pop de
        pop bc
        ret

; (Set some object properties?)
; Used by c_cc25.
c_d4cd:  ; #d4cd
        ld ix, scene.obj1
        ld b, #07
        ld de, Obj
.l_0:
        bit 7, (ix+Obj.flags)
        jr Z, .l_1
        ld (ix+Obj.flags), #00
.l_1:
        add ix, de
        djnz .l_0
        ret


; Used by c_cc25.
performSmartIfSmartKeyPressed:  ; #d4e5
        call checkSmartKey
        ret NZ
        ld a, (State.hasSmart)
        or a
        ret Z

        ; perform smart
        ld a, (State.s_54)
        or a
        ret NZ
        ld iy, scene.obj2
        ld b, #06
.l_0:
        push bc
        bit 3, (iy+Obj.o_24)
        jr NZ, .l_1
        ld l, (iy+Obj.x+0)
        ld h, (iy+Obj.x+1)
        ld de, #0120
        xor a
        sbc hl, de
        jr NC, .l_1
        call c_ec00.l_0
.l_1:
        ld de, Obj
        add iy, de
        pop bc
        djnz .l_0
        xor a
        ld (State.hasSmart), a
        ret


textSelectLevel:  ; #d51e
        db "SELECT  LEVEL"C

levelNames:  ; #d52b
        db "KLONDIKE"C
        db " ORIENT "C
        db " AMAZON "C
        db "ICELAND "C
.bermuda
        db "BERMUDA "C

; Show level selection menu
; Used by c_cc25.
levelSelectionMenu:  ; #d553
        call clearScreenPixels
        ld a, #47
        call fillScreenAttrs
        ld hl, #0809
        ld de, textSelectLevel
        ld c, #46
        call printString
        ld hl, State.levelsDone
        ld b, #05
        xor a
.l_0:
        add (hl)
        inc hl
        djnz .l_0
        cp 5
        jp Z, gameWin
        cp 4
        jr NZ, .l_3
        ld de, levelNames.bermuda
        ld hl, #0B0C
        ld c, #47
        call printString
        ld a, #04
        ld (State.level), a
.l_1:
        ld a, (controlState)
        bit 4, a
        jr NZ, .l_1
.l_2:
        ld a, (controlState)
        bit 4, a
        jr Z, .l_2
        jp .l_7
.l_3:
        ld a, (controlState)
        ld c, a
        ld a, (State.level)
        bit 2, c
        jr Z, .l_4
        dec a
        jr .l_5
.l_4:
        bit 3, c
        jr Z, .l_5
        inc a
.l_5:
        and #03
        ld (State.level), a
        ld l, a
        ld h, #00
        ld de, State.levelsDone
        add hl, de
        ld a, (hl)
        or a
        jr Z, .l_6
        ld a, (State.level)
        inc a
        jr .l_5
.l_6:
        ld a, (State.level)
        add a
        add a
        add a
        ld l, a
        ld h, #00
        ld de, levelNames
        add hl, de
        ex de, hl
        ld hl, #0B0C
        ld c, #47
        call printString
        ld bc, #00FA
        call delay
        ld a, (controlState)
        bit 4, a
        jr Z, .l_3
.l_7:
        call loadLevelIfNeeded
        jp NC, levelSelectionMenu
        ld a, #00
        out (#FE), a
        call clearScreenPixels
        ld hl, #0E0B
        ld de, textPressFire
        ld c, #47
        call printString
.l_8:
        ld a, (controlState)
        bit 4, a
        jr Z, .l_8
        ret


; Tape messages
textLoadError:  ; #d606
        db "LOAD ERROR"C
textPressFire:  ; #d610
        db "PRESS FIRE"C
textStartTape:  ; #d61A
        db "START TAPE"C
textLoading:  ; #d624
        db " LOADING"C

; Load level if needed
; Used by c_d553.
loadLevelIfNeeded:  ; #d62c
        ld a, (State.loadedLevel)
        ld b, a
        ld a, (State.level)
        cp b
        jr NZ, .l_0
        scf
        ret
.l_0:
        call clearScreenPixels
        ld de, textStartTape
        ld hl, #0C0B
        ld c, #47
        call printString
        call Tape.loadLevel
        jr NC, .l_1
        ld a, (State.level)
        ld (State.loadedLevel), a
        scf
        ret
.l_1:
        push af
        ld a, #FF
        ld (State.loadedLevel), a
        call clearScreenPixels
        ld hl, #0C0B
        ld de, textLoadError
        ld c, #46
        call printString
        inc de
        ld hl, #0E0B
        ld c, #47
        call printString
.l_2:
        ld a, (controlState)
        bit 4, a
        jr Z, .l_2
        pop af
        ret


; Game epilogue text
epilogueText:  ; #d679
        db "  GOOD WORK MONTY"C
        db "THE FIVE SCROLLS ARE"C
        db "SAFE  YOU HAVE SAVED"C
        db "    OUR PLANET"C

; Successful end of the game
; Used by c_d553.
gameWin:  ; #d6c0
        ld hl, #0806
        ld de, epilogueText
        ld c, #42
        ld b, #04
.l_0:
        push bc
        push hl
        call printString
        inc de
        pop hl
        inc h
        inc h
        pop bc
        inc c
        djnz .l_0
        ld bc, 30000
        call delay
.l_1:
        ld a, (controlState)
        or a
        jr Z, .l_1
        pop hl
        jp gameStart


    ENDMODULE
