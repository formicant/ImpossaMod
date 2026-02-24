    MODULE Enemy

; If object is one that falls, process its motion
;   arg `ix`: object
fallingMotion: ; #ed5f
        ld a, (ix+Obj.mo.subType)

        cp Motion.trajOrFall.andStay
        jr Z, .fallAndStay

        cp Motion.trajOrFall.andExplode
        ret NZ                  ; not falling

.fallAndExplode:
        call collectTileTypes
        ld a, (State.tTypeBot)
        cp TileType.ladderTop
        ret C                   ; space or ladder

        ; if any other tile type, explode
        bit Flag.isBig, (ix+Obj.flags)
        jr NZ, .big
        call Scene.makeObjectBig
.big:
        ld a, (ix+Obj.objType)
        cp ObjType.klondike.stalactite
        jr NZ, .skipAdjustX
        ld a, (ix+Obj.x+0)
        sub 8
        ld (ix+Obj.x+0), a
.skipAdjustX:
        ld (ix+Obj.walkPhase), 0
        ld (ix+Obj.spriteSet), -1
        ld (ix+Obj.colour), Colour.brWhite
        ld a, Sound.explosion
        jp Sound.playSound

.fallAndStay:
        call collectTileTypes
        ld a, (State.tTypeBot)
        cp TileType.wall
        ret C                   ; space, ladder, or ladderTop

        ; if any other tile type, stop
        ld (ix+Obj.mo.type), Motion.none
        set Flag.waiting, (ix+Obj.flags)

        ld a, (ix+Obj.objType)
        cp ObjType.amazon.hangingMonkey
        ret NZ
        ld hl, Lev2Amazon.lS.sittingMonkey
        ld (ix+Obj.sprite+0), l
        ld (ix+Obj.sprite+1), h
        ld (ix+Obj.spriteSet), 0
        ret

    ENDMODULE
