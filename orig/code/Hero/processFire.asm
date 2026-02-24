    MODULE Hero

; Signed vertical velocity of a bomb by time
bombVerticalVelocity:  ; #df2b
        db -4, -2, -1, -1, 0, 1, 1, 1, 1, 2, 3
        db 4, 6, 7, 8, 10, 11, 12, 14, 15, 16
        db #80

kickBubbles:  ; #df41
        dw cS.kickBubble1
        dw cS.kickBubble2
        dw cS.kickBubble3

; Explosion phases of a bomb for different number of soup cans
bombExplosionPhases:  ; #df47
        db 0, 1, 0, -1, 0, 0, 0, 0  ; s
        db 0, 1, 2, 1, 0, -1, 0, 0  ; ss
        db 0, 1, 2, 3, 2, 1, 0, -1  ; sss

explosionSprites:  ; #df5f
        dw cS.explosion1
        dw cS.explosion2
        dw cS.explosion3
        dw cS.explosion4

laserBulletTable:  ; #df67       w   h
        dw cS.laserBullet1 : db 16,  7, 8
        dw cS.laserBullet2 : db 16, 11, 6
        dw cS.laserBullet3 : db 16, 15, 4

powerBulletTable:  ; #df76       w   h
        dw cS.powerBullet1 : db  4,  4, 9
        dw cS.powerBullet2 : db  4, 16, 4
        dw cS.powerBullet3 : db  8,  8, 8


; Decrement weapon time and perform fire if pressed
; Used by c_cc25.
processFire:  ; #df85
        ld a, (State.pressTime)
        or a
        ret NZ
        ld a, (State.inShop)
        or a
        ret NZ

        ; decrement weapon time
        ld a, (State.weapon)
        or a
        jr Z, .skipWeaponTime
        ld hl, (State.weaponTime)
        ld a, h
        or l
        jr NZ, .decWeaponTime
        ; weapon time elapsed

        ld a, (State.attack)
        or a
        jr NZ, .skipWeaponTime
        xor a
        ld (State.weapon), a    ; remove weapon
        ret

.decWeaponTime:
        dec hl
        ld (State.weaponTime), hl
.skipWeaponTime:

        ld a, (State.attack)
        or a
        jp NZ, alreadyInAttack

        ld a, (State.heroState)
        cp HeroState.fall
        ret NC                  ; fall or climb

        ld a, (Control.state)
        bit Key.fire, a
        ret Z

        ; fire pressed
        ld ix, Scene.hero
        ld iy, Scene.obj1       ; bullet, bomb, or bubble
        ld a, (State.weapon)
        or a
        jp NZ, .useWeapon

        ; no weapon
        ld a, Sound.kickOrThrow
        call Sound.playSound

        ; set kicking sprite
        ld hl, cS.heroKicks
        ld (ix+Obj.sprite+0), l
        ld (ix+Obj.sprite+1), h

        ; create kick bubble
        ld (iy+Obj.flags), 1<<Flag.isBig
        ld (iy+Obj.colour), Colour.brWhite
        ld (iy+Obj.mo.direction), 1<<Dir.right
        ld (iy+Obj.mo.horizSpeed), 0
        ld (iy+Obj.spriteSet), 0

        ; set x coord
        ld l, (ix+Obj.x+0)
        ld h, (ix+Obj.x+1)
        ld de, 16
        bit Dir.right, (ix+Obj.mo.direction)
        jr NZ, .kickRight
.kickLeft:
        ld de, -16
.kickRight:
        add hl, de
        ld (iy+Obj.x+0), l
        ld (iy+Obj.x+1), h

        ; set y coord
        ld a, (ix+Obj.y)
        ld (iy+Obj.y), a

        ; select bubble sprite
        ld a, (State.soupCans)
        dec a
        add a
        ld l, a
        ld h, 0
        ld de, kickBubbles
        add hl, de
        ld a, (hl)
        ld (iy+Obj.sprite+0), a
        inc hl
        ld a, (hl)
        ld (iy+Obj.sprite+1), a

        ld a, Attack.kick
        ld (State.attack), a
        ld a, 3
        ld (State.attackTime), a

        jp Enemy.checkEnemiesForDamage

.useWeapon:
        cp ObjType.shatterbomb
        jp NZ, .gun

.shatterbomb:
        ld a, Sound.kickOrThrow
        call Sound.playSound

        ; set throwing sprite
        ld hl, cS.heroThrows
        ld (ix+Obj.sprite+0), l
        ld (ix+Obj.sprite+1), h

        ; create bomb
        ld hl, cS.shatterbomb
        ld (iy+Obj.sprite+0), l
        ld (iy+Obj.sprite+1), h
        ld (iy+Obj.flags), 1<<Flag.exists
        ld (iy+Obj.colour), Colour.brCyan
        ld (iy+Obj.spriteSet), 0
        ld (iy+Obj.width), 8
        ld (iy+Obj.height), 8

        ; set x coord
        ld l, (ix+Obj.x+0)
        ld h, (ix+Obj.x+1)
        ld de, 8
        bit Dir.right, (ix+Obj.mo.direction)
        jr NZ, .throwRight
.throwLeft:
        ld de, -6
.throwRight:
        add hl, de
        ld (iy+Obj.x+0), l
        ld (iy+Obj.x+1), h

        ; set y coord
        ld a, (ix+Obj.y)
        add -4
        ld (iy+Obj.y), a

        ld (iy+Obj.mo.horizSpeed), 4
        ld a, (ix+Obj.mo.direction)
        and Dir.horizontal
        ld (iy+Obj.mo.direction), a

        xor a
        ld (State.bombTime), a
        ld a, Attack.throw
        ld (State.attack), a
        ld a, 3
        ld (State.attackTime), a

        jp Enemy.checkEnemiesForDamage

.gun:
        cp ObjType.powerGun
        jp NZ, .laserGun

.powerGun:
        ld a, Sound.powerShot
        call Sound.playSound

        ld a, (State.soupCans)
        dec a
        ld l, a
    .2  add a
        add l
        ld l, a
        ld h, 0
        ld de, powerBulletTable
        add hl, de

        ; create bullet
        ld c, (hl)              ; bullet sprite (low)
        inc hl
        ld b, (hl)              ; bullet sprite (high)
        ld (iy+Obj.sprite+0), c
        ld (iy+Obj.sprite+1), b

        inc hl
        ld a, (hl)              ; bullet width
        ld (iy+Obj.width), a
        inc hl
        ld a, (hl)              ; bullet height
        ld (iy+Obj.height), a
        inc hl
        ld a, (hl)              ; bullet y offset
        add (ix+Obj.y)
        ld (iy+Obj.y), a

        ; bullet x coord
        ld l, (ix+Obj.x+0)
        ld h, (ix+Obj.x+1)
        ld de, 24
        bit Dir.right, (ix+Obj.mo.direction)
        jr NZ, .powerShootRight
.powerShootLeft
        ld de, -16
.powerShootRight:
        add hl, de
        ld (iy+Obj.x+0), l
        ld (iy+Obj.x+1), h

        ld (iy+Obj.flags), 1<<Flag.exists
        ld (iy+Obj.colour), Colour.brWhite
        ld (iy+Obj.mo.horizSpeed), 8
        ld (iy+Obj.mo.vertSpeed), 8
        ld (iy+Obj.spriteSet), 0

        ld a, (ix+Obj.mo.direction)
        and Dir.horizontal
        ld (iy+Obj.mo.direction), a

        ld (State.recoilDir), a
        ld a, Attack.power
        ld (State.attack), a
        ld a, 1
        ld (selfGuidedTime), a
        ld a, 4
        ld (State.recoilTime), a

        jp Enemy.checkEnemiesForDamage

.laserGun:
        ld a, Sound.laserShot
        call Sound.playSound

        ld a, (State.soupCans)
        dec a
        ld l, a
    .2  add a
        add l
        ld l, a
        ld h, 0
        ld de, laserBulletTable
        add hl, de

        ; create bullet
        ld c, (hl)              ; bullet sprite (low)
        inc hl
        ld b, (hl)              ; bullet sprite (high)
        ld (iy+Obj.sprite+0), c
        ld (iy+Obj.sprite+1), b

        inc hl
        ld a, (hl)              ; bullet width
        ld (iy+Obj.width), a
        inc hl
        ld a, (hl)              ; bullet height
        ld (iy+Obj.height), a
        inc hl
        ld a, (hl)              ; bullet y offset
        add (ix+Obj.y)
        ld (iy+Obj.y), a

        ; bullet x coord
        ld l, (ix+Obj.x+0)
        ld h, (ix+Obj.x+1)
        ld de, 16
        bit Dir.right, (ix+Obj.mo.direction)
        jr NZ, .laserShootRight
.laserShootLeft
        ld de, -6
.laserShootRight:
        add hl, de
        ld (iy+Obj.x+0), l
        ld (iy+Obj.x+1), h

        ld (iy+Obj.spriteSet), 0
        ld (iy+Obj.flags), 1<<Flag.exists
        ld (iy+Obj.colour), Colour.brCyan
        ld (iy+Obj.mo.horizSpeed), 8

        ld a, (ix+Obj.mo.direction)
        and Dir.horizontal
        ld (iy+Obj.mo.direction), a

        ld (State.recoilDir), a
        ld a, Attack.laser
        ld (State.attack), a
        ld a, 4
        ld (State.recoilTime), a

        jp Enemy.checkEnemiesForDamage

    ENDMODULE
