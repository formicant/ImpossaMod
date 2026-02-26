    MODULE Hero

; (Some game logic from call table #D6E7?)
heroFalls:  ; #db4e
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
        call Tiles.getTileType
        cp TileType.ladderTop
        jp NC, heroWalks.stop
        ld a, (State.tileFootR)
        call Tiles.getTileType
        cp TileType.ladderTop
        jp NC, heroWalks.stop

        ld a, (Control.state)
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

    ENDMODULE
