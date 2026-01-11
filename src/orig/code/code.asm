    MODULE Code


; Entry point
entryPoint:  ; #cc25
        di
        ld a, #FF
        ld (State.loadedLevel), a
        ld sp, 0
        call initInterrupts
        call detectSpectrumModel
        
        ; init mirroring table
        ld b, 0
        ld h, #6A
.l_0:
        ld l, b
        ld a, b
        ld c, 0
    DUP 8
        rla
        rr c
    EDUP
        ld (hl), c
        djnz .l_0
        
        jp gameStart

gameStart:  ; #cc5a
        call gameMenu
        call clearGameState
.l_2:
        call levelSelectionMenu
        call clearScreenPixels
        ld a, #47
        call fillScreenAttrs
        call c_d29a
        call c_e5f2
        call c_d1c1
        
.gameLoop:
        ld a, (State.s_57)
        or a
        jr Z, .l_5
        ld ix, #BEE6
        ld de, #0032
        ld b, #07
.l_4:
        bit 0, (ix+5)
        jr NZ, .l_5
        add ix, de
        djnz .l_4
        ld bc, 5000
        call delay
        jp .l_2
        
.l_5:
        call c_d4e5
        call c_d4cd
        call c_f553
        call c_ecee
        call c_e56f
        call c_f6e7
        call c_f8cb
        call c_e60a
        call c_d0d0
        call c_e6e1
        call c_d308
        call c_d709
        call c_e920
        call c_e9b1
        call c_df85
        call c_d278
        call rollConveyorTiles
        call c_c044
        
        ld c, 3
        call waitFrames
        
        call c_c561
        ld a, (State.s_05)
        or a
        jr Z, .l_6
        
        xor a
        ld (State.s_05), a
        ld ix, c_beb4
        set 0, (ix+5)
        call c_cdae
        call c_f6e7
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
        call c_d09a
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
        ld bc, #7530
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
        ld hl, #1700
        ld de, textPaused
        ld c, #47
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
        call c_d09a
.l_2:
        call checkPauseKey
        jr Z, .l_2
        ld hl, #6528
        ld b, #0A
.l_3:
        ld (hl), #01
        inc hl
        djnz .l_3
        ret

; ?
; Used by c_d1c1, c_e60a, c_e920 and c_e9b1.
c_cd9b:  ; #cd9b
        ld (State.screenX), hl
        ld hl, -32
        add hl, de
        ld (State.s_03), hl
        call c_f6ba
        call c_c636
        jp c_cecc

; (Advance in map?)
; Used by c_cc25.
c_cdae:  ; #cdae
        ld hl, #6080
        ld de, #6081
        ld (hl), #00
        ld bc, #057F
        ldir
        call c_c060
        call c_ce23
        ld c, 3
        call waitFrames
        ld hl, #5BE0
        exx
        ld hl, #5BE2
        ld de, #6162
        call c_c4c0
        ld c, 1
        call waitFrames
        ld hl, #5BE2
        exx
        ld hl, #5BE6
        ld de, #6166
        call c_c4c0
        ld c, 5
        call waitFrames
        ld hl, #5BE6
        exx
        ld hl, #5BE8
        ld de, #6168
        call c_c4c0
        call c_cf17
        ld hl, (State.screenX)
        ld de, #0008
        add hl, de
        ld (State.screenX), hl
        call c_ce57
        call c_ceb2
        ld hl, #6080
        ld de, #6081
        ld (hl), #00
        ld bc, #057F
        ldir
        call c_c044
        call c_c561
        ld de, c_cf61
        jp c_cf85.l_0

; ?
; Used by c_cdae.
c_ce23:  ; #ce23
        ld de, -3
        ld hl, #615C
        ld c, #04
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
        cp #01
        ld a, #00
        jp Z, .l_1
        inc hl
        inc hl
        ld a, (hl)
        and a
        jp NZ, .l_4
        ld (hl), #01
.l_4:
        inc hl
        inc hl
        ld a, (hl)
        and a
        jp NZ, .l_5
        ld (hl), #01
.l_5:
        add hl, de
        xor a
        jp .l_2

; (Screen scrolling?)
; Used by c_cdae.
c_ce57:  ; #ce57
        ld de, #5BB0
        ld hl, #5BB8
        ld a, #18
.l_0:
    .36 ldi
        ld bc, #0008
        add hl, bc
        ex de, hl
        add hl, bc
        ex de, hl
        dec a
        jr NZ, .l_0
        ret

; (Locate place in level map?)
; Used by c_cdae.
c_ceb2:  ; #ceb2
        ld hl, (State.screenX)
        ld de, #0020
        add hl, de
        ld e, l
        ld d, h
        sra h
        rr l
        add hl, de
        ld de, Level.blockMap
        add hl, de
        ld de, #5BD4
        ld b, #02
        jp c_cecc.l_0

; Copy level map segment to #5BB4 buffer
; Used by c_cd9b.
c_cecc:  ; #cecc
        ld hl, (State.screenX)
        ld e, l
        ld d, h
        sra h
        rr l
        add hl, de
        ld de, Level.blockMap
        add hl, de
        ld de, #5BB4
        ld b, #0A
; This entry point is used by c_ceb2.
.l_0:
        push bc
        push de
        ld b, #06
.l_1:
        push bc
        push hl
        ld l, (hl)
        ld h, 0
    .4  add hl, hl
        ld bc, Level.tileBlocks
        add hl, bc
        ld a, #04
.l_2:
        ld bc, #002C
    .4  ldi
        ex de, hl
        add hl, bc
        ex de, hl
        dec a
        jp NZ, .l_2
        pop hl
        inc hl
        pop bc
        djnz .l_1
        pop de
        push hl
        ld hl, #0004
        add hl, de
        ex de, hl
        pop hl
        pop bc
        djnz .l_0
        jp c_d213

; ?
; Used by c_cdae.
c_cf17:  ; #cf17
        ld b, #08
        ld ix, c_beb4
.l_0:
        ld l, (ix+0)
        ld h, (ix+1)
        ld de, -64
        add hl, de
        bit 7, h
        jr Z, .l_1
        ld (ix+5), #00
.l_1:
        ld (ix+0), l
        ld (ix+1), h
        ld a, (ix+23)
        cp #01
        jr NZ, .l_2
        ld l, (ix+30)
        ld h, (ix+31)
        add hl, de
        ld (ix+30), l
        ld (ix+31), h
.l_2:
        ld de, #0032
        add ix, de
        djnz .l_0
        ret

; Data block at CF51
c_cf51:  ; #cf51
        db #00, #00, #00, #00, #00, #00

; Score ()
c_cf57:  ; #cf57
        db #00, #00, #00, #00, #00

; (?)
c_cf5c:
        db #00

; (Scores table (decimal)?)
c_cf5d:  ; #cf5d
        db #00, #00, #00, #06
c_cf61:  ; #cf61
        db #03, #00, #00, #01
        db #00, #00, #00, #00, #02, #00, #00, #00
        db #00, #04, #00, #00, #00, #00, #08, #00
        db #00, #00, #01, #06, #00, #00, #00, #03
        db #02, #00, #00, #02, #00, #00, #00
c_cf84:  ; #cf84
        db #00

; Add score?
; Used by c_e4fc and c_e6e1.
c_cf85:  ; #cf85
        or a
        ret Z
        ld l, a
        add a
        add a
        add l
        ld l, a
        ld h, #00
        ld de, c_cf5d
        add hl, de
        ld de, #0004
        add hl, de
        ex de, hl
        jr .l_0
; This entry point is used by c_cdae and c_ec00.
.l_0:
        ld hl, c_cf5c
        or a
        ld b, 5
.l_1:
        ld a, (de)
        adc a, (hl)
        cp 10
        jp NC, .l_6
        or a
.l_2:
        ld (hl), a
        dec hl
        dec de
        djnz .l_1
        ld a, (hl)
        adc a, 0
        cp 10
        jp C, .l_3
        xor a
.l_3:
        ld (hl), a
; This entry point is used by c_c76f and c_d1c1.
.l_4:
        ld hl, c_cf57
        ld de, c_cf51
        ld b, 6
.l_5:
        ld a, (hl)
        add '0'
        ld (de), a
        inc hl
        inc de
        djnz .l_5
        dec de
        ex de, hl
        set 7, (hl)
.yx+*   ld hl, -0               ; `h`: y coord, `l`: x coord
        ld de, c_cf51
        ld c, #47               ; bright white
        jp printString
.l_6:
        sub #0A
        scf
        jp .l_2

; Clear score at #CF57?
; Used by c_d133.
c_cfdb:  ; #cfdb
        ld hl, c_cf57
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
        ld hl, #000B            ; y: 0, x: 12
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


; 1 soup can
c_d01d:  ; #d01d
        db "/  "C

; 2 soup cans
c_d020:  ; #d020
        db "// "C

; 3 soup cans
c_d023:  ; #d023
        db "///"C

; Print soup cans in the panel
; Used by c_d1c1, c_e6e1 and c_e9b1.
c_d026:  ; #d026
        ld a, (State.soupCans)
        dec a
        ld l, a
        add a
        add l
        ld l, a
        ld h, #00
        ld de, c_d01d
        add hl, de
        ex de, hl
        ld hl, #0007
        ld c, #43
        jp printString

; Energy characters
c_d03d:  ; #d03d
        db #28, #28, #28, #2A, #2A, #2A, #2A, #2C
        db #2C, #2C, #2C, #2C, #2C, #2C, #2C, #2C
        db #2C

; Print energy in the panel
; Used by c_d09a, c_d0af, c_d1c1, c_e9b1 and c_f618.
c_d04e:  ; #d04e
        ld hl, State.energyText
        push hl
        ld b, #11
.l_0:
        ld (hl), #20
        inc hl
        djnz .l_0
        pop hl
        ld de, c_d03d
        ld a, (State.energy)
        ld c, a
        cp #02
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
        ld (hl), #2E
        inc hl
        djnz .l_4
.l_5:
        ld hl, State.energyText + 16
        set 7, (hl)
        ld hl, #000F
        ld de, State.energyText
        call printString
        call applyLifeIndicatorAttrs
        ret

; Add energy
; Used by c_cc25, c_cd5c, c_e6e1 and c_e9b1.
c_d09a:  ; #d09a
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
        jp c_d04e

; Decrement energy
; Used by c_d709 and c_e6e1.
c_d0af:  ; #d0af
        ld a, (ix+14)
        or a
        ret NZ
        ld a, (State.energy)
        sub #01
        jr NC, .l_0
        ld a, #FF
        ld (State.s_1F), a
        xor a
.l_0:
        ld (State.energy), a
        ld (ix+14), #07
        ld a, #0C
        call playSound
        jp c_d04e


; (Decrement some property for 8 objects at #BEB4)
; Used by c_cc25.
c_d0d0:  ; #d0d0
        ld ix, c_beb4
        ld b, #08
        ld de, #0032
.l_0:
        ld a, (ix+14)
        or a
        jr Z, .l_1
        dec a
        ld (ix+14), a
        and #01
        jr NZ, .l_1
        set 4, (ix+5)
.l_1:
        add ix, de
        djnz .l_0
        ret


; Delay for approximately `bc` milliseconds
; Used by c_c6d5, c_cc25, c_d553 and c_d6c0.
delay:  ; #d0f0
        push bc
        ld b, #FF
.l_0:
        djnz .l_0
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
        
        call c_cfdb
        ld b, 5
        ld hl, State.levelsDone
.l_0:
        ld (hl), 0
        inc hl
        djnz .l_0
        ret

; (Copies something to #BEB4)
; Used by c_d1c1.
c_d153:  ; #d153
        ld ix, c_beb4
        ld l, b
        ld h, #00
        add hl, hl
        add hl, hl
        add hl, hl
        add hl, hl
        add hl, hl
        ld de, #0020
        add hl, de
        ld (ix+0), l
        ld (ix+1), h
        ld a, c
        add a
        add a
        add a
        add a
        add a
        add #28
        ld (ix+2), a
        ld hl, cS.heroStands
        ld a, (State.weapon)
        cp 2
        jr C, .l_0
        ld hl, cS.armedHeroStands
.l_0:
        ld (ix+3), l
        ld (ix+4), h
        ld (ix+21), #01
        ld (ix+5), #03
        ld (ix+10), #10
        ld (ix+11), #15
        ld (ix+7), #00
        ld (ix+9), #47
        ld (ix+8), #FF
        xor a
        ld (State.s_28), a
        ld (State.s_41), a
        ret


; Start position and right limit, 4 bytes per level
c_d1ab:  ; #d1ab
        db 1, 4, 0,  54
        db 1, 4, 0, 108
        db 3, 4, 0, 138
        db 2, 4, 0, 126
        db 1, 3, 0,  40


; (used in #C884 and #D213)
conveyorTileIndices:  ; #d1bf
.left:  db #73
.right: db #74


; Init level / game vars
; Used by c_cc25.
c_d1c1:  ; #d1c1
        ld a, #01
        ld (State.soupCans), a
        ld a, (State.maxEnergy)
        ld (State.energy), a
        xor a
        ld (State.coins), a
        ld (State.weapon), a
        call printCoinCount
        call c_cf85.l_4
        call c_d04e
        call c_d026
        xor a
        ld (State.s_54), a
        ld (State.s_46), a
        ld (State.s_57), a
        inc a
        ld (State.hasSmart), a
        ld a, (State.level)
        add a
        add a
        ld l, a
        ld h, #00
        ld de, c_d1ab
        add hl, de
        ld b, (hl)
        inc hl
        ld c, (hl)
        push bc
        inc hl
        ld a, (hl)
        inc hl
        ld l, (hl)
        ld h, #00
        add hl, hl
        add hl, hl
        ex de, hl
        ld l, a
        ld h, #00
        add hl, hl
        add hl, hl
        call c_cd9b
        pop bc
        call c_d153
        ret


; ?
; Used by c_cecc.
c_d213:  ; #d213
        ld a, (conveyorTileIndices.left)
        ld (#5FD1), a
        ld hl, #5BDF
        ld de, (conveyorTileIndices)
        ld ix, State.s_5A
.l_0:
        inc hl
        ld a, (hl)
        cp d
        jp Z, .l_2
        cp e
        jp NZ, .l_0
        ld bc, #5FD1
        push hl
        xor a
        sbc hl, bc
        pop hl
        jp Z, .l_4
        ld (ix+0), l
        ld (ix+1), h
        ld b, #00
.l_1:
        inc b
        inc hl
        ld a, (hl)
        cp e
        jp Z, .l_1
        ld (ix+2), b
        inc ix
        inc ix
        inc ix
        jp .l_0
.l_2:
        ld (ix+0), l
        ld (ix+1), h
        ld b, #00
.l_3:
        inc b
        inc hl
        ld a, (hl)
        cp d
        jp Z, .l_3
        ld (ix+2), b
        inc ix
        inc ix
        inc ix
        jp .l_0
.l_4:
        ld (ix+0), #00
        ld (ix+1), #00
        ret

; (Fill something with ones?)
; Used by c_cc25.
c_d278:  ; #d278
        ld de, #0580
        ld ix, State.s_5A
.l_0:
        ld l, (ix+0)
        ld h, (ix+1)
        ld a, h
        or l
        ret Z
        ld b, (ix+2)
        add hl, de
.l_1:
        ld (hl), #01
        inc hl
        djnz .l_1
        inc ix
        inc ix
        inc ix
        jp .l_0

; Clear 400-byte buffer at #BEB4?
; Used by c_cc25.
c_d29a:  ; #d29a
        ld hl, #0000
        ld de, #0032
        ld b, #08
.l_0:
        add hl, de
        djnz .l_0
        ld c, l
        ld b, h
        ld hl, c_beb4
.l_1:
        ld (hl), #00
        inc hl
        dec bc
        ld a, b
        or c
        jr NZ, .l_1
        ret

; (Some game logic?)
; Used by c_ec00.
c_d2b3:  ; #d2b3
        bit 1, (iy+5)
        jr Z, .l_0
        res 1, (iy+5)
        ld l, (iy+0)
        ld h, (iy+1)
        ld de, #0004
        add hl, de
        ld (iy+0), l
        ld (iy+1), h
        ld a, (iy+2)
        add #04
        ld (iy+2), a
.l_0:
        ld hl, cS.coin
        ld (iy+3), l
        ld (iy+4), h
        ld (iy+7), #00
        ld (iy+23), #06
        ld (iy+8), #06
        ld (iy+21), #00
        ld (iy+15), #00
        ld (iy+12), #FE
        ld (iy+9), #46
        res 5, (iy+5)
        res 3, (iy+5)
        res 2, (iy+5)
        xor a
        ret

; (Some game logic?)
; Used by c_cc25.
c_d308:  ; #d308
        ld ix, c_beb4
        bit 0, (ix+24)
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
        ld iy, #BF18
        ld b, #06
.l_1:
        call c_d3bb
        jr NZ, .l_2
        ld de, #0032
        add iy, de
        djnz .l_1
        ret
.l_2:
        xor a
        ld (State.s_28), a
        ld (State.s_41), a
        ld (ix+19), #00
        set 0, (ix+24)
        push iy
        pop hl
        ld (ix+30), l
        ld (ix+31), h
.l_3:
        ld l, (ix+30)
        ld h, (ix+31)
        push hl
        pop iy
        call c_d3bb
        jr NZ, .l_4
        res 0, (ix+24)
        ret
.l_4:
        ld hl, cS.heroStands
        ld a, (State.weapon)
        cp 2
        jr C, .l_5
        ld hl, cS.armedHeroStands
.l_5:
        ld (ix+3), l
        ld (ix+4), h
        ld a, (iy+2)
        sub (ix+11)
        ld (ix+2), a
        ld c, (iy+21)
        ld a, (iy+23)
        cp #03
        jr Z, .l_6
        ld c, (iy+18)
.l_6:
        ld a, c
        and #03
        ret Z
        ld a, (iy+19)
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
        ld l, (ix+0)
        ld h, (ix+1)
        add hl, de
        ld (ix+0), l
        ld (ix+1), h
        ret

; (Some game logic?)
; Used by c_d308.
c_d3bb:  ; #d3bb
        bit 0, (iy+5)
        ret Z
        bit 0, (iy+24)
        ret Z
        ld a, (ix+2)
        add (ix+11)
        sub (iy+2)
        jp P, .l_0
        neg
.l_0:
        cp #05
        jr NC, .l_1
        ld l, (ix+0)
        ld h, (ix+1)
        ld de, #0014
        add hl, de
        ld e, (iy+0)
        ld d, (iy+1)
        xor a
        sbc hl, de
        jr C, .l_1
        ld l, (iy+10)
        ld h, #00
        add hl, de
        ld e, (ix+0)
        ld d, (ix+1)
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
        ld a, (ix+2)
        cp #E0
        jr NC, .l_2
        ld c, (ix+11)
        add c
        cp #20
        jr C, .l_2
        ld l, (ix+0)
        ld h, (ix+1)
        push hl
        ld d, #00
        ld e, (ix+10)
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
        ld l, (ix+0)
        ld h, (ix+1)
        ld de, -4
        add hl, de
        ld (ix+0), l
        ld (ix+1), h
        ld a, #FE
        add (ix+2)
        ld (ix+2), a
        set 1, (ix+5)
        ret

; ?
; Used by c_dce1, c_dd09, c_dd46, c_dd73, c_df85, c_f1d7, c_f2e7 and
; c_f618.
c_d460:  ; #d460
        push bc
        push de
        ld a, (ix+2)
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
        ld l, (ix+0)
        ld h, (ix+1)
        ld a, (ix+8)
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
        ld l, (ix+0)
        ld h, (ix+1)
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
        ld de, #5B00
        add hl, de
        pop de
        pop bc
        ret

; (Set some object properties?)
; Used by c_cc25.
c_d4cd:  ; #d4cd
        ld ix, #BEE6
        ld b, #07
        ld de, #0032
.l_0:
        bit 7, (ix+5)
        jr Z, .l_1
        ld (ix+5), #00
.l_1:
        add ix, de
        djnz .l_0
        ret

; Handle Smart
; Used by c_cc25.
c_d4e5:  ; #d4e5
        call checkSmartKey
        ret NZ
        ld a, (State.hasSmart)
        or a
        ret Z
        ld a, (State.s_54)
        or a
        ret NZ
        ld iy, #BF18
        ld b, #06
.l_0:
        push bc
        bit 3, (iy+24)
        jr NZ, .l_1
        ld l, (iy+0)
        ld h, (iy+1)
        ld de, #0120
        xor a
        sbc hl, de
        jr NC, .l_1
        call c_ec00.l_0
.l_1:
        ld de, #0032
        add iy, de
        pop bc
        djnz .l_0
        xor a
        ld (State.hasSmart), a
        ret

; "SELECT  LEVEL"
textSelectLevel:  ; #d51e
        db "SELECT  LEVEL"C

; Level names
levelNames:  ; #d52b
        db "KLONDIKE"C
        db " ORIENT "C
        db " AMAZON "C
        db "ICELAND "C
.bermuda
        db "BERMUDA "C

; Level selection menu
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
        jp Z, gameEnd
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
        call c_d62c
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
c_d62c:  ; #d62c
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
        call c_c9ac
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

; Game end
; Used by c_d553.
gameEnd:  ; #d6c0
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
        ld bc, #7530
        call delay
.l_1:
        ld a, (controlState)
        or a
        jr Z, .l_1
        pop hl
        jp gameStart

; (Some call table)
c_d6e7:  ; #d6e7
        dw c_d7f6
        dw c_d94c
        dw c_da95
        dw c_db4e
        dw c_dbfc

; Data block at D6F1
c_d6f1:  ; #d6f1
        db #F8, #F8, #F8, #F9, #F9, #F9, #F9, #FA
        db #FD, #FE, #FF, #00, #00, #00, #01, #01
        db #02, #02, #04, #07, #07, #08, #08, #7F

; (Some game logic, calls from call table #D6E7?)
; Used by c_cc25.
c_d709:  ; #d709
        ld ix, c_beb4
        call c_dd73
        ld a, (State.s_28)
        add a
        ld l, a
        ld h, #00
        ld de, c_d6e7
        add hl, de
        ld e, (hl)
        inc hl
        ld d, (hl)
        ld (.call), de
.call+* call -0
        ld a, (State.s_28)
        cp #02
        jp NC, .l_4
        ld a, (State.s_39)
        or a
        jr Z, .l_0
        dec a
        ld (State.s_39), a
        ld a, (State.s_38)
        cp #01
        jp NZ, .l_7
        jp .l_6
.l_0:
        ld a, (State.s_31)
        call c_eaee
        cp #05
        jp Z, .l_6
        cp #06
        jp Z, .l_7
        ld a, (State.s_32)
        call c_eaee
        cp #05
        jp Z, .l_6
        cp #06
        jp Z, .l_7
        ld a, (State.s_31)
        call c_eaee
        cp #09
        jr Z, .l_1
        ld a, (State.s_32)
        call c_eaee
        cp #09
        jr NZ, .l_4
.l_1:
        call c_d0af
        ld a, #02
        ld (State.s_28), a
        ld a, (controlState)
        and #03
        jp Z, .l_2
        ld b, a
        ld a, (ix+21)
        and #FC
        or b
        ld (ix+21), a
        ld (ix+19), #02
.l_2:
        ld a, #03
        ld (State.s_27), a
        xor a
        ld (State.s_41), a
        ld hl, cS.heroJumps
        ld a, (State.weapon)
        cp 2
        jr C, .l_3
        ld hl, cS.armedHeroJumps
.l_3:
        ld (ix+3), l
        ld (ix+4), h
.l_4:
        xor a
        ld (State.s_05), a
        ld de, (State.screenX)
        ld hl, (State.s_03)
        xor a
        sbc hl, de
        jr Z, .l_5
        jr C, .l_5
        ld l, (ix+0)
        ld h, (ix+1)
        ld de, -200
        add hl, de
        jr NC, .l_5
        ld a, #FF
        ld (State.s_05), a
.l_5:
        jp c_e419
.l_6:
        call c_de37
        jr NZ, .l_4
        ld a, (ix+0)
        add #FF
        ld (ix+0), a
        jp .l_4
.l_7:
        call c_deb1
        jr NZ, .l_4
        ld a, (ix+0)
        add #01
        ld (ix+0), a
        jp .l_4

; (Some game logic from call table #D6E7?)
c_d7f6:  ; #d7f6
        ld a, (controlState)
        bit 3, a
        jr Z, .l_0
        ld a, (State.s_33)
        call c_eaee
        cp #01
        jp Z, .l_12
        cp #02
        jp Z, .l_12
        jp .l_9
.l_0:
        bit 2, a
        jr Z, .l_1
        ld a, (State.s_34)
        call c_eaee
        cp #02
        jp Z, .l_12
.l_1:
        ld a, (controlState)
        bit 1, a
        jp NZ, .l_7
        bit 0, a
        jp NZ, .l_8
        bit 0, (ix+24)
        ret NZ
        ld a, (State.s_31)
        call c_eaee
        cp #02
        jr NC, .l_2
        ld a, (State.s_32)
        call c_eaee
        cp #02
        jp C, c_d94c.l_13
.l_2:
        ld a, (State.s_31)
        call c_eaee
        cp #07
        jr Z, .l_3
        ld a, (State.s_32)
        call c_eaee
        cp #07
        jr Z, .l_3
        ld a, (State.s_31)
        call c_eaee
        cp #05
        ret NC
        ld a, (State.s_32)
        call c_eaee
        cp #05
        jp C, c_d94c.l_11
        ret
.l_3:
        bit 0, (ix+21)
        jr NZ, .l_4
        call c_de37
        jp NZ, c_d94c.l_11
        ld a, (ix+0)
        add #FE
        ld (ix+0), a
        jp .l_5
.l_4:
        call c_deb1
        jp NZ, c_d94c.l_11
        ld a, (ix+0)
        add #02
        ld (ix+0), a
.l_5:
        ld hl, cS.heroWalks1
        ld a, (State.weapon)
        cp 2
        jr C, .l_6
        ld hl, cS.armedHeroWalks1
.l_6:
        ld (ix+3), l
        ld (ix+4), h
        ret
.l_7:
        ld a, #01
        ld (State.s_28), a
        ld a, #02
        ld (State.s_41), a
        xor a
        ld (State.s_42), a
        ld (ix+6), a
        set 1, (ix+21)
        res 0, (ix+21)
        ret
.l_8:
        ld a, #01
        ld (State.s_28), a
        ld a, #02
        ld (State.s_41), a
        xor a
        ld (State.s_42), a
        ld (ix+6), a
        set 0, (ix+21)
        res 1, (ix+21)
        ret
.l_9:
        ld a, (State.s_45)
        or a
        ret NZ
        res 0, (ix+24)
        ld a, #02
        ld (State.s_28), a
        ld a, (controlState)
        and #03
        jp Z, .l_10
        ld b, a
        ld a, (ix+21)
        and #FC
        or b
        ld (ix+21), a
        ld (ix+19), #02
.l_10:
        ld a, #03
        ld (State.s_27), a
        xor a
        ld (State.s_41), a
        ld hl, cS.heroJumps
        ld a, (State.weapon)
        cp 2
        jr C, .l_11
        ld hl, cS.armedHeroJumps
.l_11:
        ld (ix+3), l
        ld (ix+4), h
        ld a, #05
        call playSound
        jp c_da95
; This entry point is used by c_d94c, c_da95 and c_db4e.
.l_12:
        ld a, (State.s_45)
        or a
        ret NZ
        ld a, #04
        ld (State.s_28), a
        xor a
        ld (State.s_3E), a
        ld hl, cS.heroClimbs
        ld a, (State.weapon)
        cp 2
        jr C, .l_13
        ld hl, cS.armedHeroClimbs
.l_13:
        ld (ix+3), l
        ld (ix+4), h
        xor a
        ld (State.s_41), a
        jp c_dbfc

; (Some game logic from call table #D6E7?)
c_d94c:  ; #d94c
        bit 0, (ix+24)
        jr NZ, .l_0
        ld a, (State.s_31)
        call c_eaee
        cp #02
        jr NC, .l_0
        ld a, (State.s_32)
        call c_eaee
        cp #02
        jp C, .l_13
.l_0:
        ld a, (controlState)
        bit 3, a
        jp NZ, .l_11
        bit 2, a
        jr Z, .l_1
        ld a, (State.s_34)
        call c_eaee
        cp #02
        jp Z, c_d7f6.l_12
.l_1:
        bit 0, (ix+21)
        jp NZ, .l_5
        call c_de37
        or a
        jp NZ, .l_11
        ld a, (State.s_31)
        call c_eaee
        cp #08
        jr Z, .l_2
        ld a, (State.s_32)
        call c_eaee
        cp #08
        jr NZ, .l_3
.l_2:
        ld a, (ix+0)
        add #FF
        ld (ix+0), a
        ld a, #04
        ld (State.s_41), a
        jr .l_4
.l_3:
        ld a, (ix+0)
        add #FE
        ld (ix+0), a
        ld a, #02
        ld (State.s_41), a
        ld a, (State.s_42)
        and #01
        ld (State.s_42), a
.l_4:
        ld a, (controlState)
        bit 1, a
        jp Z, .l_11
        jr .l_9
.l_5:
        call c_deb1
        or a
        jp NZ, .l_11
        ld a, (State.s_31)
        call c_eaee
        cp #08
        jr Z, .l_6
        ld a, (State.s_32)
        call c_eaee
        cp #08
        jr NZ, .l_7
.l_6:
        ld a, (ix+0)
        add #01
        ld (ix+0), a
        ld a, #04
        ld (State.s_41), a
        jr .l_8
.l_7:
        ld a, (ix+0)
        add #02
        ld (ix+0), a
        ld a, #02
        ld (State.s_41), a
        ld a, (State.s_42)
        and #01
        ld (State.s_42), a
.l_8:
        ld a, (controlState)
        bit 0, a
        jp Z, .l_11
.l_9:
        ld a, (State.s_31)
        call c_eaee
        cp #07
        jr Z, .l_10
        ld a, (State.s_32)
        call c_eaee
        cp #07
        ret NZ
.l_10:
        ld a, #01
        ld (State.s_41), a
        xor a
        ld (State.s_42), a
        ret
; This entry point is used by c_d7f6, c_da95, c_db4e and c_dbfc.
.l_11:
        xor a
        ld (State.s_28), a
        ld (State.s_41), a
        ld a, (ix+2)
        and #F8
        or #03
        ld (ix+2), a
        ld (ix+19), #00
        ld hl, cS.heroStands
        ld a, (State.weapon)
        cp 2
        jr C, .l_12
        ld hl, cS.armedHeroStands
.l_12:
        ld (ix+3), l
        ld (ix+4), h
        ret
; This entry point is used by c_d7f6, c_da95, c_dbfc and c_e6e1.
.l_13:
        xor a
        ld (State.s_45), a
        ld a, #03
        ld (State.s_28), a
        xor a
        ld (State.s_41), a
        ld a, (controlState)
        and #03
        jp Z, .l_14
        ld b, a
        ld a, (ix+21)
        and #FC
        or b
        ld (ix+21), a
        ld a, #02
        ld (ix+19), a
.l_14:
        ld hl, cS.heroFalls
        ld a, (State.weapon)
        cp 2
        jr C, .l_15
        ld hl, cS.armedHeroFalls
.l_15:
        ld (ix+3), l
        ld (ix+4), h
        jp c_db4e

; (Some game logic from call table #D6E7?)
; Used by c_d7f6.
c_da95:  ; #da95
        ld hl, cS.heroJumps
        ld a, (State.weapon)
        cp 2
        jr C, .l_0
        ld hl, cS.armedHeroJumps
.l_0:
        ld (ix+3), l
        ld (ix+4), h
        ld a, (controlState)
        bit 3, a
        jr Z, .l_1
        ld a, (State.s_33)
        call c_eaee
        cp #01
        jp Z, c_d7f6.l_12
        cp #02
        jp Z, c_d7f6.l_12
.l_1:
        ld a, (ix+19)
        or a
        jr Z, .l_3
        bit 0, (ix+21)
        jr NZ, .l_2
        call c_de37
        or a
        jr NZ, .l_3
        ld a, (ix+19)
        neg
        add (ix+0)
        ld (ix+0), a
        jr .l_3
.l_2:
        call c_deb1
        or a
        jr NZ, .l_3
        ld a, (ix+19)
        add (ix+0)
        ld (ix+0), a
.l_3:
        ld a, (State.s_27)
        ld e, a
        ld d, #00
        ld hl, c_d6f1
        add hl, de
        ld a, (hl)
        ld (State.s_37), a
        cp #7F
        jp Z, c_d94c.l_13
        add (ix+2)
        ld (ix+2), a
        ld a, (hl)
        ld hl, State.s_27
        inc (hl)
        or a
        jp P, .l_4
        exa
        call c_dd46
        ld a, (State.s_35)
        call c_eaee
        cp #04
        jr NC, .l_5
        ld a, (State.s_36)
        call c_eaee
        cp #04
        jr NC, .l_5
        ret
.l_4:
        call c_dd09
        ld a, (State.s_31)
        call c_eaee
        cp #02
        jp NC, c_d94c.l_11
        ld a, (State.s_32)
        call c_eaee
        cp #02
        jp NC, c_d94c.l_11
        ret
.l_5:
        exa
        neg
        add (ix+2)
        and #F8
        ld (ix+2), a
        ret

; (Some game logic from call table #D6E7?)
; Used by c_d94c.
c_db4e:  ; #db4e
        ld a, (controlState)
        bit 3, a
        jr Z, .l_0
        ld a, (State.s_33)
        call c_eaee
        cp #01
        jp Z, c_d7f6.l_12
        cp #02
        jp Z, c_d7f6.l_12
.l_0:
        ld l, (ix+0)
        ld h, (ix+1)
        push hl
        ld a, (ix+19)
        or a
        jr Z, .l_2
        bit 0, (ix+21)
        jr NZ, .l_1
        call c_de37
        or a
        jr NZ, .l_2
        ld a, (ix+19)
        neg
        add (ix+0)
        ld (ix+0), a
        jr .l_2
.l_1:
        call c_deb1
        or a
        jr NZ, .l_2
        ld a, (ix+19)
        add (ix+0)
        ld (ix+0), a
.l_2:
        exx
        ld l, (ix+0)
        ld h, (ix+1)
        exx
        pop hl
        ld (ix+0), l
        ld (ix+1), h
        ld a, (ix+2)
        add #04
        ld (ix+2), a
        call c_dd09
        exx
        ld (ix+0), l
        ld (ix+1), h
        exx
        ld a, (State.s_31)
        call c_eaee
        cp #02
        jp NC, c_d94c.l_11
        ld a, (State.s_32)
        call c_eaee
        cp #02
        jp NC, c_d94c.l_11
        ld a, (controlState)
        bit 1, a
        jr NZ, .l_3
        bit 0, a
        jr NZ, .l_4
        ld (ix+19), #00
        ret
.l_3:
        ld (ix+19), #02
        set 1, (ix+21)
        res 0, (ix+21)
        ret
.l_4:
        ld (ix+19), #02
        set 0, (ix+21)
        res 1, (ix+21)
        ret

; (Some game logic from call table #D6E7?)
; Used by c_d7f6.
c_dbfc:  ; #dbfc
        ld a, (controlState)
        bit 3, a
        jr Z, .l_1
        ld a, (State.s_33)
        call c_eaee
        or a
        jr NZ, .l_0
        ld a, (State.s_34)
        call c_eaee
        or a
        jp Z, c_d94c.l_13
.l_0:
        call c_dd46
        ld a, (State.s_35)
        call c_eaee
        cp #04
        jr NC, .l_1
        ld a, (State.s_36)
        call c_eaee
        cp #04
        jr NC, .l_1
        call c_dcce
        ld a, (ix+2)
        add #FE
        ld (ix+2), a
.l_1:
        ld a, (controlState)
        bit 2, a
        jr Z, .l_3
        ld a, (State.s_33)
        call c_eaee
        or a
        jr NZ, .l_2
        ld a, (State.s_34)
        call c_eaee
        or a
        jp Z, c_d94c.l_13
.l_2:
        call c_dcce
        ld a, (ix+2)
        add #02
        ld (ix+2), a
.l_3:
        ld a, (ix+2)
        or #01
        ld (ix+2), a
        and #07
        cp #03
        jr NZ, .l_4
        call c_dce1
        ld a, (State.s_34)
        call c_eaee
        cp #02
        jp NC, c_d94c.l_11
.l_4:
        ld a, (controlState)
        bit 1, a
        jr Z, .l_6
        ld a, (State.s_33)
        call c_eaee
        or a
        jr NZ, .l_5
        ld a, (State.s_34)
        call c_eaee
        or a
        jp Z, c_d94c.l_13
.l_5:
        call c_de37
        jr NZ, .l_6
        call c_dcce
        ld a, (ix+0)
        add #FE
        ld (ix+0), a
.l_6:
        ld a, (controlState)
        bit 0, a
        jr Z, .l_8
        ld a, (State.s_33)
        call c_eaee
        or a
        jr NZ, .l_7
        ld a, (State.s_34)
        call c_eaee
        or a
        jp Z, c_d94c.l_13
.l_7:
        call c_deb1
        jr NZ, .l_8
        call c_dcce
        ld a, (ix+0)
        add #02
        ld (ix+0), a
.l_8:
        ret

; ?
; Used by c_dbfc.
c_dcce:  ; #dcce
        ld a, (State.s_42)
        inc a
        and #03
        ld (State.s_42), a
        ret NZ
        ld a, (ix+21)
        xor #03
        ld (ix+21), a
        ret

; ?
; Used by c_dbfc.
c_dce1:  ; #dce1
        ld a, (ix+0)
        add #0C
        ld (ix+0), a
        ld a, (ix+2)
        add #15
        ld (ix+2), a
        call c_d460
        ld a, (hl)
        ld (State.s_34), a
        ld a, (ix+0)
        add #F4
        ld (ix+0), a
        ld a, (ix+2)
        add #EB
        ld (ix+2), a
        ret

; ?
; Used by c_da95 and c_db4e.
c_dd09:  ; #dd09
        ld a, (ix+0)
        add #06
        ld (ix+0), a
        ld a, (ix+1)
        adc a, #00
        ld (ix+1), a
        ld a, (ix+2)
        add #18
        ld (ix+2), a
        call c_d460
        ld a, (hl)
        ld (State.s_31), a
        inc hl
        ld a, (hl)
        ld (State.s_32), a
        ld a, (ix+0)
        add #FA
        ld (ix+0), a
        ld a, (ix+1)
        adc a, #FF
        ld (ix+1), a
        ld a, (ix+2)
        add #E8
        ld (ix+2), a
        ret

; ?
; Used by c_da95 and c_dbfc.
c_dd46:  ; #dd46
        ld a, (ix+0)
        add #06
        ld (ix+0), a
        ld a, (ix+2)
        add #FF
        ld (ix+2), a
        call c_d460
        ld a, (hl)
        ld (State.s_35), a
        inc hl
        ld a, (hl)
        ld (State.s_36), a
        ld a, (ix+0)
        add #FA
        ld (ix+0), a
        ld a, (ix+2)
        add #01
        ld (ix+2), a
        ret

; ?
; Used by c_d709.
c_dd73:  ; #dd73
        ld a, (ix+0)
        add #04
        ld (ix+0), a
        ld a, (ix+1)
        adc a, #00
        ld (ix+1), a
        call c_d460
        ld bc, #002C
        ld a, (hl)
        ld (State.s_29), a
        add hl, bc
        ld a, (hl)
        ld (State.s_2A), a
        add hl, bc
        ld a, (hl)
        ld (State.s_2B), a
        add hl, bc
        ld a, (hl)
        ld (State.s_2C), a
        ld a, (ix+0)
        add #0C
        ld (ix+0), a
        ld a, (ix+1)
        adc a, #00
        ld (ix+1), a
        call c_d460
        ld bc, #002C
        ld a, (hl)
        ld (State.s_2D), a
        add hl, bc
        ld a, (hl)
        ld (State.s_2E), a
        add hl, bc
        ld a, (hl)
        ld (State.s_2F), a
        add hl, bc
        ld a, (hl)
        ld (State.s_30), a
        ld a, (ix+0)
        add #F6
        ld (ix+0), a
        ld a, (ix+1)
        adc a, #FF
        ld (ix+1), a
        ld a, (ix+2)
        add #15
        ld (ix+2), a
        call c_d460
        ld a, (hl)
        ld (State.s_31), a
        inc hl
        ld a, (hl)
        ld (State.s_32), a
        ld a, (ix+0)
        add #06
        ld (ix+0), a
        ld a, (ix+1)
        adc a, #00
        ld (ix+1), a
        ld a, (ix+2)
        add #F8
        ld (ix+2), a
        call c_d460
        ld a, (hl)
        ld (State.s_33), a
        add hl, bc
        ld a, (hl)
        ld (State.s_34), a
        ld a, (ix+0)
        add #F4
        ld (ix+0), a
        ld a, (ix+1)
        adc a, #FF
        ld (ix+1), a
        ld a, (ix+2)
        add #F3
        ld (ix+2), a
        ld a, (ix+2)
        and #07
        cp #03
        jr NZ, .l_0
        xor a
        ld (State.s_2C), a
        ld (State.s_30), a
        ret
.l_0:
        ret

; (Checks something?)
; Used by c_d308, c_d709, c_d7f6, c_d94c, c_da95, c_db4e and c_dbfc.
c_de37:  ; #de37
        ld l, (ix+0)
        ld h, (ix+1)
        ld de, -32
        add hl, de
        jr NC, .l_2
        ld a, (State.s_28)
        cp #04
        jr NZ, .l_0
        ld a, (State.s_29)
        call c_eaee
        cp #03
        jr NC, .l_2
        ld a, (State.s_2A)
        call c_eaee
        cp #03
        jr NC, .l_2
        ld a, (State.s_2B)
        call c_eaee
        cp #03
        jr NC, .l_2
        ld a, (State.s_2C)
        call c_eaee
        cp #03
        jr NC, .l_2
        jp .l_1
.l_0:
        ld a, (State.s_29)
        call c_eaee
        cp #04
        jr NC, .l_2
        ld a, (State.s_2A)
        call c_eaee
        cp #04
        jr NC, .l_2
        ld a, (State.s_2B)
        call c_eaee
        cp #04
        jr NC, .l_2
        ld a, (State.s_28)
        cp #02
        jr NZ, .l_1
        ld a, (State.s_37)
        or a
        jp M, .l_1
        ld a, (State.s_30)
        call c_eaee
        cp #04
        jr NC, .l_2
.l_1:
        xor a
        ret
.l_2:
        ld a, #FF
        or a
        ret

; (Checks something?)
; Used by c_d308, c_d709, c_d7f6, c_d94c, c_da95, c_db4e and c_dbfc.
c_deb1:  ; #deb1
        ld l, (ix+0)
        ld h, (ix+1)
        ld de, -252
        add hl, de
        jr C, .l_2
        ld a, (State.s_28)
        cp #04
        jr NZ, .l_0
        ld a, (State.s_2D)
        call c_eaee
        cp #03
        jr NC, .l_2
        ld a, (State.s_2E)
        call c_eaee
        cp #03
        jr NC, .l_2
        ld a, (State.s_2F)
        call c_eaee
        cp #03
        jr NC, .l_2
        ld a, (State.s_30)
        call c_eaee
        cp #03
        jr NC, .l_2
        jp .l_1
.l_0:
        ld a, (State.s_2D)
        call c_eaee
        cp #04
        jr NC, .l_2
        ld a, (State.s_2E)
        call c_eaee
        cp #04
        jr NC, .l_2
        ld a, (State.s_2F)
        call c_eaee
        cp #04
        jr NC, .l_2
        ld a, (State.s_28)
        cp #02
        jr NZ, .l_1
        ld a, (State.s_37)
        or a
        jp M, .l_1
        ld a, (State.s_30)
        call c_eaee
        cp #04
        jr NC, .l_2
.l_1:
        xor a
        ret
.l_2:
        ld a, #FF
        or a
        ret

; (Some data on enemies?)
c_df2b:  ; #df2b
        db #FC, #FE, #FF, #FF, #00, #01, #01, #01
        db #01, #02, #03, #04, #06, #07, #08, #0A
        db #0B, #0C, #0E, #0F, #10, #80

kickBubbles:  ; #df41
        dw cS.kickBubble1
        dw cS.kickBubble2
        dw cS.kickBubble3

c_df47:  ; #df47
        db 0, 1, 0, -1
        db 0, 0, 0, 0, 0, 1, 2, 1, 0, -1
        db 0, 0, 0, 1, 2, 3, 2, 1, 0, -1

explosionBubbles:  ; #df5f
        dw cS.explosion1
        dw cS.explosion2
        dw cS.explosion3
        dw cS.explosion4

lazerBulletTable:  ; #df67            w   h
        dw cS.lazerBullet1 : db 16,  7, 8
        dw cS.lazerBullet2 : db 16, 11, 6
        dw cS.lazerBullet3 : db 16, 15, 4
powerBulletTable:  ; #df76
        dw cS.powerBullet1 : db  4,  4, 9
        dw cS.powerBullet2 : db  4, 16, 4
        dw cS.powerBullet3 : db  8,  8, 8

; (Some logic for enemies?)
; Used by c_cc25.
c_df85:  ; #df85
        ld a, (State.s_45)
        or a
        ret NZ
        ld a, (State.s_46)
        or a
        ret NZ
        ld a, (State.weapon)
        or a
        jr Z, .l_1
        ld hl, (State.s_3A)
        ld a, h
        or l
        jr NZ, .l_0
        ld a, (State.s_3D)
        or a
        jr NZ, .l_1
        xor a
        ld (State.weapon), a
        ret
.l_0:
        dec hl
        ld (State.s_3A), hl
.l_1:
        ld a, (State.s_3D)
        or a
        jp NZ, .l_9
        ld a, (State.s_28)
        cp #03
        ret NC
        ld a, (controlState)
        bit 4, a
        ret Z
        ld ix, c_beb4
        ld iy, #BEE6
        ld a, (State.weapon)
        or a
        jp NZ, .l_3
        ld a, #04
        call playSound
        ld hl, cS.heroKicks
        ld (ix+3), l
        ld (ix+4), h
        ld (iy+5), #02
        ld (iy+9), #47
        ld (iy+21), #01
        ld (iy+19), #00
        ld (iy+7), #00
        ld l, (ix+0)
        ld h, (ix+1)
        ld de, #0010
        bit 0, (ix+21)
        jr NZ, .l_2
        ld de, -16
.l_2:
        add hl, de
        ld (iy+0), l
        ld (iy+1), h
        ld a, (ix+2)
        ld (iy+2), a
        ld a, (State.soupCans)
        dec a
        add a
        ld l, a
        ld h, #00
        ld de, kickBubbles
        add hl, de
        ld a, (hl)
        ld (iy+3), a
        inc hl
        ld a, (hl)
        ld (iy+4), a
        ld a, #01
        ld (State.s_3D), a
        ld a, #03
        ld (State.s_3E), a
        jp c_eb00
.l_3:
        cp #01
        jp NZ, .l_5
        ld a, #04
        call playSound
        ld hl, cS.heroThrows
        ld (ix+3), l
        ld (ix+4), h
        ld hl, cS.shatterbomb
        ld (iy+3), l
        ld (iy+4), h
        ld (iy+5), #01
        ld (iy+9), #45
        ld (iy+7), #00
        ld (iy+10), #08
        ld (iy+11), #08
        ld l, (ix+0)
        ld h, (ix+1)
        ld de, #0008
        bit 0, (ix+21)
        jr NZ, .l_4
        ld de, -6
.l_4:
        add hl, de
        ld (iy+0), l
        ld (iy+1), h
        ld a, (ix+2)
        add #FC
        ld (iy+2), a
        ld (iy+19), #04
        ld a, (ix+21)
        and #03
        ld (iy+21), a
        xor a
        ld (State.s_3F), a
        ld a, #02
        ld (State.s_3D), a
        ld a, #03
        ld (State.s_3E), a
        jp c_eb00
.l_5:
        cp #02
        jp NZ, .l_7
        ld a, #0A
        call playSound
        ld a, (State.soupCans)
        dec a
        ld l, a
        add a
        add a
        add l
        ld l, a
        ld h, #00
        ld de, powerBulletTable
        add hl, de
        ld c, (hl)
        inc hl
        ld b, (hl)
        ld (iy+3), c
        ld (iy+4), b
        inc hl
        ld a, (hl)
        ld (iy+10), a
        inc hl
        ld a, (hl)
        ld (iy+11), a
        inc hl
        ld a, (hl)
        add (ix+2)
        ld (iy+2), a
        ld l, (ix+0)
        ld h, (ix+1)
        ld de, #0018
        bit 0, (ix+21)
        jr NZ, .l_6
        ld de, -16
.l_6:
        add hl, de
        ld (iy+0), l
        ld (iy+1), h
        ld (iy+5), #01
        ld (iy+9), #47
        ld (iy+19), #08
        ld (iy+20), #08
        ld (iy+7), #00
        ld a, (ix+21)
        and #03
        ld (iy+21), a
        ld (State.s_38), a
        ld a, #03
        ld (State.s_3D), a
        ld a, #01
        ld (c_e308), a
        ld a, #04
        ld (State.s_39), a
        jp c_eb00
.l_7:
        ld a, #08
        call playSound
        ld a, (State.soupCans)
        dec a
        ld l, a
        add a
        add a
        add l
        ld l, a
        ld h, #00
        ld de, lazerBulletTable
        add hl, de
        ld c, (hl)
        inc hl
        ld b, (hl)
        ld (iy+3), c
        ld (iy+4), b
        inc hl
        ld a, (hl)
        ld (iy+10), a
        inc hl
        ld a, (hl)
        ld (iy+11), a
        inc hl
        ld a, (hl)
        add (ix+2)
        ld (iy+2), a
        ld l, (ix+0)
        ld h, (ix+1)
        ld de, #0010
        bit 0, (ix+21)
        jr NZ, .l_8
        ld de, -6
.l_8:
        add hl, de
        ld (iy+0), l
        ld (iy+1), h
        ld (iy+7), #00
        ld (iy+5), #01
        ld (iy+9), #45
        ld (iy+19), #08
        ld a, (ix+21)
        and #03
        ld (iy+21), a
        ld (State.s_38), a
        ld a, #04
        ld (State.s_3D), a
        ld a, #04
        ld (State.s_39), a
        jp c_eb00
.l_9:
        ld ix, #BEE6
        cp #01
        jr NZ, .l_12
        ld ix, c_beb4
        ld hl, State.s_3E
        ld a, (hl)
        or a
        jr Z, .l_10
        dec (hl)
        ld hl, cS.heroKicks
        ld (ix+3), l
        ld (ix+4), h
        ret
.l_10:
        ld a, (State.s_28)
        or a
        jr NZ, .l_11
        ld hl, cS.heroStands
        ld (ix+3), l
        ld (ix+4), h
.l_11:
        xor a
        ld (State.s_3D), a
        ld ix, #BEE6
        ld (ix+5), a
        ret
.l_12:
        cp #02
        jp NZ, .l_19
        ld hl, State.s_3E
        ld a, (hl)
        or a
        jr Z, .l_13
        dec (hl)
        push ix
        ld ix, c_beb4
        ld hl, cS.heroThrows
        ld (ix+3), l
        ld (ix+4), h
        pop ix
.l_13:
        ld a, (State.s_40)
        or a
        jp NZ, .l_16
        call c_eb00
        jr NC, .l_15
        ld a, (State.s_3F)
        ld l, a
        ld h, #00
        ld de, c_df2b
        add hl, de
        ld a, (hl)
        cp #80
        jr Z, .l_14
        ld hl, State.s_3F
        inc (hl)
        ld (ix+20), a
.l_14:
        ld a, (ix+20)
        add (ix+2)
        ld (ix+2), a
        call c_d407.l_0
        jp NC, .l_18
        ld a, (ix+0)
        add #04
        ld (ix+0), a
        ld a, (ix+1)
        adc a, #00
        ld (ix+1), a
        call c_d460
        ld a, (ix+0)
        add #FC
        ld (ix+0), a
        ld a, (ix+1)
        adc a, #FF
        ld (ix+1), a
        ld a, (hl)
        call c_eaee
        cp #02
        ret C
.l_15:
        ld a, #06
        call playSound
        ld a, (ix+0)
        add #FC
        ld (ix+0), a
        ld a, (ix+1)
        adc a, #FF
        ld (ix+1), a
        ld a, (ix+2)
        add #F8
        ld (ix+2), a
        xor a
        ld (State.s_40), a
        ld (ix+21), a
        set 1, (ix+5)
        ld a, (State.soupCans)
        dec a
        ld (.l), a
.l_16:
.l+*    ld l, #00
        ld h, #00
        add hl, hl
        add hl, hl
        add hl, hl
        ld de, c_df47
        add hl, de
        ex de, hl
        ld a, (State.s_40)
        inc a
        ld (State.s_40), a
        srl a
        jr Z, .l_17
        dec a
.l_17:
        ld l, a
        ld h, #00
        add hl, de
        ld a, (hl)
        cp #FF
        jr Z, .l_18
        ld l, a
        ld h, #00
        add hl, hl
        ld de, explosionBubbles
        add hl, de
        ld a, (hl)
        inc hl
        ld h, (hl)
        ld (ix+3), a
        ld (ix+4), h
        ld (ix+9), #47
        jp c_eb00
.l_18:
        xor a
        ld (ix+5), a
        ld (State.s_3D), a
        ld (State.s_40), a
        ld (c_e308), a
        ret
.l_19:
        call c_d407.l_0
        jr NC, .l_18
        ld a, (ix+0)
        add #04
        ld (ix+0), a
        ld a, (ix+1)
        adc a, #00
        ld (ix+1), a
        ld a, (ix+2)
        add #08
        ld (ix+2), a
        call c_d460
        ld a, (ix+0)
        add #FC
        ld (ix+0), a
        ld a, (ix+1)
        adc a, #FF
        ld (ix+1), a
        ld a, (ix+2)
        add #F8
        ld (ix+2), a
        ld a, (hl)
        call c_eaee
        cp #02
        jp NC, .l_18
        call c_eb00
        jr NC, .l_18
        ld a, (State.s_3D)
        cp #03
        ret NZ
        ld a, (State.soupCans)
        cp #03
        jr Z, c_e31c
        ret

; (Some data on enemies?)
c_e308:  ; #e308
        db 0
c_e309:  ; #e309
        db 1, 5, 4, 6, 2, 10, 8, 9
c_e311:  ; #e311
        db 0, 0, 4, 0, 2, 1, 3, 0, 6, 7, 5

; (Some logic for enemies?)
; Used by c_df85.
c_e31c:  ; #e31c
        ld a, (c_e308)
        or a
        jr Z, .l_0
        dec a
        ld (c_e308), a
        ret
.l_0:
        ld ix, #BEE6
        ld iy, #BF18
        ld de, #0032
        ld b, #06
.l_1:
        bit 0, (iy+5)
        jr Z, .l_2
        ld a, (iy+7)
        cp #FF
        jr Z, .l_2
        bit 7, (iy+5)
        jr NZ, .l_2
        ld a, (iy+12)
        cp #FE
        jr Z, .l_2
        cp #FF
        jr Z, .l_2
        ld l, (iy+0)
        ld h, (iy+1)
        ld de, #0020
        xor a
        sbc hl, de
        jr NC, .l_3
.l_2:
        add iy, de
        djnz .l_1
        ld a, (ix+21)
        and #03
        ld (ix+21), a
        ret
.l_3:
        ld a, (ix+21)
        ld l, a
        ld h, #00
        ld de, c_e311
        add hl, de
        ld b, (hl)
        ld (ix+21), #00
        ld l, (ix+0)
        ld h, (ix+1)
        ld e, (iy+0)
        ld d, (iy+1)
        xor a
        sbc hl, de
        jp P, .l_4
        ld a, h
        neg
        ld h, a
        ld a, l
        neg
        ld l, a
        inc hl
        set 0, (ix+21)
        jr .l_5
.l_4:
        set 1, (ix+21)
.l_5:
        ld de, #0004
        xor a
        sbc hl, de
        jr NC, .l_6
        ld (ix+21), #00
.l_6:
        ld a, (ix+2)
        sub (iy+2)
        jp P, .l_7
        neg
        set 2, (ix+21)
        jr .l_8
.l_7:
        set 3, (ix+21)
.l_8:
        cp #04
        jr NC, .l_9
        res 2, (ix+21)
        res 3, (ix+21)
.l_9:
        ld a, (ix+21)
        ld l, a
        ld h, #00
        ld de, c_e311
        add hl, de
        ld c, (hl)
        ld a, b
        sub c
        jp Z, .l_11
        and #07
        ld d, a
        ld a, c
        sub b
        and #07
        cp d
        ld a, #01
        jp C, .l_10
        neg
.l_10:
        add b
        and #07
        ld l, a
        ld h, #00
        ld de, c_e309
        add hl, de
        ld a, (hl)
        ld (ix+21), a
.l_11:
        ld a, #01
        ld (c_e308), a
        ret

; (Some data on weapons?)
heroWalkPhases:  ; #e401
        dw cS.heroWalks1
        dw cS.heroWalks2
        dw cS.heroStands
        dw cS.heroWalks3
        dw cS.heroWalks4
        dw cS.heroStands
.armed:
        dw cS.armedHeroWalks1
        dw cS.armedHeroWalks2
        dw cS.armedHeroStands
        dw cS.armedHeroWalks3
        dw cS.armedHeroWalks4
        dw cS.armedHeroStands

; (Some game logic with weapons?)
; Used by c_d709.
c_e419:  ; #e419
        ld a, (State.s_45)
        or a
        jr Z, .l_1
        dec a
        ld (State.s_45), a
        ld de, cS.heroSmallWalks
        ld a, (State.s_41)
        or a
        jr Z, .l_0
        inc (ix+6)
        ld a, (ix+6)
        and #02
        jr NZ, .l_0
        ld de, cS.heroSmallStands
.l_0:
        ld (ix+3), e
        ld (ix+4), d
        ret
.l_1:
        ld a, (State.s_41)
        or a
        ret Z
        ld hl, State.s_42
        inc (hl)
        ld a, (State.s_41)
        cp (hl)
        ret NZ
        ld (hl), #00
        inc (ix+6)
        ld a, (ix+6)
        cp #06
        jr C, .l_2
        xor a
        ld (ix+6), a
.l_2:
        add a
        ld l, a
        ld h, #00
        ld de, heroWalkPhases
        ld a, (State.weapon)
        cp 2
        jr C, .l_3
        ld de, heroWalkPhases.armed
.l_3:
        add hl, de
        ld e, (hl)
        inc hl
        ld d, (hl)
        ld (ix+3), e
        ld (ix+4), d
        ret

; (Some sprite drawing logic?)
; Used by c_c07c, c_c245, c_c314 and c_c3ac.
c_e47a:  ; #e47a
        ld l, (ix+3)
        ld h, (ix+4)
        ld de, #007E
        bit 1, (ix+5)
        jr NZ, .l_0
        ld de, #0040
.l_0:
        ld a, (ix+8)
        cp #FF
        ret Z
        ld a, (ix+7)
        or a
        ret Z
        cp #FF
        jr Z, c_e4fc
        exa
        ld a, (ix+48)
        or a
        ret NZ
        exa
        cp #FC
        jp Z, c_e566
        cp #FD
        jp Z, c_e54f
        cp #FE
        jr Z, c_e52d
        cp #02
        jr NZ, .l_4
        ld a, (ix+6)
        and #02
        srl a
        jr Z, .l_3
.l_1:
        ld b, a
.l_2:
        add hl, de
        djnz .l_2
.l_3:
        inc (ix+6)
        ret
.l_4:
        cp #03
        jr NZ, .l_5
        ld a, (ix+6)
        and #07
        srl a
        or a
        jr Z, .l_3
        cp #03
        jr C, .l_1
        ld (ix+6), #00
        jr .l_3
.l_5:
        ld a, (ix+6)
        and #06
        srl a
        jr Z, .l_3
        cp #03
        jr NZ, .l_1
        ld a, #01
        jr .l_1

; Cloud sprite phase addresses
c_e4ee:  ; #e4ee
        dw cS.explosion1
        dw cS.explosion2
        dw cS.explosion3
        dw cS.explosion4
        dw cS.explosion3
        dw cS.explosion2
        dw cS.explosion1

; Get cloud sprite phase address
; Used by c_e47a.
c_e4fc:  ; #e4fc
        set 5, (ix+5)
        set 2, (ix+5)
        set 3, (ix+5)
        ld a, (ix+6)
        add a
        ld l, a
        ld h, #00
        ld de, c_e4ee
        add hl, de
        ld a, (hl)
        inc hl
        ld h, (hl)
        ld l, a
        inc (ix+6)
        ld a, (ix+6)
        cp #07
        ret C
        set 7, (ix+5)
        push hl
        ld a, (ix+13)
        call c_cf85
        pop hl
        ret

; (Some game logic?)
; Used by c_e47a.
c_e52d:  ; #e52d
        ld a, (ix+18)
        or a
        jr NZ, .l_0
        call generateRandom
        bit 7, a
        jr NZ, .l_1
        add hl, de
        jr .l_1
.l_0:
        add hl, de
        add hl, de
.l_1:
        bit 0, (ix+18)
        jr NZ, .l_2
        set 6, (ix+5)
        ret
.l_2:
        res 6, (ix+5)
        ret

; (Get Mole sprite address?)
; Used by c_e47a.
c_e54f:  ; #e54f
        bit 5, (ix+5)
        ret NZ
        ld (ix+9), #47
        ld hl, cS.shopMole
        ld (ix+3), l
        ld (ix+4), h
        ld (ix+8), #09
        ret

; (Modifies some object properties?)
; Used by c_e47a.
c_e566:  ; #e566
        ld a, (ix+5)
        xor #40
        ld (ix+5), a
        ret

; (Modifies some object properties?)
; Used by c_cc25.
c_e56f:  ; #e56f
        ld ix, #BEE6
        ld b, #07
.l_0:
        push bc
        call c_e582
        ld bc, #0032
        add ix, bc
        pop bc
        djnz .l_0
        ret

; (Modifies some object properties?)
; Used by c_e56f.
c_e582:  ; #e582
        bit 0, (ix+5)
        ret Z
        ld a, (ix+48)
        or a
        ret NZ
        bit 5, (ix+5)
        ret NZ
        bit 2, (ix+5)
        jr NZ, .l_1
        bit 0, (ix+21)
        jr Z, .l_0
        ld e, (ix+19)
        ld d, #00
        ld l, (ix+0)
        ld h, (ix+1)
        add hl, de
        ld (ix+0), l
        ld (ix+1), h
        jr .l_1
.l_0:
        bit 1, (ix+21)
        jr Z, .l_1
        ld a, (ix+19)
        neg
        ld e, a
        ld d, #FF
        ld l, (ix+0)
        ld h, (ix+1)
        add hl, de
        ld (ix+0), l
        ld (ix+1), h
.l_1:
        bit 3, (ix+5)
        ret NZ
        bit 3, (ix+21)
        jr Z, .l_2
        ld a, (ix+20)
        neg
        add (ix+2)
        ld (ix+2), a
        ret
.l_2:
        bit 2, (ix+21)
        ret Z
        ld a, (ix+20)
        add (ix+2)
        ld (ix+2), a
        ret

; (Init some objects at #BEE6)
; Used by c_cc25, c_e60a, c_e920 and c_e9b1.
c_e5f2:  ; #e5f2
        push ix
        push de
        ld de, #0032
        ld ix, #BEE6
        ld b, #07
.l_0:
        ld (ix+5), #00
        add ix, de
        djnz .l_0
        pop de
        pop ix
        ret

; ?
; Used by c_cc25.
c_e60a:  ; #e60a
        ld ix, c_beb4
        ld a, (State.s_27)
        ld (State.s_44), a
        ld a, (ix+2)
        ld (State.s_43), a
        cp #0B
        jp C, .l_0
        cp #E0
        jr NC, .l_1
        ret
.l_0:
        xor a
        exa
        ld (ix+2), #E0
        xor a
        ld (State.s_27), a
        jr .l_2
.l_1:
        ld a, #01
        exa
        ld (ix+2), #0C
.l_2:
        ld de, Level.transitTable
        ld l, (ix+0)
        ld h, (ix+1)
        ld bc, -22
        add hl, bc
        sra h
        rr l
        sra h
        rr l
        sra h
        rr l
        ld bc, (State.screenX)
        add hl, bc
        sra h
        rr l
        sra h
        rr l
        ld (.hl), hl
.l_3:
        exa
        ld c, a
        exa
        ld a, (de)
        cp c
        jr NZ, .l_4
        inc de
        ld a, (de)
        ld c, a
        inc de
        ld a, (de)
        ld b, a
        xor a
.hl+*   ld hl, -0
        sbc hl, bc
        jr Z, .l_5
        dec de
        dec de
.l_4:
        ld hl, #0008
        add hl, de
        ex de, hl
        ld a, (de)
        or a
        jp P, .l_3
        ld a, (State.s_43)
        ld (ix+2), a
        ld a, (State.s_44)
        ld (State.s_27), a
        ret
.l_5:
        ld a, #3C
        ld (State.s_51), a
        call c_e5f2
        ld hl, #0005
        add hl, de
        ld a, (hl)
        add a
        add a
        add a
        add a
        add a
        add #20
        ld (ix+0), a
        ld (ix+1), #00
        ld de, -4
        add hl, de
        ld e, (hl)
        inc hl
        ld d, (hl)
        inc hl
        ld a, (hl)
        inc hl
        ld h, (hl)
        ld l, a
        add hl, hl
        add hl, hl
        ex de, hl
        add hl, hl
        add hl, hl
        call c_e5f2
        call c_cd9b
        xor a
        ret

; (Checks some object properties?)
; Used by c_f564 and c_f74a.
c_e6c2:  ; #e6c2
        push de
        push bc
        ld b, #06
        ld ix, #BF18
        ld de, #0032
.l_0:
        bit 0, (ix+5)
        jr Z, .l_1
        add ix, de
        djnz .l_0
        xor a
        pop bc
        pop de
        ret
.l_1:
        scf
        pop bc
        pop de
        ret

; (Some variable?)
c_e6df:  ; #e6df
        dw #0000

; (Process collision?)
; Used by c_cc25.
c_e6e1:  ; #e6e1
        ld a, (State.s_46)
        or a
        ret NZ
        ld ix, c_beb4
        ld l, (ix+0)
        ld h, (ix+1)
        ld (c_e6df), hl
        inc hl
        inc hl
        inc hl
        inc hl
        ld (ix+0), l
        ld (ix+1), h
        ld iy, #BF18
        ld b, #06
.l_0:
        push bc
        call c_e80a
        pop bc
        jr NC, .l_1
        ld de, #0032
        add iy, de
        djnz .l_0
        ld hl, (c_e6df)
        ld (ix+0), l
        ld (ix+1), h
        ret
.l_1:
        ld hl, (c_e6df)
        ld (ix+0), l
        ld (ix+1), h
        ld a, (iy+8)
        cp #0E
        jp NC, .l_12
        or a
        ret Z
        cp #04
        jr NC, .l_2
        exa
        ld a, (State.s_3D)
        or a
        ret NZ
        exa
        ld (State.weapon), a
        ld hl, #02EE
        ld (State.s_3A), hl
        ld (iy+5), #00
        ld a, #0D
        jp playSound
.l_2:
        cp #09
        jr Z, .l_3
        push af
        ld a, #0B
        call playSound
        pop af
.l_3:
        cp #04
        jr NZ, .l_5
        ld a, (State.soupCans)
        cp #03
        jr Z, .l_4
        inc a
        ld (State.soupCans), a
.l_4:
        ld (iy+5), #00
        jp c_d026
.l_5:
        cp #05
        jr NZ, .l_6
        ld (iy+5), #00
        ld a, #04
        jp c_d09a
.l_6:
        cp #06
        jr NZ, .l_7
        ld (iy+5), #00
        ld a, (State.coins)
        add #19
        ld (State.coins), a
        jp printCoinCount
.l_7:
        cp #07
        jr NZ, .l_9
        ld (iy+5), #00
        ld a, (State.maxEnergy)
        add #04
        cp #22
        jr C, .l_8
        ld a, #22
.l_8:
        ld (State.maxEnergy), a
        ld a, #04
        jp c_d09a
.l_9:
        cp #08
        jr NZ, .l_10
        ld (iy+5), #00
        ld a, #FF
        ld (State.s_20), a
        ret
.l_10:
        cp #0A
        jr NC, .l_11
        ld a, (controlState)
        bit 2, a
        ret Z
        ld (iy+5), #00
        ld a, #FF
        ld (State.s_46), a
        ret
.l_11:
        ld (iy+5), #00
        ld a, (iy+13)
        jp c_cf85
.l_12:
        cp #0E
        jr NZ, .l_14
        bit 3, (iy+21)
        ret NZ
        ld a, (State.s_45)
        or a
        ret NZ
        ld a, (State.s_28)
        cp #02
        jr C, .l_13
        ret NZ
        call c_d94c.l_13
        ld a, (State.s_28)
        or a
        ret NZ
.l_13:
        ld a, #32
        ld (State.s_45), a
.l_14:
        ld a, (iy+7)
        cp #FF
        ret Z
        bit 0, (iy+24)
        ret NZ
        ld a, (iy+12)
        cp #FE
        ret Z
        jp c_d0af

; (Checks some object properties?)
; Used by c_e6e1, c_e9b1, c_eb19 and c_f618.
c_e80a:  ; #e80a
        bit 0, (iy+5)
        jr NZ, .l_0
        scf
        ret
.l_0:
        ld d, (ix+11)
        ld e, (ix+10)
        ld b, (iy+11)
        ld c, (iy+10)
        ld a, (ix+2)
        ld l, a
        add d
        ld h, (iy+2)
        cp h
        ret C
        ld a, h
        add b
        cp l
        ret C
        ld l, (ix+0)
        ld h, (ix+1)
        push hl
        ld d, #00
        add hl, de
        ld e, (iy+0)
        ld d, (iy+1)
        ld a, (iy+8)
        cp #0E
        jr NZ, .l_1
        ld a, e
        add #06
        ld e, a
.l_1:
        or a
        sbc hl, de
        pop hl
        ret C
        ex de, hl
        ld b, #00
        ld a, (iy+8)
        cp #0E
        jr NZ, .l_2
        ld a, c
        sub #0C
        ld c, a
.l_2:
        add hl, bc
        or a
        sbc hl, de
        ret

; (Some table, 5 levels * 6 words)
c_e85f:  ; #e85f
.lev0:  dw #0668, #0668, #0404, #03AC, #0414, #0102
.lev1:  dw #0668, #0688, #0405, #02B4, #0378, #0405
.lev2:  dw #0668, #0688, #0405, #04D8, #04F8, #020B
.lev3:  dw #066C, #068C, #0403, #04F8, #0530, #0402
.lev4:  dw #066C, #068C, #0405, #0580, #0640, #0304

; Item prices in the shop
c_e89b:  ; #e89b
        db 125, 150, 175, 250, 75, 1, 200, 100, 0

; Item names in the shop
c_e8a4:  ; #e8a4
        db "SHATTERBOMB "C
        db "POWER GUN   "C
        db "LAZER GUN   "C
        db "SOUP CAN    "C
        db "SLIMY WORMS "C
        db "            "C
        db "PINTA A DAY "C
        db "DIARY       "C
        db "   EXIT SHOP"C

; "TOO MUCH"
c_e910:  ; #e910
        db "   TOO MUCH     "C

; (Init something?)
; Used by c_cc25.
c_e920:  ; #e920
        ld a, (State.s_46)
        bit 7, a
        ret Z
        call c_e5f2
        ld a, (State.level)
        add a
        add a
        ld l, a
        add a
        add l
        ld l, a
        ld h, #00
        ld de, c_e85f
        add hl, de
        ld e, (hl)
        inc hl
        ld d, (hl)
        push de
        inc hl
        ld e, (hl)
        inc hl
        ld d, (hl)
        dec de
        dec de
        dec de
        dec de
        inc hl
        call c_eace
        pop hl
        call c_cd9b
        ld a, #7F
        ld (State.s_46), a
        call c_f6ba
        ld ix, #BF18
        ld b, #06
        ld de, #0032
.l_0:
        ld a, (ix+8)
        or a
        jr Z, .l_1
        add ix, de
        djnz .l_0
.l_1:
        ld iy, c_beb4
        ld a, (iy+0)
        add #20
        ld (ix+0), a
        ld (ix+1), #00
        ld a, (iy+2)
        add #0B
        ld (ix+2), a
        ld hl, cS.shopMole
        ld (ix+3), l
        ld (ix+4), h
        ld (ix+9), #47
        ld (ix+21), #00
        ld (ix+10), #18
        ld (ix+11), #15
        ld (ix+8), #09
        ld (ix+5), #03
        ld (ix+12), #FE
        ld (ix+24), #00
        ld (ix+49), #00
        ld (ix+23), #00
        ret

; Shop logic
; Used by c_cc25.
c_e9b1:  ; #e9b1
        ld a, (State.s_46)
        cp #7F
        ret NZ
        ld ix, c_beb4
        ld iy, #BF18
        ld b, #06
.l_0:
        push bc
        call c_e80a
        pop bc
        jr NC, .l_1
        ld de, #0032
        add iy, de
        djnz .l_0
        jp c_d04e
.l_1:
        ld a, (iy+8)
        or a
        ret Z
        dec a
        ld (State.shopItem), a
        ld l, a
        ld h, #00
        add hl, hl
        add hl, hl
        ld e, l
        ld d, h
        add hl, hl
        add hl, de
        ld de, c_e8a4
        add hl, de
        ex de, hl
        ld c, #47
        ld hl, #000F
        call printString
        ld a, (State.shopItem)
        ld l, a
        ld h, #00
        ld de, c_e89b
        add hl, de
        ld a, (hl)
        ld (State.shopPrice), a
        or a
        jr Z, .l_2
        ld hl, #001C            ; y: 0, x: 28
        ld c, #47               ; bright white
        call printNumber
.l_2:
        ld a, (controlState)
        bit 4, a
        ret Z
        ld a, (State.shopPrice)
        or a
        jr NZ, .l_3
        call c_e5f2
        ld a, (State.level)
        add a
        add a
        ld l, a
        add a
        add l
        ld l, a
        ld h, #00
        ld de, c_e85f
        add hl, de
        ld de, #0006
        add hl, de
        ld e, (hl)
        inc hl
        ld d, (hl)
        push de
        inc hl
        ld e, (hl)
        inc hl
        ld d, (hl)
        dec de
        dec de
        dec de
        dec de
        inc hl
        call c_eace
        pop hl
        call c_cd9b
        xor a
        ld (State.s_46), a
        ld (State.s_28), a
        jp c_d04e
.l_3:
        ld a, (State.shopPrice)
        ld b, a
        ld a, (State.coins)
        sub b
        jr NC, .l_5
        ld hl, #000F
        ld de, c_e910
        ld c, #47
        call printString
.l_4:
        ld a, (controlState)
        bit 4, a
        jr NZ, .l_4
        ret
.l_5:
        ld (State.coins), a
        call printCoinCount
        ld (iy+5), #00
        ld a, (State.shopItem)
        inc a
        cp #04
        jr NC, .l_6
        ld (State.weapon), a
        ld hl, #02EE
        ld (State.s_3A), hl
        ret
.l_6:
        cp #04
        jr NZ, .l_8
        ld a, (State.soupCans)
        cp #03
        jr Z, .l_7
        inc a
        ld (State.soupCans), a
.l_7:
        ld (iy+5), #00
        jp c_d026
.l_8:
        cp #05
        jr NZ, .l_9
        ld (iy+5), #00
        ld a, #04
        jp c_d09a
.l_9:
        cp #07
        jr NZ, .l_11
        ld (iy+5), #00
        ld a, (State.maxEnergy)
        add #04
        cp #22
        jr C, .l_10
        ld a, #22
.l_10:
        ld (State.maxEnergy), a
        ld a, #04
        jp c_d09a
.l_11:
        cp #08
        ret NZ
        ld (iy+5), #00
        ld a, #FF
        ld (State.s_20), a
        ret

; (Init ix+0, 1, 2 from (hl)?)
; Used by c_e920 and c_e9b1.
c_eace:  ; #eace
        ld ix, c_beb4
        ld a, (hl)
        add a
        add a
        add a
        add a
        add a
        add #20
        ld (ix+0), a
        ld (ix+1), #00
        inc hl
        ld a, (hl)
        add a
        add a
        add a
        add a
        add a
        add #20
        ld (ix+2), a
        ret

; Get tile type without bit 7
; Used by c_d709, c_d7f6, c_d94c, c_da95, c_db4e, c_dbfc, c_de37,
; c_deb1, c_df85, c_f1d7, c_f2e7 and c_f618.
c_eaee:  ; #eaee
        push hl
        ld h, high(Level.tileTypes)
        ld l, a
        ld a, (hl)
        and #7F
        pop hl
        ret

; (Some damage table (3 something * 3 soup cans)?)
c_eaf7:  ; #eaf7
        db #04, #10, #10, #02, #14, #14, #00, #18
        db #18

; Check enemies for damaging?
; Used by c_df85.
c_eb00:  ; #eb00
        ld ix, #BEE6
        ld iy, #BF18
        ld b, #06
.l_0:
        push bc
        call c_eb19
        pop bc
        ret NC
        ld de, #0032
        add iy, de
        djnz .l_0
        scf
        ret

; Logic for damaging enemies?
; Used by c_eb00.
c_eb19:  ; #eb19
        ld a, (iy+8)
        or a
        jp Z, c_ec00.l_3
        bit 0, (iy+5)
        jp Z, c_ec00.l_3
        ld a, (iy+12)
        cp #FE
        jp Z, c_ec00.l_3
        ld a, (iy+14)
        or a
        jp NZ, c_ec00.l_3
        ld a, (State.weapon)
        or a
        jr NZ, .l_1
        ld a, (iy+7)
        cp #FF
        jr NZ, .l_0
        res 0, (ix+5)
        ret
.l_0:
        ld a, (State.soupCans)
        dec a
        ld l, a
        add a
        add l
        ld l, a
        ld h, #00
        ld de, c_eaf7
        add hl, de
        ld c, l
        ld b, h
        ld l, (ix+0)
        ld h, (ix+1)
        push hl
        ld a, (bc)
        inc bc
        ld e, a
        ld d, #00
        add hl, de
        ld (ix+0), l
        ld (ix+1), h
        ld a, (bc)
        inc bc
        ld (ix+10), a
        ld a, (bc)
        ld (ix+11), a
        call c_e80a
        pop hl
        ld (ix+0), l
        ld (ix+1), h
        ret C
        set 0, (ix+5)
        jr c_ec00
.l_1:
        cp #01
        jr NZ, .l_3
        bit 1, (ix+5)
        jr NZ, .l_2
        ld a, (ix+0)
        add #04
        ld (ix+0), a
        ld a, (ix+1)
        adc a, #00
        ld (ix+1), a
        call c_e80a
        exa
        ld a, (ix+0)
        add #FC
        ld (ix+0), a
        ld a, (ix+1)
        adc a, #FF
        ld (ix+1), a
        exa
        ret
.l_2:
        ld a, (State.soupCans)
        dec a
        ld l, a
        add a
        add l
        ld l, a
        ld h, #00
        ld de, c_eaf7
        add hl, de
        ld c, l
        ld b, h
        ld l, (ix+0)
        ld h, (ix+1)
        push hl
        ld a, (bc)
        inc bc
        ld e, a
        ld d, #00
        add hl, de
        ld (ix+0), l
        ld (ix+1), h
        ld a, (bc)
        inc bc
        ld (ix+10), a
        ld a, (bc)
        ld (ix+11), a
        call c_e80a
        pop hl
        ld (ix+0), l
        ld (ix+1), h
        ret C
        jr c_ec00
.l_3:
        call c_e80a
        ret C
        jr c_ec00

; Weapon damage table (4 weapons * 3 soup cans)?
c_ebf4:  ; #ebf4
        db #FF, #FE, #FD, #FF, #FE, #FE, #FF, #FE
        db #FD, #FE, #FD, #FC

; Damage/kill enemy?
; Used by c_eb19.
c_ec00:  ; #ec00
        ld a, (iy+7)
        cp #FF
        jr Z, .l_3
        ld a, (iy+12)
        cp #FF
        jr Z, .l_3
        ld a, (State.weapon)
        ld l, a
        add a
        add l
        ld l, a
        ld h, #00
        ld de, c_ebf4
        add hl, de
        ld a, (State.soupCans)
        dec a
        ld e, a
        ld d, #00
        add hl, de
        ld a, (hl)
        ld b, a
        ld a, (State.s_54)
        or a
        jr NZ, .l_4
        ld a, b
        add (iy+12)
        jr Z, .l_0
        jr NC, .l_0
        ld (iy+12), a
        ld (iy+14), #04
        ld a, #03
        call playSound
        jr .l_2
; This entry point is used by c_d4e5.
.l_0:
        bit 4, (iy+24)
        jp NZ, c_d2b3
        bit 1, (iy+5)
        jr NZ, .l_1
        push ix
        push iy
        push iy
        pop ix
        call c_d443
        pop iy
        pop ix
.l_1:
        ld (iy+6), #00
        ld (iy+7), #FF
        ld (iy+9), #47
        ld a, #06
        call playSound
.l_2:
        xor a
        ret
; This entry point is used by c_eb19.
.l_3:
        scf
        ret
.l_4:
        ld a, (State.s_56)
        or a
        jr NZ, .l_2
        ld a, (State.s_55)
        add b
        jr NC, .l_7
        ld (State.s_55), a
        ld a, #03
        call playSound
        push ix
        push de
        ld ix, #BF18
        ld b, #04
        ld de, #0032
.l_5:
        bit 1, (ix+5)
        jr Z, .l_6
        ld (ix+14), #04
.l_6:
        add ix, de
        djnz .l_5
        pop de
        pop ix
        jr .l_2
.l_7:
        push ix
        push de
        ld ix, #BF18
        ld b, #04
        ld de, #0032
.l_8:
        bit 0, (ix+5)
        jr Z, .l_9
        bit 1, (ix+5)
        jr Z, .l_9
        ld (ix+6), #00
        ld (ix+7), #FF
        ld (ix+9), #47
.l_9:
        add ix, de
        djnz .l_8
        pop de
        pop ix
        ld a, #FF
        ld (State.s_57), a
        ld de, c_cf84
        call c_cf85.l_0
        ld a, (State.level)
        ld hl, State.levelsDone
        ld e, a
        ld d, #00
        add hl, de
        ld (hl), #01
        ld a, #06
        call playSound
        jr .l_2

; (Modifies some object properties?)
; Used by c_cc25.
c_ecee:  ; #ecee
        ld ix, #BF18
        ld b, #06
.l_0:
        push bc
        push ix
        call c_f488
        call c_ed08
        pop ix
        ld bc, #0032
        add ix, bc
        pop bc
        djnz .l_0
        ret

; (Modifies some object properties?)
; Used by c_ecee.
c_ed08:  ; #ed08
        bit 0, (ix+5)
        ret Z
        call c_f564
        ld a, (ix+23)
        cp #01
        jp Z, c_f618
        bit 5, (ix+5)
        ret NZ
        ld a, (ix+8)
        cp #0E
        jp Z, c_f2e7
        call c_f4e9
        ld a, (ix+23)
        cp #02
        jr NZ, .l_0
        call c_f37e
        jp .l_2
.l_0:
        cp #04
        call Z, c_f37e
        ld a, (ix+23)
        or a
        jp Z, .l_1
        cp #03
        jp Z, c_ef72
        cp #04
        jp Z, c_ef72
        cp #05
        jp Z, c_f0f3
        cp #06
        jp Z, c_f518
        ret
.l_1:
        set 2, (ix+5)
        set 3, (ix+5)
        ret
.l_2:
        ld a, (ix+22)
        cp #FE
        jr Z, .l_5
        cp #FF
        ret NZ
        call c_f1d7
        ld a, (State.s_4A)
        cp #02
        ret C
        bit 1, (ix+5)
        jr NZ, .l_3
        call c_d443
.l_3:
        ld a, (ix+8)
        cp #28
        jr NZ, .l_4
        ld a, (ix+0)
        sub #08
        ld (ix+0), a
.l_4:
        ld (ix+6), #00
        ld (ix+7), #FF
        ld (ix+9), #47
        ld a, #06
        jp playSound
.l_5:
        call c_f1d7
        ld a, (State.s_4A)
        cp #04
        ret C
        ld (ix+23), #00
        set 5, (ix+5)
        ld a, (ix+8)
        cp #6E
        ret NZ
        ld hl, #A918            ; TODO: suspicious addr!
        ld (ix+3), l
        ld (ix+4), h
        ld (ix+7), #00
        ret

; (Modifies some object properties?)
; Used by c_f564.
c_edc0:  ; #edc0
        ld (ix+29), a
        ld l, (ix+0)
        ld h, (ix+1)
        ld (ix+30), l
        ld (ix+31), h
        push hl
        ld a, (ix+2)
        ld (ix+32), a
        ld (ix+33), #00
        ld iy, c_beb4
        ld l, (iy+0)
        ld h, (iy+1)
        ld a, (iy+10)
        srl a
        sub #03
        ld e, a
        ld d, #00
        add hl, de
        ld (ix+34), l
        ld (ix+35), h
        push hl
        ld a, (iy+11)
        srl a
        sub #03
        add (iy+2)
        ld (ix+36), a
        ld (ix+37), #00
        pop hl
        pop de
        xor a
        sbc hl, de
        ex de, hl
        ld c, (ix+32)
        ld b, (ix+33)
        ld l, (ix+36)
        ld h, (ix+37)
        xor a
        sbc hl, bc
        bit 7, d
        jp M, .l_0
        ld (ix+42), #01
        ld (ix+43), #00
        jr .l_1
.l_0:
        ld (ix+42), #FF
        ld (ix+43), #FF
        ld a, d
        cpl
        ld d, a
        ld a, e
        cpl
        ld e, a
        inc de
.l_1:
        ld (ix+38), e
        ld (ix+39), d
        ld a, h
        or l
        jr Z, .l_2
        bit 7, h
        jp M, .l_3
        ld (ix+44), #01
        ld (ix+45), #00
        ld (ix+46), #00
        ld (ix+47), #00
        jr .l_4
.l_2:
        ld (ix+44), #01
        ld (ix+45), #00
        ld (ix+46), #FF
        ld (ix+47), #FF
        jr .l_4
.l_3:
        ld (ix+44), #FF
        ld (ix+45), #FF
        ld (ix+46), #00
        ld (ix+47), #00
        ld a, h
        cpl
        ld h, a
        ld a, l
        cpl
        ld l, a
        inc hl
.l_4:
        ld (ix+40), l
        ld (ix+41), h
        ld (ix+36), #00
        ld (ix+37), #00
        ret

; (Modifies some object properties?)
; Used by c_f618.
c_ee93:  ; #ee93
        ld a, (ix+7)
        cp #FF
        ret Z
        ld b, (ix+29)
        ld e, (ix+38)
        ld d, (ix+39)
        ld l, (ix+40)
        ld h, (ix+41)
        xor a
        sbc hl, de
        jr NC, .l_2
.l_0:
        ld a, (ix+46)
        or a
        jp M, .l_1
        ld l, (ix+32)
        ld h, (ix+33)
        ld e, (ix+44)
        ld d, (ix+45)
        add hl, de
        ld (ix+32), l
        ld (ix+33), h
        ld e, (ix+38)
        ld d, (ix+39)
        ld l, (ix+46)
        ld h, (ix+47)
        xor a
        sbc hl, de
        ld (ix+46), l
        ld (ix+47), h
.l_1:
        ld l, (ix+30)
        ld h, (ix+31)
        ld e, (ix+42)
        ld d, (ix+43)
        add hl, de
        ld (ix+30), l
        ld (ix+31), h
        ld l, (ix+40)
        ld h, (ix+41)
        ld e, (ix+46)
        ld d, (ix+47)
        add hl, de
        ld (ix+46), l
        ld (ix+47), h
        djnz .l_0
        jr .l_4
.l_2:
        ld a, (ix+46)
        or a
        jp P, .l_3
        ld l, (ix+30)
        ld h, (ix+31)
        ld e, (ix+42)
        ld d, (ix+43)
        add hl, de
        ld (ix+30), l
        ld (ix+31), h
        ld l, (ix+40)
        ld h, (ix+41)
        ld e, (ix+46)
        ld d, (ix+47)
        xor a
        add hl, de
        ld (ix+46), l
        ld (ix+47), h
.l_3:
        ld l, (ix+32)
        ld h, (ix+33)
        ld e, (ix+44)
        ld d, (ix+45)
        add hl, de
        ld (ix+32), l
        ld (ix+33), h
        ld e, (ix+38)
        ld d, (ix+39)
        ld l, (ix+46)
        ld h, (ix+47)
        xor a
        sbc hl, de
        ld (ix+46), l
        ld (ix+47), h
        djnz .l_2
.l_4:
        ld l, (ix+30)
        ld h, (ix+31)
        ld (ix+0), l
        ld (ix+1), h
        ld a, (ix+32)
        ld (ix+2), a
        xor a
        ret

; (Some game logic?)
; Used by c_ed08.
c_ef72:  ; #ef72
        ld a, (ix+22)
        cp #FF
        jp Z, .l_0
        cp #FE
        jp Z, .l_6
        cp #FC
        jp Z, .l_10
        cp #FB
        jp Z, .l_19
        jp .l_23
.l_0:
        call c_f670
        call c_f697
        call c_f1d7
        ld a, (State.s_4C)
        bit 0, (ix+21)
        jr NZ, .l_1
        ld a, (State.s_4B)
.l_1:
        cp #04
        jr NC, .l_3
        ld a, (ix+8)
        cp #82
        jr Z, .l_4
        ld a, (State.s_4E)
        bit 0, (ix+21)
        jr NZ, .l_2
        ld a, (State.s_4D)
.l_2:
        or a
        jr NZ, .l_4
.l_3:
        ld a, (ix+21)
        xor #03
        ld (ix+21), a
        jp .l_23
.l_4:
        ld l, (ix+0)
        ld h, (ix+1)
        bit 0, (ix+21)
        jr NZ, .l_5
        ld de, #0020
        xor a
        sbc hl, de
        jr C, .l_3
        jp .l_23
.l_5:
        ld d, #00
        ld e, (ix+10)
        add hl, de
        ld de, #0120
        xor a
        sbc hl, de
        jr NC, .l_3
        jp .l_23
.l_6:
        ld (ix+20), #08
        call c_f1d7
        bit 7, (ix+24)
        jr NZ, .l_9
        call c_f670
        call c_f697
        ld a, (State.s_4C)
        bit 0, (ix+21)
        jr NZ, .l_7
        ld a, (State.s_4B)
.l_7:
        cp #04
        jr C, .l_8
        ld a, (ix+21)
        xor #03
        ld (ix+21), a
.l_8:
        ld a, (State.s_4A)
        cp #02
        jp NC, .l_23
        set 7, (ix+24)
        set 2, (ix+5)
        set 2, (ix+21)
        jp .l_23
.l_9:
        ld a, (State.s_4A)
        cp #02
        jp C, .l_23
        res 7, (ix+24)
        res 2, (ix+5)
        res 2, (ix+21)
        jp .l_23
.l_10:
        bit 0, (ix+15)
        jr Z, .l_11
        call generateRandom
        cp #0A
        jr NC, .l_11
        ld a, (ix+21)
        xor #0C
        ld (ix+21), a
.l_11:
        bit 1, (ix+15)
        jr Z, .l_12
        call generateRandom
        cp #0A
        jr NC, .l_12
        ld a, (ix+21)
        xor #03
        ld (ix+21), a
.l_12:
        call c_f1d7
        bit 0, (ix+21)
        jr Z, .l_13
        ld a, (State.s_4C)
        cp #02
        jr NC, .l_14
        jr .l_15
.l_13:
        bit 1, (ix+21)
        jr Z, .l_15
        ld a, (State.s_4B)
        cp #02
        jr C, .l_15
.l_14:
        ld a, (ix+21)
        xor #03
        ld (ix+21), a
.l_15:
        bit 2, (ix+21)
        jr Z, .l_16
        ld a, (State.s_4A)
        cp #02
        jr NC, .l_17
        jr .l_18
.l_16:
        bit 3, (ix+21)
        jr Z, .l_18
        ld a, (State.s_49)
        cp #02
        jr C, .l_18
.l_17:
        ld a, (ix+21)
        xor #0C
        ld (ix+21), a
.l_18:
        jp .l_23
.l_19:
        ld a, (ix+15)
        cp (ix+16)
        jr Z, .l_20
        inc (ix+15)
        jp .l_23
.l_20:
        ld (ix+15), #00
        ld c, (ix+21)
        ld a, c
        and #03
        jr Z, .l_21
        xor #03
.l_21:
        ld b, a
        ld a, c
        and #0C
        jr Z, .l_22
        xor #0C
.l_22:
        or b
        ld (ix+21), a
        jp .l_23
; This entry point is used by c_f0f3 and c_f518.
.l_23:
        call c_d407
        ret C
        ld (ix+5), #00
        ret

; (Some game logic?)
; Used by c_ed08.
c_f0f3:  ; #f0f3
        ld (ix+19), #02
        ld (ix+20), #02
        res 2, (ix+5)
        res 3, (ix+5)
        bit 0, (ix+22)
        jr NZ, .l_0
        set 3, (ix+5)
.l_0:
        bit 1, (ix+22)
        jr NZ, .l_1
        set 2, (ix+5)
.l_1:
        ld iy, c_beb4
        ld l, (ix+0)
        ld h, (ix+1)
        ld c, (ix+10)
        srl c
        ld b, #00
        add hl, bc
        ex de, hl
        ld l, (iy+0)
        ld h, (iy+1)
        ld c, (iy+10)
        srl c
        ld b, #00
        add hl, bc
        xor a
        sbc hl, de
        ld (ix+21), #01
        jp P, .l_2
        ld (ix+21), #02
        ld a, l
        cpl
        ld l, a
        ld a, h
        cpl
        ld h, a
        inc hl
.l_2:
        ld e, (ix+19)
        ld d, #00
        xor a
        sbc hl, de
        jp P, .l_3
        set 2, (ix+5)
.l_3:
        ld a, (ix+2)
        ld c, (ix+11)
        srl c
        add c
        ld c, a
        ld a, (iy+2)
        ld b, (iy+11)
        srl b
        add b
        sub c
        set 2, (ix+21)
        res 3, (ix+21)
        jp P, .l_4
        cpl
        set 3, (ix+21)
        res 2, (ix+21)
.l_4:
        cp (ix+20)
        jr NC, .l_5
        set 3, (ix+5)
.l_5:
        call c_f1d7
        bit 0, (ix+21)
        jr Z, .l_6
        ld a, (State.s_4C)
        cp #04
        jr C, .l_6
        set 2, (ix+5)
.l_6:
        bit 1, (ix+21)
        jr Z, .l_7
        ld a, (State.s_4B)
        cp #04
        jr C, .l_7
        set 2, (ix+5)
.l_7:
        bit 2, (ix+21)
        jr Z, .l_8
        ld a, (State.s_4A)
        cp #03
        jr C, .l_8
        set 3, (ix+5)
.l_8:
        bit 3, (ix+21)
        jr Z, .l_9
        ld a, (State.s_49)
        cp #03
        jr C, .l_9
        set 3, (ix+5)
.l_9:
        jp c_ef72.l_23

; (Modifies some object properties?)
; Used by c_ed08, c_ef72, c_f0f3 and c_f518.
c_f1d7:  ; #f1d7
        bit 1, (ix+5)
        jr NZ, .l_0
        ld a, (ix+0)
        add #08
        ld (ix+0), a
        ld a, (ix+1)
        adc a, #00
        ld (ix+1), a
        call c_d460
        ld a, (hl)
        call c_eaee
        ld (State.s_49), a
        ld de, #0058
        add hl, de
        ld a, (hl)
        call c_eaee
        ld (State.s_4A), a
        ld a, (ix+0)
        add #F8
        ld (ix+0), a
        ld a, (ix+1)
        adc a, #FF
        ld (ix+1), a
        call c_d460
        ld de, #002C
        add hl, de
        ld a, (hl)
        call c_eaee
        ld (State.s_4B), a
        inc hl
        inc hl
        ld a, (hl)
        call c_eaee
        ld (State.s_4C), a
        ld de, #002A
        add hl, de
        ld a, (hl)
        call c_eaee
        ld (State.s_4D), a
        inc hl
        inc hl
        ld a, (hl)
        call c_eaee
        ld (State.s_4E), a
        ret
.l_0:
        ld a, (ix+0)
        add #0C
        ld (ix+0), a
        ld a, (ix+1)
        adc a, #00
        ld (ix+1), a
        call c_d460
        ld a, (ix+0)
        add #F4
        ld (ix+0), a
        ld a, (ix+1)
        adc a, #FF
        ld (ix+1), a
        bit 1, (ix+21)
        jr NZ, .l_1
        dec hl
.l_1:
        ld a, (hl)
        call c_eaee
        ld (State.s_49), a
        ld de, #0084
        add hl, de
        ld a, (hl)
        call c_eaee
        ld (State.s_4A), a
        inc hl
        bit 1, (ix+21)
        jr NZ, .l_2
        dec hl
.l_2:
        ld a, (hl)
        call c_eaee
        ld c, a
        ld a, (State.s_4A)
        or c
        ld (State.s_4A), a
        call c_d460
        ld a, (ix+8)
        cp #82
        jr Z, .l_3
        ld de, #0058
        add hl, de
.l_3:
        ld a, (hl)
        call c_eaee
        ld (State.s_4B), a
        inc hl
        inc hl
        inc hl
        ld a, (hl)
        call c_eaee
        ld (State.s_4C), a
        ld de, #0029
        ld a, (ix+8)
        cp #11
        jr Z, .l_4
        cp #12
        jr NZ, .l_5
.l_4:
        ld de, #0055
.l_5:
        add hl, de
        ld a, (hl)
        call c_eaee
        ld (State.s_4D), a
        inc hl
        inc hl
        inc hl
        ld a, (hl)
        call c_eaee
        ld (State.s_4E), a
        ret

; Data block at F2D1
c_f2d1:  ; #f2d1
        db #00, #01, #01, #01, #01, #02, #02, #02
        db #03, #03, #04, #04, #04, #04, #04, #04
        db #04, #04, #04, #04, #04, #04

; (Modifies some object properties?)
; Used by c_ed08.
c_f2e7:  ; #f2e7
        ld a, (ix+19)
        or a
        jr Z, .l_0
        dec (ix+19)
        ret
.l_0:
        bit 2, (ix+21)
        jr NZ, .l_2
        ld a, (ix+6)
        or a
        jr NZ, .l_1
        ld (ix+21), #04
        ld (ix+20), #00
        ld (ix+19), #20
        ret
.l_1:
        dec (ix+6)
        ld a, (ix+2)
        and #07
        jr NZ, .l_4
        call c_d460
        inc hl
        ld (hl), #00
        inc hl
        ld (hl), #00
        ld de, #057E
        add hl, de
        ld (hl), #01
        inc hl
        ld (hl), #01
        jr .l_4
.l_2:
        inc (ix+6)
        call c_d460
        ld c, #BD
        ld a, (State.level)
        cp #03
        jr NZ, .l_3
        dec c
.l_3:
        inc hl
        ld (hl), c
        inc hl
        inc c
        ld (hl), c
        ld de, #057E
        add hl, de
        ld (hl), #01
        inc hl
        ld (hl), #01
        ld a, (ix+2)
        and #07
        jr NZ, .l_4
        call c_d460
        ld de, #002D
        add hl, de
        ld a, (hl)
        call c_eaee
        or a
        jr NZ, .l_5
.l_4:
        ld a, (ix+6)
        ld l, a
        ld h, #00
        ld de, c_f2d1
        add hl, de
        ld a, (hl)
        ld (ix+20), a
        ret
.l_5:
        ld (ix+21), #08
        ld (ix+20), #00
        ret

; (Direction transform?)
c_f373:  ; #f373
        db #00, #08, #04, #00, #02, #0A, #06, #00
        db #01, #09, #05

; (Moves object along trajectory?)
; Used by c_ed08.
c_f37e:  ; #f37e
        bit 5, (ix+5)
        ret NZ
        xor a
        ld (State.s_4F), a
        ld (State.s_50), a
        ld a, (ix+15)
        add a
        ld l, a
        ld h, #00
        ld de, Level.trajVelTable
        add hl, de
        ld e, (hl)
        inc hl
        ld d, (hl)
        ld a, (ix+15)
        add a
        ld l, a
        ld h, #00
        ld bc, Level.trajDirTable
        add hl, bc
        ld c, (hl)
        inc hl
        ld b, (hl)
.l_0:
        ld l, (ix+16)
        ld h, #00
        add hl, de
        ld a, (hl)
        cp #FF
        jr NZ, .l_1
        dec hl
        ld a, (hl)
        ld (State.s_4F), a
        ld l, (ix+16)
        ld h, #00
        add hl, bc
        dec hl
        ld a, (hl)
        ld (State.s_50), a
        dec (ix+16)
        jr .l_5
.l_1:
        cp #FE
        jr NZ, .l_2
        ld (ix+16), #00
        jr .l_0
.l_2:
        cp #FD
        jr NZ, .l_3
        dec (ix+16)
        jr .l_5
.l_3:
        cp #FC
        jr NZ, .l_4
        ld (ix+17), #FF
        dec (ix+16)
        jr .l_0
.l_4:
        ld (State.s_4F), a
        ld l, (ix+16)
        ld h, #00
        add hl, bc
        ld a, (hl)
        ld (State.s_50), a
.l_5:
        ld a, (State.s_50)
        ld l, a
        ld h, #00
        ld de, c_f373
        add hl, de
        ld c, (hl)
        ld a, (ix+17)
        or a
        jr Z, .l_8
        ld a, c
        and #03
        jr Z, .l_6
        xor #03
.l_6:
        ld b, a
        ld a, c
        and #0C
        jr Z, .l_7
        xor #0C
.l_7:
        or b
        ld c, a
.l_8:
        ld (ix+18), c
        ld a, (State.s_4F)
        bit 0, (ix+24)
        jr Z, .l_9
        ld (ix+19), a
.l_9:
        ld b, a
        bit 2, c
        jr Z, .l_10
        ld a, (ix+2)
        add b
        ld (ix+2), a
        jr .l_11
.l_10:
        bit 3, c
        jr Z, .l_11
        ld a, (ix+2)
        sub b
        ld (ix+2), a
.l_11:
        ld e, b
        ld d, #00
        bit 0, c
        jr Z, .l_12
        ld l, (ix+0)
        ld h, (ix+1)
        add hl, de
        ld (ix+0), l
        ld (ix+1), h
        jr .l_13
.l_12:
        bit 1, c
        jr Z, .l_13
        ld l, (ix+0)
        ld h, (ix+1)
        xor a
        sbc hl, de
        ld (ix+0), l
        ld (ix+1), h
.l_13:
        ld a, (ix+17)
        or a
        jr NZ, .l_14
        inc (ix+16)
        jr .l_15
.l_14:
        dec (ix+16)
        jp P, .l_15
        ld (ix+16), #00
        ld (ix+17), #00
.l_15:
        call c_d407
        ret C
        ld (ix+5), #00
        ret

; (Modifies some object properties?)
; Used by c_ecee.
c_f488:  ; #f488
        ld a, (ix+27)
        or a
        ret Z
        ld iy, c_beb4
        ld a, (ix+26)
        neg
        add (ix+2)
        ld c, a
        add (ix+28)
        cp (iy+2)
        ret C
        ld a, (iy+2)
        add (iy+11)
        cp c
        ret C
        ld l, (ix+0)
        ld h, (ix+1)
        ld e, (ix+25)
        ld d, #00
        xor a
        sbc hl, de
        ex de, hl
        ld l, (iy+0)
        ld h, (iy+1)
        ld c, (iy+10)
        ld b, #00
        add hl, bc
        xor a
        sbc hl, de
        ret C
        ld l, (ix+27)
        ld h, #00
        add hl, de
        ld e, (iy+0)
        ld d, (iy+1)
        xor a
        sbc hl, de
        ret C
        res 5, (ix+5)
        res 2, (ix+5)
        res 3, (ix+5)
        ld (ix+27), #00
        ret

; (Modifies some object properties?)
; Used by c_ed08.
c_f4e9:  ; #f4e9
        ld a, (ix+8)
        cp #0F
        jr Z, .l_0
        cp #10
        ret NZ
.l_0:
        call generateRandom
        cp #02
        ret NC
        ld (ix+6), #00
        ld (ix+7), #FF
        ld (ix+9), #47
        ret

; Data block at F506
c_f506:  ; #f506
        db #FA, #FB, #FC, #FD, #FE, #FE, #FF, #FF
        db #00, #01, #01, #02, #02, #03, #04, #05
        db #06, #7F

; (Modifies some object properties?)
; Used by c_ed08.
c_f518:  ; #f518
        ld a, (ix+15)
        ld l, a
        ld h, #00
        ld de, c_f506
        add hl, de
        ld a, (hl)
        cp #7F
        jr NZ, .l_0
        dec (ix+15)
        ld a, #08
.l_0:
        add (ix+2)
        ld (ix+2), a
        ld a, (hl)
        cp #7F
        jr NZ, .l_1
        call c_f1d7
        ld a, (State.s_4A)
        cp #04
        jr C, .l_1
        ld a, (ix+2)
        and #F8
        ld (ix+2), a
        ld (ix+23), #00
.l_1:
        inc (ix+15)
        jp c_ef72.l_23

; Decrements some counter at State.s_51
; Used by c_cc25.
c_f553:  ; #f553
        ld a, (State.s_51)
        or a
        jr Z, .l_0
        dec a
        ld (State.s_51), a
        ret
.l_0:
        ld a, #3C
        ld (State.s_51), a
        ret

; (Modifies some object properties?)
; Used by c_ed08.
c_f564:  ; #f564
        ld a, (State.s_51)
        or a
        ret NZ
        ld a, (ix+23)
        cp #01
        ret Z
        ld a, (ix+49)
        or a
        ret Z
        push ix
        call c_e6c2
        push ix
        pop iy
        pop ix
        ret NC
        ld hl, cS.powerBullet1
        ld (iy+3), l
        ld (iy+4), h
        ld (iy+7), #00
        ld (iy+9), #47
        ld (iy+21), #00
        ld (iy+19), #05
        ld (iy+20), #03
        ld (iy+10), #06
        ld (iy+11), #06
        ld (iy+12), #01
        ld (iy+5), #01
        ld (iy+8), #00
        ld (iy+23), #01
        ld (iy+24), #00
        ld a, (ix+49)
        ld (iy+49), a
        ld a, (ix+10)
        sub (iy+10)
        srl a
        ld e, a
        ld d, #00
        ld l, (ix+0)
        ld h, (ix+1)
        add hl, de
        ld (iy+0), l
        ld (iy+1), h
        ld a, (ix+11)
        sub (iy+11)
        srl a
        add (ix+2)
        ld (iy+2), a
        ld a, (iy+49)
        cp #01
        jr Z, .l_2
        cp #02
        jr NZ, .l_0
        ld a, (ix+21)
        and #03
        ld (iy+21), a
        ret
.l_0:
        cp #03
        jr NZ, .l_1
        ld (iy+21), #08
        ret
.l_1:
        cp #04
        ret NZ
        ld (iy+21), #04
        ret
.l_2:
        push ix
        push iy
        pop ix
        ld a, #04
        call c_edc0
        pop ix
        ret

; (Modifies some object properties?)
; Used by c_ed08.
c_f618:  ; #f618
        ld a, (ix+49)
        cp #01
        call Z, c_ee93
        ld iy, c_beb4
        call c_e80a
        jr C, .l_1
        ld (ix+5), #00
        ld b, (ix+12)
        ld a, (iy+14)
        or a
        ret NZ
        ld a, (State.energy)
        sub b
        jr NC, .l_0
        ld a, #FF
        ld (State.s_1F), a
        xor a
.l_0:
        ld (State.energy), a
        ld (iy+14), #07
        jp c_d04e
.l_1:
        ld a, (State.level)
        or a
        jr NZ, .l_2
        ld a, (State.s_54)
        or a
        jr NZ, .l_3
.l_2:
        call c_d460
        ld a, (hl)
        call c_eaee
        cp #04
        jr C, .l_3
        ld (ix+5), #00
        ret
.l_3:
        call c_d407.l_0
        ret C
        ld (ix+5), #00
        ret

; (Some game logic?)
; Used by c_ef72.
c_f670:  ; #f670
        bit 5, (ix+24)
        ret Z
        call generateRandom
        cp #08
        ret NC
        bit 1, (ix+15)
        jr Z, .l_0
        ld a, (ix+21)
        xor #03
        ld (ix+21), a
.l_0:
        bit 0, (ix+15)
        ret Z
        ld a, (ix+21)
        xor #0C
        ld (ix+21), a
        ret

; (Some game logic?)
; Used by c_ef72.
c_f697:  ; #f697
        bit 1, (ix+24)
        ret Z
        ld a, (ix+48)
        or a
        jr Z, .l_0
        dec (ix+48)
        ret
.l_0:
        call generateRandom
        cp #04
        ret NC
        call generateRandom
        and #1F
        ld (ix+48), a
        ret

; Object type offset by level
c_f6b5:  ; #f6b5
        db #00, #31, #5F, #88, #BC

; Get objects from the object table
; Used by c_cd9b and c_e920.
c_f6ba:  ; #f6ba
        ld bc, Level.objectTable
.l_0:
        ld de, (State.screenX)
        ld a, (bc)
        ld h, a
        inc bc
        ld a, (bc)
        ld l, a
        inc bc
        xor a
        sbc hl, de
        jr C, .l_1
        push hl
        ld de, #0020
        xor a
        sbc hl, de
        pop hl
        jr NC, .l_2
        call c_f74a
        jr .l_0
.l_1:
        inc bc
        inc bc
        jr .l_0
.l_2:
        dec bc
        dec bc
        ld (State.s_52), bc
        jr c_f6e7.l_3

; Get next objects from the object table
; Used by c_cc25.
c_f6e7:  ; #f6e7
        ld bc, (State.s_52)
.l_0:
        ld de, (State.screenX)
        ld a, (bc)
        ld h, a
        inc bc
        ld a, (bc)
        ld l, a
        inc bc
        xor a
        sbc hl, de
        jr C, .l_1
        push hl
        ld de, #0028
        xor a
        sbc hl, de
        pop hl
        jr NC, .l_2
        push bc
        call c_f74a
        pop bc
        inc bc
        inc bc
        jr .l_0
.l_1:
        inc bc
        inc bc
        jr .l_0
.l_2:
        dec bc
        dec bc
        ld (State.s_52), bc
; This entry point is used by c_f6ba.
.l_3:
        ld ix, #BF18
        ld b, #06
.l_4:
        bit 0, (ix+5)
        jr Z, .l_6
        ld l, (ix+0)
        ld h, (ix+1)
        ld de, #0120
        xor a
        sbc hl, de
        jp C, .l_5
        set 5, (ix+5)
        jr .l_6
.l_5:
        ld a, (ix+27)
        or a
        jr NZ, .l_6
        res 5, (ix+5)
.l_6:
        ld de, #0032
        add ix, de
        djnz .l_4
        ret

; Initialize object from the object type
; Used by c_f6ba and c_f6e7.
c_f74a:  ; #f74a
        call c_e6c2
        ret NC
        add hl, hl
        add hl, hl
        add hl, hl
        ld de, #0020
        add hl, de
        ld (ix+0), l
        ld (ix+1), h
        ld a, (bc)
        add a
        add a
        add a
        add #20
        ld (ix+2), a
        inc bc
        ld a, (bc)
        cp #0A
        jr C, .l_0
        exa
        ld a, (State.level)
        ld l, a
        ld h, #00
        ld de, c_f6b5
        add hl, de
        ld l, (hl)
        exa
        sub l
.l_0:
        inc bc
; This entry point is used by c_f8f4, c_f9a4, c_fa65, c_fad3 and
; c_fb45.
.l_1:
        exx
        ld l, a
        ld h, #00
        add hl, hl
        ld c, l
        ld b, h
        add hl, hl
        add hl, hl
        ld e, l
        ld d, h
        add hl, hl
        add hl, de
        add hl, bc
        push hl
        exx
        pop hl
        ld de, Common.objectTypes
        add hl, de
        ld (ix+6), #00
        ld (ix+48), #00
        ld (ix+21), #02
        ld a, (hl)
        ld (ix+3), a
        inc hl
        ld a, (hl)
        ld (ix+4), a
        inc hl
        ld a, (hl)
        ld (ix+9), a
        inc hl
        ld a, (hl)
        ld (ix+7), a
        inc hl
        ld a, (hl)
        ld (ix+5), a
        inc hl
        ld a, (hl)
        ld (ix+10), a
        inc hl
        ld a, (hl)
        ld (ix+11), a
        inc hl
        ld a, (hl)
        ld (ix+12), a
        inc hl
        ld a, (hl)
        or a
        jr Z, .l_2
        ld a, (ix+5)
        or #2C
        ld (ix+5), a
.l_2:
        inc hl
        ld a, (hl)
        ld (ix+13), a
        inc hl
        ld a, (hl)
        ld (ix+24), a
        inc hl
        ld a, (hl)
        ld (ix+8), a
        or a
        jr NZ, .l_3
        ld a, (State.s_46)
        cp #7F
        jr NZ, .l_3
        ld (ix+5), #00
        ret
.l_3:
        inc hl
        ld a, (hl)
        ld (ix+49), a
        inc hl
        ld a, (hl)
        ld (ix+15), a
        inc hl
        ld a, (hl)
        ld (ix+16), a
        inc hl
        ld a, (hl)
        ld (ix+17), a
        inc hl
        ld a, (hl)
        ld (ix+18), a
        inc hl
        ld a, (hl)
        ld (ix+19), a
        inc hl
        ld a, (hl)
        ld (ix+20), a
        inc hl
        ld a, (hl)
        ld (ix+21), a
        inc hl
        ld a, (hl)
        ld (ix+22), a
        inc hl
        ld a, (hl)
        ld (ix+23), a
        inc hl
        ld a, (hl)
        ld (ix+25), a
        inc hl
        ld a, (hl)
        ld (ix+26), a
        inc hl
        ld a, (hl)
        ld (ix+27), a
        inc hl
        ld a, (hl)
        ld (ix+28), a
        ld a, (ix+21)
        ld l, a
        ld h, #00
        ld de, c_f373
        add hl, de
        ld a, (hl)
        ld (ix+21), a
        bit 1, (ix+5)
        jr NZ, .l_4
        ld a, (ix+2)
        sub (ix+11)
        ld (ix+2), a
        jr .l_5
.l_4:
        ld a, (ix+2)
        sub (ix+11)
        ld (ix+2), a
.l_5:
        ld a, (ix+8)
        cp #0E
        jr NZ, .l_6
        ld l, (ix+0)
        ld h, (ix+1)
        ld de, #0004
        add hl, de
        ld (ix+0), l
        ld (ix+1), h
        ld a, (ix+2)
        and #F8
        ld (ix+2), a
        ret
.l_6:
        cp #01
        jr NZ, .l_7
        ld a, (ix+2)
        add #06
        ld (ix+2), a
        ret
.l_7:
        ld a, (ix+8)
        cp #A3
        jr NZ, .l_8
        ld (ix+5), #00
        ret
.l_8:
        ld a, (State.s_54)
        or a
        ret NZ
        ld a, (ix+8)
        cp #35
        jr Z, .l_9
        cp #5E
        jr Z, .l_10
        cp #8A
        jr Z, .l_10
        cp #BF
        jr Z, .l_10
        cp #ED
        jr Z, .l_10
        ret
.l_9:
        ld hl, (State.screenX)
        ld de, #05D4
        xor a
        sbc hl, de
        jr NC, .l_10
        ld (ix+5), #00
        ret
.l_10:
        ld a, #01
        ld (State.s_54), a
        ld a, #3C
        ld (State.s_55), a
        ret

; Boss logic switch by level
; Used by c_cc25.
c_f8cb:  ; #f8cb
        ld a, (State.s_54)
        or a
        ret Z
        ld a, (State.level)
        or a
        jp Z, c_f8f4
        cp #01
        jp Z, c_f9a4
        cp #02
        jp Z, c_fa65
        cp #03
        jp Z, c_fad3
        cp #04
        jp Z, c_fb45
        ret

; Klondike boss positions
c_f8ec:  ; #f8ec
        db #98, #AB, #D8, #AB, #98, #4B, #D8, #4B

; Klondike boss logic
; Used by c_f8cb.
c_f8f4:  ; #f8f4
        ld a, (State.s_54)
        cp #01
        jr NZ, .l_1
        ld a, (State.s_57)
        or a
        ret NZ
        ld ix, #BF18
        ld a, #36
        call c_f74a.l_1
        ld ix, #BF4A
        ld a, #34
        call c_f74a.l_1
        ld ix, #BF7C
        ld a, #35
        call c_f74a.l_1
        ld ix, #BFAE
        ld a, #33
        call c_f74a.l_1
        call generateRandom
        and #03
        add a
        ld l, a
        ld h, #00
        ld de, c_f8ec
        add hl, de
        ld a, (hl)
        inc hl
        ld h, (hl)
        ld l, a
        ld b, #04
        ld ix, #BF18
        ld de, #0032
.l_0:
        ld (ix+0), l
        ld (ix+1), #00
        ld (ix+2), h
        add ix, de
        djnz .l_0
        ld a, #02
        ld (State.s_54), a
        xor a
        ld (State.s_56), a
        ld a, #FF
        ld (State.s_51), a
        ret
.l_1:
        ld hl, State.s_54
        inc (hl)
        ld a, (hl)
        cp #41
        jr NZ, .l_2
        ld ix, #BF7C
        ld hl, Lev0Klondike.lS.bossAnt2
        ld (ix+3), l
        ld (ix+4), h
        ld a, #FF
        ld (State.s_56), a
        ld a, #02
        ld (State.s_51), a
        ret
.l_2:
        cp #69
        jr NZ, .l_3
        ld a, #01
        ld (State.s_51), a
        ret
.l_3:
        cp #96
        ret C
; This entry point is used by c_fa65.
.l_4:
        ld b, #04
        ld ix, #BF18
        ld de, #0032
.l_5:
        ld (ix+5), #00
        djnz .l_5
        ld a, #01
        ld (State.s_54), a
        ret

; Orient boss data
c_f99e:  ; #f99e
        db #18, #00, #00, #15, #18, #15

; Orient boss logic
; Used by c_f8cb.
c_f9a4:  ; #f9a4
        ld a, (State.s_54)
        cp #01
        jr NZ, .l_1
        ld a, (State.s_57)
        or a
        ret NZ
        ld ix, #BF18
        ld a, #32
        call c_f74a.l_1
        ld ix, #BF4A
        ld a, #33
        call c_f74a.l_1
        ld ix, #BF7C
        ld a, #34
        call c_f74a.l_1
        ld ix, #BFAE
        ld a, #35
        call c_f74a.l_1
        ld de, c_f99e
        ld b, #03
        ld ix, #BF18
        ld iy, #BF4A
.l_0:
        push bc
        ld l, (ix+0)
        ld h, (ix+1)
        ld a, (de)
        inc de
        ld c, a
        ld b, #00
        add hl, bc
        ld (iy+0), l
        ld (iy+1), h
        ld a, (de)
        inc de
        add (ix+2)
        ld (iy+2), a
        ld bc, #0032
        add iy, bc
        pop bc
        djnz .l_0
        ld a, #02
        ld (State.s_54), a
        xor a
        ld (State.s_56), a
        ld a, #3C
        ld (State.s_51), a
        ret
.l_1:
        ld ix, #BF18
        bit 3, (ix+21)
        jr Z, .l_2
        ld a, (ix+2)
        cp #20
        jr NC, .l_3
        ld c, #0C
        call c_fbb9
        jr .l_3
.l_2:
        ld a, (ix+2)
        cp #98
        jr C, .l_3
        ld c, #0C
        call c_fbb9
.l_3:
        ld l, (ix+0)
        ld h, (ix+1)
        bit 1, (ix+21)
        jr NZ, .l_4
        ld de, #00F0
        xor a
        sbc hl, de
        ret C
        ld c, #03
        call c_fbb9
        jp c_fbd2
.l_4:
        ld de, #0020
        xor a
        sbc hl, de
        ret NC
        ld c, #03
        call c_fbb9
        jp c_fbd2

; Amazon boss positions
c_fa61:  ; #fa61
        db #E4, #7B, #44, #7B

; Amazon boss logic
; Used by c_f8cb.
c_fa65:  ; #fa65
        ld a, (State.s_54)
        cp #01
        jr NZ, .l_0
        ld a, (State.s_57)
        or a
        ret NZ
        ld ix, #BF18
        ld a, #2B
        call c_f74a.l_1
        ld ix, #BF4A
        ld a, #2C
        call c_f74a.l_1
        call generateRandom
        and #01
        add a
        ld l, a
        ld h, #00
        ld de, c_fa61
        add hl, de
        ld e, (hl)
        inc hl
        ld a, (hl)
        ld ix, #BF18
        ld iy, #BF4A
        ld (ix+0), e
        ld (iy+0), e
        ld (ix+1), #00
        ld (iy+1), #00
        ld (ix+2), a
        add #18
        ld (iy+2), a
        ld a, #02
        ld (State.s_54), a
        xor a
        ld (State.s_56), a
        ld a, #3C
        ld (State.s_51), a
        ret
.l_0:
        ld a, (State.s_58)
        or a
        jr Z, .l_1
        dec a
        ld (State.s_58), a
        ret
.l_1:
        ld a, #50
        ld (State.s_58), a
        jp c_f8f4.l_4

; Iceland boss logic
; Used by c_f8cb.
c_fad3:  ; #fad3
        ld a, (State.s_54)
        cp #01
        jr NZ, .l_0
        ld a, (State.s_57)
        or a
        ret NZ
        ld ix, #BF18
        ld a, #37
        call c_f74a.l_1
        ld ix, #BF4A
        ld a, #38
        call c_f74a.l_1
        ld ix, #BF18
        ld iy, #BF4A
        ld (ix+2), #60
        ld l, (ix+0)
        ld h, (ix+1)
        ld (iy+0), l
        ld (iy+1), h
        ld a, #13
        add (ix+2)
        ld (iy+2), a
        ld a, #02
        ld (State.s_54), a
        xor a
        ld (State.s_56), a
        ld a, #3C
        ld (State.s_51), a
        ret
.l_0:
        ld ix, #BF18
        ld l, (ix+0)
        ld h, (ix+1)
        bit 1, (ix+21)
        jr NZ, .l_2
        ld de, #0108
        xor a
        sbc hl, de
        ret C
.l_1:
        ld c, #03
        jp c_fbb9
.l_2:
        ld de, #0020
        xor a
        sbc hl, de
        jr C, .l_1
        ret

; Bermuda boss logic
; Used by c_f8cb.
c_fb45:  ; #fb45
        ld a, (State.s_54)
        cp #01
        jr NZ, .l_0
        ld a, (State.s_57)
        or a
        ret NZ
        ld ix, #BF18
        ld a, #38
        call c_f74a.l_1
        ld ix, #BF4A
        ld a, #39
        call c_f74a.l_1
        ld ix, #BF18
        ld iy, #BF4A
        ld l, (ix+0)
        ld h, (ix+1)
        ld (iy+0), l
        ld (iy+1), h
        ld (ix+2), #92
        ld (iy+2), #A7
        ld a, #02
        ld (State.s_54), a
        xor a
        ld (State.s_56), a
        ld a, #C8
        ld (State.s_51), a
        ret
.l_0:
        ld ix, #BF18
        ld iy, #BF4A
        ld a, (State.s_59)
        inc a
        and #07
        ld (State.s_59), a
        cp #04
        jr Z, .l_1
        cp #05
        jr NZ, .l_2
.l_1:
        set 6, (ix+5)
        set 6, (iy+5)
        ret
.l_2:
        res 6, (ix+5)
        res 6, (iy+5)
        ret

; (Some boss logic?)
; Used by c_f9a4 and c_fad3.
c_fbb9:  ; #fbb9
        push ix
        ld b, #04
        ld ix, #BF18
        ld de, #0032
.l_0:
        ld a, (ix+21)
        xor c
        ld (ix+21), a
        add ix, de
        djnz .l_0
        pop ix
        ret

; (Some boss logic?)
; Used by c_f9a4.
c_fbd2:  ; #fbd2
        push ix
        ld ix, #BF18
        ld iy, #BF4A
        call c_fbf9
        ld a, (ix+49)
        ld c, (iy+49)
        ld (ix+49), c
        ld (iy+49), a
        ld ix, #BF7C
        ld iy, #BFAE
        call c_fbf9
        pop ix
        ret

; (Some boss logic?)
; Used by c_fbd2.
c_fbf9:  ; #fbf9
        ld l, (ix+3)
        ld h, (ix+4)
        ld e, (iy+3)
        ld d, (iy+4)
        ld (ix+3), e
        ld (ix+4), d
        ld (iy+3), l
        ld (iy+4), h
        ret

; Code ends: #FC12


    ENDMODULE
