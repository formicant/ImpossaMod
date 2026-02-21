    MODULE Code


; (Some call table)
heroStateRoutines:  ; #d6e7
        dw heroStands
        dw heroWalks
        dw heroJumps
        dw heroFalls
        dw heroClimbs


; Vertical velocity by jump phase
jumpVelocityTable:  ; #d6f1
.up:    db -8, -8, -8, -7, -7, -7, -7, -6, -3, -2, -1
.down:  db  0,  0,  0,  1,  1,  2,  2,  4,  7,  7,  8,  8
.end:   db #7F


; Process hero's behaviour
; Used by c_cc25.
processHero:  ; #d709
        ld ix, scene.hero
        call collectStateTiles

        ld a, (State.heroState)
        add a
        ld l, a
        ld h, 0
        ld de, heroStateRoutines
        add hl, de

        ld e, (hl)
        inc hl
        ld d, (hl)
        ld (.call), de
.call+* call -0

        ld a, (State.heroState)
        cp HeroState.jump
        jp NC, .checkAdvance

        ld a, (State.recoilTime)
        or a
        jr Z, .skipRecoil
        dec a
        ld (State.recoilTime), a

        ld a, (State.recoilDir)
        cp 1<<Dir.right
        jp NZ, .dragRight

        jp .dragLeft

.skipRecoil:
        ; check conveyors
        ld a, (State.tileFootL)
        call getTileType
        cp TileType.conveyorL
        jp Z, .dragLeft
        cp TileType.conveyorR
        jp Z, .dragRight

        ld a, (State.tileFootR)
        call getTileType
        cp TileType.conveyorL
        jp Z, .dragLeft
        cp TileType.conveyorR
        jp Z, .dragRight

        ; check water/spikes
        ld a, (State.tileFootL)
        call getTileType
        cp TileType.waterSpikes
        jr Z, .waterSpikes
        ld a, (State.tileFootR)
        call getTileType
        cp TileType.waterSpikes
        jr NZ, .checkAdvance

.waterSpikes:
        call decEnergy
        ld a, HeroState.jump
        ld (State.heroState), a

        ld a, (controlState)
        and (1<<Key.left) | (1<<Key.right)
        jp Z, .jumpUp

        ; jump sideways
        ld b, a
        ld a, (ix+Obj.mo.direction)
        and ~Dir.horizontal
        or b
        ld (ix+Obj.mo.direction), a
        ld (ix+Obj.mo.horizSpeed), 2

.jumpUp:
        ld a, 3
        ld (State.jumpPhase), a
        xor a
        ld (State.stepPeriod), a

        ; set sprite
        ld hl, cS.heroJumps
        ld a, (State.weapon)
        cp ObjType.powerGun
        jr C, .noGun
        ld hl, cS.armedHeroJumps
.noGun:
        ld (ix+Obj.sprite+0), l
        ld (ix+Obj.sprite+1), h

.checkAdvance:
        xor a
        ld (State.advance), a
        ld de, (State.screenX)
        ld hl, (State.mapSpanEnd)
        xor a
        sbc hl, de
        jr Z, .noAdvance
        jr C, .noAdvance

        ld l, (ix+Obj.x+0)
        ld h, (ix+Obj.x+1)
        ld de, -200
        add hl, de
        jr NC, .noAdvance

        ld a, #FF
        ld (State.advance), a

.noAdvance:
        jp setWalkPhase

.dragLeft:
        call isObstacleToTheLeft
        jr NZ, .checkAdvance

        ld a, (ix+Obj.x)
        add -1                  ; conveyor/recoil speed
        ld (ix+Obj.x), a
        jp .checkAdvance

.dragRight:
        call isObstacleToTheRight
        jr NZ, .checkAdvance

        ld a, (ix+Obj.x)
        add 1                   ; conveyor/recoil speed
        ld (ix+Obj.x), a
        jp .checkAdvance


; (Some game logic from call table #D6E7?)
heroStands:  ; #d7f6
        ld a, (controlState)
        bit Key.up, a
        jr Z, .notUp

.keyUp:
        ld a, (State.tileCentre)
        call getTileType
        cp TileType.ladder
        jp Z, .climb
        cp TileType.ladderTop
        jp Z, .climb

        jp .jump

.notUp:
        bit Key.down, a
        jr Z, .notDown

.keyDown:
        ld a, (State.tileFootC)
        call getTileType
        cp TileType.ladderTop
        jp Z, .climb

.notDown:
        ld a, (controlState)
        bit Key.left, a
        jp NZ, .keyLeft
        bit Key.right, a
        jp NZ, .keyRight

        bit Flag.riding, (ix+Obj.auxFlags)
        ret NZ

        ; check foot tiles
        ld a, (State.tileFootL)
        call getTileType
        cp TileType.ladderTop
        jr NC, .notFalling
        ld a, (State.tileFootR)
        call getTileType
        cp TileType.ladderTop
        jp C, heroWalks.fall

.notFalling:
        ; check for ice
        ld a, (State.tileFootL)
        call getTileType
        cp TileType.ice
        jr Z, .ice
        ld a, (State.tileFootR)
        call getTileType
        cp TileType.ice
        jr Z, .ice

        ld a, (State.tileFootL)
        call getTileType
        cp TileType.conveyorL
        ret NC                  ; ret if conveyor, slow, water/spikes (?)
        ld a, (State.tileFootR)
        call getTileType
        cp TileType.conveyorL
        jp C, heroWalks.stop    ; if space, ladder, platform, wall (?)
        ret                     ; ret if conveyor, slow, water/spikes (?)

.ice:
        bit Dir.right, (ix+Obj.mo.direction)
        jr NZ, .slipRight
.slipLeft:
        call isObstacleToTheLeft
        jp NZ, heroWalks.stop
        ld a, (ix+Obj.x)
        add -2                  ; slip speed
        ld (ix+Obj.x), a
        jp .slip
.slipRight:
        call isObstacleToTheRight
        jp NZ, heroWalks.stop
        ld a, (ix+Obj.x)
        add 2                   ; slip speed
        ld (ix+Obj.x), a
.slip:
        ; set slipping sprite
        ld hl, cS.heroWalks1
        ld a, (State.weapon)
        cp ObjType.powerGun
        jr C, .slipNoGun
        ld hl, cS.armedHeroWalks1
.slipNoGun:
        ld (ix+Obj.sprite+0), l
        ld (ix+Obj.sprite+1), h
        ret

.keyLeft:
        ld a, HeroState.walk
        ld (State.heroState), a
        ld a, 2
        ld (State.stepPeriod), a
        xor a
        ld (State.stepTime), a
        ld (ix+Obj.walkPhase), a
        set Dir.left, (ix+Obj.mo.direction)
        res Dir.right, (ix+Obj.mo.direction)
        ret

.keyRight:
        ld a, HeroState.walk
        ld (State.heroState), a
        ld a, 2
        ld (State.stepPeriod), a
        xor a
        ld (State.stepTime), a
        ld (ix+Obj.walkPhase), a
        set Dir.right, (ix+Obj.mo.direction)
        res Dir.left, (ix+Obj.mo.direction)
        ret

.jump:
        ld a, (State.pressTime)
        or a
        ret NZ

        res Flag.riding, (ix+Obj.auxFlags)

        ld a, HeroState.jump
        ld (State.heroState), a

        ld a, (controlState)
        and (1<<Key.left) | (1<<Key.right)
        jp Z, .jumpUp

        ld b, a
        ld a, (ix+Obj.mo.direction)
        and ~Dir.horizontal
        or b
        ld (ix+Obj.mo.direction), a
        ld (ix+Obj.mo.horizSpeed), 2

.jumpUp:
        ld a, 3
        ld (State.jumpPhase), a
        xor a
        ld (State.stepPeriod), a

        ; set jumping sprite
        ld hl, cS.heroJumps
        ld a, (State.weapon)
        cp ObjType.powerGun
        jr C, .jumpNoGun
        ld hl, cS.armedHeroJumps
.jumpNoGun:
        ld (ix+Obj.sprite+0), l
        ld (ix+Obj.sprite+1), h

        ld a, Sound.jump
        call playSound
        jp heroJumps

; This entry point is used by c_d94c, c_da95 and c_db4e.
.climb:
        ld a, (State.pressTime)
        or a
        ret NZ

        ld a, HeroState.climb
        ld (State.heroState), a
        xor a
        ld (State.attackTime), a

        ; set climbing sprite
        ld hl, cS.heroClimbs
        ld a, (State.weapon)
        cp ObjType.powerGun
        jr C, .climbNoGun
        ld hl, cS.armedHeroClimbs
.climbNoGun:
        ld (ix+Obj.sprite+0), l
        ld (ix+Obj.sprite+1), h

        xor a
        ld (State.stepPeriod), a
        jp heroClimbs


; (Some game logic from call table #D6E7?)
heroWalks:  ; #d94c
        bit Flag.riding, (ix+Obj.auxFlags)
        jr NZ, .notFalling

        ; check tiles below
        ld a, (State.tileFootL)
        call getTileType
        cp TileType.ladderTop
        jr NC, .notFalling
        ld a, (State.tileFootR)
        call getTileType
        cp TileType.ladderTop
        jp C, .fall

.notFalling:
        ld a, (controlState)
        bit Key.up, a
        jp NZ, .stop
        bit Key.down, a
        jr Z, .notDown

.keyDown:
        ld a, (State.tileFootC)
        call getTileType
        cp TileType.ladderTop
        jp Z, heroStands.climb

.notDown:
        bit Dir.right, (ix+Obj.mo.direction)
        jp NZ, .right

.left:
        call isObstacleToTheLeft
        or a
        jp NZ, .stop

        ld a, (State.tileFootL)
        call getTileType
        cp TileType.slow
        jr Z, .slowLeft
        ld a, (State.tileFootR)
        call getTileType
        cp TileType.slow
        jr NZ, .walkLeft

.slowLeft:
        ld a, (ix+Obj.x)
        add -1                  ; slow walking speed
        ld (ix+Obj.x), a
        ld a, 4
        ld (State.stepPeriod), a
        jr .checkWalkingLeft

.walkLeft:
        ld a, (ix+Obj.x)
        add -2                  ; walking speed
        ld (ix+Obj.x), a
        ld a, 2
        ld (State.stepPeriod), a
        ld a, (State.stepTime)
        and 1
        ld (State.stepTime), a

.checkWalkingLeft:
        ld a, (controlState)
        bit Key.left, a
        jp Z, .stop
        jr .checkIce

.right:
        call isObstacleToTheRight
        or a
        jp NZ, .stop

        ld a, (State.tileFootL)
        call getTileType
        cp TileType.slow
        jr Z, .slowRight
        ld a, (State.tileFootR)
        call getTileType
        cp TileType.slow
        jr NZ, .walkRight

.slowRight:
        ld a, (ix+Obj.x)
        add 1                   ; slow walking speed
        ld (ix+Obj.x), a
        ld a, 4
        ld (State.stepPeriod), a
        jr .checkWalkingRight

.walkRight:
        ld a, (ix+Obj.x)
        add 2                   ; walking speed
        ld (ix+Obj.x), a
        ld a, 2
        ld (State.stepPeriod), a
        ld a, (State.stepTime)
        and 1
        ld (State.stepTime), a

.checkWalkingRight:
        ld a, (controlState)
        bit Key.right, a
        jp Z, .stop

.checkIce:
        ld a, (State.tileFootL)
        call getTileType
        cp TileType.ice
        jr Z, .ice
        ld a, (State.tileFootR)
        call getTileType
        cp TileType.ice
        ret NZ

.ice:
        ld a, 1
        ld (State.stepPeriod), a
        xor a
        ld (State.stepTime), a
        ret

; This entry point is used by c_d7f6, c_da95, c_db4e and c_dbfc.
.stop:
        xor a
        ld (State.heroState), a
        ld (State.stepPeriod), a

        ld a, (ix+Obj.y)
        and #F8
        or #03
        ld (ix+Obj.y), a

        ld (ix+Obj.mo.horizSpeed), 0

        ; set standing sprite
        ld hl, cS.heroStands
        ld a, (State.weapon)
        cp ObjType.powerGun
        jr C, .standNoGun
        ld hl, cS.armedHeroStands
.standNoGun:
        ld (ix+Obj.sprite+0), l
        ld (ix+Obj.sprite+1), h
        ret

; This entry point is used by c_d7f6, c_da95, c_dbfc and c_e6e1.
.fall:
        xor a
        ld (State.pressTime), a
        ld a, HeroState.fall
        ld (State.heroState), a
        xor a
        ld (State.stepPeriod), a

        ld a, (controlState)
        and (1<<Key.left) | (1<<Key.right)
        jp Z, .fallDown

        ld b, a
        ld a, (ix+Obj.mo.direction)
        and ~Dir.horizontal
        or b
        ld (ix+Obj.mo.direction), a
        ld a, 2
        ld (ix+Obj.mo.horizSpeed), a

.fallDown:
        ; set falling sprite
        ld hl, cS.heroFalls
        ld a, (State.weapon)
        cp ObjType.powerGun
        jr C, .fallNoGun
        ld hl, cS.armedHeroFalls
.fallNoGun:
        ld (ix+Obj.sprite+0), l
        ld (ix+Obj.sprite+1), h
        jp heroFalls


; (Some game logic from call table #D6E7?)
; Used by c_d7f6.
heroJumps:  ; #da95
        ; set sprite
        ld hl, cS.heroJumps
        ld a, (State.weapon)
        cp ObjType.powerGun
        jr C, .nGun
        ld hl, cS.armedHeroJumps
.nGun:
        ld (ix+Obj.sprite+0), l
        ld (ix+Obj.sprite+1), h

        ld a, (controlState)
        bit Key.up, a
        jr Z, .skipGrabLadder

        ; grab ladder if present
        ld a, (State.tileCentre)
        call getTileType
        cp TileType.ladder
        jp Z, heroStands.climb
        cp TileType.ladderTop
        jp Z, heroStands.climb

.skipGrabLadder:
        ld a, (ix+Obj.mo.horizSpeed)
        or a
        jr Z, .vertical

        bit Dir.right, (ix+Obj.mo.direction)
        jr NZ, .right

.left:
        call isObstacleToTheLeft
        or a
        jr NZ, .vertical
        ld a, (ix+Obj.mo.horizSpeed)
        neg
        add (ix+Obj.x)
        ld (ix+Obj.x), a
        jr .vertical

.right:
        call isObstacleToTheRight
        or a
        jr NZ, .vertical
        ld a, (ix+Obj.mo.horizSpeed)
        add (ix+Obj.x)
        ld (ix+Obj.x), a

.vertical:
        ld a, (State.jumpPhase)
        ld e, a
        ld d, 0
        ld hl, jumpVelocityTable
        add hl, de
        ld a, (hl)
        ld (State.jumpVel), a
        cp #7F                  ; end jump
        jp Z, heroWalks.fall

        ; `a`: vertical velocity
        add (ix+Obj.y)
        ld (ix+Obj.y), a

        ld a, (hl)              ; vertical velocity
        ; next phase
        ld hl, State.jumpPhase
        inc (hl)

        or a
        jp P, .down

.up:
        exa
        call collectTilesAbove
        ld a, (State.tileAbovL)
        call getTileType
        cp TileType.wall
        jr NC, .obstacleAbove
        ld a, (State.tileAbovR)
        call getTileType
        cp TileType.wall
        jr NC, .obstacleAbove
        ret

.down:
        call collectTwoTilesBelow
        ld a, (State.tileFootL)
        call getTileType
        cp TileType.ladderTop
        jp NC, heroWalks.stop
        ld a, (State.tileFootR)
        call getTileType
        cp TileType.ladderTop
        jp NC, heroWalks.stop
        ret

.obstacleAbove:
        exa
        neg
        add (ix+Obj.y)
        and -8
        ld (ix+Obj.y), a
        ret


; (Some game logic from call table #D6E7?)
; Used by c_d94c.
heroFalls:  ; #db4e
        ld a, (controlState)
        bit Key.up, a
        jr Z, .skipGrabLadder

        ; grab ladder if present
        ld a, (State.tileCentre)
        call getTileType
        cp TileType.ladder
        jp Z, heroStands.climb
        cp TileType.ladderTop
        jp Z, heroStands.climb

.skipGrabLadder:
        ld l, (ix+Obj.x+0)
        ld h, (ix+Obj.x+1)
        push hl

        ld a, (ix+Obj.mo.horizSpeed)
        or a
        jr Z, .vertical

        bit Dir.right, (ix+Obj.mo.direction)
        jr NZ, .right:

.left:
        call isObstacleToTheLeft
        or a
        jr NZ, .vertical
        ld a, (ix+Obj.mo.horizSpeed)
        neg
        add (ix+Obj.x)
        ld (ix+Obj.x), a
        jr .vertical

.right::
        call isObstacleToTheRight
        or a
        jr NZ, .vertical
        ld a, (ix+Obj.mo.horizSpeed)
        add (ix+Obj.x)
        ld (ix+Obj.x), a

.vertical:
        exx
        ld l, (ix+Obj.x+0)
        ld h, (ix+Obj.x+1)
        exx                     ; `hl'`: old x
        pop hl                  ; `hl`: new x
        ld (ix+Obj.x+0), l
        ld (ix+Obj.x+1), h

        ld a, (ix+Obj.y)
        add 4                   ; fall speed
        ld (ix+Obj.y), a

        call collectTwoTilesBelow

        exx
        ld (ix+Obj.x+0), l
        ld (ix+Obj.x+1), h
        exx

        ; check tiles below
        ld a, (State.tileFootL)
        call getTileType
        cp TileType.ladderTop
        jp NC, heroWalks.stop
        ld a, (State.tileFootR)
        call getTileType
        cp TileType.ladderTop
        jp NC, heroWalks.stop

        ld a, (controlState)
        bit Key.left, a
        jr NZ, .keyLeft
        bit Key.right, a
        jr NZ, .keyRight

        ld (ix+Obj.mo.horizSpeed), 0
        ret

.keyLeft:
        ld (ix+Obj.mo.horizSpeed), 2
        set Dir.left, (ix+Obj.mo.direction)
        res Dir.right, (ix+Obj.mo.direction)
        ret

.keyRight:
        ld (ix+Obj.mo.horizSpeed), 2
        set Dir.right, (ix+Obj.mo.direction)
        res Dir.left, (ix+Obj.mo.direction)
        ret


; (Some game logic from call table #D6E7?)
; Used by c_d7f6.
heroClimbs:  ; #dbfc
        ld a, (controlState)
        bit Key.up, a
        jr Z, .notUp

        ld a, (State.tileCentre)
        call getTileType
        or a
        jr NZ, .checkTilesAbove
        ld a, (State.tileFootC)
        call getTileType
        or a
        jp Z, heroWalks.fall

.checkTilesAbove:
        call collectTilesAbove
        ld a, (State.tileAbovL)
        call getTileType
        cp TileType.wall
        jr NC, .notUp
        ld a, (State.tileAbovR)
        call getTileType
        cp TileType.wall
        jr NC, .notUp

        ; climb up
        call climbStep
        ld a, (ix+Obj.y)
        add -2                  ; climb speed
        ld (ix+Obj.y), a

.notUp:
        ld a, (controlState)
        bit Key.down, a
        jr Z, .notDown

        ld a, (State.tileCentre)
        call getTileType
        or a
        jr NZ, .l_2
        ld a, (State.tileFootC)
        call getTileType
        or a
        jp Z, heroWalks.fall

.l_2:

        ; climb down
        call climbStep
        ld a, (ix+Obj.y)
        add 2                   ; climb speed
        ld (ix+Obj.y), a

.notDown:
        ld a, (ix+Obj.y)
        or 1                    ; ceil to odd
        ld (ix+Obj.y), a

        and 7
        cp 3
        jr NZ, .l_4

        call collectCentreTileBelow
        ld a, (State.tileFootC)
        call getTileType
        cp TileType.ladderTop
        jp NC, heroWalks.stop

.l_4:
        ld a, (controlState)
        bit Key.left, a
        jr Z, .notLeft
        ld a, (State.tileCentre)
        call getTileType
        or a
        jr NZ, .left

        ld a, (State.tileFootC)
        call getTileType
        or a
        jp Z, heroWalks.fall

.left:
        call isObstacleToTheLeft
        jr NZ, .notLeft
        call climbStep
        ld a, (ix+Obj.x)
        add -2
        ld (ix+Obj.x), a

.notLeft:
        ld a, (controlState)
        bit Key.right, a
        jr Z, .notRight

        ld a, (State.tileCentre)
        call getTileType
        or a
        jr NZ, .right

        ld a, (State.tileFootC)
        call getTileType
        or a
        jp Z, heroWalks.fall

.right:
        call isObstacleToTheRight
        jr NZ, .notRight
        call climbStep
        ld a, (ix+Obj.x)
        add 2
        ld (ix+Obj.x), a

.notRight:
        ret


; Alter hero's feet when climbing
; Used by c_dbfc.
climbStep:  ; #dcce
        ld a, (State.stepTime)
        inc a
        and %11
        ld (State.stepTime), a
        ret NZ

        ld a, (ix+Obj.mo.direction)
        xor Dir.horizontal
        ld (ix+Obj.mo.direction), a
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
        ld (State.tileFootC), a

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
        ld (State.tileFootL), a
        inc hl
        ld a, (hl)
        ld (State.tileFootR), a

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
        ld (State.tileAbovL), a
        inc hl
        ld a, (hl)
        ld (State.tileAbovR), a

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
        ld (State.tileTopL), a
        add hl, bc              ; move down
        ld a, (hl)
        ld (State.tileMidL), a
        add hl, bc              ; move down
        ld a, (hl)
        ld (State.tileBotL), a
        add hl, bc              ; move down
        ld a, (hl)
        ld (State.tileUndrL), a

        ld a, (ix+Obj.x)
        add 12
        ld (ix+Obj.x), a
        ld a, (ix+Obj.x+1)
        adc a, 0
        ld (ix+Obj.x+1), a

        call getScrTileAddr
        ld bc, 44
        ld a, (hl)
        ld (State.tileTopR), a
        add hl, bc              ; move down
        ld a, (hl)
        ld (State.tileMidR), a
        add hl, bc              ; move down
        ld a, (hl)
        ld (State.tileBotR), a
        add hl, bc              ; move down
        ld a, (hl)
        ld (State.tileUndrR), a

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
        ld (State.tileFootL), a
        inc hl                  ; move right
        ld a, (hl)
        ld (State.tileFootR), a

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
        ld (State.tileFootC), a

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
        ld (State.tileUndrL), a
        ld (State.tileUndrR), a
        ret
.l_0:
        ret


; Check if tiles to the left are impenetrable
;   arg `ix`: hero
;   ret `a`: #FF and flag NZ if true, `a`: 0 and flag Z if false
; Used by c_d308, c_d709, c_d7f6, c_d94c, c_da95, c_db4e and c_dbfc.
isObstacleToTheLeft:  ; #de37
        ld l, (ix+Obj.x+0)
        ld h, (ix+Obj.x+1)
        ld de, -32
        add hl, de
        jr NC, .true             ; x < 32

        ; x >= 32
        ld a, (State.heroState)
        cp HeroState.climb
        jr NZ, .climbing

        ld a, (State.tileTopL)
        call getTileType
        cp TileType.platform
        jr NC, .true
        ld a, (State.tileMidL)
        call getTileType
        cp TileType.platform
        jr NC, .true
        ld a, (State.tileBotL)
        call getTileType
        cp TileType.platform
        jr NC, .true
        ld a, (State.tileUndrL)
        call getTileType
        cp TileType.platform
        jr NC, .true
        jp .false

.climbing:
        ld a, (State.tileTopL)
        call getTileType
        cp TileType.wall
        jr NC, .true
        ld a, (State.tileMidL)
        call getTileType
        cp TileType.wall
        jr NC, .true
        ld a, (State.tileBotL)
        call getTileType
        cp TileType.wall
        jr NC, .true

        ld a, (State.heroState)
        cp HeroState.jump
        jr NZ, .false
        ld a, (State.jumpVel)
        or a
        jp M, .false            ; moving upwards

        ld a, (State.tileUndrR)
        call getTileType
        cp TileType.wall
        jr NC, .true

.false:
        xor a
        ret
.true:
        ld a, #FF
        or a
        ret


; Check if tiles to the right are impenetrable
;   arg `ix`: hero
;   ret `a`: #FF and flag NZ if true, `a`: 0 and flag Z if false
; Used by c_d308, c_d709, c_d7f6, c_d94c, c_da95, c_db4e and c_dbfc.
isObstacleToTheRight:  ; #deb1
        ld l, (ix+Obj.x+0)
        ld h, (ix+Obj.x+1)
        ld de, -252
        add hl, de
        jr C, .true

        ld a, (State.heroState)
        cp HeroState.climb
        jr NZ, .climbing

        ld a, (State.tileTopR)
        call getTileType
        cp TileType.platform
        jr NC, .true
        ld a, (State.tileMidR)
        call getTileType
        cp TileType.platform
        jr NC, .true
        ld a, (State.tileBotR)
        call getTileType
        cp TileType.platform
        jr NC, .true
        ld a, (State.tileUndrR)
        call getTileType
        cp TileType.platform
        jr NC, .true
        jp .false

.climbing:
        ld a, (State.tileTopR)
        call getTileType
        cp TileType.wall
        jr NC, .true
        ld a, (State.tileMidR)
        call getTileType
        cp TileType.wall
        jr NC, .true
        ld a, (State.tileBotR)
        call getTileType
        cp TileType.wall
        jr NC, .true
        ld a, (State.heroState)
        cp HeroState.jump
        jr NZ, .false
        ld a, (State.jumpVel)
        or a
        jp M, .false            ; moving upwards
        ld a, (State.tileUndrR)
        call getTileType
        cp TileType.wall
        jr NC, .true

.false:
        xor a
        ret
.true:
        ld a, #FF
        or a
        ret


; Signed vertical velocity of a bomb by time
bombVerticalVelocity:  ; #df2b
        db -4, -2, -1, -1, 0, 1, 1, 1, 1, 2, 3
        db 4, 6, 7, 8, 10, 11, 12, 14, 15, 16
        db #80

kickBubbles:  ; #df41
        dw cS.kickBubble1
        dw cS.kickBubble2
        dw cS.kickBubble3

; Explosion phases of a bomb for different number of soup cans
bombExplosionPhases:  ; #df47
        db 0, 1, 0, -1, 0, 0, 0, 0  ; s
        db 0, 1, 2, 1, 0, -1, 0, 0  ; ss
        db 0, 1, 2, 3, 2, 1, 0, -1  ; sss

explosionSprites:  ; #df5f
        dw cS.explosion1
        dw cS.explosion2
        dw cS.explosion3
        dw cS.explosion4

laserBulletTable:  ; #df67       w   h
        dw cS.laserBullet1 : db 16,  7, 8
        dw cS.laserBullet2 : db 16, 11, 6
        dw cS.laserBullet3 : db 16, 15, 4

powerBulletTable:  ; #df76       w   h
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

        ld a, (State.attack)
        or a
        jr NZ, .skipWeaponTime
        xor a
        ld (State.weapon), a    ; remove weapon
        ret

.decWeaponTime:
        dec hl
        ld (State.weaponTime), hl
.skipWeaponTime:

        ld a, (State.attack)
        or a
        jp NZ, .alreadyInAttack

        ld a, (State.heroState)
        cp HeroState.fall
        ret NC                  ; fall or climb

        ld a, (controlState)
        bit Key.fire, a
        ret Z

        ; fire pressed
        ld ix, scene.hero
        ld iy, scene.obj1       ; bullet, bomb, or bubble
        ld a, (State.weapon)
        or a
        jp NZ, .useWeapon

        ; no weapon
        ld a, Sound.kickOrThrow
        call playSound

        ; set kicking sprite
        ld hl, cS.heroKicks
        ld (ix+Obj.sprite+0), l
        ld (ix+Obj.sprite+1), h

        ; create kick bubble
        ld (iy+Obj.flags), 1<<Flag.isBig
        ld (iy+Obj.colour), Colour.brWhite
        ld (iy+Obj.mo.direction), 1<<Dir.right
        ld (iy+Obj.mo.horizSpeed), 0
        ld (iy+Obj.spriteSet), 0

        ; set x coord
        ld l, (ix+Obj.x+0)
        ld h, (ix+Obj.x+1)
        ld de, 16
        bit Dir.right, (ix+Obj.mo.direction)
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

        ; select bubble sprite
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

        ld a, Attack.kick
        ld (State.attack), a
        ld a, 3
        ld (State.attackTime), a

        jp checkEnemiesForDamage

.useWeapon:
        cp ObjType.shatterbomb
        jp NZ, .gun

.shatterbomb:
        ld a, Sound.kickOrThrow
        call playSound

        ; set throwing sprite
        ld hl, cS.heroThrows
        ld (ix+Obj.sprite+0), l
        ld (ix+Obj.sprite+1), h

        ; create bomb
        ld hl, cS.shatterbomb
        ld (iy+Obj.sprite+0), l
        ld (iy+Obj.sprite+1), h
        ld (iy+Obj.flags), 1<<Flag.exists
        ld (iy+Obj.colour), Colour.brCyan
        ld (iy+Obj.spriteSet), 0
        ld (iy+Obj.width), 8
        ld (iy+Obj.height), 8

        ; set x coord
        ld l, (ix+Obj.x+0)
        ld h, (ix+Obj.x+1)
        ld de, 8
        bit Dir.right, (ix+Obj.mo.direction)
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

        ld (iy+Obj.mo.horizSpeed), 4
        ld a, (ix+Obj.mo.direction)
        and Dir.horizontal
        ld (iy+Obj.mo.direction), a

        xor a
        ld (State.bombTime), a
        ld a, Attack.throw
        ld (State.attack), a
        ld a, 3
        ld (State.attackTime), a

        jp checkEnemiesForDamage

.gun:
        cp ObjType.powerGun
        jp NZ, .laserGun

.powerGun:
        ld a, Sound.powerShot
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
        bit Dir.right, (ix+Obj.mo.direction)
        jr NZ, .powerShootRight
.powerShootLeft
        ld de, -16
.powerShootRight:
        add hl, de
        ld (iy+Obj.x+0), l
        ld (iy+Obj.x+1), h

        ld (iy+Obj.flags), 1<<Flag.exists
        ld (iy+Obj.colour), Colour.brWhite
        ld (iy+Obj.mo.horizSpeed), 8
        ld (iy+Obj.mo.vertSpeed), 8
        ld (iy+Obj.spriteSet), 0

        ld a, (ix+Obj.mo.direction)
        and Dir.horizontal
        ld (iy+Obj.mo.direction), a

        ld (State.recoilDir), a
        ld a, Attack.power
        ld (State.attack), a
        ld a, 1
        ld (selfGuidedTime), a
        ld a, 4
        ld (State.recoilTime), a

        jp checkEnemiesForDamage

.laserGun:
        ld a, Sound.laserShot
        call playSound

        ld a, (State.soupCans)
        dec a
        ld l, a
    .2  add a
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
        bit Dir.right, (ix+Obj.mo.direction)
        jr NZ, .laserShootRight
.laserShootLeft
        ld de, -6
.laserShootRight:
        add hl, de
        ld (iy+Obj.x+0), l
        ld (iy+Obj.x+1), h

        ld (iy+Obj.spriteSet), 0
        ld (iy+Obj.flags), 1<<Flag.exists
        ld (iy+Obj.colour), Colour.brCyan
        ld (iy+Obj.mo.horizSpeed), 8

        ld a, (ix+Obj.mo.direction)
        and Dir.horizontal
        ld (iy+Obj.mo.direction), a

        ld (State.recoilDir), a
        ld a, Attack.laser
        ld (State.attack), a
        ld a, 4
        ld (State.recoilTime), a

        jp checkEnemiesForDamage

.alreadyInAttack:
        ; `a`: attack
        ld ix, scene.obj1       ; bullet, bomb, or bubble
        cp Attack.kick
        jr NZ, .notKicking

.kicking:
        ld ix, scene.hero
        ld hl, State.attackTime
        ld a, (hl)
        or a
        jr Z, .endKicking

        dec (hl)
        ld hl, cS.heroKicks
        ld (ix+Obj.sprite+0), l
        ld (ix+Obj.sprite+1), h
        ret

.endKicking:
        ld a, (State.heroState)
        or a
        jr NZ, .skipStanding
        ld hl, cS.heroStands
        ld (ix+Obj.sprite+0), l
        ld (ix+Obj.sprite+1), h
.skipStanding:
        xor a
        ld (State.attack), a
        ld ix, scene.obj1       ; kick bubble
        ld (ix+Obj.flags), a    ; remove object
        ret

.notKicking:
        cp Attack.throw
        jp NZ, .bulletIsFlying

.bombIsFlying:
        ld hl, State.attackTime
        ld a, (hl)
        or a
        jr Z, .skipThrowing

        dec (hl)
        push ix
        ld ix, scene.hero
        ld hl, cS.heroThrows
        ld (ix+Obj.sprite+0), l
        ld (ix+Obj.sprite+1), h
        pop ix

.skipThrowing:
        ld a, (State.blowUpTime)
        or a
        jp NZ, .bombIsExploding

        call checkEnemiesForDamage
        jr NC, .bombExploded

        ld a, (State.bombTime)
        ld l, a
        ld h, 0
        ld de, bombVerticalVelocity
        add hl, de
        ld a, (hl)              ; bomb vertical velocity
        cp #80                  ; end marker
        jr Z, .bombFalls

        ld hl, State.bombTime
        inc (hl)
        ld (ix+Obj.mo.vertSpeed), a

.bombFalls:
        ld a, (ix+Obj.mo.vertSpeed)
        add (ix+Obj.y)
        ld (ix+Obj.y), a

        call isObjectVisible
        jp NC, .removeBombOrBullet      ; if outside the screen

        ; check tile at the bomb's location
        ld a, (ix+Obj.x+0)
        add 4
        ld (ix+Obj.x+0), a
        ld a, (ix+Obj.x+1)
        adc a, 0
        ld (ix+Obj.x+1), a

        call getScrTileAddr     ; `hl`: tile addr

        ld a, (ix+Obj.x+0)
        add -4
        ld (ix+Obj.x+0), a
        ld a, (ix+Obj.x+1)
        adc a, -1
        ld (ix+Obj.x+1), a

        ld a, (hl)
        call getTileType
        cp TileType.ladderTop
        ret C                   ; space or ladder

.bombExploded:
        ld a, Sound.explosion
        call playSound

        ; turn into explosion cloud
        ld a, (ix+Obj.x+0)
        add -4
        ld (ix+Obj.x+0), a
        ld a, (ix+Obj.x+1)
        adc a, -1
        ld (ix+Obj.x+1), a

        ld a, (ix+Obj.y)
        add -8
        ld (ix+Obj.y), a

        xor a
        ld (State.blowUpTime), a
        ld (ix+Obj.mo.direction), a
        set Flag.isBig, (ix+Obj.flags)

        ; choose explosion phases depending on soup can count
        ld a, (State.soupCans)
        dec a
        ld (.soup), a

.bombIsExploding:
.soup+* ld l, -0
        ld h, 0
    .3  add hl, hl
        ld de, bombExplosionPhases
        add hl, de
        ex de, hl               ; `de`: phase list

        ld a, (State.blowUpTime)
        inc a
        ld (State.blowUpTime), a
        srl a
        jr Z, .skipDec
        dec a
.skipDec:
        ld l, a
        ld h, 0
        add hl, de
        ld a, (hl)              ; explosion phase
        cp -1                   ; end marker
        jr Z, .removeBombOrBullet

        ; get explosion sprite
        ld l, a
        ld h, 0
        add hl, hl
        ld de, explosionSprites
        add hl, de
        ld a, (hl)
        inc hl
        ld h, (hl)

        ; set explosion sprite
        ld (ix+Obj.sprite+0), a
        ld (ix+Obj.sprite+1), h
        ld (ix+Obj.colour), Colour.brWhite
        jp checkEnemiesForDamage

.removeBombOrBullet:
        xor a
        ld (ix+Obj.flags), a    ; remove object
        ld (State.attack), a
        ld (State.blowUpTime), a
        ld (selfGuidedTime), a
        ret

.bulletIsFlying:
        call isObjectVisible
        jr NC, .removeBombOrBullet

        ; check tile at the bullet's location
        ld a, (ix+Obj.x)
        add 4
        ld (ix+Obj.x), a
        ld a, (ix+Obj.x+1)
        adc a, 0
        ld (ix+Obj.x+1), a
        ld a, (ix+Obj.y)
        add 8
        ld (ix+Obj.y), a

        call getScrTileAddr     ; `hl`: tile addr

        ld a, (ix+Obj.x)
        add -4
        ld (ix+Obj.x), a
        ld a, (ix+Obj.x+1)
        adc a, -1
        ld (ix+Obj.x+1), a
        ld a, (ix+Obj.y)
        add -8
        ld (ix+Obj.y), a

        ld a, (hl)
        call getTileType
        cp TileType.ladderTop
        jp NC, .removeBombOrBullet

        ; space or ladder
        call checkEnemiesForDamage
        jr NC, .removeBombOrBullet

        ; check if the bullet is self-guided
        ld a, (State.attack)
        cp Attack.power
        ret NZ
        ld a, (State.soupCans)
        cp 3
        jr Z, selfGuidedBullet
        ret


; Time after which new trajectory correction will occur
selfGuidedTime:  ; #e308
        db -0

; Table for converting angle to direction
; (angles are measured clockwise from the rightward direction
; in eights of a revolution)
angleToDir:  ; #e309
.a0:    db 1<<Dir.right
.a1:    db (1<<Dir.down) | (1<<Dir.right)
.a2:    db 1<<Dir.down
.a3:    db (1<<Dir.down) | (1<<Dir.left)
.a4:    db 1<<Dir.left
.a5:    db (1<<Dir.up) | (1<<Dir.left)
.a6:    db 1<<Dir.up
.a7:    db (1<<Dir.up) | (1<<Dir.right)

; Table for converting direction to angle
; (angles are measured clockwise from the rightward direction
; in eights of a revolution)
dirToAngle:  ; #e311
        db 0
.right: db 0
.left:  db 4
        db 0
.down:  db 2
.downR: db 1
.downL: db 3
        db 0
.up:    db 6
.upR:   db 7
.upL:   db 5

; Control a self-guided bullet (power gun with 3 soup cans)
; Used by c_df85.
selfGuidedBullet:  ; #e31c
        ld a, (selfGuidedTime)
        or a
        jr Z, .l_0

        dec a
        ld (selfGuidedTime), a
        ret

.l_0:
        ld ix, scene.obj1       ; bullet

        ; search for target object
        ld iy, scene.obj2
        ld de, Obj              ; object size
        ld b, 6                 ; object count
.object:
        ; skip non-existent objects
        bit Flag.exists, (iy+Obj.flags)
        jr Z, .nextObject
        ld a, (iy+Obj.spriteSet)
        cp SpriteSet.explosion
        jr Z, .nextObject
        bit Flag.cleanUp, (iy+Obj.flags)
        jr NZ, .nextObject

        ; skip non-damageable objects
        ld a, (iy+Obj.health)
        cp -2
        jr Z, .nextObject
        cp -1
        jr Z, .nextObject

        ; skip left off-screen objects
        ld l, (iy+Obj.x+0)
        ld h, (iy+Obj.x+1)
        ld de, 32
        xor a
        sbc hl, de
        jr NC, .found

.nextObject:
        add iy, de
        djnz .object

.notFound:
        ; continue moving horizontally
        ld a, (ix+Obj.mo.direction)
        and Dir.horizontal
        ld (ix+Obj.mo.direction), a
        ret

.found:
        ; `ix`: bullet
        ; `iy`: target object
        ld a, (ix+Obj.mo.direction)
        ld l, a
        ld h, 0
        ld de, dirToAngle
        add hl, de
        ld b, (hl)              ; previous direction angle

        ; calculate target direction
        ld (ix+Obj.mo.direction), 0
        ld l, (ix+Obj.x+0)
        ld h, (ix+Obj.x+1)
        ld e, (iy+Obj.x+0)
        ld d, (iy+Obj.x+1)
        xor a
        sbc hl, de
        jp P, .left

.right:
        ; TODO: is this correct?
        ld a, h
        neg
        ld h, a
        ld a, l
        neg
        ld l, a
        inc hl
        set Dir.right, (ix+Obj.mo.direction)
        jr .l_5
.left:
        set Dir.left, (ix+Obj.mo.direction)

.l_5:
        ; `hl`: unsigned horiz distance(?)
        ld de, 4
        xor a
        sbc hl, de
        jr NC, .vertical
        ld (ix+Obj.mo.direction), 0

.vertical:
        ld a, (ix+Obj.y)
        sub (iy+Obj.y)
        jp P, .up

.down:
        neg
        set Dir.down, (ix+Obj.mo.direction)
        jr .l_8
.up:
        set Dir.up, (ix+Obj.mo.direction)

.l_8:
        cp 4
        jr NC, .l_9
        res Dir.down, (ix+Obj.mo.direction)
        res Dir.up, (ix+Obj.mo.direction)

.l_9:
        ld a, (ix+Obj.mo.direction)
        ld l, a
        ld h, 0
        ld de, dirToAngle
        add hl, de
        ld c, (hl)              ; target direction angle

        ld a, b
        sub c                   ; `a`: signed angle difference with target
        jp Z, .sameDirection

        and %00000111
        ld d, a                 ; anti-clockwise angle difference
        ld a, c
        sub b
        and %00000111           ; clockwise angle difference
        cp d
        ld a, 1                 ; clockwise angle step
        jp C, .clockwise
        neg                     ; anti-clockwise angle step
.clockwise:

        ; set new direction
        add b
        and %00000111           ; new direction angle
        ld l, a
        ld h, 0
        ld de, angleToDir
        add hl, de
        ld a, (hl)              ; new direction
        ld (ix+Obj.mo.direction), a

.sameDirection:
        ld a, 1
        ld (selfGuidedTime), a
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
setWalkPhase:  ; #e419
        ld a, (State.pressTime)
        or a
        jr Z, .noPress

        ; hero is pressed
        dec a
        ld (State.pressTime), a

        ; set small sprite
        ld de, cS.heroSmallWalks
        ld a, (State.stepPeriod)
        or a
        jr Z, .l_0
        inc (ix+Obj.walkPhase)
        ld a, (ix+Obj.walkPhase)
        and %00000010
        jr NZ, .l_0
        ld de, cS.heroSmallStands
.l_0:
        ld (ix+Obj.sprite+0), e
        ld (ix+Obj.sprite+1), d
        ret

.noPress:
        ld a, (State.stepPeriod)
        or a
        ret Z

        ld hl, State.stepTime
        inc (hl)
        ld a, (State.stepPeriod)
        cp (hl)
        ret NZ

        ld (hl), 0

        inc (ix+Obj.walkPhase)
        ld a, (ix+Obj.walkPhase)
        cp 6                    ; walk phase count
        jr C, .l_2
        xor a
        ld (ix+Obj.walkPhase), a      ; reset walk phase

.l_2:
        add a
        ld l, a
        ld h, 0
        ld de, heroWalkPhases
        ld a, (State.weapon)
        cp ObjType.powerGun
        jr C, .noGun
        ld de, heroWalkPhases.armed
.noGun:
        add hl, de
        ld e, (hl)
        inc hl
        ld d, (hl)
        ld (ix+Obj.sprite+0), e
        ld (ix+Obj.sprite+1), d
        ret


    ENDMODULE
