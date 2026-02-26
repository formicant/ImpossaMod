    MODULE Enemy

; Choose motion type based on `motionSub`
;   arg `ix`: object
generalMotion:  ; #ef72
        ld a, (ix+Obj.mo.subType)
        cp Motion.general.walk
        jp Z, walkMotion

        cp Motion.general.walkOrFall
        jp Z, walkOrFallMotion

        cp Motion.general.random
        jp Z, randomMotion

        cp Motion.general.range
        jp Z, rangeMotion

        jp removeIfOffScreen


walkMotion:
        call randomlyChangeDirection
        call randomlyStandStill

        call collectTileTypes
        ld a, (State.tTypeRight)
        bit Dir.right, (ix+Obj.mo.direction)
        jr NZ, .l_1
        ld a, (State.tTypeLeft)
.l_1:
        cp TileType.wall
        jr NC, .turnAround

.walk:
        ld a, (ix+Obj.objType)
        cp ObjType.amazon.crocodile
        jr Z, .checkScreenEdge

        ld a, (State.tTypeBotR)
        bit Dir.right, (ix+Obj.mo.direction)
        jr NZ, .l_2
        ld a, (State.tTypeBotL)
.l_2:
        or a                    ; if space, turn around
        jr NZ, .checkScreenEdge

.turnAround:
        ld a, (ix+Obj.mo.direction)
        xor Dir.horizontal
        ld (ix+Obj.mo.direction), a
        jp removeIfOffScreen

.checkScreenEdge:
        ld l, (ix+Obj.x+0)
        ld h, (ix+Obj.x+1)
        bit Dir.right, (ix+Obj.mo.direction)
        jr NZ, .right

.left:
        ld de, 32
        xor a
        sbc hl, de
        jr C, .turnAround
        jp removeIfOffScreen

.right:
        ld d, 0
        ld e, (ix+Obj.width)
        add hl, de
        ld de, 288
        xor a
        sbc hl, de
        jr NC, .turnAround
        jp removeIfOffScreen


walkOrFallMotion:
        ld (ix+Obj.mo.vertSpeed), 8
        call collectTileTypes
        bit Flag.falling, (ix+Obj.auxFlags)
        jr NZ, .fall

        call randomlyChangeDirection
        call randomlyStandStill

        ld a, (State.tTypeRight)
        bit Dir.right, (ix+Obj.mo.direction)
        jr NZ, .l_7
        ld a, (State.tTypeLeft)
.l_7:
        cp TileType.wall
        jr C, .walk

.turnAround:
        ld a, (ix+Obj.mo.direction)
        xor Dir.horizontal
        ld (ix+Obj.mo.direction), a

.walk:
        ld a, (State.tTypeBot)
        cp TileType.ladderTop
        jp NC, removeIfOffScreen

.startFalling:
        set Flag.falling, (ix+Obj.auxFlags)
        set Flag.fixedX, (ix+Obj.flags)
        set Dir.down, (ix+Obj.mo.direction)
        jp removeIfOffScreen

.fall:
        ld a, (State.tTypeBot)
        cp TileType.ladderTop
        jp C, removeIfOffScreen ; space or ladder

.stopFalling:
        res Flag.falling, (ix+Obj.auxFlags)
        res Flag.fixedX, (ix+Obj.flags)
        res Dir.down, (ix+Obj.mo.direction)
        jp removeIfOffScreen


randomMotion: ; randomDirection
        bit 0, (ix+Obj.mo.coordConstr)
        jr Z, .l_11
        call Utils.generateRandom
        cp 10
        jr NC, .l_11
        ld a, (ix+Obj.mo.direction)
        xor Dir.vertical
        ld (ix+Obj.mo.direction), a
.l_11:
        bit 1, (ix+Obj.mo.coordConstr)
        jr Z, .l_12
        call Utils.generateRandom
        cp 10
        jr NC, .l_12
        ld a, (ix+Obj.mo.direction)
        xor Dir.horizontal
        ld (ix+Obj.mo.direction), a

.l_12:
        call collectTileTypes

        bit Dir.right, (ix+Obj.mo.direction)
        jr Z, .l_13
        ld a, (State.tTypeRight)
        cp TileType.ladderTop
        jr NC, .l_14
        jr .l_15
.l_13:
        bit Dir.left, (ix+Obj.mo.direction)
        jr Z, .l_15
        ld a, (State.tTypeLeft)
        cp TileType.ladderTop
        jr C, .l_15
.l_14:
        ld a, (ix+Obj.mo.direction)
        xor Dir.horizontal
        ld (ix+Obj.mo.direction), a
.l_15:
        bit Dir.down, (ix+Obj.mo.direction)
        jr Z, .l_16
        ld a, (State.tTypeBot)
        cp TileType.ladderTop
        jr NC, .l_17
        jr .end
.l_16:
        bit Dir.up, (ix+Obj.mo.direction)
        jr Z, .end
        ld a, (State.tTypeTop)
        cp TileType.ladderTop
        jr C, .end
.l_17:
        ld a, (ix+Obj.mo.direction)
        xor Dir.vertical
        ld (ix+Obj.mo.direction), a
.end:
        jp removeIfOffScreen


rangeMotion: ; backAndForth
        ld a, (ix+Obj.mo.step)
        cp (ix+Obj.mo.range)
        jr Z, .rangeEnd
        inc (ix+Obj.mo.step)
        jp removeIfOffScreen

.rangeEnd:
        ld (ix+Obj.mo.step), 0

        ; invert direction
        ld c, (ix+Obj.mo.direction)
        ld a, c
        and Dir.horizontal
        jr Z, .l_21
        xor Dir.horizontal
.l_21:
        ld b, a
        ld a, c
        and Dir.vertical
        jr Z, .l_22
        xor Dir.vertical
.l_22:
        or b
        ld (ix+Obj.mo.direction), a
        jp removeIfOffScreen

    ENDMODULE
