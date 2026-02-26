    MODULE Enemy

; Move object towards the hero
;   arg `ix`: object
selfGuidedMotion:  ; #f0f3
        ld (ix+Obj.mo.horizSpeed), 2
        ld (ix+Obj.mo.vertSpeed), 2
        res Flag.fixedX, (ix+Obj.flags)
        res Flag.fixedY, (ix+Obj.flags)

        ; coordinate constraints
        bit Motion.selfGuided.vert, (ix+Obj.mo.subType)
        jr NZ, .skip
        set Flag.fixedY, (ix+Obj.flags)
.skip:
        bit Motion.selfGuided.horiz, (ix+Obj.mo.subType)
        jr NZ, .horizontal
        set Flag.fixedX, (ix+Obj.flags)

.horizontal:
        ld iy, Scene.hero
        ld l, (ix+Obj.x+0)
        ld h, (ix+Obj.x+1)
        ld c, (ix+Obj.width)
        srl c
        ld b, 0
        add hl, bc
        ex de, hl
        ; `de` objects's centre x

        ld l, (iy+Obj.x+0)
        ld h, (iy+Obj.x+1)
        ld c, (iy+Obj.width)
        srl c
        ld b, 0
        add hl, bc
        ; `hl` hero's centre x

        xor a
        sbc hl, de              ; signed x difference
        ; choose horizontal direction
        ld (ix+Obj.mo.direction), 1<<Dir.right
        jp P, .right
.left:
        ld (ix+Obj.mo.direction), 1<<Dir.left
        ; `neg hl`
        ld a, l
        cpl
        ld l, a
        ld a, h
        cpl
        ld h, a
        inc hl
.right:
        ; `hl`: unsigned distance
        ld e, (ix+Obj.mo.horizSpeed)
        ld d, 0
        xor a
        sbc hl, de
        jp P, .vertical
        ; stop if too close
        set Flag.fixedX, (ix+Obj.flags)

.vertical:
        ld a, (ix+Obj.y)
        ld c, (ix+Obj.height)
        srl c
        add c
        ld c, a                 ; objects's centre y

        ld a, (iy+Obj.y)
        ld b, (iy+Obj.height)
        srl b
        add b                   ; `a`: hero's centre y

        sub c                   ; signed x difference
        ; choose vertical direction
        set Dir.down, (ix+Obj.mo.direction)
        res Dir.up, (ix+Obj.mo.direction)
        jp P, .down
.up:
        cpl                     ; should be `neg`(?)
        set Dir.up, (ix+Obj.mo.direction)
        res Dir.down, (ix+Obj.mo.direction)
.down:
        ; `a`: unsigned distance
        cp (ix+Obj.mo.vertSpeed)
        jr NC, .checkTiles
        ; stop if too close
        set Flag.fixedY, (ix+Obj.flags)

.checkTiles:
        call collectTileTypes

.rightTile:
        bit Dir.right, (ix+Obj.mo.direction)
        jr Z, .leftTile
        ld a, (State.tTypeRight)
        cp TileType.wall
        jr C, .leftTile
        set Flag.fixedX, (ix+Obj.flags)

.leftTile:
        bit Dir.left, (ix+Obj.mo.direction)
        jr Z, .downTile
        ld a, (State.tTypeLeft)
        cp TileType.wall
        jr C, .downTile
        set Flag.fixedX, (ix+Obj.flags)

.downTile:
        bit Dir.down, (ix+Obj.mo.direction)
        jr Z, .upTile
        ld a, (State.tTypeBot)
        cp TileType.platform
        jr C, .upTile
        set Flag.fixedY, (ix+Obj.flags)

.upTile:
        bit Dir.up, (ix+Obj.mo.direction)
        jr Z, .end
        ld a, (State.tTypeTop)
        cp TileType.platform
        jr C, .end
        set Flag.fixedY, (ix+Obj.flags)

.end:
        jp removeIfOffScreen

    ENDMODULE
