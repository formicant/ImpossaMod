    MODULE Code

; Hero's x coord stored here temporarily
tmpHeroX:  ; #e6df
        dw -0

; Find collisions between the hero and other objects and do appropriate action
; Used by c_cc25.
processHeroCollisions:  ; #e6e1
        ld a, (State.inShop)
        or a
        ret NZ

        ld ix, Scene.hero
        ld l, (ix+Obj.x+0)
        ld h, (ix+Obj.x+1)
        ld (tmpHeroX), hl
    .4  inc hl
        ld (ix+Obj.x+0), l
        ld (ix+Obj.x+1), h

        ld iy, Scene.obj2
        ld b, 6                 ; object count
.object:
        push bc
        call Scene.checkObjectCollision
        pop bc
        jr NC, .collision
        ld de, Obj              ; object size
        add iy, de
        djnz .object

        ld hl, (tmpHeroX)
        ld (ix+Obj.x+0), l
        ld (ix+Obj.x+1), h
        ret

.collision:
        ld hl, (tmpHeroX)
        ld (ix+Obj.x+0), l
        ld (ix+Obj.x+1), h

        ld a, (iy+Obj.objType)
        cp ObjType.pressPlatf
        jp NC, .levelSpecific
        or a                    ; no type
        ret Z

        cp ObjType.soupCan
        jr NC, .l_2

        ; weapon
        exa
        ld a, (State.attack)
        or a
        ret NZ
        exa
        ld (State.weapon), a
        ld hl, 750
        ld (State.weaponTime), hl
        ld (iy+Obj.flags), 0    ; remove object
        ld a, Sound.pickWeapon
        jp Sound.playSound

.l_2:
        cp ObjType.shopMole
        jr Z, .skipSound
        push af
        ld a, Sound.pickItem
        call Sound.playSound
        pop af
.skipSound:

        cp ObjType.soupCan
        jr NZ, .notSoupCan
        ld a, (State.soupCans)
        cp 3
        jr Z, .maxSoupCans
        inc a
        ld (State.soupCans), a
.maxSoupCans:
        ld (iy+Obj.flags), 0    ; remove object
        jp Panel.printSoupCans

.notSoupCan:
        cp ObjType.slimyWorms
        jr NZ, .notSlimyWorms
        ld (iy+Obj.flags), 0    ; remove object
        ld a, 4
        jp addEnergy

.notSlimyWorms:
        cp ObjType.coin
        jr NZ, .notCoin
        ld (iy+Obj.flags), 0    ; remove object
        ld a, (State.coins)
    IFDEF _MOD
        inc a                   ; coin denomination
    ELSE
        add 25
    ENDIF
        ld (State.coins), a
        jp Panel.printCoinCount

.notCoin:
        cp ObjType.pintaADay
        jr NZ, .notPintaADay
        ld (iy+Obj.flags), 0    ; remove object
        ld a, (State.maxEnergy)
        add 4
        cp 34
        jr C, .addMaxEnergy
        ld a, 34
.addMaxEnergy:
        ld (State.maxEnergy), a
        ld a, 4
        jp addEnergy

.notPintaADay:
        cp ObjType.diary
        jr NZ, .notDiary
        ld (iy+Obj.flags), 0    ; remove object
        ld a, #FF
        ld (State.hasDiary), a
        ret

.notDiary:
        cp ObjType.scoreItem1
        jr NC, .scoreItem

        ; shop mole
        ld a, (Control.controlState)
        bit Key.down, a
        ret Z
        ld (iy+Obj.flags), 0    ; remove object
        ld a, #FF
        ld (State.inShop), a
        ret

.scoreItem:
        ld (iy+Obj.flags), 0    ; remove object
        ld a, (iy+Obj.score)
        jp Panel.addScore

.levelSpecific:
        cp ObjType.pressPlatf
        jr NZ, .notPress

        ; TODO: press logic
        bit Dir.up, (iy+Obj.mo.direction)
        ret NZ
        ld a, (State.pressTime)
        or a
        ret NZ
        ld a, (State.heroState)
        cp 2
        jr C, .l_13
        ret NZ
        call heroWalks.fall
        ld a, (State.heroState)
        or a
        ret NZ
.l_13:
        ld a, 50
        ld (State.pressTime), a

.notPress:
        ld a, (iy+Obj.spriteSet)
        cp SpriteSet.explosion
        ret Z                   ; is exploding
        bit Flag.riding, (iy+Obj.auxFlags)
        ret NZ                  ; is rideable
        ld a, (iy+Obj.health)
        cp -2                   ; not an enemy (?)
        ret Z
        jp decEnergy

    ENDMODULE
