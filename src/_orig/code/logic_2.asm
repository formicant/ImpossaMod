    MODULE Code


; (Modifies some object properties?)
; Used by c_cc25.
moveObjects:  ; #e56f
        ld ix, scene.obj1
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
        bit 0, (ix+Obj.flags)   ; exists
        ret Z

        ld a, (ix+Obj.o_48)
        or a
        ret NZ
        bit 5, (ix+Obj.flags)   ; waiting
        ret NZ

.horizontal:
        bit 2, (ix+Obj.flags)   ; fixed horizontally
        jr NZ, .vertical

        bit 0, (ix+Obj.direction)
        jr Z, .left
        ; move right
        ld e, (ix+Obj.horizSpeed)
        ld d, 0
        ld l, (ix+Obj.x+0)
        ld h, (ix+Obj.x+1)
        add hl, de
        ld (ix+Obj.x+0), l
        ld (ix+Obj.x+1), h
        jr .vertical
.left:
        bit 1, (ix+Obj.direction)
        jr Z, .vertical
        ; move left
        ld a, (ix+Obj.horizSpeed)
        neg
        ld e, a
        ld d, -1
        ld l, (ix+Obj.x+0)
        ld h, (ix+Obj.x+1)
        add hl, de
        ld (ix+Obj.x+0), l
        ld (ix+Obj.x+1), h

.vertical:
        bit 3, (ix+Obj.flags)   ; fixed vertically
        ret NZ

        bit 3, (ix+Obj.direction)
        jr Z, .down
        ; move up
        ld a, (ix+Obj.vertSpeed)
        neg
        add (ix+Obj.y)
        ld (ix+Obj.y), a
        ret
.down:
        bit 2, (ix+Obj.direction)
        ret Z
        ; move down
        ld a, (ix+Obj.vertSpeed)
        add (ix+Obj.y)
        ld (ix+Obj.y), a
        ret


; Mark all scene objects except the hero as non-existent
; Used by c_cc25, c_e60a, c_e920 and c_e9b1.
removeObjects:  ; #e5f2
        push ix
        push de
        ld de, Obj
        ld ix, scene.obj1
        ld b, 7
.object:
        ld (ix+Obj.flags), 0
        add ix, de
        djnz .object

        pop de
        pop ix
        ret


; Check if the hero enters a transit
; Used by c_cc25.
checkTransitEnter:  ; #e60a
        ld ix, scene.hero
        ld a, (State.s_27)
        ld (State.s_44), a

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
        ld (State.s_27), a
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
        ld a, (State.s_44)
        ld (State.s_27), a
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


; Get address for a new object in `scene`
;   ret `ix`: object addr
;       `C` flag iff there is place for a new object
; Used by c_f564 and c_f74a.
allocateObject:  ; #e6c2
        push de
        push bc
        ld b, 6                 ; object count
        ld ix, scene.obj2
        ld de, Obj              ; object size
.object:
        bit 0, (ix+Obj.flags)   ; exists
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

        ld ix, scene.hero
        ld l, (ix+Obj.x+0)
        ld h, (ix+Obj.x+1)
        ld (tmpHeroX), hl
    .4  inc hl
        ld (ix+Obj.x+0), l
        ld (ix+Obj.x+1), h

        ld iy, scene.obj2
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
        cp 14                   ; press/platform
        jp NC, .levelSpecific
        or a                    ; no type
        ret Z

        cp 4                    ; soupCan
        jr NC, .l_2

        ; weapon
        exa
        ld a, (State.s_3D)
        or a
        ret NZ
        exa
        ld (State.weapon), a
        ld hl, 750
        ld (State.weaponTime), hl
        ld (iy+Obj.flags), 0    ; remove object
        ld a, 13                ; pick up weapon
        jp playSound

.l_2:
        cp 9                    ; shop mole
        jr Z, .skipSound
        push af
        ld a, 11                ; pick up item sound
        call playSound
        pop af
.skipSound:

        cp 4                    ; soupCan
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
        cp 5                    ; slimyWorms
        jr NZ, .notSlimyWorms
        ld (iy+Obj.flags), 0    ; remove object
        ld a, 4
        jp addEnergy

.notSlimyWorms:
        cp 6                    ; coin
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
        cp 7                    ; pintaADay
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
        cp 8                    ; diary
        jr NZ, .notDiary
        ld (iy+Obj.flags), 0    ; remove object
        ld a, #FF
        ld (State.hasDiary), a
        ret

.notDiary:
        cp 10                   ; score item
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
        cp 14                   ; press/platform
        jr NZ, .notPress

        ; TODO: press logic
        bit 3, (iy+Obj.direction)   ; up
        ret NZ
        ld a, (State.pressTime)
        or a
        ret NZ
        ld a, (State.s_28)
        cp 2
        jr C, .l_13
        ret NZ
        call c_d94c_t1.l_13
        ld a, (State.s_28)
        or a
        ret NZ
.l_13:
        ld a, 50
        ld (State.pressTime), a

.notPress:
        ld a, (iy+Obj.o_7)      ; ?
        cp #FF
        ret Z
        bit 0, (iy+Obj.o_24)    ; ?
        ret NZ
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
        bit 0, (iy+Obj.flags)   ; object 2 exists
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
        cp 14                   ; object 2 is press/platform
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
        cp 14                   ; object 2 is press/platform
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
        db "LAZER GUN   "C
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
        ld ix, scene.obj2
        ld b, 6                 ; object count
        ld de, Obj              ; object size
.object:
        ld a, (ix+Obj.objType)
        or a
        jr Z, .initShopMole
        add ix, de
        djnz .object

.initShopMole:
        ld iy, scene.hero
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
        ld (ix+Obj.colour), Colour.white

        ld (ix+Obj.direction), 0
        ld (ix+Obj.width), 24
        ld (ix+Obj.height), 21
        ld (ix+Obj.objType), 9
        ld (ix+Obj.flags), %00000011
        ld (ix+Obj.health), -2
        ld (ix+Obj.o_24), 0
        ld (ix+Obj.o_49), 0
        ld (ix+Obj.behaviour), 0
        ret

; Shop logic
; Used by c_cc25.
shopLogic:  ; #e9b1
        ld a, (State.inShop)
        cp #7F
        ret NZ

        ; find item where hero stands
        ld ix, scene.hero
        ld iy, scene.obj2
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
        ld c, Colour.white
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
        ld c, Colour.white
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
        ld (State.s_28), a

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
        ld c, Colour.white
        call printString
.waitFireRelease:
        ld a, (controlState)
        bit Key.fire, a
        jr NZ, .waitFireRelease
        ret

.canBuy:
        ld (State.coins), a
        call printCoinCount
        ld (iy+Obj.flags), 0    ; remove item

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
        ld (iy+Obj.flags), 0
        jp printSoupCans

.notSoupCan:
        cp 5                    ; slimy worms
        jr NZ, .notSlimyWorms
        ld (iy+Obj.flags), 0
        ld a, 4
        jp addEnergy

.notSlimyWorms:
        cp 7
        jr NZ, .notPintaADay
        ld (iy+Obj.flags), 0
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

        ld (iy+Obj.flags), 0
        ld a, #FF
        ld (State.hasDiary), a
        ret


; Place hero by the coords from (hl)
;   arg `hl`: addr pointing to coords (x, y) in tiles relative to screen
; Used by c_e920 and c_e9b1.
placeHero:  ; #eace
        ld ix, scene.hero
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
        and %01111111           ; remove fg/bg bit
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
        ld ix, scene.obj1       ; bullet, bomb, or kick bubble
        ld iy, scene.obj2
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

        bit 0, (iy+Obj.flags)
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
        ld a, (iy+Obj.o_7)
        cp -1
        jr NZ, .l_0
        res 0, (ix+Obj.flags)   ; remove bubble
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
        set 0, (ix+Obj.flags)   ; remove bubble
        jr damageEnemy

.weaponUsed:
        cp 1                    ; shatterbomb
        jr NZ, .gun

.shatterbomb:
        bit 1, (ix+Obj.flags)
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
        ld a, (iy+Obj.o_7)
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

        ld a, 3                 ; damage enemy sound
        call playSound
        jr .damaged

; This entry point is used by c_d4e5.
.kill:
        bit 4, (iy+Obj.o_24)    ; gives coin
        jp NZ, turnIntoCoin

        ; turn into cloud
        bit 1, (iy+Obj.flags)   ; is big
        jr NZ, .big
        push ix
        push iy
        push iy
        pop ix
        call makeObjectBig
        pop iy
        pop ix
.big:
        ld (iy+Obj.o_6), 0
        ld (iy+Obj.o_7), -1
        ld (iy+Obj.colour), Colour.white
        ld a, 6                 ; kill enemy sound
        call playSound

.damaged:
        xor a
        ret

; This entry point is used by c_eb19.
.notDamaged:
        scf
        ret

.boss:
        ld a, (State.s_56)
        or a
        jr NZ, .damaged

        ld a, (State.bossHealth)
        add b                   ; `b`: damage points
        jr NC, .bossKilled

        ld (State.bossHealth), a
        ld a, 3                 ; damage enemy sound
        call playSound

        push ix
        push de
        ld ix, scene.obj2
        ld b, 4                 ; object count
        ld de, Obj              ; object size
.bossPartBlink:
        bit 1, (ix+Obj.flags)
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
        ld ix, scene.obj2
        ld b, 4                 ; object count
        ld de, Obj              ; object size
.bossPartCloud:
        bit 0, (ix+Obj.flags)
        jr Z, .l_9
        bit 1, (ix+Obj.flags)
        jr Z, .l_9
        ; turn into cloud
        ld (ix+Obj.o_6), 0
        ld (ix+Obj.o_7), -1
        ld (ix+Obj.colour), Colour.white
.l_9:
        add ix, de
        djnz .bossPartCloud

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

        ld a, 6                 ; kill enemy sound
        call playSound
        jr .damaged


; For every object in the scene, process its behaviour
; Used by c_cc25.
processObjsBehaviour:  ; #ecee
        ld ix, scene.obj2
        ld b, 6                 ; object count
.object:
        push bc
        push ix
        call checkStillEnemyActivation
        call processObjectBehaviour
        pop ix
        ld bc, Obj              ; object size
        add ix, bc
        pop bc
        djnz .object
        ret


; Check object type and behaviour type and do appropriate actions
;   arg `ix`: object
; Used by c_ecee.
processObjectBehaviour:  ; #ed08
        bit 0, (ix+Obj.flags)   ; exists
        ret Z

        call emitEnemyBullet

        ld a, (ix+Obj.behaviour)
        cp 1
        jp Z, c_f618

        bit 5, (ix+Obj.flags)   ; waiting
        ret NZ

        ld a, (ix+Obj.objType)
        cp 14                   ; press/platform
        jp Z, c_f2e7

        call c_f4e9

        ld a, (ix+Obj.behaviour)
        cp 2
        jr NZ, .l_0
        call c_f37e
        jp .l_2
.l_0:
        cp 4
        call Z, c_f37e

        ld a, (ix+Obj.behaviour)
        or a
        jp Z, .l_1
        cp 3
        jp Z, c_ef72
        cp 4
        jp Z, c_ef72
        cp 5
        jp Z, c_f0f3
        cp 6
        jp Z, c_f518
        ret

.l_1:
        set 2, (ix+Obj.flags)
        set 3, (ix+Obj.flags)
        ret

.l_2:
        ld a, (ix+Obj.o_22)
        cp -2
        jr Z, .l_5
        cp -1
        ret NZ

        call c_f1d7

        ld a, (State.s_4A)
        cp 2
        ret C

        bit 1, (ix+Obj.flags)
        jr NZ, .l_3
        call makeObjectBig
.l_3:
        ld a, (ix+Obj.objType)
        cp 40                   ; Klondike stalactite
        jr NZ, .l_4
        ld a, (ix+Obj.x+0)
        sub 8
        ld (ix+Obj.x+0), a
.l_4:
        ld (ix+Obj.o_6), 0
        ld (ix+Obj.o_7), -1
        ld (ix+Obj.colour), Colour.white
        ld a, 6                 ; kill enemy
        jp playSound

.l_5:
        call c_f1d7

        ld a, (State.s_4A)
        cp 4
        ret C

        ld (ix+Obj.behaviour), 0
        set 5, (ix+Obj.flags)   ; waiting
        ld a, (ix+Obj.objType)
        cp 110                  ; Amazon hangingMonkey
        ret NZ
        ld hl, Lev2Amazon.lS.sittingMonkey
        ld (ix+Obj.sprite+0), l
        ld (ix+Obj.sprite+1), h
        ld (ix+Obj.o_7), 0
        ret


; (Modifies some object properties?)
; Used by c_f564.
c_edc0:  ; #edc0
        ld (ix+Obj.o_29), a
        ld l, (ix+Obj.x+0)
        ld h, (ix+Obj.x+1)
        ld (ix+Obj.o_30+0), l
        ld (ix+Obj.o_30+1), h
        push hl
        ld a, (ix+Obj.y)
        ld (ix+Obj.o_32+0), a
        ld (ix+Obj.o_32+1), 0

        ld iy, scene.hero
        ld l, (iy+Obj.x+0)
        ld h, (iy+Obj.x+1)
        ld a, (iy+Obj.width)
        srl a
        sub #03
        ld e, a
        ld d, #00
        add hl, de
        ld (ix+Obj.o_34+0), l   ; never used again(?)
        ld (ix+Obj.o_34+1), h   ; never used again(?)
        push hl
        ld a, (iy+Obj.height)
        srl a
        sub #03
        add (iy+Obj.y)
        ld (ix+Obj.o_36+0), a
        ld (ix+Obj.o_36+1), 0
        pop hl
        pop de
        xor a
        sbc hl, de
        ex de, hl
        ld c, (ix+Obj.o_32+0)
        ld b, (ix+Obj.o_32+1)
        ld l, (ix+Obj.o_36+0)
        ld h, (ix+Obj.o_36+1)
        xor a
        sbc hl, bc
        bit 7, d
        jp M, .l_0
        ld (ix+Obj.o_42+0), 1
        ld (ix+Obj.o_42+1), 0
        jr .l_1
.l_0:
        ld (ix+Obj.o_42+0), #FF
        ld (ix+Obj.o_42+1), #FF
        ld a, d
        cpl
        ld d, a
        ld a, e
        cpl
        ld e, a
        inc de
.l_1:
        ld (ix+Obj.o_38+0), e
        ld (ix+Obj.o_38+1), d
        ld a, h
        or l
        jr Z, .l_2
        bit 7, h
        jp M, .l_3
        ld (ix+Obj.o_44+0), 1
        ld (ix+Obj.o_44+1), 0
        ld (ix+Obj.o_46+0), 0
        ld (ix+Obj.o_46+1), 0
        jr .l_4
.l_2:
        ld (ix+Obj.o_44+0), 1
        ld (ix+Obj.o_44+1), 0
        ld (ix+Obj.o_46+0), #FF
        ld (ix+Obj.o_46+1), #FF
        jr .l_4
.l_3:
        ld (ix+Obj.o_44+0), #FF
        ld (ix+Obj.o_44+1), #FF
        ld (ix+Obj.o_46+0), 0
        ld (ix+Obj.o_46+1), 0
        ld a, h
        cpl
        ld h, a
        ld a, l
        cpl
        ld l, a
        inc hl
.l_4:
        ld (ix+Obj.o_40+0), l
        ld (ix+Obj.o_40+1), h
        ld (ix+Obj.o_36+0), 0
        ld (ix+Obj.o_36+1), 0
        ret

; (Modifies some object properties?)
; Used by c_f618.
c_ee93:  ; #ee93
        ld a, (ix+Obj.o_7)
        cp #FF
        ret Z
        ld b, (ix+Obj.o_29)
        ld e, (ix+Obj.o_38+0)
        ld d, (ix+Obj.o_38+1)
        ld l, (ix+Obj.o_40+0)
        ld h, (ix+Obj.o_40+1)
        xor a
        sbc hl, de
        jr NC, .l_2
.l_0:
        ld a, (ix+Obj.o_46+0)
        or a
        jp M, .l_1
        ld l, (ix+Obj.o_32+0)
        ld h, (ix+Obj.o_32+1)
        ld e, (ix+Obj.o_44+0)
        ld d, (ix+Obj.o_44+1)
        add hl, de
        ld (ix+Obj.o_32+0), l
        ld (ix+Obj.o_32+1), h
        ld e, (ix+Obj.o_38+0)
        ld d, (ix+Obj.o_38+1)
        ld l, (ix+Obj.o_46+0)
        ld h, (ix+Obj.o_46+1)
        xor a
        sbc hl, de
        ld (ix+Obj.o_46+0), l
        ld (ix+Obj.o_46+1), h
.l_1:
        ld l, (ix+Obj.o_30+0)
        ld h, (ix+Obj.o_30+1)
        ld e, (ix+Obj.o_42+0)
        ld d, (ix+Obj.o_42+1)
        add hl, de
        ld (ix+Obj.o_30+0), l
        ld (ix+Obj.o_30+1), h
        ld l, (ix+Obj.o_40+0)
        ld h, (ix+Obj.o_40+1)
        ld e, (ix+Obj.o_46+0)
        ld d, (ix+Obj.o_46+1)
        add hl, de
        ld (ix+Obj.o_46+0), l
        ld (ix+Obj.o_46+1), h
        djnz .l_0
        jr .l_4
.l_2:
        ld a, (ix+Obj.o_46+0)
        or a
        jp P, .l_3
        ld l, (ix+Obj.o_30+0)
        ld h, (ix+Obj.o_30+1)
        ld e, (ix+Obj.o_42+0)
        ld d, (ix+Obj.o_42+1)
        add hl, de
        ld (ix+Obj.o_30+0), l
        ld (ix+Obj.o_30+1), h
        ld l, (ix+Obj.o_40+0)
        ld h, (ix+Obj.o_40+1)
        ld e, (ix+Obj.o_46+0)
        ld d, (ix+Obj.o_46+1)
        xor a
        add hl, de
        ld (ix+Obj.o_46+0), l
        ld (ix+Obj.o_46+1), h
.l_3:
        ld l, (ix+Obj.o_32+0)
        ld h, (ix+Obj.o_32+1)
        ld e, (ix+Obj.o_44+0)
        ld d, (ix+Obj.o_44+1)
        add hl, de
        ld (ix+Obj.o_32+0), l
        ld (ix+Obj.o_32+1), h
        ld e, (ix+Obj.o_38+0)
        ld d, (ix+Obj.o_38+1)
        ld l, (ix+Obj.o_46+0)
        ld h, (ix+Obj.o_46+1)
        xor a
        sbc hl, de
        ld (ix+Obj.o_46+0), l
        ld (ix+Obj.o_46+1), h
        djnz .l_2
.l_4:
        ld l, (ix+Obj.o_30+0)
        ld h, (ix+Obj.o_30+1)
        ld (ix+Obj.x+0), l
        ld (ix+Obj.x+1), h
        ld a, (ix+Obj.o_32+0)
        ld (ix+Obj.y), a
        xor a
        ret

; (Some game logic?)
; Used by c_ed08.
c_ef72:  ; #ef72
        ld a, (ix+Obj.o_22)
        cp #FF
        jp Z, .l_0
        cp #FE
        jp Z, .l_6
        cp #FC
        jp Z, .l_10
        cp #FB
        jp Z, .l_19
        jp .l_23
.l_0:
        call c_f670
        call c_f697
        call c_f1d7
        ld a, (State.s_4C)
        bit 0, (ix+Obj.direction)
        jr NZ, .l_1
        ld a, (State.s_4B)
.l_1:
        cp #04
        jr NC, .l_3
        ld a, (ix+Obj.objType)
        cp #82
        jr Z, .l_4
        ld a, (State.s_4E)
        bit 0, (ix+Obj.direction)
        jr NZ, .l_2
        ld a, (State.s_4D)
.l_2:
        or a
        jr NZ, .l_4
.l_3:
        ld a, (ix+Obj.direction)
        xor #03
        ld (ix+Obj.direction), a
        jp .l_23
.l_4:
        ld l, (ix+Obj.x+0)
        ld h, (ix+Obj.x+1)
        bit 0, (ix+Obj.direction)
        jr NZ, .l_5
        ld de, #0020
        xor a
        sbc hl, de
        jr C, .l_3
        jp .l_23
.l_5:
        ld d, #00
        ld e, (ix+Obj.width)
        add hl, de
        ld de, #0120
        xor a
        sbc hl, de
        jr NC, .l_3
        jp .l_23
.l_6:
        ld (ix+Obj.vertSpeed), #08
        call c_f1d7
        bit 7, (ix+Obj.o_24)
        jr NZ, .l_9
        call c_f670
        call c_f697
        ld a, (State.s_4C)
        bit 0, (ix+Obj.direction)
        jr NZ, .l_7
        ld a, (State.s_4B)
.l_7:
        cp #04
        jr C, .l_8
        ld a, (ix+Obj.direction)
        xor #03
        ld (ix+Obj.direction), a
.l_8:
        ld a, (State.s_4A)
        cp #02
        jp NC, .l_23
        set 7, (ix+Obj.o_24)
        set 2, (ix+Obj.flags)
        set 2, (ix+Obj.direction)
        jp .l_23
.l_9:
        ld a, (State.s_4A)
        cp #02
        jp C, .l_23
        res 7, (ix+Obj.o_24)
        res 2, (ix+Obj.flags)
        res 2, (ix+Obj.direction)
        jp .l_23
.l_10:
        bit 0, (ix+Obj.trajectory)
        jr Z, .l_11
        call generateRandom
        cp #0A
        jr NC, .l_11
        ld a, (ix+Obj.direction)
        xor #0C
        ld (ix+Obj.direction), a
.l_11:
        bit 1, (ix+Obj.trajectory)
        jr Z, .l_12
        call generateRandom
        cp #0A
        jr NC, .l_12
        ld a, (ix+Obj.direction)
        xor #03
        ld (ix+Obj.direction), a
.l_12:
        call c_f1d7
        bit 0, (ix+Obj.direction)
        jr Z, .l_13
        ld a, (State.s_4C)
        cp #02
        jr NC, .l_14
        jr .l_15
.l_13:
        bit 1, (ix+Obj.direction)
        jr Z, .l_15
        ld a, (State.s_4B)
        cp #02
        jr C, .l_15
.l_14:
        ld a, (ix+Obj.direction)
        xor #03
        ld (ix+Obj.direction), a
.l_15:
        bit 2, (ix+Obj.direction)
        jr Z, .l_16
        ld a, (State.s_4A)
        cp #02
        jr NC, .l_17
        jr .l_18
.l_16:
        bit 3, (ix+Obj.direction)
        jr Z, .l_18
        ld a, (State.s_49)
        cp #02
        jr C, .l_18
.l_17:
        ld a, (ix+Obj.direction)
        xor #0C
        ld (ix+Obj.direction), a
.l_18:
        jp .l_23
.l_19:
        ld a, (ix+Obj.trajectory)
        cp (ix+Obj.o_16)
        jr Z, .l_20
        inc (ix+Obj.trajectory)
        jp .l_23
.l_20:
        ld (ix+Obj.trajectory), 0
        ld c, (ix+Obj.direction)
        ld a, c
        and #03
        jr Z, .l_21
        xor #03
.l_21:
        ld b, a
        ld a, c
        and #0C
        jr Z, .l_22
        xor #0C
.l_22:
        or b
        ld (ix+Obj.direction), a
        jp .l_23
; This entry point is used by c_f0f3 and c_f518.
.l_23:
        call isObjectVisibleOrWaiting
        ret C
        ld (ix+Obj.flags), 0
        ret

; (Some game logic?)
; Used by c_ed08.
c_f0f3:  ; #f0f3
        ld (ix+Obj.horizSpeed), 2
        ld (ix+Obj.vertSpeed), 2
        res 2, (ix+Obj.flags)
        res 3, (ix+Obj.flags)
        bit 0, (ix+Obj.o_22)
        jr NZ, .l_0
        set 3, (ix+Obj.flags)
.l_0:
        bit 1, (ix+Obj.o_22)
        jr NZ, .l_1
        set 2, (ix+Obj.flags)
.l_1:
        ld iy, scene
        ld l, (ix+Obj.x+0)
        ld h, (ix+Obj.x+1)
        ld c, (ix+Obj.width)
        srl c
        ld b, #00
        add hl, bc
        ex de, hl
        ld l, (iy+Obj.x+0)
        ld h, (iy+Obj.x+1)
        ld c, (iy+Obj.width)
        srl c
        ld b, #00
        add hl, bc
        xor a
        sbc hl, de
        ld (ix+Obj.direction), #01
        jp P, .l_2
        ld (ix+Obj.direction), #02
        ld a, l
        cpl
        ld l, a
        ld a, h
        cpl
        ld h, a
        inc hl
.l_2:
        ld e, (ix+Obj.horizSpeed)
        ld d, #00
        xor a
        sbc hl, de
        jp P, .l_3
        set 2, (ix+Obj.flags)
.l_3:
        ld a, (ix+Obj.y)
        ld c, (ix+Obj.height)
        srl c
        add c
        ld c, a
        ld a, (iy+Obj.y)
        ld b, (iy+Obj.height)
        srl b
        add b
        sub c
        set 2, (ix+Obj.direction)
        res 3, (ix+Obj.direction)
        jp P, .l_4
        cpl
        set 3, (ix+Obj.direction)
        res 2, (ix+Obj.direction)
.l_4:
        cp (ix+Obj.vertSpeed)
        jr NC, .l_5
        set 3, (ix+Obj.flags)
.l_5:
        call c_f1d7
        bit 0, (ix+Obj.direction)
        jr Z, .l_6
        ld a, (State.s_4C)
        cp #04
        jr C, .l_6
        set 2, (ix+Obj.flags)
.l_6:
        bit 1, (ix+Obj.direction)
        jr Z, .l_7
        ld a, (State.s_4B)
        cp #04
        jr C, .l_7
        set 2, (ix+Obj.flags)
.l_7:
        bit 2, (ix+Obj.direction)
        jr Z, .l_8
        ld a, (State.s_4A)
        cp #03
        jr C, .l_8
        set 3, (ix+Obj.flags)
.l_8:
        bit 3, (ix+Obj.direction)
        jr Z, .l_9
        ld a, (State.s_49)
        cp #03
        jr C, .l_9
        set 3, (ix+Obj.flags)
.l_9:
        jp c_ef72.l_23

; (Modifies some object properties?)
; Used by c_ed08, c_ef72, c_f0f3 and c_f518.
c_f1d7:  ; #f1d7
        bit 1, (ix+Obj.flags)
        jr NZ, .l_0
        ld a, (ix+Obj.x+0)
        add #08
        ld (ix+Obj.x+0), a
        ld a, (ix+Obj.x+1)
        adc a, #00
        ld (ix+Obj.x+1), a
        call getScrTileAddr
        ld a, (hl)
        call getTileType
        ld (State.s_49), a
        ld de, #0058
        add hl, de
        ld a, (hl)
        call getTileType
        ld (State.s_4A), a
        ld a, (ix+Obj.x+0)
        add #F8
        ld (ix+Obj.x+0), a
        ld a, (ix+Obj.x+1)
        adc a, #FF
        ld (ix+Obj.x+1), a
        call getScrTileAddr
        ld de, #002C
        add hl, de
        ld a, (hl)
        call getTileType
        ld (State.s_4B), a
        inc hl
        inc hl
        ld a, (hl)
        call getTileType
        ld (State.s_4C), a
        ld de, #002A
        add hl, de
        ld a, (hl)
        call getTileType
        ld (State.s_4D), a
        inc hl
        inc hl
        ld a, (hl)
        call getTileType
        ld (State.s_4E), a
        ret
.l_0:
        ld a, (ix+Obj.x+0)
        add #0C
        ld (ix+Obj.x+0), a
        ld a, (ix+Obj.x+1)
        adc a, #00
        ld (ix+Obj.x+1), a
        call getScrTileAddr
        ld a, (ix+Obj.x+0)
        add #F4
        ld (ix+Obj.x+0), a
        ld a, (ix+Obj.x+1)
        adc a, #FF
        ld (ix+Obj.x+1), a
        bit 1, (ix+Obj.direction)
        jr NZ, .l_1
        dec hl
.l_1:
        ld a, (hl)
        call getTileType
        ld (State.s_49), a
        ld de, #0084
        add hl, de
        ld a, (hl)
        call getTileType
        ld (State.s_4A), a
        inc hl
        bit 1, (ix+Obj.direction)
        jr NZ, .l_2
        dec hl
.l_2:
        ld a, (hl)
        call getTileType
        ld c, a
        ld a, (State.s_4A)
        or c
        ld (State.s_4A), a
        call getScrTileAddr
        ld a, (ix+Obj.objType)
        cp #82
        jr Z, .l_3
        ld de, #0058
        add hl, de
.l_3:
        ld a, (hl)
        call getTileType
        ld (State.s_4B), a
        inc hl
        inc hl
        inc hl
        ld a, (hl)
        call getTileType
        ld (State.s_4C), a
        ld de, #0029
        ld a, (ix+Obj.objType)
        cp #11
        jr Z, .l_4
        cp #12
        jr NZ, .l_5
.l_4:
        ld de, #0055
.l_5:
        add hl, de
        ld a, (hl)
        call getTileType
        ld (State.s_4D), a
        inc hl
        inc hl
        inc hl
        ld a, (hl)
        call getTileType
        ld (State.s_4E), a
        ret

; Data block at F2D1
c_f2d1:  ; #f2d1
        db #00, #01, #01, #01, #01, #02, #02, #02
        db #03, #03, #04, #04, #04, #04, #04, #04
        db #04, #04, #04, #04, #04, #04

; (Modifies some object properties?)
; Used by c_ed08.
c_f2e7:  ; #f2e7
        ld a, (ix+Obj.horizSpeed)
        or a
        jr Z, .l_0
        dec (ix+Obj.horizSpeed)
        ret
.l_0:
        bit 2, (ix+Obj.direction)
        jr NZ, .l_2
        ld a, (ix+Obj.o_6)
        or a
        jr NZ, .l_1
        ld (ix+Obj.direction), 4
        ld (ix+Obj.vertSpeed), 0
        ld (ix+Obj.horizSpeed), 32
        ret
.l_1:
        dec (ix+Obj.o_6)
        ld a, (ix+Obj.y)
        and #07
        jr NZ, .l_4
        call getScrTileAddr
        inc hl
        ld (hl), 0
        inc hl
        ld (hl), 0
        ld de, scrTileUpd - scrTiles - 2
        add hl, de
        ld (hl), 1
        inc hl
        ld (hl), 1
        jr .l_4
.l_2:
        inc (ix+Obj.o_6)
        call getScrTileAddr
        ld c, #BD
        ld a, (State.level)
        cp #03
        jr NZ, .l_3
        dec c
.l_3:
        inc hl
        ld (hl), c
        inc hl
        inc c
        ld (hl), c
        ld de, scrTileUpd - scrTiles - 2
        add hl, de
        ld (hl), 1
        inc hl
        ld (hl), 1
        ld a, (ix+Obj.y)
        and %00000111
        jr NZ, .l_4
        call getScrTileAddr
        ld de, 45
        add hl, de
        ld a, (hl)
        call getTileType
        or a
        jr NZ, .l_5
.l_4:
        ld a, (ix+Obj.o_6)
        ld l, a
        ld h, 0
        ld de, c_f2d1
        add hl, de
        ld a, (hl)
        ld (ix+Obj.vertSpeed), a
        ret
.l_5:
        ld (ix+Obj.direction), 8
        ld (ix+Obj.vertSpeed), 0
        ret


; Direction transform (bit 3← 2→ 1↓ 0↑) to (bit 3↑ 2↓ 1← 0→)
directionTransform:  ; #f373
        db %0000
.up:    db %1000
.dn:    db %0100
        db %0000
.lf:    db %0010
.upLf:  db %1010
.dnLf:  db %0110
        db %0000
.rg:    db %0001
.upRg:  db %1001
.dnRg:  db %0101


; (Moves object along trajectory?)
; Used by c_ed08.
c_f37e:  ; #f37e
        bit 5, (ix+Obj.flags)
        ret NZ
        xor a
        ld (State.s_4F), a
        ld (State.s_50), a
        ld a, (ix+Obj.trajectory)
        add a
        ld l, a
        ld h, #00
        ld de, Level.trajVelTable
        add hl, de
        ld e, (hl)
        inc hl
        ld d, (hl)
        ld a, (ix+Obj.trajectory)
        add a
        ld l, a
        ld h, #00
        ld bc, Level.trajDirTable
        add hl, bc
        ld c, (hl)
        inc hl
        ld b, (hl)
.l_0:
        ld l, (ix+Obj.o_16)
        ld h, #00
        add hl, de
        ld a, (hl)
        cp #FF
        jr NZ, .l_1
        dec hl
        ld a, (hl)
        ld (State.s_4F), a
        ld l, (ix+Obj.o_16)
        ld h, #00
        add hl, bc
        dec hl
        ld a, (hl)
        ld (State.s_50), a
        dec (ix+Obj.o_16)
        jr .l_5
.l_1:
        cp #FE
        jr NZ, .l_2
        ld (ix+Obj.o_16), #00
        jr .l_0
.l_2:
        cp #FD
        jr NZ, .l_3
        dec (ix+Obj.o_16)
        jr .l_5
.l_3:
        cp #FC
        jr NZ, .l_4
        ld (ix+Obj.o_17), #FF
        dec (ix+Obj.o_16)
        jr .l_0
.l_4:
        ld (State.s_4F), a
        ld l, (ix+Obj.o_16)
        ld h, #00
        add hl, bc
        ld a, (hl)
        ld (State.s_50), a
.l_5:
        ld a, (State.s_50)
        ld l, a
        ld h, #00
        ld de, directionTransform
        add hl, de
        ld c, (hl)
        ld a, (ix+Obj.o_17)
        or a
        jr Z, .l_8
        ld a, c
        and #03
        jr Z, .l_6
        xor #03
.l_6:
        ld b, a
        ld a, c
        and #0C
        jr Z, .l_7
        xor #0C
.l_7:
        or b
        ld c, a
.l_8:
        ld (ix+Obj.o_18), c
        ld a, (State.s_4F)
        bit 0, (ix+Obj.o_24)
        jr Z, .l_9
        ld (ix+Obj.horizSpeed), a
.l_9:
        ld b, a
        bit 2, c
        jr Z, .l_10
        ld a, (ix+Obj.y)
        add b
        ld (ix+Obj.y), a
        jr .l_11
.l_10:
        bit 3, c
        jr Z, .l_11
        ld a, (ix+Obj.y)
        sub b
        ld (ix+Obj.y), a
.l_11:
        ld e, b
        ld d, #00
        bit 0, c
        jr Z, .l_12
        ld l, (ix+Obj.x+0)
        ld h, (ix+Obj.x+1)
        add hl, de
        ld (ix+Obj.x+0), l
        ld (ix+Obj.x+1), h
        jr .l_13
.l_12:
        bit 1, c
        jr Z, .l_13
        ld l, (ix+Obj.x+0)
        ld h, (ix+Obj.x+1)
        xor a
        sbc hl, de
        ld (ix+Obj.x+0), l
        ld (ix+Obj.x+1), h
.l_13:
        ld a, (ix+Obj.o_17)
        or a
        jr NZ, .l_14
        inc (ix+Obj.o_16)
        jr .l_15
.l_14:
        dec (ix+Obj.o_16)
        jp P, .l_15
        ld (ix+Obj.o_16), 0
        ld (ix+Obj.o_17), 0
.l_15:
        call isObjectVisibleOrWaiting
        ret C
        ld (ix+Obj.flags), 0
        ret


; Check if hero is inside the activation zone of a still enemy
; Used by c_ecee.
checkStillEnemyActivation:  ; #f488
        ld a, (ix+Obj.stillActW)
        or a
        ret Z                   ; not a still enemy

        ; test vertical zone range
        ; hero_top <= obj_y - stillActY + stillActH
        ld iy, scene.hero
        ld a, (ix+Obj.stillActY)
        neg
        add (ix+Obj.y)
        ld c, a
        add (ix+Obj.stillActH)
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
        ld e, (ix+Obj.stillActX)
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
        ld l, (ix+Obj.stillActW)
        ld h, 0
        add hl, de
        ld e, (iy+Obj.x+0)
        ld d, (iy+Obj.x+1)
        xor a
        sbc hl, de
        ret C

        ; if in range, activate the enemy
        res 5, (ix+Obj.flags)   ; remove waiting flag
        res 2, (ix+Obj.flags)
        res 3, (ix+Obj.flags)
        ld (ix+Obj.stillActW), 0
        ret


; Decide whether to blow up a dynamite (?)
; Used by c_ed08.
c_f4e9:  ; #f4e9
        ld a, (ix+Obj.objType)
        cp 15                   ; dynamite
        jr Z, .isDynamite
        cp 16                   ; dynamite
        ret NZ
.isDynamite:
        call generateRandom
        cp 2
        ret NC
        ld (ix+Obj.o_6), 0
        ld (ix+Obj.o_7), -1
        ld (ix+Obj.colour), Colour.white
        ret

; Data block at F506
c_f506:  ; #f506
        db -6, -5, -4, -3, -2, -2, -1, -1, 0, 1, 1, 2, 2, 3, 4, 5, 6
        db #7F

; (Modifies some object properties?)
; Used by c_ed08.
c_f518:  ; #f518
        ld a, (ix+Obj.trajectory)
        ld l, a
        ld h, #00
        ld de, c_f506
        add hl, de
        ld a, (hl)
        cp #7F
        jr NZ, .l_0
        dec (ix+Obj.trajectory)
        ld a, #08
.l_0:
        add (ix+Obj.y)
        ld (ix+Obj.y), a
        ld a, (hl)
        cp #7F
        jr NZ, .l_1
        call c_f1d7
        ld a, (State.s_4A)
        cp #04
        jr C, .l_1
        ld a, (ix+Obj.y)
        and #F8
        ld (ix+Obj.y), a
        ld (ix+Obj.behaviour), #00
.l_1:
        inc (ix+Obj.trajectory)
        jp c_ef72.l_23


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
; Used by c_ed08.
emitEnemyBullet:  ; #f564
        ld a, (State.bulletTime)
        or a
        ret NZ
        ld a, (ix+Obj.behaviour)
        cp 1
        ret Z
        ld a, (ix+Obj.o_49)
        or a
        ret Z

        push ix
        call allocateObject
        push ix
        pop iy
        pop ix
        ret NC                  ; ret if no place for new object
        ; `iy`: new object addr

        ld hl, cS.powerBullet1
        ld (iy+Obj.sprite+0), l
        ld (iy+Obj.sprite+1), h
        ld (iy+Obj.o_7), 0
        ld (iy+Obj.colour), Colour.white
        ld (iy+Obj.direction), 0
        ld (iy+Obj.horizSpeed), 5
        ld (iy+Obj.vertSpeed), 3
        ld (iy+Obj.width), 6
        ld (iy+Obj.height), 6
        ld (iy+Obj.health), 1
        ld (iy+Obj.flags), %1   ; small
        ld (iy+Obj.objType), 0
        ld (iy+Obj.behaviour), 1
        ld (iy+Obj.o_24), 0
        ld a, (ix+Obj.o_49)
        ld (iy+Obj.o_49), a

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

        ld a, (iy+Obj.o_49)
        cp 1
        jr Z, .l_2
        cp 2
        jr NZ, .l_0
        ld a, (ix+Obj.direction)
        and %00000011
        ld (iy+Obj.direction), a
        ret
.l_0:
        cp 3
        jr NZ, .l_1
        ld (iy+Obj.direction), 8
        ret
.l_1:
        cp 4
        ret NZ
        ld (iy+Obj.direction), 4
        ret
.l_2:
        push ix
        push iy
        pop ix
        ld a, 4
        call c_edc0
        pop ix
        ret

; (Modifies some object properties?)
; Used by c_ed08.
c_f618:  ; #f618
        ld a, (ix+Obj.o_49)
        cp 1
        call Z, c_ee93
        ld iy, scene
        call checkObjectCollision
        jr C, .l_1
        ld (ix+Obj.flags), 0
        ld b, (ix+Obj.health)
        ld a, (iy+Obj.blinkTime)
        or a
        ret NZ
        ld a, (State.energy)
        sub b
        jr NC, .l_0
        ld a, #FF
        ld (State.isDead), a
        xor a
.l_0:
        ld (State.energy), a
        ld (iy+Obj.blinkTime), 7
        jp printEnergy
.l_1:
        ld a, (State.level)
        or a
        jr NZ, .l_2
        ld a, (State.bossFight)
        or a
        jr NZ, .l_3
.l_2:
        call getScrTileAddr
        ld a, (hl)
        call getTileType
        cp 4
        jr C, .l_3
        ld (ix+Obj.flags), 0
        ret
.l_3:
        call isObjectVisible
        ret C
        ld (ix+Obj.flags), 0
        ret

; (Some game logic?)
; Used by c_ef72.
c_f670:  ; #f670
        bit 5, (ix+Obj.o_24)
        ret Z
        call generateRandom
        cp 8
        ret NC
        bit 1, (ix+Obj.trajectory)
        jr Z, .l_0
        ld a, (ix+Obj.direction)
        xor %00000011
        ld (ix+Obj.direction), a
.l_0:
        bit 0, (ix+Obj.trajectory)
        ret Z
        ld a, (ix+Obj.direction)
        xor %00001100
        ld (ix+Obj.direction), a
        ret

; (Some game logic?)
; Used by c_ef72.
c_f697:  ; #f697
        bit 1, (ix+Obj.o_24)
        ret Z
        ld a, (ix+Obj.o_48)
        or a
        jr Z, .l_0
        dec (ix+Obj.o_48)
        ret
.l_0:
        call generateRandom
        cp 4
        ret NC
        call generateRandom
        and %00011111
        ld (ix+Obj.o_48), a
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
        ld ix, scene.obj2
        ld b, 6                 ; object count
.object:
        bit 0, (ix+Obj.flags)   ; exists
        jr Z, .skip
        ld l, (ix+Obj.x+0)
        ld h, (ix+Obj.x+1)
        ld de, 288
        xor a
        sbc hl, de
        jp C, .visible
        set 5, (ix+Obj.flags)   ; waiting
        jr .skip
.visible:
        ld a, (ix+Obj.stillActW)
        or a
        jr NZ, .skip            ; visible, but still
        res 5, (ix+Obj.flags)   ; remove waiting flag
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
        ld (ix+Obj.o_6), 0
        ld (ix+Obj.o_48), 0
        ld (ix+Obj.direction), %0000010
        ld a, (hl)              ; spriteAddr (low)
        ld (ix+Obj.sprite+0), a
        inc hl                  ; +1
        ld a, (hl)              ; spriteAddr (high)
        ld (ix+Obj.sprite+1), a
        inc hl                  ; +2
        ld a, (hl)              ; attr
        ld (ix+Obj.colour), a
        inc hl                  ; +3
        ld a, (hl)
        ld (ix+Obj.o_7), a
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
        ld a, (hl)
        or a
        jr Z, .l_2
        ld a, (ix+Obj.flags)
        or %00101100
        ld (ix+Obj.flags), a
.l_2:
        inc hl                  ; +9
        ld a, (hl)
        ld (ix+Obj.score), a
        inc hl                  ; +10
        ld a, (hl)
        ld (ix+Obj.o_24), a
        inc hl                  ; +11
        ld a, (hl)              ; objType (with offset)
        ld (ix+Obj.objType), a
        or a
        jr NZ, .l_3
        ld a, (State.inShop)
        cp #7F
        jr NZ, .l_3
        ld (ix+Obj.flags), #00
        ret
.l_3:
        inc hl                  ; +12
        ld a, (hl)
        ld (ix+Obj.o_49), a
        inc hl                  ; +13
        ld a, (hl)              ; trajectory
        ld (ix+Obj.trajectory), a
        inc hl                  ; +14
        ld a, (hl)
        ld (ix+Obj.o_16), a
        inc hl                  ; +15
        ld a, (hl)
        ld (ix+Obj.o_17), a
        inc hl                  ; +16
        ld a, (hl)
        ld (ix+Obj.o_18), a
        inc hl                  ; +17
        ld a, (hl)              ; mirror (?)
        ld (ix+Obj.horizSpeed), a
        inc hl                  ; +18
        ld a, (hl)
        ld (ix+Obj.vertSpeed), a
        inc hl                  ; +19
        ld a, (hl)
        ld (ix+Obj.direction), a
        inc hl                  ; +20
        ld a, (hl)
        ld (ix+Obj.o_22), a
        inc hl                  ; +21
        ld a, (hl)
        ld (ix+Obj.behaviour), a
        inc hl                  ; +22
        ld a, (hl)
        ld (ix+Obj.stillActX), a
        inc hl                  ; +23
        ld a, (hl)
        ld (ix+Obj.stillActY), a
        inc hl                  ; +24
        ld a, (hl)
        ld (ix+Obj.stillActW), a
        inc hl                  ; +25
        ld a, (hl)
        ld (ix+Obj.stillActH), a

        ; direction transform
        ld a, (ix+Obj.direction)
        ld l, a
        ld h, 0
        ld de, directionTransform
        add hl, de
        ld a, (hl)
        ld (ix+Obj.direction), a

        ; get top by bottom and height
        bit 1, (ix+Obj.flags)   ; is big
        jr NZ, .big             ; why? same code for both cases
.small:
        ld a, (ix+Obj.y)
        sub (ix+Obj.height)
        ld (ix+Obj.y), a
        jr .l_5
.big:
        ld a, (ix+Obj.y)
        sub (ix+Obj.height)
        ld (ix+Obj.y), a

.l_5:
        ld a, (ix+Obj.objType)
        cp 14                   ; press/platform
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
        cp 1                    ; shatterbomb
        jr NZ, .notShatterBomb
        ld a, (ix+Obj.y)
        add 6
        ld (ix+Obj.y), a
        ret

.notShatterBomb:
        ld a, (ix+Obj.objType)
        cp 163                  ; one of three snowBall types in Iceland (?)
        jr NZ, .notSnowBall
        ld (ix+Obj.flags), 0    ; remove object (?)
        ret

.notSnowBall:
        ld a, (State.bossFight)
        or a
        ret NZ

        ld a, (ix+Obj.objType)
        cp 53                   ; Klondike boss
        jr Z, .possiblyBoss
        cp 94                   ; Orient boss
        jr Z, .boss
        cp 138                  ; Amazon boss
        jr Z, .boss
        cp 191                  ; Iceland boss
        jr Z, .boss
        cp 237                  ; Bermuda boss
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
