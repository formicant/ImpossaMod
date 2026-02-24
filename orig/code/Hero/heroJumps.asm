    MODULE Hero

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

        ld a, (Control.state)
        bit Key.up, a
        jr Z, .skipGrabLadder

        ; grab ladder if present
        ld a, (State.tileCentre)
        call Tiles.getTileType
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
        call Tiles.getTileType
        cp TileType.wall
        jr NC, .obstacleAbove
        ld a, (State.tileAbovR)
        call Tiles.getTileType
        cp TileType.wall
        jr NC, .obstacleAbove
        ret

.down:
        call collectTwoTilesBelow
        ld a, (State.tileFootL)
        call Tiles.getTileType
        cp TileType.ladderTop
        jp NC, heroWalks.stop
        ld a, (State.tileFootR)
        call Tiles.getTileType
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

    ENDMODULE
