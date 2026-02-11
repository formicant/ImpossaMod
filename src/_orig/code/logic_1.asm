    MODULE Code


; (Some call table)
c_d6e7:  ; #d6e7
        dw c_d7f6_t0
        dw c_d94c_t1
        dw c_da95_t2
        dw c_db4e_t3
        dw c_dbfc_t4

; Data block at D6F1
c_d6f1:  ; #d6f1
        db -8, -8, -8, -7, -7, -7, -7, -6, -3, -2, -1, 0, 0, 0, 1, 1, 2, 2, 4, 7, 7, 8, 8
        db #7F

; (Some game logic, calls from call table #D6E7?)
; Used by c_cc25.
c_d709:  ; #d709
        ld ix, scene.hero
        call collectStateTiles

        ld a, (State.s_28)
        add a
        ld l, a
        ld h, 0
        ld de, c_d6e7
        add hl, de

        ld e, (hl)
        inc hl
        ld d, (hl)
        ld (.call), de
.call+* call -0

        ld a, (State.s_28)
        cp 2
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
        ld a, (State.tileLfFoot)
        call getTileType
        cp TileType.conveyorL
        jp Z, .l_6
        cp TileType.conveyorR
        jp Z, .l_7
        ld a, (State.tileRgFoot)
        call getTileType
        cp TileType.conveyorL
        jp Z, .l_6
        cp TileType.conveyorR
        jp Z, .l_7
        ld a, (State.tileLfFoot)
        call getTileType
        cp TileType.waterSpikes
        jr Z, .l_1
        ld a, (State.tileRgFoot)
        call getTileType
        cp TileType.waterSpikes
        jr NZ, .l_4
.l_1:
        call decEnergy
        ld a, #02
        ld (State.s_28), a
        ld a, (controlState)
        and (1<<Key.left) | (1<<Key.right)
        jp Z, .l_2
        ld b, a
        ld a, (ix+Obj.direction)
        and ~Dir.horizontal
        or b
        ld (ix+Obj.direction), a
        ld (ix+Obj.horizSpeed), 2
.l_2:
        ld a, 3
        ld (State.s_27), a
        xor a
        ld (State.s_41), a
        ld hl, cS.heroJumps
        ld a, (State.weapon)
        cp 2
        jr C, .l_3
        ld hl, cS.armedHeroJumps
.l_3:
        ld (ix+Obj.sprite+0), l
        ld (ix+Obj.sprite+1), h
.l_4:
        xor a
        ld (State.s_05), a
        ld de, (State.screenX)
        ld hl, (State.mapSpanEnd)
        xor a
        sbc hl, de
        jr Z, .l_5
        jr C, .l_5
        ld l, (ix+Obj.x+0)
        ld h, (ix+Obj.x+1)
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
        ld a, (ix+Obj.x)
        add #FF
        ld (ix+Obj.x), a
        jp .l_4
.l_7:
        call c_deb1
        jr NZ, .l_4
        ld a, (ix+Obj.x)
        add #01
        ld (ix+Obj.x), a
        jp .l_4


; (Some game logic from call table #D6E7?)
c_d7f6_t0:  ; #d7f6
        ld a, (controlState)
        bit Key.up, a
        jr Z, .notUp

        ld a, (State.tileCentre)
        call getTileType

        cp TileType.ladder
        jp Z, .l_12
        cp TileType.ladderTop
        jp Z, .l_12
        jp .l_9

.notUp:
        bit Key.down, a
        jr Z, .l_1
        ld a, (State.tileCnFoot)
        call getTileType
        cp TileType.ladderTop
        jp Z, .l_12
.l_1:
        ld a, (controlState)
        bit Key.left, a
        jp NZ, .l_7
        bit Key.right, a
        jp NZ, .l_8
        bit Flag.fo_0, (ix+Obj.o_24)
        ret NZ
        ld a, (State.tileLfFoot)
        call getTileType
        cp TileType.ladderTop
        jr NC, .l_2
        ld a, (State.tileRgFoot)
        call getTileType
        cp TileType.ladderTop
        jp C, c_d94c_t1.l_13
.l_2:
        ld a, (State.tileLfFoot)
        call getTileType
        cp TileType.ice
        jr Z, .l_3
        ld a, (State.tileRgFoot)
        call getTileType
        cp TileType.ice
        jr Z, .l_3
        ld a, (State.tileLfFoot)
        call getTileType
        cp TileType.conveyorL
        ret NC
        ld a, (State.tileRgFoot)
        call getTileType
        cp TileType.conveyorL
        jp C, c_d94c_t1.l_11
        ret
.l_3:
        bit Dir.right, (ix+Obj.direction)
        jr NZ, .l_4
        call c_de37
        jp NZ, c_d94c_t1.l_11
        ld a, (ix+Obj.x)
        add #FE
        ld (ix+Obj.x), a
        jp .l_5
.l_4:
        call c_deb1
        jp NZ, c_d94c_t1.l_11
        ld a, (ix+Obj.x)
        add #02
        ld (ix+Obj.x), a
.l_5:
        ld hl, cS.heroWalks1
        ld a, (State.weapon)
        cp 2
        jr C, .l_6
        ld hl, cS.armedHeroWalks1
.l_6:
        ld (ix+Obj.sprite+0), l
        ld (ix+Obj.sprite+1), h
        ret
.l_7:
        ld a, #01
        ld (State.s_28), a
        ld a, #02
        ld (State.s_41), a
        xor a
        ld (State.s_42), a
        ld (ix+Obj.o_6), a
        set Dir.left, (ix+Obj.direction)
        res Dir.right, (ix+Obj.direction)
        ret
.l_8:
        ld a, #01
        ld (State.s_28), a
        ld a, #02
        ld (State.s_41), a
        xor a
        ld (State.s_42), a
        ld (ix+Obj.o_6), a
        set Dir.right, (ix+Obj.direction)
        res Dir.left, (ix+Obj.direction)
        ret
.l_9:
        ld a, (State.pressTime)
        or a
        ret NZ
        res Flag.fo_0, (ix+Obj.o_24)
        ld a, #02
        ld (State.s_28), a
        ld a, (controlState)
        and (1<<Key.left) | (1<<Key.right)
        jp Z, .l_10
        ld b, a
        ld a, (ix+Obj.direction)
        and ~Dir.horizontal
        or b
        ld (ix+Obj.direction), a
        ld (ix+Obj.horizSpeed), #02
.l_10:
        ld a, 3
        ld (State.s_27), a
        xor a
        ld (State.s_41), a
        ld hl, cS.heroJumps
        ld a, (State.weapon)
        cp 2
        jr C, .l_11
        ld hl, cS.armedHeroJumps
.l_11:
        ld (ix+Obj.sprite+0), l
        ld (ix+Obj.sprite+1), h
        ld a, 5
        call playSound
        jp c_da95_t2
; This entry point is used by c_d94c, c_da95 and c_db4e.
.l_12:
        ld a, (State.pressTime)
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
        ld (ix+Obj.sprite+0), l
        ld (ix+Obj.sprite+1), h
        xor a
        ld (State.s_41), a
        jp c_dbfc_t4


; (Some game logic from call table #D6E7?)
c_d94c_t1:  ; #d94c
        bit Flag.fo_0, (ix+Obj.o_24)
        jr NZ, .l_0
        ld a, (State.tileLfFoot)
        call getTileType
        cp TileType.ladderTop
        jr NC, .l_0
        ld a, (State.tileRgFoot)
        call getTileType
        cp TileType.ladderTop
        jp C, .l_13
.l_0:
        ld a, (controlState)
        bit Key.up, a
        jp NZ, .l_11
        bit Key.down, a
        jr Z, .l_1
        ld a, (State.tileCnFoot)
        call getTileType
        cp TileType.ladderTop
        jp Z, c_d7f6_t0.l_12
.l_1:
        bit Dir.right, (ix+Obj.direction)
        jp NZ, .l_5
        call c_de37
        or a
        jp NZ, .l_11
        ld a, (State.tileLfFoot)
        call getTileType
        cp TileType.slow
        jr Z, .l_2
        ld a, (State.tileRgFoot)
        call getTileType
        cp TileType.slow
        jr NZ, .l_3
.l_2:
        ld a, (ix+Obj.x)
        add #FF
        ld (ix+Obj.x), a
        ld a, #04
        ld (State.s_41), a
        jr .l_4
.l_3:
        ld a, (ix+Obj.x)
        add #FE
        ld (ix+Obj.x), a
        ld a, #02
        ld (State.s_41), a
        ld a, (State.s_42)
        and #01
        ld (State.s_42), a
.l_4:
        ld a, (controlState)
        bit Key.left, a
        jp Z, .l_11
        jr .l_9
.l_5:
        call c_deb1
        or a
        jp NZ, .l_11
        ld a, (State.tileLfFoot)
        call getTileType
        cp TileType.slow
        jr Z, .l_6
        ld a, (State.tileRgFoot)
        call getTileType
        cp TileType.slow
        jr NZ, .l_7
.l_6:
        ld a, (ix+Obj.x)
        add #01
        ld (ix+Obj.x), a
        ld a, #04
        ld (State.s_41), a
        jr .l_8
.l_7:
        ld a, (ix+Obj.x)
        add #02
        ld (ix+Obj.x), a
        ld a, #02
        ld (State.s_41), a
        ld a, (State.s_42)
        and #01
        ld (State.s_42), a
.l_8:
        ld a, (controlState)
        bit Key.right, a
        jp Z, .l_11
.l_9:
        ld a, (State.tileLfFoot)
        call getTileType
        cp TileType.ice
        jr Z, .l_10
        ld a, (State.tileRgFoot)
        call getTileType
        cp TileType.ice
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
        ld a, (ix+Obj.y)
        and #F8
        or #03
        ld (ix+Obj.y), a
        ld (ix+Obj.horizSpeed), #00
        ld hl, cS.heroStands
        ld a, (State.weapon)
        cp 2
        jr C, .l_12
        ld hl, cS.armedHeroStands
.l_12:
        ld (ix+Obj.sprite+0), l
        ld (ix+Obj.sprite+1), h
        ret
; This entry point is used by c_d7f6, c_da95, c_dbfc and c_e6e1.
.l_13:
        xor a
        ld (State.pressTime), a
        ld a, #03
        ld (State.s_28), a
        xor a
        ld (State.s_41), a
        ld a, (controlState)
        and (1<<Key.left) | (1<<Key.right)
        jp Z, .l_14
        ld b, a
        ld a, (ix+Obj.direction)
        and ~Dir.horizontal
        or b
        ld (ix+Obj.direction), a
        ld a, #02
        ld (ix+Obj.horizSpeed), a
.l_14:
        ld hl, cS.heroFalls
        ld a, (State.weapon)
        cp 2
        jr C, .l_15
        ld hl, cS.armedHeroFalls
.l_15:
        ld (ix+Obj.sprite+0), l
        ld (ix+Obj.sprite+1), h
        jp c_db4e_t3


; (Some game logic from call table #D6E7?)
; Used by c_d7f6.
c_da95_t2:  ; #da95
        ld hl, cS.heroJumps
        ld a, (State.weapon)
        cp 2
        jr C, .l_0
        ld hl, cS.armedHeroJumps
.l_0:
        ld (ix+Obj.sprite+0), l
        ld (ix+Obj.sprite+1), h
        ld a, (controlState)
        bit Key.up, a
        jr Z, .l_1
        ld a, (State.tileCentre)
        call getTileType
        cp TileType.ladder
        jp Z, c_d7f6_t0.l_12
        cp TileType.ladderTop
        jp Z, c_d7f6_t0.l_12
.l_1:
        ld a, (ix+Obj.horizSpeed)
        or a
        jr Z, .l_3
        bit Dir.right, (ix+Obj.direction)
        jr NZ, .l_2
        call c_de37
        or a
        jr NZ, .l_3
        ld a, (ix+Obj.horizSpeed)
        neg
        add (ix+Obj.x)
        ld (ix+Obj.x), a
        jr .l_3
.l_2:
        call c_deb1
        or a
        jr NZ, .l_3
        ld a, (ix+Obj.horizSpeed)
        add (ix+Obj.x)
        ld (ix+Obj.x), a
.l_3:
        ld a, (State.s_27)
        ld e, a
        ld d, 0
        ld hl, c_d6f1
        add hl, de
        ld a, (hl)
        ld (State.s_37), a
        cp #7F
        jp Z, c_d94c_t1.l_13
        add (ix+Obj.y)
        ld (ix+Obj.y), a
        ld a, (hl)
        ld hl, State.s_27
        inc (hl)
        or a
        jp P, .l_4
        exa
        call collectTilesAbove
        ld a, (State.tileLfAbov)
        call getTileType
        cp TileType.wall
        jr NC, .l_5
        ld a, (State.tileRgAbov)
        call getTileType
        cp TileType.wall
        jr NC, .l_5
        ret
.l_4:
        call collectTwoTilesBelow
        ld a, (State.tileLfFoot)
        call getTileType
        cp TileType.ladderTop
        jp NC, c_d94c_t1.l_11
        ld a, (State.tileRgFoot)
        call getTileType
        cp TileType.ladderTop
        jp NC, c_d94c_t1.l_11
        ret
.l_5:
        exa
        neg
        add (ix+Obj.y)
        and #F8
        ld (ix+Obj.y), a
        ret


; (Some game logic from call table #D6E7?)
; Used by c_d94c.
c_db4e_t3:  ; #db4e
        ld a, (controlState)
        bit Key.up, a
        jr Z, .l_0
        ld a, (State.tileCentre)
        call getTileType
        cp TileType.ladder
        jp Z, c_d7f6_t0.l_12
        cp TileType.ladderTop
        jp Z, c_d7f6_t0.l_12
.l_0:
        ld l, (ix+Obj.x+0)
        ld h, (ix+Obj.x+1)
        push hl
        ld a, (ix+Obj.horizSpeed)
        or a
        jr Z, .l_2
        bit Dir.right, (ix+Obj.direction)
        jr NZ, .l_1
        call c_de37
        or a
        jr NZ, .l_2
        ld a, (ix+Obj.horizSpeed)
        neg
        add (ix+Obj.x)
        ld (ix+Obj.x), a
        jr .l_2
.l_1:
        call c_deb1
        or a
        jr NZ, .l_2
        ld a, (ix+Obj.horizSpeed)
        add (ix+Obj.x)
        ld (ix+Obj.x), a
.l_2:
        exx
        ld l, (ix+Obj.x+0)
        ld h, (ix+Obj.x+1)
        exx
        pop hl
        ld (ix+Obj.x+0), l
        ld (ix+Obj.x+1), h
        ld a, (ix+Obj.y)
        add #04
        ld (ix+Obj.y), a
        call collectTwoTilesBelow
        exx
        ld (ix+Obj.x+0), l
        ld (ix+Obj.x+1), h
        exx
        ld a, (State.tileLfFoot)
        call getTileType
        cp TileType.ladderTop
        jp NC, c_d94c_t1.l_11
        ld a, (State.tileRgFoot)
        call getTileType
        cp TileType.ladderTop
        jp NC, c_d94c_t1.l_11
        ld a, (controlState)
        bit Key.left, a
        jr NZ, .l_3
        bit Key.right, a
        jr NZ, .l_4
        ld (ix+Obj.horizSpeed), #00
        ret
.l_3:
        ld (ix+Obj.horizSpeed), #02
        set Dir.left, (ix+Obj.direction)
        res Dir.right, (ix+Obj.direction)
        ret
.l_4:
        ld (ix+Obj.horizSpeed), #02
        set Dir.right, (ix+Obj.direction)
        res Dir.left, (ix+Obj.direction)
        ret


; (Some game logic from call table #D6E7?)
; Used by c_d7f6.
c_dbfc_t4:  ; #dbfc
        ld a, (controlState)
        bit Key.up, a
        jr Z, .l_1
        ld a, (State.tileCentre)
        call getTileType
        or a
        jr NZ, .l_0
        ld a, (State.tileCnFoot)
        call getTileType
        or a
        jp Z, c_d94c_t1.l_13
.l_0:
        call collectTilesAbove
        ld a, (State.tileLfAbov)
        call getTileType
        cp TileType.wall
        jr NC, .l_1
        ld a, (State.tileRgAbov)
        call getTileType
        cp TileType.wall
        jr NC, .l_1
        call c_dcce
        ld a, (ix+Obj.y)
        add #FE
        ld (ix+Obj.y), a
.l_1:
        ld a, (controlState)
        bit Key.down, a
        jr Z, .l_3
        ld a, (State.tileCentre)
        call getTileType
        or a
        jr NZ, .l_2
        ld a, (State.tileCnFoot)
        call getTileType
        or a
        jp Z, c_d94c_t1.l_13
.l_2:
        call c_dcce
        ld a, (ix+Obj.y)
        add #02
        ld (ix+Obj.y), a
.l_3:
        ld a, (ix+Obj.y)
        or #01
        ld (ix+Obj.y), a
        and #07
        cp #03
        jr NZ, .l_4
        call collectCentreTileBelow
        ld a, (State.tileCnFoot)
        call getTileType
        cp TileType.ladderTop
        jp NC, c_d94c_t1.l_11
.l_4:
        ld a, (controlState)
        bit Key.left, a
        jr Z, .l_6
        ld a, (State.tileCentre)
        call getTileType
        or a
        jr NZ, .l_5
        ld a, (State.tileCnFoot)
        call getTileType
        or a
        jp Z, c_d94c_t1.l_13
.l_5:
        call c_de37
        jr NZ, .l_6
        call c_dcce
        ld a, (ix+Obj.x)
        add #FE
        ld (ix+Obj.x), a
.l_6:
        ld a, (controlState)
        bit Key.right, a
        jr Z, .l_8
        ld a, (State.tileCentre)
        call getTileType
        or a
        jr NZ, .l_7
        ld a, (State.tileCnFoot)
        call getTileType
        or a
        jp Z, c_d94c_t1.l_13
.l_7:
        call c_deb1
        jr NZ, .l_8
        call c_dcce
        ld a, (ix+Obj.x)
        add #02
        ld (ix+Obj.x), a
.l_8:
        ret


; ?
; Used by c_dbfc.
c_dcce:  ; #dcce
        ld a, (State.s_42)
        inc a
        and %11
        ld (State.s_42), a
        ret NZ

        ld a, (ix+Obj.direction)
        xor Dir.horizontal      ; left <-> right
        ld (ix+Obj.direction), a
        ret


; Get one central tile below the object and store it in the state
; Used by c_dbfc.
collectCentreTileBelow:  ; #dce1
        ld a, (ix+Obj.x)
        add 12
        ld (ix+Obj.x), a
        ld a, (ix+Obj.y)
        add 21
        ld (ix+Obj.y), a

        call getScrTileAddr
        ld a, (hl)
        ld (State.tileCnFoot), a

        ld a, (ix+Obj.x)
        add -12
        ld (ix+Obj.x), a
        ld a, (ix+Obj.y)
        add -21
        ld (ix+Obj.y), a
        ret

; Get two tiles below the object and store them in the state
; Used by c_da95 and c_db4e.
collectTwoTilesBelow:  ; #dd09
        ld a, (ix+Obj.x)
        add 6
        ld (ix+Obj.x), a
        ld a, (ix+Obj.x+1)
        adc a, 0
        ld (ix+Obj.x+1), a
        ld a, (ix+Obj.y)
        add 24
        ld (ix+Obj.y), a

        call getScrTileAddr
        ld a, (hl)
        ld (State.tileLfFoot), a
        inc hl
        ld a, (hl)
        ld (State.tileRgFoot), a

        ld a, (ix+Obj.x)
        add -6
        ld (ix+Obj.x), a
        ld a, (ix+Obj.x+1)
        adc a, -1
        ld (ix+Obj.x+1), a
        ld a, (ix+Obj.y)
        add -24
        ld (ix+Obj.y), a
        ret

; Get tiles above the object and store them in the state
;   arg `ix`: object
; Used by c_da95 and c_dbfc.
collectTilesAbove:  ; #dd46
        ld a, (ix+Obj.x)
        add 6
        ld (ix+Obj.x), a
        ld a, (ix+Obj.y)
        add -1
        ld (ix+Obj.y), a

        call getScrTileAddr
        ld a, (hl)
        ld (State.tileLfAbov), a
        inc hl
        ld a, (hl)
        ld (State.tileRgAbov), a

        ld a, (ix+Obj.x)
        add -6
        ld (ix+Obj.x), a
        ld a, (ix+Obj.y)
        add 1
        ld (ix+Obj.y), a
        ret

; Get tiles behind different parts of the object and store them in the state
;   arg `ix`: object
; Used by c_d709.
collectStateTiles:  ; #dd73
        ld a, (ix+Obj.x)
        add 4
        ld (ix+Obj.x), a
        ld a, (ix+Obj.x+1)
        adc a, 0
        ld (ix+Obj.x+1), a

        call getScrTileAddr
        ld bc, 44
        ld a, (hl)
        ld (State.tileLfTop), a
        add hl, bc              ; move down
        ld a, (hl)
        ld (State.tileLfMid), a
        add hl, bc              ; move down
        ld a, (hl)
        ld (State.tileLfBot), a
        add hl, bc              ; move down
        ld a, (hl)
        ld (State.tileLfUndr), a

        ld a, (ix+Obj.x)
        add 12
        ld (ix+Obj.x), a
        ld a, (ix+Obj.x+1)
        adc a, 0
        ld (ix+Obj.x+1), a

        call getScrTileAddr
        ld bc, 44
        ld a, (hl)
        ld (State.tileRgTop), a
        add hl, bc              ; move down
        ld a, (hl)
        ld (State.tileRgMid), a
        add hl, bc              ; move down
        ld a, (hl)
        ld (State.tileRgBot), a
        add hl, bc              ; move down
        ld a, (hl)
        ld (State.tileRgUndr), a

        ld a, (ix+Obj.x)
        add -10
        ld (ix+Obj.x), a
        ld a, (ix+Obj.x+1)
        adc a, -1
        ld (ix+Obj.x+1), a

        ld a, (ix+Obj.y)
        add 21
        ld (ix+Obj.y), a

        call getScrTileAddr
        ld a, (hl)
        ld (State.tileLfFoot), a
        inc hl                  ; move right
        ld a, (hl)
        ld (State.tileRgFoot), a

        ld a, (ix+Obj.x)
        add 6
        ld (ix+Obj.x), a
        ld a, (ix+Obj.x+1)
        adc a, 0
        ld (ix+Obj.x+1), a

        ld a, (ix+Obj.y)
        add -8
        ld (ix+Obj.y), a

        call getScrTileAddr
        ld a, (hl)
        ld (State.tileCentre), a
        add hl, bc              ; move down
        ld a, (hl)
        ld (State.tileCnFoot), a

        ld a, (ix+Obj.x)
        add -12
        ld (ix+Obj.x), a
        ld a, (ix+Obj.x+1)
        adc a, -1
        ld (ix+Obj.x+1), a

        ld a, (ix+Obj.y)
        add -13
        ld (ix+Obj.y), a

        ld a, (ix+Obj.y)
        and 7
        cp 3
        jr NZ, .l_0

        xor a
        ld (State.tileLfUndr), a
        ld (State.tileRgUndr), a
        ret
.l_0:
        ret


; (Checks something?)
; Used by c_d308, c_d709, c_d7f6, c_d94c, c_da95, c_db4e and c_dbfc.
c_de37:  ; #de37
        ld l, (ix+Obj.x+0)
        ld h, (ix+Obj.x+1)
        ld de, -32
        add hl, de
        jr NC, .l_2

        ld a, (State.s_28)
        cp #04
        jr NZ, .l_0
        ld a, (State.tileLfTop)
        call getTileType
        cp TileType.platform
        jr NC, .l_2
        ld a, (State.tileLfMid)
        call getTileType
        cp TileType.platform
        jr NC, .l_2
        ld a, (State.tileLfBot)
        call getTileType
        cp TileType.platform
        jr NC, .l_2
        ld a, (State.tileLfUndr)
        call getTileType
        cp TileType.platform
        jr NC, .l_2
        jp .l_1
.l_0:
        ld a, (State.tileLfTop)
        call getTileType
        cp TileType.wall
        jr NC, .l_2
        ld a, (State.tileLfMid)
        call getTileType
        cp TileType.wall
        jr NC, .l_2
        ld a, (State.tileLfBot)
        call getTileType
        cp TileType.wall
        jr NC, .l_2
        ld a, (State.s_28)
        cp #02
        jr NZ, .l_1
        ld a, (State.s_37)
        or a
        jp M, .l_1
        ld a, (State.tileRgUndr)
        call getTileType
        cp TileType.wall
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
        ld l, (ix+Obj.x+0)
        ld h, (ix+Obj.x+1)
        ld de, -252
        add hl, de
        jr C, .l_2
        ld a, (State.s_28)
        cp #04
        jr NZ, .l_0
        ld a, (State.tileRgTop)
        call getTileType
        cp TileType.platform
        jr NC, .l_2
        ld a, (State.tileRgMid)
        call getTileType
        cp TileType.platform
        jr NC, .l_2
        ld a, (State.tileRgBot)
        call getTileType
        cp TileType.platform
        jr NC, .l_2
        ld a, (State.tileRgUndr)
        call getTileType
        cp TileType.platform
        jr NC, .l_2
        jp .l_1
.l_0:
        ld a, (State.tileRgTop)
        call getTileType
        cp TileType.wall
        jr NC, .l_2
        ld a, (State.tileRgMid)
        call getTileType
        cp TileType.wall
        jr NC, .l_2
        ld a, (State.tileRgBot)
        call getTileType
        cp TileType.wall
        jr NC, .l_2
        ld a, (State.s_28)
        cp #02
        jr NZ, .l_1
        ld a, (State.s_37)
        or a
        jp M, .l_1
        ld a, (State.tileRgUndr)
        call getTileType
        cp TileType.wall
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

laserBulletTable:  ; #df67       w   h
        dw cS.laserBullet1 : db 16,  7, 8
        dw cS.laserBullet2 : db 16, 11, 6
        dw cS.laserBullet3 : db 16, 15, 4
powerBulletTable:  ; #df76
        dw cS.powerBullet1 : db  4,  4, 9
        dw cS.powerBullet2 : db  4, 16, 4
        dw cS.powerBullet3 : db  8,  8, 8


; Decrement weapon time and perform fire if pressed
; Used by c_cc25.
processFire:  ; #df85
        ld a, (State.pressTime)
        or a
        ret NZ
        ld a, (State.inShop)
        or a
        ret NZ

        ; decrement weapon time
        ld a, (State.weapon)
        or a
        jr Z, .skipWeaponTime
        ld hl, (State.weaponTime)
        ld a, h
        or l
        jr NZ, .decWeaponTime
        ; weapon time elapsed
        ld a, (State.s_3D)
        or a
        jr NZ, .skipWeaponTime
        xor a
        ld (State.weapon), a    ; remove weapon
        ret
.decWeaponTime:
        dec hl
        ld (State.weaponTime), hl
.skipWeaponTime:

        ld a, (State.s_3D)
        or a
        jp NZ, .l_9

        ld a, (State.s_28)
        cp 3
        ret NC

        ld a, (controlState)
        bit Key.fire, a                ; fire key
        ret Z

        ; fire pressed
        ld ix, scene.hero
        ld iy, scene.obj1
        ld a, (State.weapon)
        or a
        jp NZ, .useWeapon

        ; no weapon
        ld a, 4                 ; kick/throw sound
        call playSound

        ld hl, cS.heroKicks
        ld (ix+Obj.sprite+0), l
        ld (ix+Obj.sprite+1), h

        ; create kick bubble
        ld (iy+Obj.flags), 1<<Flag.isBig
        ld (iy+Obj.colour), Colour.brWhite
        ld (iy+Obj.direction), 1<<Dir.right
        ld (iy+Obj.horizSpeed), 0
        ld (iy+Obj.o_7), 0

        ; set x coord
        ld l, (ix+Obj.x+0)
        ld h, (ix+Obj.x+1)
        ld de, 16
        bit Dir.right, (ix+Obj.direction)
        jr NZ, .kickRight
.kickLeft:
        ld de, -16
.kickRight:
        add hl, de
        ld (iy+Obj.x+0), l
        ld (iy+Obj.x+1), h
        ; set y coord
        ld a, (ix+Obj.y)
        ld (iy+Obj.y), a

        ld a, (State.soupCans)
        dec a
        add a
        ld l, a
        ld h, 0
        ld de, kickBubbles
        add hl, de
        ld a, (hl)
        ld (iy+Obj.sprite+0), a
        inc hl
        ld a, (hl)
        ld (iy+Obj.sprite+1), a

        ld a, 1
        ld (State.s_3D), a
        ld a, 3
        ld (State.s_3E), a
        jp checkEnemiesForDamage

.useWeapon:
        cp 1
        jp NZ, .gun

.shatterbomb:
        ld a, 4                 ; kick/throw sound
        call playSound

        ld hl, cS.heroThrows
        ld (ix+Obj.sprite+0), l
        ld (ix+Obj.sprite+1), h

        ; create bomb
        ld hl, cS.shatterbomb
        ld (iy+Obj.sprite+0), l
        ld (iy+Obj.sprite+1), h
        ld (iy+Obj.flags), 1<<Flag.exists
        ld (iy+Obj.colour), Colour.brCyan
        ld (iy+Obj.o_7), 0
        ld (iy+Obj.width), 8
        ld (iy+Obj.height), 8

        ; set x coord
        ld l, (ix+Obj.x+0)
        ld h, (ix+Obj.x+1)
        ld de, 8
        bit Dir.right, (ix+Obj.direction)
        jr NZ, .throwRight
.throwLeft:
        ld de, -6
.throwRight:
        add hl, de
        ld (iy+Obj.x+0), l
        ld (iy+Obj.x+1), h
        ; set y coord
        ld a, (ix+Obj.y)
        add -4
        ld (iy+Obj.y), a

        ld (iy+Obj.horizSpeed), 4
        ld a, (ix+Obj.direction)
        and Dir.horizontal
        ld (iy+Obj.direction), a

        xor a
        ld (State.s_3F), a
        ld a, 2
        ld (State.s_3D), a
        ld a, 3
        ld (State.s_3E), a

        jp checkEnemiesForDamage

.gun:
        cp 2                    ; powerGun
        jp NZ, .laserGun

.powerGun:
        ld a, 10                ; powerGun sound
        call playSound

        ld a, (State.soupCans)
        dec a
        ld l, a
    .2  add a
        add l
        ld l, a
        ld h, 0
        ld de, powerBulletTable
        add hl, de

        ; create bullet
        ld c, (hl)              ; bullet sprite (low)
        inc hl
        ld b, (hl)              ; bullet sprite (high)
        ld (iy+Obj.sprite+0), c
        ld (iy+Obj.sprite+1), b

        inc hl
        ld a, (hl)              ; bullet width
        ld (iy+Obj.width), a
        inc hl
        ld a, (hl)              ; bullet height
        ld (iy+Obj.height), a
        inc hl
        ld a, (hl)              ; bullet y offset
        add (ix+Obj.y)
        ld (iy+Obj.y), a

        ; bullet x coord
        ld l, (ix+Obj.x+0)
        ld h, (ix+Obj.x+1)
        ld de, 24
        bit Dir.right, (ix+Obj.direction)
        jr NZ, .powerShootRight
.powerShootLeft
        ld de, -16
.powerShootRight:
        add hl, de
        ld (iy+Obj.x+0), l
        ld (iy+Obj.x+1), h

        ld (iy+Obj.flags), 1<<Flag.exists
        ld (iy+Obj.colour), Colour.brWhite
        ld (iy+Obj.horizSpeed), 8
        ld (iy+Obj.vertSpeed), 8
        ld (iy+Obj.o_7), 0

        ld a, (ix+Obj.direction)
        and Dir.horizontal
        ld (iy+Obj.direction), a

        ld (State.s_38), a
        ld a, 3
        ld (State.s_3D), a
        ld a, 1
        ld (c_e308), a
        ld a, 4
        ld (State.s_39), a

        jp checkEnemiesForDamage

.laserGun:
        ld a, 8                 ; laser gun sound
        call playSound

        ld a, (State.soupCans)
        dec a
        ld l, a
        add a
        add a
        add l
        ld l, a
        ld h, 0
        ld de, laserBulletTable
        add hl, de

        ; create bullet
        ld c, (hl)              ; bullet sprite (low)
        inc hl
        ld b, (hl)              ; bullet sprite (high)
        ld (iy+Obj.sprite+0), c
        ld (iy+Obj.sprite+1), b

        inc hl
        ld a, (hl)              ; bullet width
        ld (iy+Obj.width), a
        inc hl
        ld a, (hl)              ; bullet height
        ld (iy+Obj.height), a
        inc hl
        ld a, (hl)              ; bullet y offset
        add (ix+Obj.y)
        ld (iy+Obj.y), a

        ; bullet x coord
        ld l, (ix+Obj.x+0)
        ld h, (ix+Obj.x+1)
        ld de, 16
        bit Dir.right, (ix+Obj.direction)
        jr NZ, .laserShootRight
.laserShootLeft
        ld de, -6
.laserShootRight:
        add hl, de
        ld (iy+Obj.x+0), l
        ld (iy+Obj.x+1), h

        ld (iy+Obj.o_7), 0
        ld (iy+Obj.flags), 1<<Flag.exists
        ld (iy+Obj.colour), Colour.brCyan
        ld (iy+Obj.horizSpeed), 8

        ld a, (ix+Obj.direction)
        and Dir.horizontal
        ld (iy+Obj.direction), a

        ld (State.s_38), a
        ld a, 4
        ld (State.s_3D), a
        ld a, 4
        ld (State.s_39), a

        jp checkEnemiesForDamage

.l_9:
        ld ix, scene.obj1
        cp 1
        jr NZ, .l_12

        ld ix, scene.hero
        ld hl, State.s_3E
        ld a, (hl)
        or a
        jr Z, .l_10
        dec (hl)
        ld hl, cS.heroKicks
        ld (ix+Obj.sprite+0), l
        ld (ix+Obj.sprite+1), h
        ret
.l_10:
        ld a, (State.s_28)
        or a
        jr NZ, .l_11
        ld hl, cS.heroStands
        ld (ix+Obj.sprite+0), l
        ld (ix+Obj.sprite+1), h
.l_11:
        xor a
        ld (State.s_3D), a
        ld ix, scene.obj1
        ld (ix+Obj.flags), a    ; remove object
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
        ld ix, scene
        ld hl, cS.heroThrows
        ld (ix+Obj.sprite+0), l
        ld (ix+Obj.sprite+1), h
        pop ix
.l_13:
        ld a, (State.s_40)
        or a
        jp NZ, .l_16
        call checkEnemiesForDamage
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
        ld (ix+Obj.vertSpeed), a
.l_14:
        ld a, (ix+Obj.vertSpeed)
        add (ix+Obj.y)
        ld (ix+Obj.y), a
        call isObjectVisible
        jp NC, .l_18
        ld a, (ix+Obj.x)
        add #04
        ld (ix+Obj.x), a
        ld a, (ix+Obj.x+1)
        adc a, #00
        ld (ix+Obj.x+1), a
        call getScrTileAddr
        ld a, (ix+Obj.x)
        add #FC
        ld (ix+Obj.x), a
        ld a, (ix+Obj.x+1)
        adc a, #FF
        ld (ix+Obj.x+1), a
        ld a, (hl)
        call getTileType
        cp TileType.ladderTop
        ret C
.l_15:
        ld a, 6                 ; kill enemy sound
        call playSound
        ld a, (ix+Obj.x)
        add #FC
        ld (ix+Obj.x), a
        ld a, (ix+Obj.x+1)
        adc a, #FF
        ld (ix+Obj.x+1), a
        ld a, (ix+Obj.y)
        add #F8
        ld (ix+Obj.y), a
        xor a
        ld (State.s_40), a
        ld (ix+Obj.direction), a
        set Flag.isBig, (ix+Obj.flags)
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
        ld (ix+Obj.sprite+0), a
        ld (ix+Obj.sprite+1), h
        ld (ix+Obj.colour), Colour.brWhite
        jp checkEnemiesForDamage
.l_18:
        xor a
        ld (ix+Obj.flags), a    ; remove object
        ld (State.s_3D), a
        ld (State.s_40), a
        ld (c_e308), a
        ret
.l_19:
        call isObjectVisible
        jr NC, .l_18
        ld a, (ix+Obj.x)
        add #04
        ld (ix+Obj.x), a
        ld a, (ix+Obj.x+1)
        adc a, #00
        ld (ix+Obj.x+1), a
        ld a, (ix+Obj.y)
        add #08
        ld (ix+Obj.y), a
        call getScrTileAddr
        ld a, (ix+Obj.x)
        add #FC
        ld (ix+Obj.x), a
        ld a, (ix+Obj.x+1)
        adc a, #FF
        ld (ix+Obj.x+1), a
        ld a, (ix+Obj.y)
        add #F8
        ld (ix+Obj.y), a
        ld a, (hl)
        call getTileType
        cp TileType.ladderTop
        jp NC, .l_18
        call checkEnemiesForDamage
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
        ld ix, scene.obj1
        ld iy, scene.obj2
        ld de, Obj
        ld b, #06
.l_1:
        bit Flag.exists, (iy+Obj.flags)
        jr Z, .l_2
        ld a, (iy+Obj.o_7)
        cp #FF
        jr Z, .l_2
        bit Flag.cleanUp, (iy+Obj.flags)
        jr NZ, .l_2
        ld a, (iy+Obj.health)
        cp #FE
        jr Z, .l_2
        cp #FF
        jr Z, .l_2
        ld l, (iy+Obj.x+0)
        ld h, (iy+Obj.x+1)
        ld de, #0020
        xor a
        sbc hl, de
        jr NC, .l_3
.l_2:
        add iy, de
        djnz .l_1
        ld a, (ix+Obj.direction)
        and Dir.horizontal
        ld (ix+Obj.direction), a
        ret
.l_3:
        ld a, (ix+Obj.direction)
        ld l, a
        ld h, 0
        ld de, c_e311
        add hl, de
        ld b, (hl)
        ld (ix+Obj.direction), 0
        ld l, (ix+Obj.x+0)
        ld h, (ix+Obj.x+1)
        ld e, (iy+Obj.x+0)
        ld d, (iy+Obj.x+1)
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
        set Dir.right, (ix+Obj.direction)
        jr .l_5
.l_4:
        set Dir.left, (ix+Obj.direction)
.l_5:
        ld de, #0004
        xor a
        sbc hl, de
        jr NC, .l_6
        ld (ix+Obj.direction), 0
.l_6:
        ld a, (ix+Obj.y)
        sub (iy+Obj.y)
        jp P, .l_7
        neg
        set Dir.down, (ix+Obj.direction)
        jr .l_8
.l_7:
        set Dir.up, (ix+Obj.direction)
.l_8:
        cp #04
        jr NC, .l_9
        res Dir.down, (ix+Obj.direction)
        res Dir.up, (ix+Obj.direction)
.l_9:
        ld a, (ix+Obj.direction)
        ld l, a
        ld h, 0
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
        ld (ix+Obj.direction), a
.l_11:
        ld a, #01
        ld (c_e308), a
        ret


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
        ld a, (State.pressTime)
        or a
        jr Z, .l_1
        dec a
        ld (State.pressTime), a
        ld de, cS.heroSmallWalks
        ld a, (State.s_41)
        or a
        jr Z, .l_0
        inc (ix+Obj.o_6)
        ld a, (ix+Obj.o_6)
        and #02
        jr NZ, .l_0
        ld de, cS.heroSmallStands
.l_0:
        ld (ix+Obj.sprite+0), e
        ld (ix+Obj.sprite+1), d
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
        inc (ix+Obj.o_6)
        ld a, (ix+Obj.o_6)
        cp #06
        jr C, .l_2
        xor a
        ld (ix+Obj.o_6), a
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
        ld (ix+Obj.sprite+0), e
        ld (ix+Obj.sprite+1), d
        ret


    ENDMODULE
