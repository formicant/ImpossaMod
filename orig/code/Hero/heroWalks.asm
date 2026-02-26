    MODULE Hero

; (Some game logic from call table #D6E7?)
heroWalks:  ; #d94c
        bit Flag.riding, (ix+Obj.auxFlags)
        jr NZ, .notFalling

        ; check tiles below
        ld a, (State.tileFootL)
        call Tiles.getTileType
        cp TileType.ladderTop
        jr NC, .notFalling
        ld a, (State.tileFootR)
        call Tiles.getTileType
        cp TileType.ladderTop
        jp C, .fall

.notFalling:
        ld a, (Control.state)
        bit Key.up, a
        jp NZ, .stop
        bit Key.down, a
        jr Z, .notDown

.keyDown:
        ld a, (State.tileFootC)
        call Tiles.getTileType
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
        call Tiles.getTileType
        cp TileType.slow
        jr Z, .slowLeft
        ld a, (State.tileFootR)
        call Tiles.getTileType
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
        ld a, (Control.state)
        bit Key.left, a
        jp Z, .stop
        jr .checkIce

.right:
        call isObstacleToTheRight
        or a
        jp NZ, .stop

        ld a, (State.tileFootL)
        call Tiles.getTileType
        cp TileType.slow
        jr Z, .slowRight
        ld a, (State.tileFootR)
        call Tiles.getTileType
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
        ld a, (Control.state)
        bit Key.right, a
        jp Z, .stop

.checkIce:
        ld a, (State.tileFootL)
        call Tiles.getTileType
        cp TileType.ice
        jr Z, .ice
        ld a, (State.tileFootR)
        call Tiles.getTileType
        cp TileType.ice
        ret NZ

.ice:
        ld a, 1
        ld (State.stepPeriod), a
        xor a
        ld (State.stepTime), a
        ret

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

.fall:
        xor a
        ld (State.pressTime), a
        ld a, HeroState.fall
        ld (State.heroState), a
        xor a
        ld (State.stepPeriod), a

        ld a, (Control.state)
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

    ENDMODULE
