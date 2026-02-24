    MODULE Code

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

        call Scene.removeObjects

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

        call Scene.findAndPutObjectsToScene

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
        call Scene.checkObjectCollision
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
        call Scene.removeObjects
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
