    MODULE Code


; (Modifies some object properties?)
; Used by c_cc25.
c_e56f:  ; #e56f
        ld ix, scene.obj1
        ld b, #07
.l_0:
        push bc
        call c_e582
        ld bc, Obj
        add ix, bc
        pop bc
        djnz .l_0
        ret

; (Modifies some object properties?)
; Used by c_e56f.
c_e582:  ; #e582
        bit 0, (ix+Obj.flags)
        ret Z
        ld a, (ix+Obj.o_48)
        or a
        ret NZ
        bit 5, (ix+Obj.flags)
        ret NZ
        bit 2, (ix+Obj.flags)
        jr NZ, .l_1
        bit 0, (ix+Obj.o_21)
        jr Z, .l_0
        ld e, (ix+Obj.o_19)
        ld d, #00
        ld l, (ix+Obj.x+0)
        ld h, (ix+Obj.x+1)
        add hl, de
        ld (ix+Obj.x+0), l
        ld (ix+Obj.x+1), h
        jr .l_1
.l_0:
        bit 1, (ix+Obj.o_21)
        jr Z, .l_1
        ld a, (ix+Obj.o_19)
        neg
        ld e, a
        ld d, #FF
        ld l, (ix+Obj.x+0)
        ld h, (ix+Obj.x+1)
        add hl, de
        ld (ix+Obj.x+0), l
        ld (ix+Obj.x+1), h
.l_1:
        bit 3, (ix+Obj.flags)
        ret NZ
        bit 3, (ix+Obj.o_21)
        jr Z, .l_2
        ld a, (ix+Obj.o_20)
        neg
        add (ix+Obj.y)
        ld (ix+Obj.y), a
        ret
.l_2:
        bit 2, (ix+Obj.o_21)
        ret Z
        ld a, (ix+Obj.o_20)
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

; ?
; Used by c_cc25.
c_e60a:  ; #e60a
        ld ix, scene
        ld a, (State.s_27)
        ld (State.s_44), a
        ld a, (ix+Obj.y)
        ld (State.s_43), a
        cp #0B
        jp C, .l_0
        cp #E0
        jr NC, .l_1
        ret
.l_0:
        xor a
        exa
        ld (ix+Obj.y), #E0
        xor a
        ld (State.s_27), a
        jr .l_2
.l_1:
        ld a, #01
        exa
        ld (ix+Obj.y), #0C
.l_2:
        ld de, Level.transitTable
        ld l, (ix+Obj.x+0)
        ld h, (ix+Obj.x+1)
        ld bc, -22
        add hl, bc
        sra h
        rr l
        sra h
        rr l
        sra h
        rr l
        ld bc, (State.screenX)
        add hl, bc
        sra h
        rr l
        sra h
        rr l
        ld (.hl), hl
.l_3:
        exa
        ld c, a
        exa
        ld a, (de)
        cp c
        jr NZ, .l_4
        inc de
        ld a, (de)
        ld c, a
        inc de
        ld a, (de)
        ld b, a
        xor a
.hl+*   ld hl, -0
        sbc hl, bc
        jr Z, .l_5
        dec de
        dec de
.l_4:
        ld hl, Transit
        add hl, de
        ex de, hl
        ld a, (de)
        or a
        jp P, .l_3
        ld a, (State.s_43)
        ld (ix+Obj.y), a
        ld a, (State.s_44)
        ld (State.s_27), a
        ret
.l_5:
        ld a, #3C
        ld (State.s_51), a
        call removeObjects
        ld hl, #0005
        add hl, de
        ld a, (hl)
        add a
        add a
        add a
        add a
        add a
        add #20
        ld (ix+Obj.x+0), a
        ld (ix+Obj.x+1), #00
        ld de, -4
        add hl, de
        ld e, (hl)
        inc hl
        ld d, (hl)
        inc hl
        ld a, (hl)
        inc hl
        ld h, (hl)
        ld l, a
        add hl, hl
        add hl, hl
        ex de, hl
        add hl, hl
        add hl, hl
        call removeObjects
        call moveToMapSpan
        xor a
        ret

; (Checks some object properties?)
; Used by c_f564 and c_f74a.
c_e6c2:  ; #e6c2
        push de
        push bc
        ld b, #06
        ld ix, scene.obj2
        ld de, Obj
.l_0:
        bit 0, (ix+Obj.flags)
        jr Z, .l_1
        add ix, de
        djnz .l_0
        xor a
        pop bc
        pop de
        ret
.l_1:
        scf
        pop bc
        pop de
        ret

; (Some variable?)
c_e6df:  ; #e6df
        dw #0000

; (Process collision?)
; Used by c_cc25.
c_e6e1:  ; #e6e1
        ld a, (State.s_46)
        or a
        ret NZ
        ld ix, scene
        ld l, (ix+Obj.x+0)
        ld h, (ix+Obj.x+1)
        ld (c_e6df), hl
        inc hl
        inc hl
        inc hl
        inc hl
        ld (ix+Obj.x+0), l
        ld (ix+Obj.x+1), h
        ld iy, scene.obj2
        ld b, #06
.l_0:
        push bc
        call c_e80a
        pop bc
        jr NC, .l_1
        ld de, Obj
        add iy, de
        djnz .l_0
        ld hl, (c_e6df)
        ld (ix+Obj.x+0), l
        ld (ix+Obj.x+1), h
        ret
.l_1:
        ld hl, (c_e6df)
        ld (ix+Obj.x+0), l
        ld (ix+Obj.x+1), h
        ld a, (iy+Obj.o_8)
        cp #0E
        jp NC, .l_12
        or a
        ret Z
        cp #04
        jr NC, .l_2
        exa
        ld a, (State.s_3D)
        or a
        ret NZ
        exa
        ld (State.weapon), a
        ld hl, #02EE
        ld (State.s_3A), hl
        ld (iy+Obj.flags), #00
        ld a, #0D
        jp playSound
.l_2:
        cp #09
        jr Z, .l_3
        push af
        ld a, #0B
        call playSound
        pop af
.l_3:
        cp #04
        jr NZ, .l_5
        ld a, (State.soupCans)
        cp #03
        jr Z, .l_4
        inc a
        ld (State.soupCans), a
.l_4:
        ld (iy+Obj.flags), #00
        jp printSoupCans
.l_5:
        cp #05
        jr NZ, .l_6
        ld (iy+Obj.flags), #00
        ld a, #04
        jp addEnergy
.l_6:
        cp #06
        jr NZ, .l_7
        ld (iy+Obj.flags), #00
        ld a, (State.coins)
    IFDEF _MOD
        inc a                   ; coin denomination
    ELSE
        add 25
    ENDIF
        ld (State.coins), a
        jp printCoinCount
.l_7:
        cp #07
        jr NZ, .l_9
        ld (iy+Obj.flags), #00
        ld a, (State.maxEnergy)
        add #04
        cp #22
        jr C, .l_8
        ld a, #22
.l_8:
        ld (State.maxEnergy), a
        ld a, #04
        jp addEnergy
.l_9:
        cp #08
        jr NZ, .l_10
        ld (iy+Obj.flags), #00
        ld a, #FF
        ld (State.hasDiary), a
        ret
.l_10:
        cp #0A
        jr NC, .l_11
        ld a, (controlState)
        bit 2, a
        ret Z
        ld (iy+Obj.flags), #00
        ld a, #FF
        ld (State.s_46), a
        ret
.l_11:
        ld (iy+Obj.flags), #00
        ld a, (iy+Obj.o_13)
        jp addScore
.l_12:
        cp #0E
        jr NZ, .l_14
        bit 3, (iy+Obj.o_21)
        ret NZ
        ld a, (State.s_45)
        or a
        ret NZ
        ld a, (State.s_28)
        cp #02
        jr C, .l_13
        ret NZ
        call c_d94c.l_13
        ld a, (State.s_28)
        or a
        ret NZ
.l_13:
        ld a, #32
        ld (State.s_45), a
.l_14:
        ld a, (iy+Obj.o_7)
        cp #FF
        ret Z
        bit 0, (iy+Obj.o_24)
        ret NZ
        ld a, (iy+Obj.health)
        cp #FE
        ret Z
        jp decEnergy

; (Checks some object properties?)
; Used by c_e6e1, c_e9b1, c_eb19 and c_f618.
c_e80a:  ; #e80a
        bit 0, (iy+Obj.flags)
        jr NZ, .l_0
        scf
        ret
.l_0:
        ld d, (ix+Obj.o_11)
        ld e, (ix+Obj.o_10)
        ld b, (iy+Obj.o_11)
        ld c, (iy+Obj.o_10)
        ld a, (ix+Obj.y)
        ld l, a
        add d
        ld h, (iy+Obj.y)
        cp h
        ret C
        ld a, h
        add b
        cp l
        ret C
        ld l, (ix+Obj.x+0)
        ld h, (ix+Obj.x+1)
        push hl
        ld d, #00
        add hl, de
        ld e, (iy+Obj.x+0)
        ld d, (iy+Obj.x+1)
        ld a, (iy+Obj.o_8)
        cp #0E
        jr NZ, .l_1
        ld a, e
        add #06
        ld e, a
.l_1:
        or a
        sbc hl, de
        pop hl
        ret C
        ex de, hl
        ld b, #00
        ld a, (iy+Obj.o_8)
        cp #0E
        jr NZ, .l_2
        ld a, c
        sub #0C
        ld c, a
.l_2:
        add hl, bc
        or a
        sbc hl, de
        ret

; (Some table, 5 levels * 6 words)
c_e85f:  ; #e85f
.lev0:  dw #0668, #0668, #0404, #03AC, #0414, #0102
.lev1:  dw #0668, #0688, #0405, #02B4, #0378, #0405
.lev2:  dw #0668, #0688, #0405, #04D8, #04F8, #020B
.lev3:  dw #066C, #068C, #0403, #04F8, #0530, #0402
.lev4:  dw #066C, #068C, #0405, #0580, #0640, #0304

; Item prices in the shop
c_e89b:  ; #e89b
    IFDEF _MOD
        db 5, 6, 7, 10, 3, 1, 8, 4, 0   ; coin denomination
    ELSE
        db 125, 150, 175, 250, 75, 1, 200, 100, 0
    ENDIF

; Item names in the shop
c_e8a4:  ; #e8a4
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
c_e910:  ; #e910
        db "   TOO MUCH     "C

; (Init something?)
; Used by c_cc25.
c_e920:  ; #e920
        ld a, (State.s_46)
        bit 7, a
        ret Z
        call removeObjects
        ld a, (State.level)
        add a
        add a
        ld l, a
        add a
        add l
        ld l, a
        ld h, #00
        ld de, c_e85f
        add hl, de
        ld e, (hl)
        inc hl
        ld d, (hl)
        push de
        inc hl
        ld e, (hl)
        inc hl
        ld d, (hl)
        dec de
        dec de
        dec de
        dec de
        inc hl
        call c_eace
        pop hl
        call moveToMapSpan
        ld a, #7F
        ld (State.s_46), a
        call findAndPutObjectsToScene
        ld ix, scene.obj2
        ld b, #06
        ld de, Obj
.l_0:
        ld a, (ix+Obj.o_8)
        or a
        jr Z, .l_1
        add ix, de
        djnz .l_0
.l_1:
        ld iy, scene
        ld a, (iy+Obj.x+0)
        add #20
        ld (ix+Obj.x+0), a
        ld (ix+Obj.x+1), #00
        ld a, (iy+Obj.y)
        add #0B
        ld (ix+Obj.y), a
        ld hl, cS.shopMole
        ld (ix+Obj.sprite+0), l
        ld (ix+Obj.sprite+1), h
        ld (ix+Obj.color), #47
        ld (ix+Obj.o_21), #00
        ld (ix+Obj.o_10), #18
        ld (ix+Obj.o_11), #15
        ld (ix+Obj.o_8), #09
        ld (ix+Obj.flags), #03
        ld (ix+Obj.health), #FE
        ld (ix+Obj.o_24), #00
        ld (ix+Obj.o_49), #00
        ld (ix+Obj.o_23), #00
        ret

; Shop logic
; Used by c_cc25.
c_e9b1:  ; #e9b1
        ld a, (State.s_46)
        cp #7F
        ret NZ
        ld ix, scene
        ld iy, scene.obj2
        ld b, #06
.l_0:
        push bc
        call c_e80a
        pop bc
        jr NC, .l_1
        ld de, Obj
        add iy, de
        djnz .l_0
        jp printEnergy
.l_1:
        ld a, (iy+Obj.o_8)
        or a
        ret Z
        dec a
        ld (State.shopItem), a
        ld l, a
        ld h, #00
        add hl, hl
        add hl, hl
        ld e, l
        ld d, h
        add hl, hl
        add hl, de
        ld de, c_e8a4
        add hl, de
        ex de, hl
        ld c, #47
        ld hl, #000F
        call printString
        ld a, (State.shopItem)
        ld l, a
        ld h, #00
        ld de, c_e89b
        add hl, de
        ld a, (hl)
        ld (State.shopPrice), a
        or a
        jr Z, .l_2

    IFDEF _MOD
        ; TODO: set attrs
        ld hl, Screen.pixels.row0 + 27
        call printCoinCountAt
    ELSE
        ld hl, #001C            ; at 0, 28
        ld c, #47               ; bright white
        call printNumber
    ENDIF

.l_2:
        ld a, (controlState)
        bit 4, a
        ret Z
        ld a, (State.shopPrice)
        or a
        jr NZ, .l_3
        call removeObjects
        ld a, (State.level)
    .2  add a
        ld l, a
        add a
        add l
        ld l, a
        ld h, #00
        ld de, c_e85f
        add hl, de
        ld de, #0006
        add hl, de
        ld e, (hl)
        inc hl
        ld d, (hl)
        push de
        inc hl
        ld e, (hl)
        inc hl
        ld d, (hl)
    .4  dec de
        inc hl
        call c_eace
        pop hl
        call moveToMapSpan
        xor a
        ld (State.s_46), a
        ld (State.s_28), a
        jp printEnergy
.l_3:
        ld a, (State.shopPrice)
        ld b, a
        ld a, (State.coins)
        sub b
        jr NC, .l_5
        ld hl, #000F
        ld de, c_e910
        ld c, #47
        call printString
.l_4:
        ld a, (controlState)
        bit 4, a
        jr NZ, .l_4
        ret
.l_5:
        ld (State.coins), a
        call printCoinCount
        ld (iy+Obj.flags), #00
        ld a, (State.shopItem)
        inc a
        cp #04
        jr NC, .l_6
        ld (State.weapon), a
        ld hl, #02EE
        ld (State.s_3A), hl
        ret
.l_6:
        cp #04
        jr NZ, .l_8
        ld a, (State.soupCans)
        cp #03
        jr Z, .l_7
        inc a
        ld (State.soupCans), a
.l_7:
        ld (iy+Obj.flags), #00
        jp printSoupCans
.l_8:
        cp #05
        jr NZ, .l_9
        ld (iy+Obj.flags), #00
        ld a, #04
        jp addEnergy
.l_9:
        cp #07
        jr NZ, .l_11
        ld (iy+Obj.flags), #00
        ld a, (State.maxEnergy)
        add #04
        cp #22
        jr C, .l_10
        ld a, #22
.l_10:
        ld (State.maxEnergy), a
        ld a, #04
        jp addEnergy
.l_11:
        cp #08
        ret NZ
        ld (iy+Obj.flags), #00
        ld a, #FF
        ld (State.hasDiary), a
        ret

; (Init ix+Obj.o_0, 1, 2 from (hl)?)
; Used by c_e920 and c_e9b1.
c_eace:  ; #eace
        ld ix, scene
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

; Get tile type without bit 7
; Used by c_d709, c_d7f6, c_d94c, c_da95, c_db4e, c_dbfc, c_de37,
; c_deb1, c_df85, c_f1d7, c_f2e7 and c_f618.
c_eaee:  ; #eaee
        push hl
        ld h, high(Level.tileTypes)
        ld l, a
        ld a, (hl)
        and #7F
        pop hl
        ret

; (Some damage table (3 something * 3 soup cans)?)
c_eaf7:  ; #eaf7
        db #04, #10, #10, #02, #14, #14, #00, #18
        db #18

; Check enemies for damaging?
; Used by c_df85.
c_eb00:  ; #eb00
        ld ix, scene.obj1
        ld iy, scene.obj2
        ld b, #06
.l_0:
        push bc
        call c_eb19
        pop bc
        ret NC
        ld de, Obj
        add iy, de
        djnz .l_0
        scf
        ret

; Logic for damaging enemies?
; Used by c_eb00.
c_eb19:  ; #eb19
        ld a, (iy+Obj.o_8)
        or a
        jp Z, damageEnemy.notDamaged
        bit 0, (iy+Obj.flags)
        jp Z, damageEnemy.notDamaged
        ld a, (iy+Obj.health)
        cp #FE
        jp Z, damageEnemy.notDamaged
        ld a, (iy+Obj.blinkTime)
        or a
        jp NZ, damageEnemy.notDamaged
        ld a, (State.weapon)
        or a
        jr NZ, .l_1
        ld a, (iy+Obj.o_7)
        cp #FF
        jr NZ, .l_0
        res 0, (ix+Obj.flags)
        ret
.l_0:
        ld a, (State.soupCans)
        dec a
        ld l, a
        add a
        add l
        ld l, a
        ld h, #00
        ld de, c_eaf7
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
        ld (ix+Obj.o_10), a
        ld a, (bc)
        ld (ix+Obj.o_11), a
        call c_e80a
        pop hl
        ld (ix+Obj.x+0), l
        ld (ix+Obj.x+1), h
        ret C
        set 0, (ix+Obj.flags)
        jr damageEnemy
.l_1:
        cp #01
        jr NZ, .l_3
        bit 1, (ix+Obj.flags)
        jr NZ, .l_2
        ld a, (ix+Obj.x+0)
        add #04
        ld (ix+Obj.x+0), a
        ld a, (ix+Obj.x+1)
        adc a, #00
        ld (ix+Obj.x+1), a
        call c_e80a
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
        ld de, c_eaf7
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
        ld (ix+Obj.o_10), a
        ld a, (bc)
        ld (ix+Obj.o_11), a
        call c_e80a
        pop hl
        ld (ix+Obj.x+0), l
        ld (ix+Obj.x+1), h
        ret C
        jr damageEnemy
.l_3:
        call c_e80a
        ret C
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

        ld a, 3                 ; damage enemy
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
        ld (iy+Obj.color), #47  ; bright white
        ld a, 6                 ; kill enemy
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
        ld a, (State.s_55)
        add b
        jr NC, .l_7

        ld (State.s_55), a
        ld a, 3                 ; damage enemy
        call playSound

        push ix
        push de
        ld ix, scene.obj2
        ld b, 4                 ; object count
        ld de, Obj              ; object size
.bossPartLoop1:
        bit 1, (ix+Obj.flags)
        jr Z, .l_6
        ld (ix+Obj.blinkTime), 4
.l_6:
        add ix, de
        djnz .bossPartLoop1

        pop de
        pop ix
        jr .damaged

.l_7:
        push ix
        push de
        ld ix, scene.obj2
        ld b, 4                 ; object count
        ld de, Obj              ; object size
.bossPartLoop2:
        bit 0, (ix+Obj.flags)
        jr Z, .l_9
        bit 1, (ix+Obj.flags)
        jr Z, .l_9
        ; turn into cloud
        ld (ix+Obj.o_6), 0
        ld (ix+Obj.o_7), -1
        ld (ix+Obj.color), #47  ; bright white
.l_9:
        add ix, de
        djnz .bossPartLoop2

        pop de
        pop ix
        ld a, -1
        ld (State.s_57), a

        ; level complete
        ld de, scoreTable.done
        call addScoreRaw
        ld a, (State.level)
        ld hl, State.levelsDone
        ld e, a
        ld d, 0
        add hl, de
        ld (hl), 1

        ld a, 6                 ; kill enemy
        call playSound
        jr .damaged


; (Modifies some object properties?)
; Used by c_cc25.
c_ecee:  ; #ecee
        ld ix, scene.obj2
        ld b, 6
.object:
        push bc
        push ix
        call c_f488
        call c_ed08
        pop ix
        ld bc, Obj
        add ix, bc
        pop bc
        djnz .object
        ret

; (Modifies some object properties?)
; Used by c_ecee.
c_ed08:  ; #ed08
        bit 0, (ix+Obj.flags)
        ret Z
        call c_f564
        ld a, (ix+Obj.o_23)
        cp #01
        jp Z, c_f618
        bit 5, (ix+Obj.flags)
        ret NZ
        ld a, (ix+Obj.o_8)
        cp #0E
        jp Z, c_f2e7
        call c_f4e9
        ld a, (ix+Obj.o_23)
        cp #02
        jr NZ, .l_0
        call c_f37e
        jp .l_2
.l_0:
        cp #04
        call Z, c_f37e
        ld a, (ix+Obj.o_23)
        or a
        jp Z, .l_1
        cp #03
        jp Z, c_ef72
        cp #04
        jp Z, c_ef72
        cp #05
        jp Z, c_f0f3
        cp #06
        jp Z, c_f518
        ret
.l_1:
        set 2, (ix+Obj.flags)
        set 3, (ix+Obj.flags)
        ret
.l_2:
        ld a, (ix+Obj.o_22)
        cp #FE
        jr Z, .l_5
        cp #FF
        ret NZ
        call c_f1d7
        ld a, (State.s_4A)
        cp #02
        ret C
        bit 1, (ix+Obj.flags)
        jr NZ, .l_3
        call makeObjectBig
.l_3:
        ld a, (ix+Obj.o_8)
        cp #28
        jr NZ, .l_4
        ld a, (ix+Obj.x+0)
        sub #08
        ld (ix+Obj.x+0), a
.l_4:
        ld (ix+Obj.o_6), #00
        ld (ix+Obj.o_7), #FF
        ld (ix+Obj.color), #47
        ld a, #06
        jp playSound
.l_5:
        call c_f1d7
        ld a, (State.s_4A)
        cp #04
        ret C
        ld (ix+Obj.o_23), #00
        set 5, (ix+Obj.flags)
        ld a, (ix+Obj.o_8)
        cp #6E
        ret NZ
        ld hl, Lev2Amazon.lS.sittingMonkey
        ld (ix+Obj.sprite+0), l
        ld (ix+Obj.sprite+1), h
        ld (ix+Obj.o_7), #00
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
        ld (ix+Obj.o_32), a
        ld (ix+Obj.o_33), #00
        ld iy, scene
        ld l, (iy+Obj.x+0)
        ld h, (iy+Obj.x+1)
        ld a, (iy+Obj.o_10)
        srl a
        sub #03
        ld e, a
        ld d, #00
        add hl, de
        ld (ix+Obj.o_34), l
        ld (ix+Obj.o_35), h
        push hl
        ld a, (iy+Obj.o_11)
        srl a
        sub #03
        add (iy+Obj.y)
        ld (ix+Obj.o_36), a
        ld (ix+Obj.o_37), #00
        pop hl
        pop de
        xor a
        sbc hl, de
        ex de, hl
        ld c, (ix+Obj.o_32)
        ld b, (ix+Obj.o_33)
        ld l, (ix+Obj.o_36)
        ld h, (ix+Obj.o_37)
        xor a
        sbc hl, bc
        bit 7, d
        jp M, .l_0
        ld (ix+Obj.o_42), #01
        ld (ix+Obj.o_43), #00
        jr .l_1
.l_0:
        ld (ix+Obj.o_42), #FF
        ld (ix+Obj.o_43), #FF
        ld a, d
        cpl
        ld d, a
        ld a, e
        cpl
        ld e, a
        inc de
.l_1:
        ld (ix+Obj.o_38), e
        ld (ix+Obj.o_39), d
        ld a, h
        or l
        jr Z, .l_2
        bit 7, h
        jp M, .l_3
        ld (ix+Obj.o_44), #01
        ld (ix+Obj.o_45), #00
        ld (ix+Obj.o_46), #00
        ld (ix+Obj.o_47), #00
        jr .l_4
.l_2:
        ld (ix+Obj.o_44), #01
        ld (ix+Obj.o_45), #00
        ld (ix+Obj.o_46), #FF
        ld (ix+Obj.o_47), #FF
        jr .l_4
.l_3:
        ld (ix+Obj.o_44), #FF
        ld (ix+Obj.o_45), #FF
        ld (ix+Obj.o_46), #00
        ld (ix+Obj.o_47), #00
        ld a, h
        cpl
        ld h, a
        ld a, l
        cpl
        ld l, a
        inc hl
.l_4:
        ld (ix+Obj.o_40), l
        ld (ix+Obj.o_41), h
        ld (ix+Obj.o_36), #00
        ld (ix+Obj.o_37), #00
        ret

; (Modifies some object properties?)
; Used by c_f618.
c_ee93:  ; #ee93
        ld a, (ix+Obj.o_7)
        cp #FF
        ret Z
        ld b, (ix+Obj.o_29)
        ld e, (ix+Obj.o_38)
        ld d, (ix+Obj.o_39)
        ld l, (ix+Obj.o_40)
        ld h, (ix+Obj.o_41)
        xor a
        sbc hl, de
        jr NC, .l_2
.l_0:
        ld a, (ix+Obj.o_46)
        or a
        jp M, .l_1
        ld l, (ix+Obj.o_32)
        ld h, (ix+Obj.o_33)
        ld e, (ix+Obj.o_44)
        ld d, (ix+Obj.o_45)
        add hl, de
        ld (ix+Obj.o_32), l
        ld (ix+Obj.o_33), h
        ld e, (ix+Obj.o_38)
        ld d, (ix+Obj.o_39)
        ld l, (ix+Obj.o_46)
        ld h, (ix+Obj.o_47)
        xor a
        sbc hl, de
        ld (ix+Obj.o_46), l
        ld (ix+Obj.o_47), h
.l_1:
        ld l, (ix+Obj.o_30+0)
        ld h, (ix+Obj.o_30+1)
        ld e, (ix+Obj.o_42)
        ld d, (ix+Obj.o_43)
        add hl, de
        ld (ix+Obj.o_30+0), l
        ld (ix+Obj.o_30+1), h
        ld l, (ix+Obj.o_40)
        ld h, (ix+Obj.o_41)
        ld e, (ix+Obj.o_46)
        ld d, (ix+Obj.o_47)
        add hl, de
        ld (ix+Obj.o_46), l
        ld (ix+Obj.o_47), h
        djnz .l_0
        jr .l_4
.l_2:
        ld a, (ix+Obj.o_46)
        or a
        jp P, .l_3
        ld l, (ix+Obj.o_30+0)
        ld h, (ix+Obj.o_30+1)
        ld e, (ix+Obj.o_42)
        ld d, (ix+Obj.o_43)
        add hl, de
        ld (ix+Obj.o_30+0), l
        ld (ix+Obj.o_30+1), h
        ld l, (ix+Obj.o_40)
        ld h, (ix+Obj.o_41)
        ld e, (ix+Obj.o_46)
        ld d, (ix+Obj.o_47)
        xor a
        add hl, de
        ld (ix+Obj.o_46), l
        ld (ix+Obj.o_47), h
.l_3:
        ld l, (ix+Obj.o_32)
        ld h, (ix+Obj.o_33)
        ld e, (ix+Obj.o_44)
        ld d, (ix+Obj.o_45)
        add hl, de
        ld (ix+Obj.o_32), l
        ld (ix+Obj.o_33), h
        ld e, (ix+Obj.o_38)
        ld d, (ix+Obj.o_39)
        ld l, (ix+Obj.o_46)
        ld h, (ix+Obj.o_47)
        xor a
        sbc hl, de
        ld (ix+Obj.o_46), l
        ld (ix+Obj.o_47), h
        djnz .l_2
.l_4:
        ld l, (ix+Obj.o_30+0)
        ld h, (ix+Obj.o_30+1)
        ld (ix+Obj.x+0), l
        ld (ix+Obj.x+1), h
        ld a, (ix+Obj.o_32)
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
        bit 0, (ix+Obj.o_21)
        jr NZ, .l_1
        ld a, (State.s_4B)
.l_1:
        cp #04
        jr NC, .l_3
        ld a, (ix+Obj.o_8)
        cp #82
        jr Z, .l_4
        ld a, (State.s_4E)
        bit 0, (ix+Obj.o_21)
        jr NZ, .l_2
        ld a, (State.s_4D)
.l_2:
        or a
        jr NZ, .l_4
.l_3:
        ld a, (ix+Obj.o_21)
        xor #03
        ld (ix+Obj.o_21), a
        jp .l_23
.l_4:
        ld l, (ix+Obj.x+0)
        ld h, (ix+Obj.x+1)
        bit 0, (ix+Obj.o_21)
        jr NZ, .l_5
        ld de, #0020
        xor a
        sbc hl, de
        jr C, .l_3
        jp .l_23
.l_5:
        ld d, #00
        ld e, (ix+Obj.o_10)
        add hl, de
        ld de, #0120
        xor a
        sbc hl, de
        jr NC, .l_3
        jp .l_23
.l_6:
        ld (ix+Obj.o_20), #08
        call c_f1d7
        bit 7, (ix+Obj.o_24)
        jr NZ, .l_9
        call c_f670
        call c_f697
        ld a, (State.s_4C)
        bit 0, (ix+Obj.o_21)
        jr NZ, .l_7
        ld a, (State.s_4B)
.l_7:
        cp #04
        jr C, .l_8
        ld a, (ix+Obj.o_21)
        xor #03
        ld (ix+Obj.o_21), a
.l_8:
        ld a, (State.s_4A)
        cp #02
        jp NC, .l_23
        set 7, (ix+Obj.o_24)
        set 2, (ix+Obj.flags)
        set 2, (ix+Obj.o_21)
        jp .l_23
.l_9:
        ld a, (State.s_4A)
        cp #02
        jp C, .l_23
        res 7, (ix+Obj.o_24)
        res 2, (ix+Obj.flags)
        res 2, (ix+Obj.o_21)
        jp .l_23
.l_10:
        bit 0, (ix+Obj.o_15)
        jr Z, .l_11
        call generateRandom
        cp #0A
        jr NC, .l_11
        ld a, (ix+Obj.o_21)
        xor #0C
        ld (ix+Obj.o_21), a
.l_11:
        bit 1, (ix+Obj.o_15)
        jr Z, .l_12
        call generateRandom
        cp #0A
        jr NC, .l_12
        ld a, (ix+Obj.o_21)
        xor #03
        ld (ix+Obj.o_21), a
.l_12:
        call c_f1d7
        bit 0, (ix+Obj.o_21)
        jr Z, .l_13
        ld a, (State.s_4C)
        cp #02
        jr NC, .l_14
        jr .l_15
.l_13:
        bit 1, (ix+Obj.o_21)
        jr Z, .l_15
        ld a, (State.s_4B)
        cp #02
        jr C, .l_15
.l_14:
        ld a, (ix+Obj.o_21)
        xor #03
        ld (ix+Obj.o_21), a
.l_15:
        bit 2, (ix+Obj.o_21)
        jr Z, .l_16
        ld a, (State.s_4A)
        cp #02
        jr NC, .l_17
        jr .l_18
.l_16:
        bit 3, (ix+Obj.o_21)
        jr Z, .l_18
        ld a, (State.s_49)
        cp #02
        jr C, .l_18
.l_17:
        ld a, (ix+Obj.o_21)
        xor #0C
        ld (ix+Obj.o_21), a
.l_18:
        jp .l_23
.l_19:
        ld a, (ix+Obj.o_15)
        cp (ix+Obj.o_16)
        jr Z, .l_20
        inc (ix+Obj.o_15)
        jp .l_23
.l_20:
        ld (ix+Obj.o_15), #00
        ld c, (ix+Obj.o_21)
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
        ld (ix+Obj.o_21), a
        jp .l_23
; This entry point is used by c_f0f3 and c_f518.
.l_23:
        call isObjectVisibleOrWaiting
        ret C
        ld (ix+Obj.flags), #00
        ret

; (Some game logic?)
; Used by c_ed08.
c_f0f3:  ; #f0f3
        ld (ix+Obj.o_19), #02
        ld (ix+Obj.o_20), #02
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
        ld c, (ix+Obj.o_10)
        srl c
        ld b, #00
        add hl, bc
        ex de, hl
        ld l, (iy+Obj.x+0)
        ld h, (iy+Obj.x+1)
        ld c, (iy+Obj.o_10)
        srl c
        ld b, #00
        add hl, bc
        xor a
        sbc hl, de
        ld (ix+Obj.o_21), #01
        jp P, .l_2
        ld (ix+Obj.o_21), #02
        ld a, l
        cpl
        ld l, a
        ld a, h
        cpl
        ld h, a
        inc hl
.l_2:
        ld e, (ix+Obj.o_19)
        ld d, #00
        xor a
        sbc hl, de
        jp P, .l_3
        set 2, (ix+Obj.flags)
.l_3:
        ld a, (ix+Obj.y)
        ld c, (ix+Obj.o_11)
        srl c
        add c
        ld c, a
        ld a, (iy+Obj.y)
        ld b, (iy+Obj.o_11)
        srl b
        add b
        sub c
        set 2, (ix+Obj.o_21)
        res 3, (ix+Obj.o_21)
        jp P, .l_4
        cpl
        set 3, (ix+Obj.o_21)
        res 2, (ix+Obj.o_21)
.l_4:
        cp (ix+Obj.o_20)
        jr NC, .l_5
        set 3, (ix+Obj.flags)
.l_5:
        call c_f1d7
        bit 0, (ix+Obj.o_21)
        jr Z, .l_6
        ld a, (State.s_4C)
        cp #04
        jr C, .l_6
        set 2, (ix+Obj.flags)
.l_6:
        bit 1, (ix+Obj.o_21)
        jr Z, .l_7
        ld a, (State.s_4B)
        cp #04
        jr C, .l_7
        set 2, (ix+Obj.flags)
.l_7:
        bit 2, (ix+Obj.o_21)
        jr Z, .l_8
        ld a, (State.s_4A)
        cp #03
        jr C, .l_8
        set 3, (ix+Obj.flags)
.l_8:
        bit 3, (ix+Obj.o_21)
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
        call c_eaee
        ld (State.s_49), a
        ld de, #0058
        add hl, de
        ld a, (hl)
        call c_eaee
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
        call c_eaee
        ld (State.s_4B), a
        inc hl
        inc hl
        ld a, (hl)
        call c_eaee
        ld (State.s_4C), a
        ld de, #002A
        add hl, de
        ld a, (hl)
        call c_eaee
        ld (State.s_4D), a
        inc hl
        inc hl
        ld a, (hl)
        call c_eaee
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
        bit 1, (ix+Obj.o_21)
        jr NZ, .l_1
        dec hl
.l_1:
        ld a, (hl)
        call c_eaee
        ld (State.s_49), a
        ld de, #0084
        add hl, de
        ld a, (hl)
        call c_eaee
        ld (State.s_4A), a
        inc hl
        bit 1, (ix+Obj.o_21)
        jr NZ, .l_2
        dec hl
.l_2:
        ld a, (hl)
        call c_eaee
        ld c, a
        ld a, (State.s_4A)
        or c
        ld (State.s_4A), a
        call getScrTileAddr
        ld a, (ix+Obj.o_8)
        cp #82
        jr Z, .l_3
        ld de, #0058
        add hl, de
.l_3:
        ld a, (hl)
        call c_eaee
        ld (State.s_4B), a
        inc hl
        inc hl
        inc hl
        ld a, (hl)
        call c_eaee
        ld (State.s_4C), a
        ld de, #0029
        ld a, (ix+Obj.o_8)
        cp #11
        jr Z, .l_4
        cp #12
        jr NZ, .l_5
.l_4:
        ld de, #0055
.l_5:
        add hl, de
        ld a, (hl)
        call c_eaee
        ld (State.s_4D), a
        inc hl
        inc hl
        inc hl
        ld a, (hl)
        call c_eaee
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
        ld a, (ix+Obj.o_19)
        or a
        jr Z, .l_0
        dec (ix+Obj.o_19)
        ret
.l_0:
        bit 2, (ix+Obj.o_21)
        jr NZ, .l_2
        ld a, (ix+Obj.o_6)
        or a
        jr NZ, .l_1
        ld (ix+Obj.o_21), #04
        ld (ix+Obj.o_20), #00
        ld (ix+Obj.o_19), #20
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
        call c_eaee
        or a
        jr NZ, .l_5
.l_4:
        ld a, (ix+Obj.o_6)
        ld l, a
        ld h, 0
        ld de, c_f2d1
        add hl, de
        ld a, (hl)
        ld (ix+Obj.o_20), a
        ret
.l_5:
        ld (ix+Obj.o_21), #08
        ld (ix+Obj.o_20), #00
        ret

; (Direction transform?)
c_f373:  ; #f373
        db #00, #08, #04, #00, #02, #0A, #06, #00
        db #01, #09, #05

; (Moves object along trajectory?)
; Used by c_ed08.
c_f37e:  ; #f37e
        bit 5, (ix+Obj.flags)
        ret NZ
        xor a
        ld (State.s_4F), a
        ld (State.s_50), a
        ld a, (ix+Obj.o_15)
        add a
        ld l, a
        ld h, #00
        ld de, Level.trajVelTable
        add hl, de
        ld e, (hl)
        inc hl
        ld d, (hl)
        ld a, (ix+Obj.o_15)
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
        ld de, c_f373
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
        ld (ix+Obj.o_19), a
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
        ld (ix+Obj.o_16), #00
        ld (ix+Obj.o_17), #00
.l_15:
        call isObjectVisibleOrWaiting
        ret C
        ld (ix+Obj.flags), #00
        ret

; (Modifies some object properties?)
; Used by c_ecee.
c_f488:  ; #f488
        ld a, (ix+Obj.o_27)
        or a
        ret Z
        ld iy, scene
        ld a, (ix+Obj.o_26)
        neg
        add (ix+Obj.y)
        ld c, a
        add (ix+Obj.o_28)
        cp (iy+Obj.y)
        ret C
        ld a, (iy+Obj.y)
        add (iy+Obj.o_11)
        cp c
        ret C
        ld l, (ix+Obj.x+0)
        ld h, (ix+Obj.x+1)
        ld e, (ix+Obj.o_25)
        ld d, #00
        xor a
        sbc hl, de
        ex de, hl
        ld l, (iy+Obj.x+0)
        ld h, (iy+Obj.x+1)
        ld c, (iy+Obj.o_10)
        ld b, #00
        add hl, bc
        xor a
        sbc hl, de
        ret C
        ld l, (ix+Obj.o_27)
        ld h, #00
        add hl, de
        ld e, (iy+Obj.x+0)
        ld d, (iy+Obj.x+1)
        xor a
        sbc hl, de
        ret C
        res 5, (ix+Obj.flags)
        res 2, (ix+Obj.flags)
        res 3, (ix+Obj.flags)
        ld (ix+Obj.o_27), #00
        ret

; (Modifies some object properties?)
; Used by c_ed08.
c_f4e9:  ; #f4e9
        ld a, (ix+Obj.o_8)
        cp #0F
        jr Z, .l_0
        cp #10
        ret NZ
.l_0:
        call generateRandom
        cp #02
        ret NC
        ld (ix+Obj.o_6), #00
        ld (ix+Obj.o_7), #FF
        ld (ix+Obj.color), #47
        ret

; Data block at F506
c_f506:  ; #f506
        db #FA, #FB, #FC, #FD, #FE, #FE, #FF, #FF
        db #00, #01, #01, #02, #02, #03, #04, #05
        db #06, #7F

; (Modifies some object properties?)
; Used by c_ed08.
c_f518:  ; #f518
        ld a, (ix+Obj.o_15)
        ld l, a
        ld h, #00
        ld de, c_f506
        add hl, de
        ld a, (hl)
        cp #7F
        jr NZ, .l_0
        dec (ix+Obj.o_15)
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
        ld (ix+Obj.o_23), #00
.l_1:
        inc (ix+Obj.o_15)
        jp c_ef72.l_23

; Decrements some counter at State.s_51
; Used by c_cc25.
c_f553:  ; #f553
        ld a, (State.s_51)
        or a
        jr Z, .l_0
        dec a
        ld (State.s_51), a
        ret
.l_0:
        ld a, #3C
        ld (State.s_51), a
        ret

; (Modifies some object properties?)
; Used by c_ed08.
c_f564:  ; #f564
        ld a, (State.s_51)
        or a
        ret NZ
        ld a, (ix+Obj.o_23)
        cp #01
        ret Z
        ld a, (ix+Obj.o_49)
        or a
        ret Z
        push ix
        call c_e6c2
        push ix
        pop iy
        pop ix
        ret NC
        ld hl, cS.powerBullet1
        ld (iy+Obj.sprite+0), l
        ld (iy+Obj.sprite+1), h
        ld (iy+Obj.o_7), #00
        ld (iy+Obj.color), #47
        ld (iy+Obj.o_21), #00
        ld (iy+Obj.o_19), #05
        ld (iy+Obj.o_20), #03
        ld (iy+Obj.o_10), #06
        ld (iy+Obj.o_11), #06
        ld (iy+Obj.health), #01
        ld (iy+Obj.flags), #01
        ld (iy+Obj.o_8), #00
        ld (iy+Obj.o_23), #01
        ld (iy+Obj.o_24), #00
        ld a, (ix+Obj.o_49)
        ld (iy+Obj.o_49), a
        ld a, (ix+Obj.o_10)
        sub (iy+Obj.o_10)
        srl a
        ld e, a
        ld d, #00
        ld l, (ix+Obj.x+0)
        ld h, (ix+Obj.x+1)
        add hl, de
        ld (iy+Obj.x+0), l
        ld (iy+Obj.x+1), h
        ld a, (ix+Obj.o_11)
        sub (iy+Obj.o_11)
        srl a
        add (ix+Obj.y)
        ld (iy+Obj.y), a
        ld a, (iy+Obj.o_49)
        cp #01
        jr Z, .l_2
        cp #02
        jr NZ, .l_0
        ld a, (ix+Obj.o_21)
        and #03
        ld (iy+Obj.o_21), a
        ret
.l_0:
        cp #03
        jr NZ, .l_1
        ld (iy+Obj.o_21), #08
        ret
.l_1:
        cp #04
        ret NZ
        ld (iy+Obj.o_21), #04
        ret
.l_2:
        push ix
        push iy
        pop ix
        ld a, #04
        call c_edc0
        pop ix
        ret

; (Modifies some object properties?)
; Used by c_ed08.
c_f618:  ; #f618
        ld a, (ix+Obj.o_49)
        cp #01
        call Z, c_ee93
        ld iy, scene
        call c_e80a
        jr C, .l_1
        ld (ix+Obj.flags), #00
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
        ld (iy+Obj.blinkTime), #07
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
        call c_eaee
        cp #04
        jr C, .l_3
        ld (ix+Obj.flags), #00
        ret
.l_3:
        call isObjectVisible
        ret C
        ld (ix+Obj.flags), #00
        ret

; (Some game logic?)
; Used by c_ef72.
c_f670:  ; #f670
        bit 5, (ix+Obj.o_24)
        ret Z
        call generateRandom
        cp #08
        ret NC
        bit 1, (ix+Obj.o_15)
        jr Z, .l_0
        ld a, (ix+Obj.o_21)
        xor #03
        ld (ix+Obj.o_21), a
.l_0:
        bit 0, (ix+Obj.o_15)
        ret Z
        ld a, (ix+Obj.o_21)
        xor #0C
        ld (ix+Obj.o_21), a
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
        cp #04
        ret NC
        call generateRandom
        and #1F
        ld (ix+Obj.o_48), a
        ret

; Object type offset by level
c_f6b5:  ; #f6b5
        db #00, #31, #5F, #88, #BC


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
        jr NC, .l_2             ; object is not yet visible

        call putObjectToScene
        jr .object

.skipObject:
    .2  inc bc
        jr .object

.l_2:
    .2  dec bc
        ld (State.nextObject), bc
        jr putObjectsToScene


; Get next objects from the object table
; Used by c_cc25.
putNextObjectsToScene:  ; #f6e7
        ld bc, (State.nextObject)
.l_0:
        ld de, (State.screenX)
        ld a, (bc)
        ld h, a
        inc bc
        ld a, (bc)
        ld l, a
        inc bc
        xor a
        sbc hl, de
        jr C, .l_1
        push hl
        ld de, #0028
        xor a
        sbc hl, de
        pop hl
        jr NC, .l_2
        push bc
        call putObjectToScene
        pop bc
        inc bc
        inc bc
        jr .l_0
.l_1:
        inc bc
        inc bc
        jr .l_0
.l_2:
        dec bc
        dec bc
        ld (State.nextObject), bc
        ; continue


putObjectsToScene:
        ld ix, scene.obj2
        ld b, #06
.l_4:
        bit 0, (ix+Obj.flags)
        jr Z, .l_6
        ld l, (ix+Obj.x+0)
        ld h, (ix+Obj.x+1)
        ld de, #0120
        xor a
        sbc hl, de
        jp C, .l_5
        set 5, (ix+Obj.flags)
        jr .l_6
.l_5:
        ld a, (ix+Obj.o_27)
        or a
        jr NZ, .l_6
        res 5, (ix+Obj.flags)
.l_6:
        ld de, Obj
        add ix, de
        djnz .l_4
        ret

; Initialize object from the object type
; Used by c_f6ba and c_f6e7.
putObjectToScene:  ; #f74a
        call c_e6c2
        ret NC

    .3  add hl, hl
        ld de, 32
        add hl, de
        ld (ix+Obj.x+0), l
        ld (ix+Obj.x+1), h
        ld a, (bc)
    .3  add a
        add 32
        ld (ix+Obj.y), a
        inc bc
        ld a, (bc)
        cp 10
        jr C, .l_0
        exa
        ld a, (State.level)
        ld l, a
        ld h, 0
        ld de, c_f6b5
        add hl, de
        ld l, (hl)
        exa
        sub l
.l_0:
        inc bc
; This entry point is used by c_f8f4, c_f9a4, c_fa65, c_fad3 and
; c_fb45.
.l_1:
        exx
        ld l, a
        ld h, #00
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
        pop hl
        ld de, Common.objectTypes
        add hl, de
        ld (ix+Obj.o_6), #00
        ld (ix+Obj.o_48), #00
        ld (ix+Obj.o_21), #02
        ld a, (hl)
        ld (ix+Obj.sprite+0), a
        inc hl
        ld a, (hl)
        ld (ix+Obj.sprite+1), a
        inc hl
        ld a, (hl)
        ld (ix+Obj.color), a
        inc hl
        ld a, (hl)
        ld (ix+Obj.o_7), a
        inc hl
        ld a, (hl)
        ld (ix+Obj.flags), a
        inc hl
        ld a, (hl)
        ld (ix+Obj.o_10), a
        inc hl
        ld a, (hl)
        ld (ix+Obj.o_11), a
        inc hl
        ld a, (hl)
        ld (ix+Obj.health), a
        inc hl
        ld a, (hl)
        or a
        jr Z, .l_2
        ld a, (ix+Obj.flags)
        or #2C
        ld (ix+Obj.flags), a
.l_2:
        inc hl
        ld a, (hl)
        ld (ix+Obj.o_13), a
        inc hl
        ld a, (hl)
        ld (ix+Obj.o_24), a
        inc hl
        ld a, (hl)
        ld (ix+Obj.o_8), a
        or a
        jr NZ, .l_3
        ld a, (State.s_46)
        cp #7F
        jr NZ, .l_3
        ld (ix+Obj.flags), #00
        ret
.l_3:
        inc hl
        ld a, (hl)
        ld (ix+Obj.o_49), a
        inc hl
        ld a, (hl)
        ld (ix+Obj.o_15), a
        inc hl
        ld a, (hl)
        ld (ix+Obj.o_16), a
        inc hl
        ld a, (hl)
        ld (ix+Obj.o_17), a
        inc hl
        ld a, (hl)
        ld (ix+Obj.o_18), a
        inc hl
        ld a, (hl)
        ld (ix+Obj.o_19), a
        inc hl
        ld a, (hl)
        ld (ix+Obj.o_20), a
        inc hl
        ld a, (hl)
        ld (ix+Obj.o_21), a
        inc hl
        ld a, (hl)
        ld (ix+Obj.o_22), a
        inc hl
        ld a, (hl)
        ld (ix+Obj.o_23), a
        inc hl
        ld a, (hl)
        ld (ix+Obj.o_25), a
        inc hl
        ld a, (hl)
        ld (ix+Obj.o_26), a
        inc hl
        ld a, (hl)
        ld (ix+Obj.o_27), a
        inc hl
        ld a, (hl)
        ld (ix+Obj.o_28), a
        ld a, (ix+Obj.o_21)
        ld l, a
        ld h, #00
        ld de, c_f373
        add hl, de
        ld a, (hl)
        ld (ix+Obj.o_21), a
        bit 1, (ix+Obj.flags)
        jr NZ, .l_4
        ld a, (ix+Obj.y)
        sub (ix+Obj.o_11)
        ld (ix+Obj.y), a
        jr .l_5
.l_4:
        ld a, (ix+Obj.y)
        sub (ix+Obj.o_11)
        ld (ix+Obj.y), a
.l_5:
        ld a, (ix+Obj.o_8)
        cp #0E
        jr NZ, .l_6
        ld l, (ix+Obj.x+0)
        ld h, (ix+Obj.x+1)
        ld de, #0004
        add hl, de
        ld (ix+Obj.x+0), l
        ld (ix+Obj.x+1), h
        ld a, (ix+Obj.y)
        and #F8
        ld (ix+Obj.y), a
        ret
.l_6:
        cp #01
        jr NZ, .l_7
        ld a, (ix+Obj.y)
        add #06
        ld (ix+Obj.y), a
        ret
.l_7:
        ld a, (ix+Obj.o_8)
        cp #A3
        jr NZ, .l_8
        ld (ix+Obj.flags), #00
        ret
.l_8:
        ld a, (State.bossFight)
        or a
        ret NZ
        ld a, (ix+Obj.o_8)
        cp #35
        jr Z, .l_9
        cp #5E
        jr Z, .l_10
        cp #8A
        jr Z, .l_10
        cp #BF
        jr Z, .l_10
        cp #ED
        jr Z, .l_10
        ret
.l_9:
        ld hl, (State.screenX)
        ld de, #05D4
        xor a
        sbc hl, de
        jr NC, .l_10
        ld (ix+Obj.flags), #00
        ret
.l_10:
        ld a, #01
        ld (State.bossFight), a
        ld a, #3C
        ld (State.s_55), a
        ret


    ENDMODULE
