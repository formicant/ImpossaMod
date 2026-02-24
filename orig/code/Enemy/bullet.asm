    MODULE Enemy

; Tick the enemy bullet emission timer
; Used by c_cc25.
enemyBulletTimer:  ; #f553
        ld a, (State.bulletTime)
        or a
        jr Z, .setPeriod
        dec a
        ld (State.bulletTime), a
        ret

.setPeriod:
        ld a, 60
        ld (State.bulletTime), a
        ret


; Emit enemy bullet
;   arg `ix`: object
; Used by c_ed08.
emitEnemyBullet:  ; #f564
        ld a, (State.bulletTime)
        or a
        ret NZ
        ld a, (ix+Obj.mo.type)
        cp Motion.bullet
        ret Z
        ld a, (ix+Obj.emitBullets)
        or a
        ret Z

        push ix
        call Scene.allocateObject
        push ix : pop iy
        pop ix
        ret NC                  ; ret if no place for new object
        ; `iy`: new object addr

        ld hl, cS.powerBullet1
        ld (iy+Obj.sprite+0), l
        ld (iy+Obj.sprite+1), h
        ld (iy+Obj.spriteSet), 0
        ld (iy+Obj.colour), Colour.brWhite
        ld (iy+Obj.mo.direction), 0
        ld (iy+Obj.mo.horizSpeed), 5
        ld (iy+Obj.mo.vertSpeed), 3
        ld (iy+Obj.width), 6
        ld (iy+Obj.height), 6
        ld (iy+Obj.health), 1
        ld (iy+Obj.flags), 1<<Flag.exists
        ld (iy+Obj.objType), ObjType.bullet
        ld (iy+Obj.mo.type), Motion.bullet
        ld (iy+Obj.auxFlags), 0
        ld a, (ix+Obj.emitBullets)
        ld (iy+Obj.emitBullets), a

        ; set x coord
        ld a, (ix+Obj.width)
        sub (iy+Obj.width)
        srl a
        ld e, a
        ld d, 0
        ld l, (ix+Obj.x+0)
        ld h, (ix+Obj.x+1)
        add hl, de
        ld (iy+Obj.x+0), l
        ld (iy+Obj.x+1), h
        ld a, (ix+Obj.height)
        sub (iy+Obj.height)

        ; set y coord
        srl a
        add (ix+Obj.y)
        ld (iy+Obj.y), a

        ; define bullet direction
        ld a, (iy+Obj.emitBullets)
        cp EmitBullets.aim
        jr Z, .aim

        cp EmitBullets.forward
        jr NZ, .vertical
        ld a, (ix+Obj.mo.direction)
        and Dir.horizontal
        ld (iy+Obj.mo.direction), a
        ret

.vertical:
        cp EmitBullets.up
        jr NZ, .down
        ld (iy+Obj.mo.direction), 1<<Dir.up
        ret

.down:
        cp EmitBullets.down
        ret NZ
        ld (iy+Obj.mo.direction), 1<<Dir.down
        ret

.aim:
        push ix
        push iy : pop ix        ; `ix`: bullet
        ld a, 4
        call aimAtHero
        pop ix
        ret

; Move an enemy bullet and check collision
; Used by c_ed08.
bulletMotion:  ; #f618
        ld a, (ix+Obj.emitBullets)
        cp 1
        call Z, aimedBulletMotion

        ld iy, Scene.hero
        call Scene.checkObjectCollision
        jr C, .noCollision

.collision:
        ld (ix+Obj.flags), 0    ; remove bullet
        ld b, (ix+Obj.health)   ; bullet's damage
        ld a, (iy+Obj.blinkTime)
        or a
        ret NZ                  ; ret if hero blinks

        ; decrement hero's energy
        ld a, (State.energy)
        sub b
        jr NC, .heroAlive
        ld a, -1
        ld (State.isDead), a
        xor a
.heroAlive:
        ld (State.energy), a
        ld (iy+Obj.blinkTime), 7
        jp Panel.printEnergy

.noCollision:
        ld a, (State.level)
        or a                    ; Klondike?
        jr NZ, .tileCheck
        ld a, (State.bossFight)
        or a
        jr NZ, .skipTileCheck   ; skip if Klondike boss

.tileCheck:
        call Tiles.getScrTileAddr
        ld a, (hl)
        call Tiles.getTileType
        cp TileType.wall
        jr C, .skipTileCheck    ; passable (space, ladder, platform)

        ; non-passable (wall, conveyor, ice, slow, water/spikes)
        ld (ix+Obj.flags), 0    ; remove bullet
        ret

.skipTileCheck:
        call Scene.isObjectVisible
        ret C                   ; ret if visible
        ; invisible
        ld (ix+Obj.flags), 0    ; remove bullet
        ret

    ENDMODULE
