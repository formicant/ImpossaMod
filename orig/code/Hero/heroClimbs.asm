    MODULE Hero

; (Some game logic from call table #D6E7?)
heroClimbs:  ; #dbfc
        ld a, (Control.state)
        bit Key.up, a
        jr Z, .notUp

        ld a, (State.tileCentre)
        call Tiles.getTileType
        or a
        jr NZ, .checkTilesAbove
        ld a, (State.tileFootC)
        call Tiles.getTileType
        or a
        jp Z, heroWalks.fall

.checkTilesAbove:
        call collectTilesAbove
        ld a, (State.tileAbovL)
        call Tiles.getTileType
        cp TileType.wall
        jr NC, .notUp
        ld a, (State.tileAbovR)
        call Tiles.getTileType
        cp TileType.wall
        jr NC, .notUp

        ; climb up
        call climbStep
        ld a, (ix+Obj.y)
        add -2                  ; climb speed
        ld (ix+Obj.y), a

.notUp:
        ld a, (Control.state)
        bit Key.down, a
        jr Z, .notDown

        ld a, (State.tileCentre)
        call Tiles.getTileType
        or a
        jr NZ, .l_2
        ld a, (State.tileFootC)
        call Tiles.getTileType
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
        call Tiles.getTileType
        cp TileType.ladderTop
        jp NC, heroWalks.stop

.l_4:
        ld a, (Control.state)
        bit Key.left, a
        jr Z, .notLeft
        ld a, (State.tileCentre)
        call Tiles.getTileType
        or a
        jr NZ, .left

        ld a, (State.tileFootC)
        call Tiles.getTileType
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
        ld a, (Control.state)
        bit Key.right, a
        jr Z, .notRight

        ld a, (State.tileCentre)
        call Tiles.getTileType
        or a
        jr NZ, .right

        ld a, (State.tileFootC)
        call Tiles.getTileType
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

    ENDMODULE
