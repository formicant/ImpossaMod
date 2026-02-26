    MODULE Hero

; If the hero is riding an object, move the hero accordingly
heroRiding:  ; #d308
        ld ix, Scene.hero
        bit Flag.riding, (ix+Obj.auxFlags)
        jp NZ, .isRiding

        ; ?
        ld a, (State.heroState)
        cp HeroState.fall
        jr Z, .l_0
        cp HeroState.jump
        ret NZ

        ld a, (State.jumpVel)
        or a
        ret M                   ; moving upwards

.l_0:
        ; Find an object at the hero's feet
        ld iy, Scene.obj2
        ld b, 6                 ; object count
.object:
        call isHeroOnTopObject
        jr NZ, .found
        ld de, Obj              ; object size
        add iy, de
        djnz .object
        ; not found
        ret

.found:
        ; `ix`: hero
        ; `iy`: object at the hero's feet
        xor a
        ld (State.heroState), a
        ld (State.stepPeriod), a
        ld (ix+Obj.mo.horizSpeed), 0
        set Flag.riding, (ix+Obj.auxFlags)
        push iy : pop hl
        ; save obj addr
        ld (ix+Obj.aim.curX+0), l
        ld (ix+Obj.aim.curX+1), h

.isRiding:
        ld l, (ix+Obj.aim.curX+0)
        ld h, (ix+Obj.aim.curX+1)
        push hl : pop iy
        ; `iy`: object that used to be at the hero's feet
        call isHeroOnTopObject
        jr NZ, .setSprite
        ; not at the feet any more
        res Flag.riding, (ix+Obj.auxFlags)
        ret

.setSprite:
        ld hl, cS.heroStands
        ld a, (State.weapon)
        cp ObjType.powerGun
        jr C, .noGun
        ld hl, cS.armedHeroStands
.noGun:
        ld (ix+Obj.sprite+0), l
        ld (ix+Obj.sprite+1), h

        ; adjust hero's y
        ld a, (iy+Obj.y)
        sub (ix+Obj.height)
        ld (ix+Obj.y), a

        ; get object direction
        ld c, (iy+Obj.mo.direction)
        ld a, (iy+Obj.mo.type)
        cp Motion.general
        jr Z, .notTrajectory
        ld c, (iy+Obj.mo.trajDir)
.notTrajectory:
        ld a, c
        and Dir.horizontal
        ret Z

        ld a, (iy+Obj.mo.horizSpeed)
        ld d, 0
        bit Dir.right, c
        jr NZ, .skipNeg
        neg
        ld d, -1
.skipNeg:
        ld e, a
        push de                 ; object's signed horizontal velocity
        bit Dir.right, c
        jr NZ, .right

.left:
        call isObstacleToTheLeft
        pop de
        or a
        jr Z, .applyVelocity
        ret

.right:
        call isObstacleToTheRight
        pop de
        ret NZ

.applyVelocity:
        ; `de`: object's signed horizontal velocity
        ld l, (ix+Obj.x+0)
        ld h, (ix+Obj.x+1)
        add hl, de
        ld (ix+Obj.x+0), l
        ld (ix+Obj.x+1), h
        ret


; Check if the hero's bottom is near the top of a rideable object
;   arg `ix`: hero
;       `iy`: object
;   ret `a`: #FF and flag NZ if is, `a`: 0 and flag Z if isn't
isHeroOnTopObject:  ; #d3bb
        bit Flag.exists, (iy+Obj.flags)
        ret Z
        bit Flag.riding, (iy+Obj.auxFlags)
        ret Z

        ld a, (ix+Obj.y)
        add (ix+Obj.height)
        sub (iy+Obj.y)
        jp P, .l_0
        ; hero's bottom is above object's top
        neg
.l_0:
        cp 5
        jr NC, .false
        ; hero's bottom is 5 pixels apart from object's top

        ld l, (ix+Obj.x+0)
        ld h, (ix+Obj.x+1)
        ld de, 20
        add hl, de
        ld e, (iy+Obj.x+0)
        ld d, (iy+Obj.x+1)
        xor a
        sbc hl, de
        jr C, .false
        ; hero's right - object's left >= 4
        ld l, (iy+Obj.width)
        ld h, 0
        add hl, de
        ld e, (ix+Obj.x+0)
        ld d, (ix+Obj.x+1)
    .4  inc de
        xor a
        sbc hl, de
        jr C, .false
        ; object's right - hero's left >= 4
.true:
        ld a, #FF
        or a
        ret
.false:
        xor a
        ret

    ENDMODULE
