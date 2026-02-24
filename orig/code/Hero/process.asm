    MODULE Hero

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
        ld ix, Scene.hero
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
        call Tiles.getTileType
        cp TileType.conveyorL
        jp Z, .dragLeft
        cp TileType.conveyorR
        jp Z, .dragRight

        ld a, (State.tileFootR)
        call Tiles.getTileType
        cp TileType.conveyorL
        jp Z, .dragLeft
        cp TileType.conveyorR
        jp Z, .dragRight

        ; check water/spikes
        ld a, (State.tileFootL)
        call Tiles.getTileType
        cp TileType.waterSpikes
        jr Z, .waterSpikes
        ld a, (State.tileFootR)
        call Tiles.getTileType
        cp TileType.waterSpikes
        jr NZ, .checkAdvance

.waterSpikes:
        call decEnergy
        ld a, HeroState.jump
        ld (State.heroState), a

        ld a, (Control.state)
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

    ENDMODULE
