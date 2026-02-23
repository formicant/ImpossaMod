    MODULE Code

; Clear the `Scene` in some crazy way
; Used by c_cc25.
clearScene:  ; #d29a
        ld hl, 0
        ld de, Obj              ; object size
        ld b, 8                 ; object count
.multiplyLoop:
        add hl, de
        djnz .multiplyLoop
        ld c, l
        ld b, h
        ; `bc`: number of bytes to clear

        ld hl, Scene.objects
.clearByte:
        ld (hl), 0
        inc hl
        dec bc
        ld a, b
        or c
        jr NZ, .clearByte
        ret


; Turn a defeated enemy into a coin
;   `iy`: enemy object
; Used by c_ec00.
turnIntoCoin:  ; #d2b3
        bit Flag.isBig, (iy+Obj.flags)
        jr Z, .small            ; never happens(?), always big

        res Flag.isBig, (iy+Obj.flags)  ; make small
        ; adjust coords so that the centre is at the same point
        ld l, (iy+Obj.x+0)
        ld h, (iy+Obj.x+1)
        ld de, 4
        add hl, de
        ld (iy+Obj.x+0), l
        ld (iy+Obj.x+1), h
        ld a, (iy+Obj.y)
        add 4
        ld (iy+Obj.y), a
.small:
        ld hl, cS.coin
        ld (iy+Obj.sprite+0), l
        ld (iy+Obj.sprite+1), h

        ld (iy+Obj.spriteSet), 0
        ld (iy+Obj.mo.type), Motion.coinJump
        ld (iy+Obj.objType), ObjType.coin
        ld (iy+Obj.mo.direction), 0
        ld (iy+Obj.mo.step), 0
        ld (iy+Obj.health), -2
        ld (iy+Obj.colour), Colour.brYellow
        res Flag.waiting, (iy+Obj.flags)
        res Flag.fixedY, (iy+Obj.flags)
        res Flag.fixedX, (iy+Obj.flags)
    IFDEF _MOD
        ; fix smart behaviour
        ld (iy+Obj.auxFlags), 1<<Flag.nonEnemy
    ENDIF
        xor a
        ret


; If the hero is riding an object, move the hero accordingly
; Used by c_cc25.
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
; Used by c_d308.
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


; Return flag C if object is in the visible area or to the right of it
;   `ix`: object
; Used by c_ef72 and c_f37e.
isObjectVisibleOrWaiting:  ; #d407
        ld hl, 352
        ld (isObjectVisibleRaw.de), hl
        jr isObjectVisibleRaw

; Return flag C if object is in the visible area
;   `ix`: object
; used by c_df85 and c_f618.
isObjectVisible:
        ld hl, 288
        ld (isObjectVisibleRaw.de), hl
        ; continue

isObjectVisibleRaw:
        ld a, (ix+Obj.y)
        cp 224                  ; screen bottom
        jr NC, .offScreen
        ld c, (ix+Obj.height)
        add c
        cp 32                   ; screen top
        jr C, .offScreen

        ld l, (ix+Obj.x+0)
        ld h, (ix+Obj.x+1)
        push hl
        ld d, 0
        ld e, (ix+Obj.width)
        add hl, de
        ld de, 32
        xor a
        sbc hl, de
        pop hl
        jr C, .offScreen

.de+*   ld de, 288              ; or 352
        xor a
        sbc hl, de
        ret C

.offScreen:
        xor a
        ret


; Make object big
;   `ix`: object
; Used by c_ec00 and c_ed08.
makeObjectBig:  ; #d443
        ; adjust coords
        ld l, (ix+Obj.x+0)
        ld h, (ix+Obj.x+1)
        ld de, -4
        add hl, de
        ld (ix+Obj.x+0), l
        ld (ix+Obj.x+1), h
        ld a, -2
        add (ix+Obj.y)
        ld (ix+Obj.y), a

        set Flag.isBig, (ix+Obj.flags)
        ret

    ENDMODULE
