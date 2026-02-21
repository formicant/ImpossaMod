    MODULE Code


; (Modifies some object properties?)
; Used by c_cc25.
moveObjects:  ; #e56f
        ld ix, Scene.obj1
        ld b, 7                 ; object count
.object:
        push bc
        call moveObject
        ld bc, Obj              ; object size
        add ix, bc
        pop bc
        djnz .object
        ret


; (Modifies some object properties?)
; Used by c_e56f.
moveObject:  ; #e582
        bit Flag.exists, (ix+Obj.flags)
        ret Z

        ld a, (ix+Obj.stillTime)
        or a
        ret NZ
        bit Flag.waiting, (ix+Obj.flags)
        ret NZ

.horizontal:
        bit Flag.fixedX, (ix+Obj.flags)
        jr NZ, .vertical

        bit Dir.right, (ix+Obj.mo.direction)
        jr Z, .left
        ; move right
        ld e, (ix+Obj.mo.horizSpeed)
        ld d, 0
        ld l, (ix+Obj.x+0)
        ld h, (ix+Obj.x+1)
        add hl, de
        ld (ix+Obj.x+0), l
        ld (ix+Obj.x+1), h
        jr .vertical
.left:
        bit Dir.left, (ix+Obj.mo.direction)
        jr Z, .vertical
        ; move left
        ld a, (ix+Obj.mo.horizSpeed)
        neg
        ld e, a
        ld d, -1
        ld l, (ix+Obj.x+0)
        ld h, (ix+Obj.x+1)
        add hl, de
        ld (ix+Obj.x+0), l
        ld (ix+Obj.x+1), h

.vertical:
        bit Flag.fixedY, (ix+Obj.flags)
        ret NZ

        bit Dir.up, (ix+Obj.mo.direction)
        jr Z, .down
        ; move up
        ld a, (ix+Obj.mo.vertSpeed)
        neg
        add (ix+Obj.y)
        ld (ix+Obj.y), a
        ret
.down:
        bit Dir.down, (ix+Obj.mo.direction)
        ret Z
        ; move down
        ld a, (ix+Obj.mo.vertSpeed)
        add (ix+Obj.y)
        ld (ix+Obj.y), a
        ret


; Mark all scene objects except the hero as non-existent
; Used by c_cc25, c_e60a, c_e920 and c_e9b1.
removeObjects:  ; #e5f2
        push ix
        push de
        ld de, Obj
        ld ix, Scene.obj1
        ld b, 7
.object:
        ld (ix+Obj.flags), 0    ; remove object
        add ix, de
        djnz .object

        pop de
        pop ix
        ret


; Check if the hero enters a transit
; Used by c_cc25.
checkTransitEnter:  ; #e60a
        ld ix, Scene.hero
        ld a, (State.jumpPhase)
        ld (State.tmpJumpPh), a

        ld a, (ix+Obj.y)
        ld (State.tmpY), a
        cp 11
        jp C, .up
        cp 224
        jr NC, .down
        ret
.up:
        xor a
        exa
        ld (ix+Obj.y), 224      ; appear from the bottom
        xor a
        ld (State.jumpPhase), a
        jr .l_2
.down:
        ld a, 1
        exa
        ld (ix+Obj.y), 12       ; appear from the top

.l_2:
        ld de, Level.transitTable
        ld l, (ix+Obj.x+0)
        ld h, (ix+Obj.x+1)
        ld bc, -22
        add hl, bc
    DUP 3
        sra h
        rr l
    EDUP
        ; `hl`: screen x coord in tiles
        ld bc, (State.screenX)
        add hl, bc
    DUP 2
        sra h
        rr l
    EDUP
        ld (.mapX), hl          ; map x coord in blocks

.findTransit:
        exa
        ld c, a                 ; 0: up, 1: down
        exa
        ld a, (de)              ; isDown
        cp c
        jr NZ, .next
        inc de
        ld a, (de)              ; fromX (low)
        ld c, a
        inc de
        ld a, (de)              ; fromX (high)
        ld b, a
        xor a
.mapX+* ld hl, -0
        sbc hl, bc
        jr Z, .found
    .2  dec de
.next:
        ld hl, Transit          ; struct size
        add hl, de
        ex de, hl
        ld a, (de)
        or a
        jp P, .findTransit

.notFound:
        ld a, (State.tmpY)
        ld (ix+Obj.y), a
        ld a, (State.tmpJumpPh)
        ld (State.jumpPhase), a
        ret

.found:
        ld a, 60
        ld (State.bulletTime), a
        call removeObjects

        ld hl, 5
        add hl, de
        ld a, (hl)              ; toX
    .5  add a
        add 32
        ld (ix+Obj.x+0), a
        ld (ix+Obj.x+1), 0

        ld de, -4
        add hl, de
        ld e, (hl)              ; toStart (low)
        inc hl
        ld d, (hl)              ; toStart (high)
        inc hl
        ld a, (hl)              ; toEnd (low)
        inc hl
        ld h, (hl)              ; toEnd (high)
        ld l, a
    .2  add hl, hl
        ex de, hl
    .2  add hl, hl
        ; `hl`: toStart in tiles, `de`: toEnd in tiles
        call removeObjects      ; unnecessary
        call moveToMapSpan
        xor a
        ret


; Get address for a new object in `Scene`
;   ret `ix`: object addr
;       `C` flag iff there is place for a new object
; Used by c_f564 and c_f74a.
allocateObject:  ; #e6c2
        push de
        push bc
        ld b, 6                 ; object count
        ld ix, Scene.obj2
        ld de, Obj              ; object size
.object:
        bit Flag.exists, (ix+Obj.flags)
        jr Z, .free
        add ix, de
        djnz .object

        xor a
        pop bc
        pop de
        ret
.free:
        scf
        pop bc
        pop de
        ret


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
        call checkObjectCollision
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
        jp playSound

.l_2:
        cp ObjType.shopMole
        jr Z, .skipSound
        push af
        ld a, Sound.pickItem
        call playSound
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
        jp printSoupCans

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
        jp printCoinCount

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
        ld a, (controlState)
        bit Key.down, a
        ret Z
        ld (iy+Obj.flags), 0    ; remove object
        ld a, #FF
        ld (State.inShop), a
        ret

.scoreItem:
        ld (iy+Obj.flags), 0    ; remove object
        ld a, (iy+Obj.score)
        jp addScore

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


; Check if there is a collision between two objects
;   arg `ix`: object 1
;       `iy`: object 2
;   ret flag C: no collision, NC: collision
; Used by c_e6e1, c_e9b1, c_eb19 and c_f618.
checkObjectCollision:  ; #e80a
        bit Flag.exists, (iy+Obj.flags)
        jr NZ, .obj2Exists
        scf
        ret

.obj2Exists:
        ; object 1 size
        ld d, (ix+Obj.height)
        ld e, (ix+Obj.width)
        ; object 2 size
        ld b, (iy+Obj.height)
        ld c, (iy+Obj.width)

        ld a, (ix+Obj.y)
        ld l, a                 ; `l`: object 1 top
        add d                   ; `a`: object 1 bottom
        ld h, (iy+Obj.y)        ; `h`: object 2 top
        cp h
        ret C                   ; object 2 is below object 1

        ld a, h
        add b                   ; `a`: object 2 bottom
        cp l
        ret C                   ; object 1 is above object 1

        ld l, (ix+Obj.x+0)
        ld h, (ix+Obj.x+1)
        push hl                 ; object 1 left
        ld d, 0
        add hl, de              ; `hl`: object 1 right
        ld e, (iy+Obj.x+0)
        ld d, (iy+Obj.x+1)      ; `de`: object 2 left
        ld a, (iy+Obj.objType)
        cp ObjType.pressPlatf
        jr NZ, .notPressLeft
        ld a, e
        add 6
        ld e, a
.notPressLeft:
        or a
        sbc hl, de
        pop hl                  ; object 1 left
        ret C                   ; object 2 is to the right from object 1

        ex de, hl
        ld b, 0
        ld a, (iy+Obj.objType)
        cp ObjType.pressPlatf
        jr NZ, .notPressRight
        ld a, c                 ; object 2 width
        sub 12
        ld c, a
.notPressRight:
        add hl, bc              ; `hl`: object 2 right
        or a
        sbc hl, de              ; C if object 2 is to the left from object 1
        ret                     ; NC if there is a collision


; (Some table, 5 levels * 6 words)
shopTransits:     ;   shop entrance       shop exit
                  ; start  end  x  y  start  end   x  y
.lev0:  ShopTransit 1640, 1640, 4, 4,  940, 1044,  2, 1
.lev1:  ShopTransit 1640, 1672, 5, 4,  692,  888,  5, 4
.lev2:  ShopTransit 1640, 1672, 5, 4, 1240, 1272, 11, 2
.lev3:  ShopTransit 1644, 1676, 3, 4, 1272, 1328,  2, 4
.lev4:  ShopTransit 1644, 1676, 5, 4, 1408, 1600,  4, 3

; Item prices in the shop
shopItemPrices:  ; #e89b
    IFDEF _MOD
        db 5, 6, 7, 10, 3, 1, 8, 4, 0   ; coin denomination
    ELSE
        db 125, 150, 175, 250, 75, 1, 200, 100, 0
    ENDIF

; Item names in the shop
shopItemNames:  ; #e8a4
        db "SHATTERBOMB "C
        db "POWER GUN   "C
        db "LAZER GUN   "C      ; (typo)
        db "SOUP CAN    "C
        db "SLIMY WORMS "C
        db "            "C
        db "PINTA A DAY "C
        db "DIARY       "C
        db "   EXIT SHOP"C

; "TOO MUCH"
textTooMuch:  ; #e910
        db "   TOO MUCH     "C


; Place the hero into the shop
; Used by c_cc25.
enterShop:  ; #e920
        ld a, (State.inShop)
        bit 7, a
        ret Z

        call removeObjects

        ld a, (State.level)
    .2  add a
        ld l, a
        add a
        add l
        ld l, a
        ld h, 0
        ld de, shopTransits
        add hl, de

        ld e, (hl)
        inc hl
        ld d, (hl)
        push de                 ; shop span start
        inc hl
        ld e, (hl)
        inc hl
        ld d, (hl)
    .4  dec de                  ; shop span end
        inc hl
        call placeHero
        pop hl
        call moveToMapSpan

        ld a, #7F
        ld (State.inShop), a

        call findAndPutObjectsToScene

        ; find shop mole
        ld ix, Scene.obj2
        ld b, 6                 ; object count
        ld de, Obj              ; object size
.object:
        ld a, (ix+Obj.objType)
        or a
        jr Z, .initShopMole
        add ix, de
        djnz .object

.initShopMole:
        ld iy, Scene.hero
        ld a, (iy+Obj.x+0)
        add 32
        ld (ix+Obj.x+0), a
        ld (ix+Obj.x+1), 0

        ld a, (iy+Obj.y)
        add 11
        ld (ix+Obj.y), a

        ld hl, cS.shopMole
        ld (ix+Obj.sprite+0), l
        ld (ix+Obj.sprite+1), h
        ld (ix+Obj.colour), Colour.brWhite

        ld (ix+Obj.mo.direction), 0
        ld (ix+Obj.width), 24
        ld (ix+Obj.height), 21
        ld (ix+Obj.objType), ObjType.shopMole
        ld (ix+Obj.flags), (1<<Flag.exists) | (1<<Flag.isBig)
        ld (ix+Obj.health), -2
        ld (ix+Obj.auxFlags), 0
        ld (ix+Obj.emitBullets), 0
        ld (ix+Obj.mo.type), Motion.none
        ret

; Shop logic
; Used by c_cc25.
shopLogic:  ; #e9b1
        ld a, (State.inShop)
        cp #7F
        ret NZ

        ; find item where hero stands
        ld ix, Scene.hero
        ld iy, Scene.obj2
        ld b, 6                 ; object count
.object:
        push bc
        call checkObjectCollision
        pop bc
        jr NC, .found
        ld de, Obj              ; object size
        add iy, de
        djnz .object
    IFDEF _MOD
        jp printPanel
    ELSE
        jp printEnergy
    ENDIF

.found:
    IFDEF _MOD
        call clearEnergy
    ENDIF

        ld a, (iy+Obj.objType)
        or a
        ret Z

        ; get item name
        dec a
        ld (State.shopItem), a
        ld l, a
        ld h, 0
    .2  add hl, hl
        ld e, l
        ld d, h
        add hl, hl
        add hl, de
        ld de, shopItemNames
        add hl, de
        ex de, hl
        ; `hl`: item name
        ld c, Colour.brWhite
        ld hl, #000F            ; at 0, 15
        call printString

        ; get item price
        ld a, (State.shopItem)
        ld l, a
        ld h, 0
        ld de, shopItemPrices
        add hl, de
        ld a, (hl)
        ld (State.shopPrice), a
        or a
        jr Z, .skipPrice

    IFDEF _MOD
        call printPrice
    ELSE
        ld hl, #001C            ; at 0, 28
        ld c, Colour.brWhite
        call printNumber
    ENDIF

.skipPrice:
        ld a, (controlState)
        bit Key.fire, a
        ret Z

        ld a, (State.shopPrice)
        or a
        jr NZ, .buyItem

        ; exit shop
        call removeObjects
        ld a, (State.level)
    .2  add a
        ld l, a
        add a
        add l
        ld l, a
        ld h, 0
        ld de, shopTransits
        add hl, de
        ld de, 6
        add hl, de
        ; `hl` = c_e85f + level * 12 * 6
        ld e, (hl)
        inc hl
        ld d, (hl)
        push de                 ; span start
        inc hl
        ld e, (hl)
        inc hl
        ld d, (hl)
    .4  dec de                 ; span end
        inc hl
        call placeHero
        pop hl                 ; span start
        call moveToMapSpan
        xor a
        ld (State.inShop), a
        ld (State.heroState), a

    IFDEF _MOD
        jp printPanel
    ELSE
        jp printEnergy
    ENDIF

.buyItem:
        ld a, (State.shopPrice)
        ld b, a
        ld a, (State.coins)
        sub b
        jr NC, .canBuy
        ld hl, #000F            ; at 0, 15
        ld de, textTooMuch
        ld c, Colour.brWhite
        call printString
.waitFireRelease:
        ld a, (controlState)
        bit Key.fire, a
        jr NZ, .waitFireRelease
        ret

.canBuy:
        ld (State.coins), a
        call printCoinCount
        ld (iy+Obj.flags), 0    ; remove object

        ld a, (State.shopItem)
        inc a
        cp 4
        jr NC, .notWeapon
        ld (State.weapon), a
        ld hl, 750
        ld (State.weaponTime), hl
        ret

.notWeapon:
        cp 4                    ; soup can
        jr NZ, .notSoupCan
        ld a, (State.soupCans)
        cp 3
        jr Z, .tooMuchSoup
        inc a
        ld (State.soupCans), a
.tooMuchSoup:
        ld (iy+Obj.flags), 0    ; remove object
        jp printSoupCans

.notSoupCan:
        cp 5                    ; slimy worms
        jr NZ, .notSlimyWorms
        ld (iy+Obj.flags), 0    ; remove object
        ld a, 4
        jp addEnergy

.notSlimyWorms:
        cp 7
        jr NZ, .notPintaADay
        ld (iy+Obj.flags), 0    ; remove object
        ld a, (State.maxEnergy)
        add 4
        cp 34
        jr C, .canIncrease
        ld a, 34
.canIncrease:
        ld (State.maxEnergy), a
        ld a, 4
        jp addEnergy

.notPintaADay:
        cp 8                    ; diary
        ret NZ

        ld (iy+Obj.flags), 0    ; remove object
        ld a, #FF
        ld (State.hasDiary), a
        ret


; Place hero by the coords from (hl)
;   arg `hl`: addr pointing to coords (x, y) in tiles relative to screen
; Used by c_e920 and c_e9b1.
placeHero:  ; #eace
        ld ix, Scene.hero
        ld a, (hl)
    .5  add a
        add 32
        ld (ix+Obj.x+0), a
        ld (ix+Obj.x+1), 0
        inc hl
        ld a, (hl)
    .5  add a
        add 32
        ld (ix+Obj.y), a
        ret


; Get tile type
;   arg `a`: tile index
;   ret `a`: tile type without fg/bg bit
; Used by c_d709, c_d7f6, c_d94c, c_da95, c_db4e, c_dbfc, c_de37,
; c_deb1, c_df85, c_f1d7, c_f2e7 and c_f618.
getTileType:  ; #eaee
        push hl
        ld h, high(Level.tileTypes)
        ld l, a
        ld a, (hl)
        and TileType.typeMask   ; remove fg/bg bit
        pop hl
        ret


; Sizes and x offsets of kick bubble collision boxes for 3 soup cans
kickBubbleSizes:  ; #eaf7
        ;  dx  w   h
        db 4, 16, 16            ; s
        db 2, 20, 20            ; ss
        db 0, 24, 24            ; sss


; Check if kick, bomb, or bullet damages any object in the scene
;   ret flag C if object is not damaged, NC if damaged
; Used by c_df85.
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
; Used by c_eb00.
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
        call checkObjectCollision

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
        call checkObjectCollision
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
        call checkObjectCollision
        pop hl
        ld (ix+Obj.x+0), l
        ld (ix+Obj.x+1), h
        ret C                   ; ret if no collision
        ; collision
        jr damageEnemy

.gun:
        ; check bullet collision
        call checkObjectCollision
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
; Used by c_eb19.
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
        call playSound
        jr .damaged

; This entry point is used by c_d4e5.
.kill:
        bit Flag.givesCoin, (iy+Obj.auxFlags)
        jp NZ, turnIntoCoin

        ; turn into explosion cloud
        bit Flag.isBig, (iy+Obj.flags)
        jr NZ, .big
        push ix
        push iy
        push iy : pop ix
        call makeObjectBig
        pop iy
        pop ix
.big:
        ld (iy+Obj.walkPhase), 0
        ld (iy+Obj.spriteSet), -1
        ld (iy+Obj.colour), Colour.brWhite
        ld a, Sound.explosion
        call playSound

.damaged:
        xor a
        ret

; This entry point is used by c_eb19.
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
        call playSound

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
        ld de, scoreTable.done
        call addScoreRaw
        ld a, (State.level)
        ld hl, State.levelsDone
        ld e, a
        ld d, 0
        add hl, de
        ld (hl), 1

        ld a, Sound.explosion
        call playSound
        jr .damaged


; For every object in the scene, process its motion
; Used by c_cc25.
performMotionOfAllObjs:  ; #ecee
        ld ix, Scene.obj2
        ld b, 6                 ; object count
.object:
        push bc
        push ix
        call checkStillEnemyActivation
        call performObjectMotion
        pop ix
        ld bc, Obj              ; object size
        add ix, bc
        pop bc
        djnz .object
        ret


; Check object motion type and do appropriate actions
;   arg `ix`: object
; Used by c_ecee.
performObjectMotion:  ; #ed08
        bit Flag.exists, (ix+Obj.flags)
        ret Z

        call emitEnemyBullet

        ld a, (ix+Obj.mo.type)
        cp Motion.bullet
        jp Z, bulletMotion

        bit Flag.waiting, (ix+Obj.flags)
        ret NZ

        ld a, (ix+Obj.objType)
        cp ObjType.pressPlatf
        jp Z, pressPlatformMotion

        call checkDynamiteExplosion

        ld a, (ix+Obj.mo.type)
        cp Motion.trajOrFall
        jr NZ, .skip
        call trajectoryMotion
        jp fallingMotion
.skip:
        cp Motion.trajectory
        call Z, trajectoryMotion

        ld a, (ix+Obj.mo.type)
        or a
        jp Z, .noMotion

        cp Motion.general
        jp Z, generalMotion
        cp Motion.trajectory
        jp Z, generalMotion     ; does nothing (?)

        cp Motion.selfGuided
        jp Z, selfGuidedMotion

        cp Motion.coinJump
        jp Z, coinJumpMotion

        ret

.noMotion:
        set Flag.fixedX, (ix+Obj.flags)
        set Flag.fixedY, (ix+Obj.flags)
        ret


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
        call makeObjectBig
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
        jp playSound

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


; Aim an enemy bullet shot at the hero
;   arg `ix`: bullet
;       `a`: bullet speed
; Used by c_f564.
aimAtHero:  ; #edc0
        ld (ix+Obj.aim.speed), a

        ld l, (ix+Obj.x+0)
        ld h, (ix+Obj.x+1)
        ld (ix+Obj.aim.curX+0), l
        ld (ix+Obj.aim.curX+1), h
        push hl

        ld a, (ix+Obj.y)
        ld (ix+Obj.aim.curY+0), a
        ld (ix+Obj.aim.curY+1), 0

        ; find hero's centre minus half bullet size
        ld iy, Scene.hero
        ld l, (iy+Obj.x+0)
        ld h, (iy+Obj.x+1)
        ld a, (iy+Obj.width)
        srl a
        sub 3                   ; half bullet width
        ld e, a
        ld d, 0
        add hl, de
        ld (ix+Obj.aim.tgtX+0), l ; never used again(?)
        ld (ix+Obj.aim.tgtX+1), h ; never used again(?)
        push hl

        ld a, (iy+Obj.height)
        srl a
        sub 3                   ; half bullet height
        add (iy+Obj.y)
        ld (ix+Obj.aim.tgtY+0), a
        ld (ix+Obj.aim.tgtY+1), 0

        pop hl                  ; aim.tgtX
        pop de                  ; aim.curX
        xor a
        sbc hl, de
        ex de, hl               ; `de`: signed x difference

        ld c, (ix+Obj.aim.curY+0)
        ld b, (ix+Obj.aim.curY+1)
        ld l, (ix+Obj.aim.tgtY+0)
        ld h, (ix+Obj.aim.tgtY+1)
        xor a
        sbc hl, bc              ; `hl`: signed y difference

        ; check sign of x difference
        bit 7, d
        jp M, .negX             ; should work like `jp NZ`

.posX:
        ld (ix+Obj.aim.dirX+0), 1
        ld (ix+Obj.aim.dirX+1), 0
        jr .distX

.negX:
        ld (ix+Obj.aim.dirX+0), low(-1)
        ld (ix+Obj.aim.dirX+1), high(-1)
        ; `neg de`
        ld a, d
        cpl
        ld d, a
        ld a, e
        cpl
        ld e, a
        inc de

.distX:
        ; `de` unsigned x distance
        ld (ix+Obj.aim.distX+0), e
        ld (ix+Obj.aim.distX+1), d

        ; check sign of y difference
        ld a, h
        or l
        jr Z, .zeroY
        bit 7, h
        jp M, .negY             ; should work like `jp NZ`

.posY:
        ld (ix+Obj.aim.dirY+0), 1
        ld (ix+Obj.aim.dirY+1), 0
        ld (ix+Obj.aim.phase+0), 0
        ld (ix+Obj.aim.phase+1), 0
        jr .distY

.zeroY:
        ld (ix+Obj.aim.dirY+0), 1
        ld (ix+Obj.aim.dirY+1), 0
        ld (ix+Obj.aim.phase+0), low(-1)
        ld (ix+Obj.aim.phase+1), high(-1)
        jr .distY

.negY:
        ld (ix+Obj.aim.dirY+0), low(-1)
        ld (ix+Obj.aim.dirY+1), high(-1)
        ld (ix+Obj.aim.phase+0), 0
        ld (ix+Obj.aim.phase+1), 0
        ; `neg hl`
        ld a, h
        cpl
        ld h, a
        ld a, l
        cpl
        ld l, a
        inc hl

.distY:
        ld (ix+Obj.aim.distY+0), l
        ld (ix+Obj.aim.distY+1), h

        ; why?
        ld (ix+Obj.aim.tgtY+0), 0
        ld (ix+Obj.aim.tgtY+1), 0
        ret


; Move enemy bullet along a line towards aimed target
; Used by c_f618.
aimedBulletMotion:  ; #ee93
        ld a, (ix+Obj.spriteSet)
        cp -1
        ret Z

        ld b, (ix+Obj.aim.speed)

        ld e, (ix+Obj.aim.distX+0)
        ld d, (ix+Obj.aim.distX+1)
        ld l, (ix+Obj.aim.distY+0)
        ld h, (ix+Obj.aim.distY+1)
        xor a
        sbc hl, de
        jr NC, .stepByY         ; dy >= dx

.stepByX:
        ld a, (ix+Obj.aim.phase+0)
        or a
        jp M, .moveHoriz

        ; move vertically
        ld l, (ix+Obj.aim.curY+0)
        ld h, (ix+Obj.aim.curY+1)
        ld e, (ix+Obj.aim.dirY+0)
        ld d, (ix+Obj.aim.dirY+1)
        add hl, de
        ld (ix+Obj.aim.curY+0), l
        ld (ix+Obj.aim.curY+1), h

        ; adjust phase
        ld e, (ix+Obj.aim.distX+0)
        ld d, (ix+Obj.aim.distX+1)
        ld l, (ix+Obj.aim.phase+0)
        ld h, (ix+Obj.aim.phase+1)
        xor a
        sbc hl, de
        ld (ix+Obj.aim.phase+0), l
        ld (ix+Obj.aim.phase+1), h

.moveHoriz:
        ld l, (ix+Obj.aim.curX+0)
        ld h, (ix+Obj.aim.curX+1)
        ld e, (ix+Obj.aim.dirX+0)
        ld d, (ix+Obj.aim.dirX+1)
        add hl, de
        ld (ix+Obj.aim.curX+0), l
        ld (ix+Obj.aim.curX+1), h

        ; adjust phase
        ld l, (ix+Obj.aim.distY+0)
        ld h, (ix+Obj.aim.distY+1)
        ld e, (ix+Obj.aim.phase+0)
        ld d, (ix+Obj.aim.phase+1)
        add hl, de
        ld (ix+Obj.aim.phase+0), l
        ld (ix+Obj.aim.phase+1), h

        djnz .stepByX
        jr .setPosition

.stepByY:
        ld a, (ix+Obj.aim.phase+0)
        or a
        jp P, .moveVert

        ; move horizontally
        ld l, (ix+Obj.aim.curX+0)
        ld h, (ix+Obj.aim.curX+1)
        ld e, (ix+Obj.aim.dirX+0)
        ld d, (ix+Obj.aim.dirX+1)
        add hl, de
        ld (ix+Obj.aim.curX+0), l
        ld (ix+Obj.aim.curX+1), h

        ; adjust phase
        ld l, (ix+Obj.aim.distY+0)
        ld h, (ix+Obj.aim.distY+1)
        ld e, (ix+Obj.aim.phase+0)
        ld d, (ix+Obj.aim.phase+1)
        xor a
        add hl, de
        ld (ix+Obj.aim.phase+0), l
        ld (ix+Obj.aim.phase+1), h

.moveVert:
        ld l, (ix+Obj.aim.curY+0)
        ld h, (ix+Obj.aim.curY+1)
        ld e, (ix+Obj.aim.dirY+0)
        ld d, (ix+Obj.aim.dirY+1)
        add hl, de
        ld (ix+Obj.aim.curY+0), l
        ld (ix+Obj.aim.curY+1), h

        ; adjust phase
        ld e, (ix+Obj.aim.distX+0)
        ld d, (ix+Obj.aim.distX+1)
        ld l, (ix+Obj.aim.phase+0)
        ld h, (ix+Obj.aim.phase+1)
        xor a
        sbc hl, de
        ld (ix+Obj.aim.phase+0), l
        ld (ix+Obj.aim.phase+1), h

        djnz .stepByY

.setPosition:
        ld l, (ix+Obj.aim.curX+0)
        ld h, (ix+Obj.aim.curX+1)
        ld (ix+Obj.x+0), l
        ld (ix+Obj.x+1), h
        ld a, (ix+Obj.aim.curY+0)
        ld (ix+Obj.y), a
        xor a
        ret


; Choose motion type based on `motionSub`
;   arg `ix`: object
; Used by c_ed08.
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
        call generateRandom
        cp 10
        jr NC, .l_11
        ld a, (ix+Obj.mo.direction)
        xor Dir.vertical
        ld (ix+Obj.mo.direction), a
.l_11:
        bit 1, (ix+Obj.mo.coordConstr)
        jr Z, .l_12
        call generateRandom
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


; Remove object if it moved outside the screen
;   arg `ix`: object
removeIfOffScreen:
        call isObjectVisibleOrWaiting
        ret C
        ; if object became invisible
        ld (ix+Obj.flags), 0    ; remove object
        ret


; Move object towards the hero
;   arg `ix`: object
; Used by c_ed08.
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


; Get tile types behind different parts of the object and store them in the state
;   arg `ix`: object
; Used by c_ed08, c_ef72, c_f0f3 and c_f518.
collectTileTypes:  ; #f1d7
        bit Flag.isBig, (ix+Obj.flags)
        jr NZ, .big

.small:
        ; x + 8, y
        ld a, (ix+Obj.x+0)
        add 8
        ld (ix+Obj.x+0), a
        ld a, (ix+Obj.x+1)
        adc a, 0
        ld (ix+Obj.x+1), a
        call getScrTileAddr
        ld a, (hl)
        call getTileType
        ld (State.tTypeTop), a

        ; x + 8, y + 16
        ld de, 44 * 2           ; 2 tiles down
        add hl, de
        ld a, (hl)
        call getTileType
        ld (State.tTypeBot), a

        ; x, y + 8
        ld a, (ix+Obj.x+0)
        add -8
        ld (ix+Obj.x+0), a
        ld a, (ix+Obj.x+1)
        adc a, -1
        ld (ix+Obj.x+1), a
        call getScrTileAddr
        ld de, 44               ; 1 tile down
        add hl, de
        ld a, (hl)
        call getTileType
        ld (State.tTypeLeft), a

        ; x + 16, y + 8
    .2  inc hl                  ; 2 tiles right
        ld a, (hl)
        call getTileType
        ld (State.tTypeRight), a

        ; x, y + 16
        ld de, 44 - 2           ; 2 tiles down, 2 tiles left
        add hl, de
        ld a, (hl)
        call getTileType
        ld (State.tTypeBotL), a

        ; x + 16, y + 16
    .2  inc hl                  ; 2 tiles right
        ld a, (hl)
        call getTileType
        ld (State.tTypeBotR), a

        ret

.big:
        ; x + 12|8, y
        ld a, (ix+Obj.x+0)
        add 12
        ld (ix+Obj.x+0), a
        ld a, (ix+Obj.x+1)
        adc a, 0
        ld (ix+Obj.x+1), a
        call getScrTileAddr
        ld a, (ix+Obj.x+0)
        add -12
        ld (ix+Obj.x+0), a
        ld a, (ix+Obj.x+1)
        adc a, -1
        ld (ix+Obj.x+1), a
        bit Dir.left, (ix+Obj.mo.direction)
        jr NZ, .l_1
        dec hl                  ; 1 tile left
.l_1:
        ld a, (hl)
        call getTileType
        ld (State.tTypeTop), a

        ; (x + 12|8)|(x + 20|8), y + 24 (?)
        ld de, 44 * 3           ; 3 tiles down
        add hl, de
        ld a, (hl)
        call getTileType
        ld (State.tTypeBot), a
        inc hl                  ; 1 tile right
        bit Dir.left, (ix+Obj.mo.direction)
        jr NZ, .l_2
        dec hl                  ; 1 tile left
.l_2:
        ld a, (hl)
        call getTileType
        ld c, a
        ld a, (State.tTypeBot)
        or c
        ld (State.tTypeBot), a

        ; x, y + 16
        call getScrTileAddr
        ld a, (ix+Obj.objType)
        cp ObjType.amazon.crocodile
        jr Z, .l_3
        ld de, 44 * 2           ; 2 tiles down
        add hl, de
.l_3:
        ld a, (hl)
        call getTileType
        ld (State.tTypeLeft), a

        ; x + 24, y + 16
    .3  inc hl                  ; 3 tiles right
        ld a, (hl)
        call getTileType
        ld (State.tTypeRight), a

        ; x, y + 24
        ld de, 44 - 3           ; 1 tile down, 3 tiles left
        ld a, (ix+Obj.objType)
        cp ObjType.klondike.emptyMineCart
        jr Z, .l_4
        cp ObjType.klondike.fullMineCart
        jr NZ, .l_5
.l_4:
        ld de, 44 * 2 - 3       ; 2 tiles down, 3 tiles left
.l_5:
        add hl, de
        ld a, (hl)
        call getTileType
        ld (State.tTypeBotL), a

        ; x + 24, y + 24
    .3  inc hl                  ; 3 tiles right
        ld a, (hl)
        call getTileType
        ld (State.tTypeBotR), a

        ret


; Press vertical speed by walk phase (22 phases)
pressSpeedTable:  ; #f2d1
        db 0, 1, 1, 1, 1, 2, 2, 2, 3, 3, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4

; Move a press or a platform
;   arg `ix`: press/platform object
; Used by c_ed08.
pressPlatformMotion:  ; #f2e7
        ld a, (ix+Obj.mo.horizSpeed)
        or a
        jr Z, .vertical

        ; horizontal slow down
        dec (ix+Obj.mo.horizSpeed)
        ret

.vertical:
        bit Dir.down, (ix+Obj.mo.direction)
        jr NZ, .down

.notDown:
        ld a, (ix+Obj.walkPhase)
        or a
        jr NZ, .up

        ; change direction to horizontal
        ld (ix+Obj.mo.direction), 1<<Dir.down
        ld (ix+Obj.mo.vertSpeed), 0
        ld (ix+Obj.mo.horizSpeed), 32
        ret

.up:
        dec (ix+Obj.walkPhase)
        ld a, (ix+Obj.y)
        and %00000111
        jr NZ, .setVertSpeed

        ; clear press piston tiles
        call getScrTileAddr
        inc hl
        ld (hl), 0
        inc hl
        ld (hl), 0
        ; set tile update
        ld de, Tables.scrTileUpd - Tables.scrTiles - 2
        add hl, de
        ld (hl), 1
        inc hl
        ld (hl), 1
        jr .setVertSpeed

.down:
        inc (ix+Obj.walkPhase)

        ; draw press piston tiles
        call getScrTileAddr
        ; tile index
        ld c, 189
        ld a, (State.level)
        cp Level.iceland
        jr NZ, .drawPiston
        dec c
.drawPiston:
        inc hl
        ld (hl), c
        inc hl
        inc c                   ; next tile index
        ld (hl), c
        ; set tile update
        ld de, Tables.scrTileUpd - Tables.scrTiles - 2
        add hl, de
        ld (hl), 1
        inc hl
        ld (hl), 1

        ld a, (ix+Obj.y)
        and %00000111
        jr NZ, .setVertSpeed

        call getScrTileAddr
        ld de, 44 + 1
        add hl, de
        ld a, (hl)
        call getTileType
        or a
        jr NZ, .bottomReached

.setVertSpeed:
        ld a, (ix+Obj.walkPhase)
        ld l, a
        ld h, 0
        ld de, pressSpeedTable
        add hl, de
        ld a, (hl)
        ld (ix+Obj.mo.vertSpeed), a
        ret

.bottomReached:
        ; start moving up
        ld (ix+Obj.mo.direction), 1<<Dir.up
        ld (ix+Obj.mo.vertSpeed), 0
        ret


; Direction transform (bit 3← 2→ 1↓ 0↑) to (bit 3↑ 2↓ 1← 0→)
directionTransform:  ; #f373
        db 0
.up:    db %1000
.dn:    db %0100
        db 0
.lf:    db %0010
.upLf:  db %1010
.dnLf:  db %0110
        db 0
.rg:    db %0001
.upRg:  db %1001
.dnRg:  db %0101


; Move object along its trajectory
;   arg `ix`: object
; Used by c_ed08.
trajectoryMotion:  ; #f37e
        bit Flag.waiting, (ix+Obj.flags)
        ret NZ

        ; reset temp variables
        xor a
        ld (State.trajVel), a
        ld (State.trajDir), a

        ld a, (ix+Obj.mo.trajetory)
        add a
        ld l, a
        ld h, 0
        ld de, Level.trajVelTable
        add hl, de
        ld e, (hl)
        inc hl
        ld d, (hl)
        ; `de`: trajectory velocity list addr

        ld a, (ix+Obj.mo.trajetory)
        add a
        ld l, a
        ld h, 0
        ld bc, Level.trajDirTable
        add hl, bc
        ld c, (hl)
        inc hl
        ld b, (hl)
        ; `bc`: trajectory direction list addr

.getVel:
        ld l, (ix+Obj.mo.trajStep)
        ld h, 0
        add hl, de
        ld a, (hl)              ; velocity value or marker

        cp TrajMarker.last
        jr NZ, .notLast
        ; `last` marker: use the last vel/dir values forever
        dec hl
        ld a, (hl)
        ld (State.trajVel), a
        ; get direction
        ld l, (ix+Obj.mo.trajStep)
        ld h, 0
        add hl, bc
        dec hl
        ld a, (hl)
        ld (State.trajDir), a
        dec (ix+Obj.mo.trajStep)
        jr .transformDir

.notLast:
        cp TrajMarker.loop
        jr NZ, .notLoop
        ; `loop` marker: start the trajectory from the beginning
        ld (ix+Obj.mo.trajStep), 0
        jr .getVel

.notLoop:
        cp TrajMarker.stop
        jr NZ, .notStop
        ; `stop` marker: don't move any more
        dec (ix+Obj.mo.trajStep)
        jr .transformDir

.notStop:
        cp TrajMarker.back
        jr NZ, .notBack
        ; `back` marker: traverse the trajectory backwards
        ld (ix+Obj.mo.trajBack), -1
        dec (ix+Obj.mo.trajStep)
        jr .getVel

.notBack:
        ; `a`: velocity
        ld (State.trajVel), a
        ; get direction
        ld l, (ix+Obj.mo.trajStep)
        ld h, 0
        add hl, bc
        ld a, (hl)
        ld (State.trajDir), a

.transformDir:
        ; transform direction format
        ld a, (State.trajDir)
        ld l, a
        ld h, 0
        ld de, directionTransform
        add hl, de
        ld c, (hl)              ; direction as in `Dir` enum

        ld a, (ix+Obj.mo.trajBack)
        or a
        jr Z, .skipInvDir

        ; invert direction
        ld a, c
        and Dir.horizontal
        jr Z, .skipInvHoriz
        xor Dir.horizontal
.skipInvHoriz:
        ld b, a
        ld a, c
        and Dir.vertical
        jr Z, .skipInvVert
        xor Dir.vertical
.skipInvVert:
        or b
        ld c, a                 ; inverted direction

.skipInvDir:
        ld (ix+Obj.mo.trajDir), c
        ld a, (State.trajVel)
        bit Flag.riding, (ix+Obj.auxFlags) ; ?
        jr Z, .move
        ld (ix+Obj.mo.horizSpeed), a

.move:
        ld b, a                 ; speed
        bit Dir.down, c
        jr Z, .notDown
        ; move down
        ld a, (ix+Obj.y)
        add b
        ld (ix+Obj.y), a
        jr .notUp

.notDown:
        bit Dir.up, c
        jr Z, .notUp
        ; move up
        ld a, (ix+Obj.y)
        sub b
        ld (ix+Obj.y), a

.notUp:
        ld e, b
        ld d, 0                 ; `de`: speed
        bit Dir.right, c
        jr Z, .notRight
        ; move right
        ld l, (ix+Obj.x+0)
        ld h, (ix+Obj.x+1)
        add hl, de
        ld (ix+Obj.x+0), l
        ld (ix+Obj.x+1), h
        jr .notLeft

.notRight:
        bit Dir.left, c
        jr Z, .notLeft
        ; move left
        ld l, (ix+Obj.x+0)
        ld h, (ix+Obj.x+1)
        xor a
        sbc hl, de
        ld (ix+Obj.x+0), l
        ld (ix+Obj.x+1), h

.notLeft:
        ; step to the next trajectory position
        ld a, (ix+Obj.mo.trajBack)
        or a
        jr NZ, .stepBack

.stepForward:
        inc (ix+Obj.mo.trajStep)
        jr .end

.stepBack:
        dec (ix+Obj.mo.trajStep)
        jp P, .end
        ; start position reached
        ld (ix+Obj.mo.trajStep), 0
        ld (ix+Obj.mo.trajBack), 0

.end:   ; repeats `removeIfOffScreen`
        call isObjectVisibleOrWaiting
        ret C
        ; if the object became invisible
        ld (ix+Obj.flags), 0    ; remove object
        ret


; Check if hero is inside the activation zone of a still enemy
; Used by c_ecee.
checkStillEnemyActivation:  ; #f488
        ld a, (ix+Obj.activeZone.w)
        or a
        ret Z                   ; not a still enemy

        ; test vertical zone range
        ; hero_top <= obj_y - stillActY + stillActH
        ld iy, Scene.hero
        ld a, (ix+Obj.activeZone.y)
        neg
        add (ix+Obj.y)
        ld c, a
        add (ix+Obj.activeZone.h)
        cp (iy+Obj.y)
        ret C
        ; hero_bottom >= obj_y - stillActY
        ld a, (iy+Obj.y)
        add (iy+Obj.height)
        cp c
        ret C

        ; test horizontal zone range
        ; hero_right >= obj_x - stillActX
        ld l, (ix+Obj.x+0)
        ld h, (ix+Obj.x+1)
        ld e, (ix+Obj.activeZone.x)
        ld d, 0
        xor a
        sbc hl, de
        ex de, hl
        ld l, (iy+Obj.x+0)
        ld h, (iy+Obj.x+1)
        ld c, (iy+Obj.width)
        ld b, 0
        add hl, bc
        xor a
        sbc hl, de
        ret C
        ; hero_left <= obj_x - stillActX + stillActW
        ld l, (ix+Obj.activeZone.w)
        ld h, 0
        add hl, de
        ld e, (iy+Obj.x+0)
        ld d, (iy+Obj.x+1)
        xor a
        sbc hl, de
        ret C

        ; if in range, activate the enemy
        res Flag.waiting, (ix+Obj.flags)
        res Flag.fixedX, (ix+Obj.flags)
        res Flag.fixedY, (ix+Obj.flags)
        ld (ix+Obj.activeZone.w), 0
        ret


; Decide whether to blow up a dynamite
; Used by c_ed08.
checkDynamiteExplosion:  ; #f4e9
        ld a, (ix+Obj.objType)
        cp ObjType.klondike.dynamite1
        jr Z, .isDynamite
        cp ObjType.klondike.dynamite2
        ret NZ

.isDynamite:
        call generateRandom
        cp 2
        ret NC
        ; explosion cloud
        ld (ix+Obj.walkPhase), 0
        ld (ix+Obj.spriteSet), -1
        ld (ix+Obj.colour), Colour.brWhite
        ret


; Velocity table for coin jump
coinJumpVelocity:  ; #f506
        db -6, -5, -4, -3, -2, -2, -1, -1, 0
        db  1,  1,  2,  2,  3,  4,  5,  6
        db #7F

; Precess the motion of a coin appearing from a defeated enemy
; Used by c_ed08.
coinJumpMotion:  ; #f518
        ld a, (ix+Obj.mo.step)
        ld l, a
        ld h, 0
        ld de, coinJumpVelocity
        add hl, de
        ld a, (hl)
        cp #7F
        jr NZ, .jump

        ; falling
        dec (ix+Obj.mo.step)
        ld a, 8                 ; falling speed
.jump:
        add (ix+Obj.y)
        ld (ix+Obj.y), a
        ld a, (hl)
        cp #7F
        jr NZ, .end

        ; falling
        call collectTileTypes
        ld a, (State.tTypeBot)
        cp TileType.wall
        jr C, .end              ; space, ladder, ladderTop, platform

        ; impenetrable tiles
        ld a, (ix+Obj.y)
        and -8
        ld (ix+Obj.y), a
        ld (ix+Obj.mo.type), Motion.none
.end:
        inc (ix+Obj.mo.step)
        jp removeIfOffScreen


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
        call allocateObject
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
        call checkObjectCollision
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
        jp printEnergy

.noCollision:
        ld a, (State.level)
        or a                    ; Klondike?
        jr NZ, .tileCheck
        ld a, (State.bossFight)
        or a
        jr NZ, .skipTileCheck   ; skip if Klondike boss

.tileCheck:
        call getScrTileAddr
        ld a, (hl)
        call getTileType
        cp TileType.wall
        jr C, .skipTileCheck    ; passable (space, ladder, platform)

        ; non-passable (wall, conveyor, ice, slow, water/spikes)
        ld (ix+Obj.flags), 0    ; remove bullet
        ret

.skipTileCheck:
        call isObjectVisible
        ret C                   ; ret if visible
        ; invisible
        ld (ix+Obj.flags), 0    ; remove bullet
        ret


; Change object direction with some probability
; Used by c_ef72.
randomlyChangeDirection:  ; #f670
        bit Flag.changesDir, (ix+Obj.auxFlags)
        ret Z
        call generateRandom
        cp 8
        ret NC

        ; invert direction
.horizontal:
        bit 1, (ix+Obj.mo.coordConstr)
        jr Z, .vertical
        ld a, (ix+Obj.mo.direction)
        xor Dir.horizontal
        ld (ix+Obj.mo.direction), a
.vertical:
        bit 0, (ix+Obj.mo.coordConstr)
        ret Z
        ld a, (ix+Obj.mo.direction)
        xor Dir.vertical
        ld (ix+Obj.mo.direction), a
        ret


; (Some game logic?)
; Used by c_ef72.
randomlyStandStill:  ; #f697
        bit Flag.standsStill, (ix+Obj.auxFlags)
        ret Z

        ld a, (ix+Obj.stillTime)
        or a
        jr Z, .l_0
        dec (ix+Obj.stillTime)
        ret
.l_0:
        call generateRandom
        cp 4
        ret NC

        call generateRandom
        and 31
        ld (ix+Obj.stillTime), a
        ret


; Object type offset by level
levelObjTypeOffests:  ; #f6b5
        db 0, 49, 95, 136, 188


; Find position in level object table and put objects to the scene
; Used by c_cd9b and c_e920.
findAndPutObjectsToScene:  ; #f6ba
        ld bc, Level.objectTable
.object:
        ld de, (State.screenX)
        ld a, (bc)
        ld h, a
        inc bc
        ld a, (bc)
        ld l, a                 ; `hl`: x coord on map
        inc bc
        xor a
        sbc hl, de              ; `hl`: x coord on screen
        jr C, .skipObject

        push hl
        ld de, 32
        xor a
        sbc hl, de
        pop hl
        jr NC, .end             ; object is not yet visible

        call putObjectToScene
        jr .object

.skipObject:
    .2  inc bc
        jr .object

.end:
    .2  dec bc
        ld (State.nextObject), bc
        jr setWaitingFlags


; Get next objects from the object table
; Used by c_cc25.
putNextObjsToScene:  ; #f6e7
        ld bc, (State.nextObject)
.object:
        ld de, (State.screenX)
        ld a, (bc)
        ld h, a
        inc bc
        ld a, (bc)
        ld l, a                 ; `hl`: x coord on map
        inc bc
        xor a
        sbc hl, de              ; `hl`: x coord on screen
        jr C, .skipObject

        push hl
        ld de, 40
        xor a
        sbc hl, de
        pop hl
        jr NC, .end

        push bc
        call putObjectToScene
        pop bc
    .2  inc bc
        jr .object

.skipObject:
    .2  inc bc
        jr .object

.end:
    .2  dec bc
        ld (State.nextObject), bc
        ; continue


; Set waiting flags in objects that are not visible yet
; and reset in already visible objects
setWaitingFlags:
        ld ix, Scene.obj2
        ld b, 6                 ; object count
.object:
        bit Flag.exists, (ix+Obj.flags)
        jr Z, .skip
        ld l, (ix+Obj.x+0)
        ld h, (ix+Obj.x+1)
        ld de, 288
        xor a
        sbc hl, de
        jp C, .visible
        set Flag.waiting, (ix+Obj.flags)
        jr .skip
.visible:
        ld a, (ix+Obj.activeZone.w)
        or a
        jr NZ, .skip            ; visible, but still
        res Flag.waiting, (ix+Obj.flags)
.skip:
        ld de, Obj              ; object size
        add ix, de
        djnz .object
        ret


; Initialise object from the object type
;   arg `bc`: object addr in `objectTable` + 2 (points to y coord)
;       `hl`: x coord on screen in tiles
; Used by c_f6ba and c_f6e7.
putObjectToScene:  ; #f74a
        call allocateObject     ; `ix`: new object addr in the scene
        ret NC                  ; ret if no place for new object

    .3  add hl, hl
        ld de, 32
        add hl, de              ; `hl`: x coord in pixels
        ld (ix+Obj.x+0), l
        ld (ix+Obj.x+1), h

        ld a, (bc)              ; y coord in tiles
    .3  add a
        add 32                  ; y coord in pixels (bottom of the sprite)
        ld (ix+Obj.y), a

        inc bc
        ld a, (bc)              ; object type
        cp 10
        jr C, .commonObjType

        ; for a level-specific object type
        ; subtract the indexing offset
        ; (why was it added in the first place?)
        exa
        ld a, (State.level)
        ld l, a
        ld h, 0
        ld de, levelObjTypeOffests
        add hl, de
        ld l, (hl)
        exa
        sub l

.commonObjType:
        ; `a`: index in `objectTypes`
        inc bc                  ; addr of the next object in `objectTable`
        ; continue

; Create a new object of the given type
;   arg `a`: object type (index in `objectTypes`)
;       `ix`: object addr in the scene
; used by c_f8f4, c_f9a4, c_fa65, c_fad3 and c_fb45.
createObject:
        exx
        ld l, a
        ld h, 0
        add hl, hl
        ld c, l
        ld b, h
    .2  add hl, hl
        ld e, l
        ld d, h
        add hl, hl
        add hl, de
        add hl, bc
        push hl
        exx
        pop hl                  ; `hl` = `a` * 26
        ld de, Common.objectTypes
        add hl, de              ; `hl`: object type addr

        ; fill object properties
        ld (ix+Obj.walkPhase), 0
        ld (ix+Obj.stillTime), 0
        ld (ix+Obj.mo.direction), 1<<Dir.left
        ld a, (hl)              ; sprite (low)
        ld (ix+Obj.sprite+0), a
        inc hl                  ; +1
        ld a, (hl)              ; sprite (high)
        ld (ix+Obj.sprite+1), a
        inc hl                  ; +2
        ld a, (hl)              ; colour
        ld (ix+Obj.colour), a
        inc hl                  ; +3
        ld a, (hl)              ; spriteSet
        ld (ix+Obj.spriteSet), a
        inc hl                  ; +4
        ld a, (hl)              ; flags
        ld (ix+Obj.flags), a
        inc hl                  ; +5
        ld a, (hl)              ; width
        ld (ix+Obj.width), a
        inc hl                  ; +6
        ld a, (hl)              ; height
        ld (ix+Obj.height), a
        inc hl                  ; +7
        ld a, (hl)              ; health
        ld (ix+Obj.health), a
        inc hl                  ; +8
        ld a, (hl)              ; isWaiting
        or a
        jr Z, .skipWaiting
        ld a, (ix+Obj.flags)
        or (1<<Flag.fixedX) | (1<<Flag.fixedY) | (1<<Flag.waiting)
        ld (ix+Obj.flags), a
.skipWaiting:
        inc hl                  ; +9
        ld a, (hl)              ; score
        ld (ix+Obj.score), a
        inc hl                  ; +10
        ld a, (hl)              ; auxFlags
        ld (ix+Obj.auxFlags), a
        inc hl                  ; +11
        ld a, (hl)              ; objType (with offset)
        ld (ix+Obj.objType), a
        or a
        jr NZ, .skipBurrow
        ld a, (State.inShop)
        cp #7F
        jr NZ, .skipBurrow
        ld (ix+Obj.flags), 0    ; remove object
        ret
.skipBurrow:
        inc hl                  ; +12
        ld a, (hl)              ; emitBullets
        ld (ix+Obj.emitBullets), a
        ; motion options
        inc hl                  ; +13
        ld a, (hl)              ; param1
        ld (ix+Obj.mo.param1), a
        inc hl                  ; +14
        ld a, (hl)              ; param2
        ld (ix+Obj.mo.param2), a
        inc hl                  ; +15
        ld a, (hl)              ; trajBack
        ld (ix+Obj.mo.trajBack), a
        inc hl                  ; +16
        ld a, (hl)              ; trajDir
        ld (ix+Obj.mo.trajDir), a
        inc hl                  ; +17
        ld a, (hl)              ; horizSpeed
        ld (ix+Obj.mo.horizSpeed), a
        inc hl                  ; +18
        ld a, (hl)              ; vertSpeed
        ld (ix+Obj.mo.vertSpeed), a
        inc hl                  ; +19
        ld a, (hl)              ; direction
        ld (ix+Obj.mo.direction), a
        inc hl                  ; +20
        ld a, (hl)              ; subType
        ld (ix+Obj.mo.subType), a
        inc hl                  ; +21
        ld a, (hl)              ; type
        ld (ix+Obj.mo.type), a
        ; still enemy activation zone
        inc hl                  ; +22
        ld a, (hl)              ; x
        ld (ix+Obj.activeZone.x), a
        inc hl                  ; +23
        ld a, (hl)              ; y
        ld (ix+Obj.activeZone.y), a
        inc hl                  ; +24
        ld a, (hl)              ; w
        ld (ix+Obj.activeZone.w), a
        inc hl                  ; +25
        ld a, (hl)              ; h
        ld (ix+Obj.activeZone.h), a

        ; direction transform
        ld a, (ix+Obj.mo.direction)
        ld l, a
        ld h, 0
        ld de, directionTransform
        add hl, de
        ld a, (hl)
        ld (ix+Obj.mo.direction), a

        ; get top by bottom and height
        bit Flag.isBig, (ix+Obj.flags)
        jr NZ, .big             ; (why? same code for both cases)
.small:
        ld a, (ix+Obj.y)
        sub (ix+Obj.height)
        ld (ix+Obj.y), a
        jr .checkPress
.big:
        ld a, (ix+Obj.y)
        sub (ix+Obj.height)
        ld (ix+Obj.y), a

.checkPress:
        ld a, (ix+Obj.objType)
        cp ObjType.pressPlatf
        jr NZ, .notPress

        ; adjust coords for a press/platform
        ld l, (ix+Obj.x+0)
        ld h, (ix+Obj.x+1)
        ld de, 4
        add hl, de
        ld (ix+Obj.x+0), l
        ld (ix+Obj.x+1), h
        ld a, (ix+Obj.y)
        and -8
        ld (ix+Obj.y), a
        ret

.notPress:
        cp ObjType.shatterbomb
        jr NZ, .notShatterBomb
        ld a, (ix+Obj.y)
        add 6
        ld (ix+Obj.y), a
        ret

.notShatterBomb:
        ld a, (ix+Obj.objType)
        cp ObjType.iceland.snowBall1
        jr NZ, .notSnowBall
        ld (ix+Obj.flags), 0    ; remove object
        ret

.notSnowBall:
        ld a, (State.bossFight)
        or a
        ret NZ

        ld a, (ix+Obj.objType)
        cp ObjType.klondike.boss
        jr Z, .possiblyBoss
        cp ObjType.orient.boss
        jr Z, .boss
        cp ObjType.amazon.boss
        jr Z, .boss
        cp ObjType.iceland.boss
        jr Z, .boss
        cp ObjType.bermuda.boss
        jr Z, .boss
        ret

.possiblyBoss:
        ; check that the hero is in the room with the boss, not near it
        ld hl, (State.screenX)
        ld de, 1492
        xor a
        sbc hl, de
        jr NC, .boss
        ld (ix+Obj.flags), 0    ; remove object
        ret

.boss:
        ld a, 1
        ld (State.bossFight), a
        ld a, 60
        ld (State.bossHealth), a
        ret


    ENDMODULE
