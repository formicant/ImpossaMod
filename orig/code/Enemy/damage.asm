    MODULE Enemy

; Sizes and x offsets of kick bubble collision boxes for 3 soup cans
kickBubbleSizes:  ; #eaf7
        ;  dx  w   h
        db 4, 16, 16            ; s
        db 2, 20, 20            ; ss
        db 0, 24, 24            ; sss


; Check if kick, bomb, or bullet damages any object in the scene
;   ret flag C if object is not damaged, NC if damaged
checkEnemiesForDamage:  ; #eb00
        ld ix, Scene.obj1       ; bullet, bomb, or kick bubble
        ld iy, Scene.obj2
        ld b, 6                 ; object count
.object:
        push bc
        call checkEnemyDamage
        pop bc
        ret NC                  ; stop searching after first damaged enemy
        ld de, Obj              ; object size
        add iy, de
        djnz .object
        scf
        ret


; Check if kick, bomb, or bullet damages the object
;   arg `ix`: bullet, bomb, or kick bubble
;       `iy`: object
;   ret flag C if object is not damaged, NC if damaged
checkEnemyDamage:  ; #eb19
        ld a, (iy+Obj.objType)
        or a
        jp Z, damageEnemy.notDamaged

        bit Flag.exists, (iy+Obj.flags)
        jp Z, damageEnemy.notDamaged

        ld a, (iy+Obj.health)
        cp -2                   ; not an enemy (?)
        jp Z, damageEnemy.notDamaged

        ld a, (iy+Obj.blinkTime)
        or a                    ; blinking
        jp NZ, damageEnemy.notDamaged

        ld a, (State.weapon)
        or a
        jr NZ, .weaponUsed

        ; no weapon
        ld a, (iy+Obj.spriteSet)
        cp -1
        jr NZ, .l_0
        res Flag.exists, (ix+Obj.flags) ; remove bubble
        ret

.l_0:
        ld a, (State.soupCans)
        dec a
        ld l, a
        add a
        add l
        ld l, a
        ld h, 0
        ld de, kickBubbleSizes
        add hl, de
        ld c, l
        ld b, h                 ; `bc`: addr in `c_eaf7`

        ld l, (ix+Obj.x+0)
        ld h, (ix+Obj.x+1)
        push hl
        ld a, (bc)              ; kick bubble x offset
        inc bc
        ld e, a
        ld d, 0
        add hl, de
        ld (ix+Obj.x+0), l
        ld (ix+Obj.x+1), h

        ld a, (bc)              ; kick bubble width
        inc bc
        ld (ix+Obj.width), a
        ld a, (bc)              ; kick bubble height
        ld (ix+Obj.height), a

        ; check collision between kick bubble and the object
        call Scene.checkObjectCollision

        ; restore kick bubble x coord
        pop hl
        ld (ix+Obj.x+0), l
        ld (ix+Obj.x+1), h
        ret C                   ; ret if no collision

        ; collision
        set Flag.exists, (ix+Obj.flags)
        jr damageEnemy

.weaponUsed:
        cp ObjType.shatterbomb
        jr NZ, .gun

.shatterbomb:
        bit Flag.isBig, (ix+Obj.flags)
        jr NZ, .l_2
        ld a, (ix+Obj.x+0)
        add #04
        ld (ix+Obj.x+0), a
        ld a, (ix+Obj.x+1)
        adc a, #00
        ld (ix+Obj.x+1), a
        call Scene.checkObjectCollision
        exa
        ld a, (ix+Obj.x+0)
        add #FC
        ld (ix+Obj.x+0), a
        ld a, (ix+Obj.x+1)
        adc a, #FF
        ld (ix+Obj.x+1), a
        exa
        ret
.l_2:
        ld a, (State.soupCans)
        dec a
        ld l, a
        add a
        add l
        ld l, a
        ld h, #00
        ld de, kickBubbleSizes
        add hl, de
        ld c, l
        ld b, h
        ld l, (ix+Obj.x+0)
        ld h, (ix+Obj.x+1)
        push hl
        ld a, (bc)
        inc bc
        ld e, a
        ld d, #00
        add hl, de
        ld (ix+Obj.x+0), l
        ld (ix+Obj.x+1), h
        ld a, (bc)
        inc bc
        ld (ix+Obj.width), a
        ld a, (bc)
        ld (ix+Obj.height), a
        call Scene.checkObjectCollision
        pop hl
        ld (ix+Obj.x+0), l
        ld (ix+Obj.x+1), h
        ret C                   ; ret if no collision
        ; collision
        jr damageEnemy

.gun:
        ; check bullet collision
        call Scene.checkObjectCollision
        ret C                   ; ret if no collision
        ; collision
        jr damageEnemy


; Weapon damage table (4 weapons × 3 soup cans)
weaponDamageTable:  ; #ebf4
        ;   s  ss  sss
.kick:  db -1, -2, -3
.bomb:  db -1, -2, -2
.pGun:  db -1, -2, -3
.lGun:  db -2, -3, -4

; Damage/kill enemy?
damageEnemy:  ; #ec00
        ld a, (iy+Obj.spriteSet)
        cp -1
        jr Z, .notDamaged
        ld a, (iy+Obj.health)
        cp -1
        jr Z, .notDamaged

        ; look up damage points
        ld a, (State.weapon)
        ld l, a
        add a
        add l
        ld l, a
        ld h, 0
        ld de, weaponDamageTable
        add hl, de
        ld a, (State.soupCans)
        dec a
        ld e, a
        ld d, 0
        add hl, de
        ld a, (hl)              ; damage points

        ld b, a
        ld a, (State.bossFight)
        or a
        jr NZ, .boss

        ; apply damage
        ld a, b
        add (iy+Obj.health)
        jr Z, .kill
        jr NC, .kill
        ld (iy+Obj.health), a
        ld (iy+Obj.blinkTime), 4

        ld a, Sound.damageEnemy
        call Sound.playSound
        jr .damaged

.kill:
        bit Flag.givesCoin, (iy+Obj.auxFlags)
        jp NZ, turnIntoCoin

        ; turn into explosion cloud
        bit Flag.isBig, (iy+Obj.flags)
        jr NZ, .big
        push ix
        push iy
        push iy : pop ix
        call Scene.makeObjectBig
        pop iy
        pop ix
.big:
        ld (iy+Obj.walkPhase), 0
        ld (iy+Obj.spriteSet), -1
        ld (iy+Obj.colour), Colour.brWhite
        ld a, Sound.explosion
        call Sound.playSound

.damaged:
        xor a
        ret

.notDamaged:
        scf
        ret

.boss:
        ld a, (State.bossInvinc)
        or a
        jr NZ, .damaged

        ld a, (State.bossHealth)
        add b                   ; `b`: damage points
        jr NC, .bossKilled

        ld (State.bossHealth), a
        ld a, Sound.damageEnemy
        call Sound.playSound

        push ix
        push de
        ld ix, Scene.obj2
        ld b, 4                 ; object count
        ld de, Obj              ; object size
.bossPartBlink:
        bit Flag.isBig, (ix+Obj.flags)
        jr Z, .l_6
        ld (ix+Obj.blinkTime), 4
.l_6:
        add ix, de
        djnz .bossPartBlink

        pop de
        pop ix
        jr .damaged

.bossKilled:
        push ix
        push de
        ld ix, Scene.obj2
        ld b, 4                 ; object count
        ld de, Obj              ; object size
.bossPartExplosion:
        bit Flag.exists, (ix+Obj.flags)
        jr Z, .l_9
        bit Flag.isBig, (ix+Obj.flags)
        jr Z, .l_9
        ; turn into explosion cloud
        ld (ix+Obj.walkPhase), 0
        ld (ix+Obj.spriteSet), -1
        ld (ix+Obj.colour), Colour.brWhite
.l_9:
        add ix, de
        djnz .bossPartExplosion

        pop de
        pop ix
        ld a, -1
        ld (State.bossKilled), a

        ; level complete
        ld de, Panel.scoreTable.done
        call Panel.addScoreRaw
        ld a, (State.level)
        ld hl, State.levelsDone
        ld e, a
        ld d, 0
        add hl, de
        ld (hl), 1

        ld a, Sound.explosion
        call Sound.playSound
        jr .damaged

    ENDMODULE
