    MODULE Hero

alreadyInAttack:
        ; `a`: attack
        ld ix, Scene.obj1       ; bullet, bomb, or bubble
        cp Attack.kick
        jr NZ, .notKicking

.kicking:
        ld ix, Scene.hero
        ld hl, State.attackTime
        ld a, (hl)
        or a
        jr Z, .endKicking

        dec (hl)
        ld hl, cS.heroKicks
        ld (ix+Obj.sprite+0), l
        ld (ix+Obj.sprite+1), h
        ret

.endKicking:
        ld a, (State.heroState)
        or a
        jr NZ, .skipStanding
        ld hl, cS.heroStands
        ld (ix+Obj.sprite+0), l
        ld (ix+Obj.sprite+1), h
.skipStanding:
        xor a
        ld (State.attack), a
        ld ix, Scene.obj1       ; kick bubble
        ld (ix+Obj.flags), a    ; remove object
        ret

.notKicking:
        cp Attack.throw
        jp NZ, .bulletIsFlying

.bombIsFlying:
        ld hl, State.attackTime
        ld a, (hl)
        or a
        jr Z, .skipThrowing

        dec (hl)
        push ix
        ld ix, Scene.hero
        ld hl, cS.heroThrows
        ld (ix+Obj.sprite+0), l
        ld (ix+Obj.sprite+1), h
        pop ix

.skipThrowing:
        ld a, (State.blowUpTime)
        or a
        jp NZ, .bombIsExploding

        call Enemy.checkEnemiesForDamage
        jr NC, .bombExploded

        ld a, (State.bombTime)
        ld l, a
        ld h, 0
        ld de, bombVerticalVelocity
        add hl, de
        ld a, (hl)              ; bomb vertical velocity
        cp #80                  ; end marker
        jr Z, .bombFalls

        ld hl, State.bombTime
        inc (hl)
        ld (ix+Obj.mo.vertSpeed), a

.bombFalls:
        ld a, (ix+Obj.mo.vertSpeed)
        add (ix+Obj.y)
        ld (ix+Obj.y), a

        call Scene.isObjectVisible
        jp NC, .removeBombOrBullet      ; if outside the screen

        ; check tile at the bomb's location
        ld a, (ix+Obj.x+0)
        add 4
        ld (ix+Obj.x+0), a
        ld a, (ix+Obj.x+1)
        adc a, 0
        ld (ix+Obj.x+1), a

        call Tiles.getScrTileAddr     ; `hl`: tile addr

        ld a, (ix+Obj.x+0)
        add -4
        ld (ix+Obj.x+0), a
        ld a, (ix+Obj.x+1)
        adc a, -1
        ld (ix+Obj.x+1), a

        ld a, (hl)
        call Tiles.getTileType
        cp TileType.ladderTop
        ret C                   ; space or ladder

.bombExploded:
        ld a, Sound.explosion
        call Sound.playSound

        ; turn into explosion cloud
        ld a, (ix+Obj.x+0)
        add -4
        ld (ix+Obj.x+0), a
        ld a, (ix+Obj.x+1)
        adc a, -1
        ld (ix+Obj.x+1), a

        ld a, (ix+Obj.y)
        add -8
        ld (ix+Obj.y), a

        xor a
        ld (State.blowUpTime), a
        ld (ix+Obj.mo.direction), a
        set Flag.isBig, (ix+Obj.flags)

        ; choose explosion phases depending on soup can count
        ld a, (State.soupCans)
        dec a
        ld (.soup), a

.bombIsExploding:
.soup+* ld l, -0
        ld h, 0
    .3  add hl, hl
        ld de, bombExplosionPhases
        add hl, de
        ex de, hl               ; `de`: phase list

        ld a, (State.blowUpTime)
        inc a
        ld (State.blowUpTime), a
        srl a
        jr Z, .skipDec
        dec a
.skipDec:
        ld l, a
        ld h, 0
        add hl, de
        ld a, (hl)              ; explosion phase
        cp -1                   ; end marker
        jr Z, .removeBombOrBullet

        ; get explosion sprite
        ld l, a
        ld h, 0
        add hl, hl
        ld de, explosionSprites
        add hl, de
        ld a, (hl)
        inc hl
        ld h, (hl)

        ; set explosion sprite
        ld (ix+Obj.sprite+0), a
        ld (ix+Obj.sprite+1), h
        ld (ix+Obj.colour), Colour.brWhite
        jp Enemy.checkEnemiesForDamage

.removeBombOrBullet:
        xor a
        ld (ix+Obj.flags), a    ; remove object
        ld (State.attack), a
        ld (State.blowUpTime), a
        ld (selfGuidedTime), a
        ret

.bulletIsFlying:
        call Scene.isObjectVisible
        jr NC, .removeBombOrBullet

        ; check tile at the bullet's location
        ld a, (ix+Obj.x)
        add 4
        ld (ix+Obj.x), a
        ld a, (ix+Obj.x+1)
        adc a, 0
        ld (ix+Obj.x+1), a
        ld a, (ix+Obj.y)
        add 8
        ld (ix+Obj.y), a

        call Tiles.getScrTileAddr     ; `hl`: tile addr

        ld a, (ix+Obj.x)
        add -4
        ld (ix+Obj.x), a
        ld a, (ix+Obj.x+1)
        adc a, -1
        ld (ix+Obj.x+1), a
        ld a, (ix+Obj.y)
        add -8
        ld (ix+Obj.y), a

        ld a, (hl)
        call Tiles.getTileType
        cp TileType.ladderTop
        jp NC, .removeBombOrBullet

        ; space or ladder
        call Enemy.checkEnemiesForDamage
        jr NC, .removeBombOrBullet

        ; check if the bullet is self-guided
        ld a, (State.attack)
        cp Attack.power
        ret NZ
        ld a, (State.soupCans)
        cp 3
        jr Z, selfGuidedBullet
        ret

    ENDMODULE
