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
        jp Panel.printPanel
    ELSE
        jp Panel.printEnergy
    ENDIF

.found:
    IFDEF _MOD
        call Panel.clearEnergy
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
        call Utils.printString

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
        call Panel.printPrice
    ELSE
        ld hl, #001C            ; at 0, 28
        ld c, Colour.brWhite
        call Panel.printNumber
    ENDIF

.skipPrice:
        ld a, (Control.controlState)
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
        jp Panel.printPanel
    ELSE
        jp Panel.printEnergy
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
        call Utils.printString
.waitFireRelease:
        ld a, (Control.controlState)
        bit Key.fire, a
        jr NZ, .waitFireRelease
        ret

.canBuy:
        ld (State.coins), a
        call Panel.printCoinCount
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
        jp Panel.printSoupCans

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

    ENDMODULE
