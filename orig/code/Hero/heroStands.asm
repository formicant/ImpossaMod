    MODULE Hero

; (Some game logic from call table #D6E7?)
heroStands:  ; #d7f6
        ld a, (Control.state)
        bit Key.up, a
        jr Z, .notUp

.keyUp:
        ld a, (State.tileCentre)
        call Tiles.getTileType
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
        call Tiles.getTileType
        cp TileType.ladderTop
        jp Z, .climb

.notDown:
        ld a, (Control.state)
        bit Key.left, a
        jp NZ, .keyLeft
        bit Key.right, a
        jp NZ, .keyRight

        bit Flag.riding, (ix+Obj.auxFlags)
        ret NZ

        ; check foot tiles
        ld a, (State.tileFootL)
        call Tiles.getTileType
        cp TileType.ladderTop
        jr NC, .notFalling
        ld a, (State.tileFootR)
        call Tiles.getTileType
        cp TileType.ladderTop
        jp C, heroWalks.fall

.notFalling:
        ; check for ice
        ld a, (State.tileFootL)
        call Tiles.getTileType
        cp TileType.ice
        jr Z, .ice
        ld a, (State.tileFootR)
        call Tiles.getTileType
        cp TileType.ice
        jr Z, .ice

        ld a, (State.tileFootL)
        call Tiles.getTileType
        cp TileType.conveyorL
        ret NC                  ; ret if conveyor, slow, water/spikes (?)
        ld a, (State.tileFootR)
        call Tiles.getTileType
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

        ld a, (Control.state)
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
        call Sound.playSound
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

    ENDMODULE
