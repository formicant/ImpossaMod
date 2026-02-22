    MODULE Code


; Add energy
;   `a`: energy points to add
; Used by c_cc25, c_cd5c, c_e6e1 and c_e9b1.
addEnergy:  ; #d09a
        exa
        ld a, (State.maxEnergy)
        ld b, a
        exa
        ld c, a
        ld a, (State.energy)
        add c
        cp b
        jr C, .skip
        ld a, b
.skip:
        ld (State.energy), a
        jp Panel.printEnergy


; Decrement energy by one point
;   `ix`: Scene.hero
; Used by c_d709 and c_e6e1.
decEnergy:  ; #d0af
        ld a, (ix+Obj.blinkTime)
        or a
        ret NZ                  ; don't decrement if still blinking

        ld a, (State.energy)
        sub 1
        jr NC, .skip
        ld a, #FF
        ld (State.isDead), a
        xor a
.skip:
        ld (State.energy), a
        ld (ix+Obj.blinkTime), 7
        ld a, Sound.energyLoss
        call Sound.playSound
        jp Panel.printEnergy


; Decrement blinking time for all scene objects
; Used by c_cc25.
decBlinkTime:  ; #d0d0
        ld ix, Scene.objects
        ld b, 8                 ; object count
        ld de, Obj              ; object size
.object:
        ld a, (ix+Obj.blinkTime)
        or a
        jr Z, .skip

        dec a
        ld (ix+Obj.blinkTime), a
        and 1                   ; even/odd
        jr NZ, .skip
        set Flag.blink, (ix+Obj.flags)
.skip:
        add ix, de
        djnz .object
        ret


; Delay for approximately `bc` milliseconds
; Used by c_c6d5, c_cc25, c_d553 and c_d6c0.
delay:  ; #d0f0
        push bc
        ld b, #FF
.loop:
        djnz .loop
        pop bc
        dec bc
        ld a, b
        or c
        jr NZ, delay
        ret


; Random number generation
; Used by c_e52d, c_ef72, c_f4e9, c_f670, c_f697, c_f8f4 and c_fa65.
generateRandom:  ; #d0fc
        push hl, de

        ld hl, (randomSeed)
        ld de, (longFrameCounter.low)
        add hl, de
        ld de, 13
        add hl, de
        ld de, (longFrameCounter.high)
        adc hl, de
        xor l
        xor d
        xor e
        xor h
        ld l, a
        ld (randomSeed), hl

        pop de, hl
        ret

randomSeed:  ; #d11b
        dw 0


    IFNDEF _MOD                 ; moved to the interrupt routine

; 32-bit frame counter, used in random number generation
longFrameCounter:  ; #d11d
.low:   dw 0
.high:  dw 0

; Increment the 32-bit frame counter
; Called in every interrupt
incrementLongFrameCounter:  ; #d121
        ld hl, (longFrameCounter.low)
        inc hl
        ld (longFrameCounter.low), hl
        ld a, l
        or h
        ret NZ

        ld hl, (longFrameCounter.high)
        inc hl
        ld (longFrameCounter.high), hl
        ret

    ENDIF


; Clear the game state before the start of the game
; Used by c_cc25.
clearGameState:  ; #d133
        ld hl, State.start
        ld de, State.start + 1
        ld bc, State.length - 1
        ld (hl), 0
        ldir

        ld a, 18
        ld (State.maxEnergy), a

        call Panel.clearScore
        ld b, 5
        ld hl, State.levelsDone
.level:
        ld (hl), 0
        inc hl
        djnz .level
        ret


; Initialise the hero object and place it to the start position
;   `bc`: hero's position (x, y), blocks
; Used by c_d1c1.
initHero:  ; #d153
        ld ix, Scene.hero
        ld l, b
        ld h, 0
    .5  add hl, hl
        ld de, 32
        add hl, de              ; `hl` = `b` × 32 + 32
        ld (ix+Obj.x+0), l
        ld (ix+Obj.x+1), h      ; set x coord in pixels

        ld a, c
    .5  add a
        add 40                  ; `a` = `c` × 32 + 40
        ld (ix+Obj.y), a        ; set y coord in pixels

        ld hl, cS.heroStands
        ld a, (State.weapon)
        cp ObjType.powerGun
        jr C, .noGun
        ld hl, cS.armedHeroStands
.noGun:
        ld (ix+Obj.sprite+0), l
        ld (ix+Obj.sprite+1), h ; set sprite addr

        ld (ix+Obj.mo.direction), 1<<Dir.right
        ld (ix+Obj.flags), (1<<Flag.exists) | (1<<Flag.isBig)
        ld (ix+Obj.width), 16
        ld (ix+Obj.height), 21
        ld (ix+Obj.spriteSet), 0      ; ?
        ld (ix+Obj.colour), Colour.brWhite
        ld (ix+Obj.objType), ObjType.hero
        xor a
        ld (State.heroState), a
        ld (State.stepPeriod), a      ; ?
        ret


; Start position (x, y) and map span (start, end) by level
startPositions:  ; #d1ab
;          x  y start end
.lev0:  db 1, 4,  0,  54
.lev1:  db 1, 4,  0, 108
.lev2:  db 3, 4,  0, 138
.lev3:  db 2, 4,  0, 126
.lev4:  db 1, 3,  0,  40


conveyorTileIndices:  ; #d1bf
.left:  db #73
.right: db #74


; Init level / game state
; Used by c_cc25.
initLevel:  ; #d1c1
        ld a, 1
        ld (State.soupCans), a
        ld a, (State.maxEnergy)
        ld (State.energy), a
        xor a
        ld (State.coins), a
        ld (State.weapon), a

    IFNDEF _MOD
        ; panel info
        call Panel.printCoinCount
        call Panel.printScore
        call Panel.printEnergy
        call Panel.printSoupCans
    ENDIF

        xor a
        ld (State.bossFight), a
        ld (State.inShop), a
        ld (State.bossKilled), a
        inc a
        ld (State.hasSmart), a

    IFDEF _MOD
        call Panel.printPanel
    ENDIF

        ; set hero's start position
        ld a, (State.level)
    .2  add a
        ld l, a
        ld h, 0
        ld de, startPositions
        add hl, de

        ld b, (hl)              ; start x coord, blocks
        inc hl
        ld c, (hl)              ; start y coord, blocks
        push bc
        inc hl
        ld a, (hl)              ; map span start, blocks
        inc hl
        ld l, (hl)              ; map span end, blocks
        ld h, 0
    .2  add hl, hl
        ex de, hl
        ld l, a
        ld h, 0
    .2  add hl, hl
        ; `hl`: map span start, tiles
        ; `de`: map span end, tiles
        call moveToMapSpan

        pop bc                  ; hero's start position, blocks
        call initHero
        ret


; Find conveyors among the screen tiles
; Used by c_cecc.
findConveyors:  ; #d213
        ld a, (conveyorTileIndices.left)
        ld (Tables.scrTiles.stop + 1), a   ; stop-value
        ld hl, Tables.scrTiles.row1 + 3    ; before first visible tile
        ld de, (conveyorTileIndices)
        ld ix, State.conveyors
.scan:
        inc hl
        ld a, (hl)
        cp d
        jp Z, .rightConveyor
        cp e
        jp NZ, .scan
.leftConveyor:
        ld bc, Tables.scrTiles.stop + 1
        push hl
        xor a
        sbc hl, bc
        pop hl
        jp Z, .end
        ld (ix+Conveyor.start+0), l
        ld (ix+Conveyor.start+1), h
        ld b, 0
.leftNext:
        inc b
        inc hl
        ld a, (hl)
        cp e
        jp Z, .leftNext
        ld (ix+Conveyor.length), b
    .3  inc ix                  ; next conveyor
        jp .scan
.rightConveyor:
        ld (ix+Conveyor.start+0), l
        ld (ix+Conveyor.start+1), h
        ld b, 0
.rightNext:
        inc b
        inc hl
        ld a, (hl)
        cp d
        jp Z, .rightNext
        ld (ix+Conveyor.length), b
    .3  inc ix                  ; next conveyor
        jp .scan
.end:
        ld (ix+Conveyor.start+0), 0
        ld (ix+Conveyor.start+1), 0
        ret


; Mark all conveyor screen tiles to be updated
; Used by c_cc25.
updateConveyors:  ; #d278
        ld de, Tables.scrTileUpd - Tables.scrTiles
        ld ix, State.conveyors
.conveyor:
        ld l, (ix+Conveyor.start+0)
        ld h, (ix+Conveyor.start+1)
        ld a, h
        or l
        ret Z

        ld b, (ix+Conveyor.length)
        add hl, de              ; conveyor addr in `Tables.scrTileUpd`
.tile:
        ld (hl), 1              ; update
        inc hl
        djnz .tile

    .3  inc ix                  ; next conveyor
        jp .conveyor


; Clear the `Scene` in some crazy way
; Used by c_cc25.
clearScene:  ; #d29a
        ld hl, 0
        ld de, Obj              ; object size
        ld b, 8                 ; object count
.multiplyLoop:
        add hl, de
        djnz .multiplyLoop
        ld c, l
        ld b, h
        ; `bc`: number of bytes to clear

        ld hl, Scene.objects
.clearByte:
        ld (hl), 0
        inc hl
        dec bc
        ld a, b
        or c
        jr NZ, .clearByte
        ret


; Turn a defeated enemy into a coin
;   `iy`: enemy object
; Used by c_ec00.
turnIntoCoin:  ; #d2b3
        bit Flag.isBig, (iy+Obj.flags)
        jr Z, .small            ; never happens(?), always big

        res Flag.isBig, (iy+Obj.flags)  ; make small
        ; adjust coords so that the centre is at the same point
        ld l, (iy+Obj.x+0)
        ld h, (iy+Obj.x+1)
        ld de, 4
        add hl, de
        ld (iy+Obj.x+0), l
        ld (iy+Obj.x+1), h
        ld a, (iy+Obj.y)
        add 4
        ld (iy+Obj.y), a
.small:
        ld hl, cS.coin
        ld (iy+Obj.sprite+0), l
        ld (iy+Obj.sprite+1), h

        ld (iy+Obj.spriteSet), 0
        ld (iy+Obj.mo.type), Motion.coinJump
        ld (iy+Obj.objType), ObjType.coin
        ld (iy+Obj.mo.direction), 0
        ld (iy+Obj.mo.step), 0
        ld (iy+Obj.health), -2
        ld (iy+Obj.colour), Colour.brYellow
        res Flag.waiting, (iy+Obj.flags)
        res Flag.fixedY, (iy+Obj.flags)
        res Flag.fixedX, (iy+Obj.flags)
    IFDEF _MOD
        ; fix smart behaviour
        ld (iy+Obj.auxFlags), 1<<Flag.nonEnemy
    ENDIF
        xor a
        ret


; If the hero is riding an object, move the hero accordingly
; Used by c_cc25.
heroRiding:  ; #d308
        ld ix, Scene.hero
        bit Flag.riding, (ix+Obj.auxFlags)
        jp NZ, .isRiding

        ; ?
        ld a, (State.heroState)
        cp HeroState.fall
        jr Z, .l_0
        cp HeroState.jump
        ret NZ

        ld a, (State.jumpVel)
        or a
        ret M                   ; moving upwards

.l_0:
        ; Find an object at the hero's feet
        ld iy, Scene.obj2
        ld b, 6                 ; object count
.object:
        call isHeroOnTopObject
        jr NZ, .found
        ld de, Obj              ; object size
        add iy, de
        djnz .object
        ; not found
        ret

.found:
        ; `ix`: hero
        ; `iy`: object at the hero's feet
        xor a
        ld (State.heroState), a
        ld (State.stepPeriod), a
        ld (ix+Obj.mo.horizSpeed), 0
        set Flag.riding, (ix+Obj.auxFlags)
        push iy : pop hl
        ; save obj addr
        ld (ix+Obj.aim.curX+0), l
        ld (ix+Obj.aim.curX+1), h

.isRiding:
        ld l, (ix+Obj.aim.curX+0)
        ld h, (ix+Obj.aim.curX+1)
        push hl : pop iy
        ; `iy`: object that used to be at the hero's feet
        call isHeroOnTopObject
        jr NZ, .setSprite
        ; not at the feet any more
        res Flag.riding, (ix+Obj.auxFlags)
        ret

.setSprite:
        ld hl, cS.heroStands
        ld a, (State.weapon)
        cp ObjType.powerGun
        jr C, .noGun
        ld hl, cS.armedHeroStands
.noGun:
        ld (ix+Obj.sprite+0), l
        ld (ix+Obj.sprite+1), h

        ; adjust hero's y
        ld a, (iy+Obj.y)
        sub (ix+Obj.height)
        ld (ix+Obj.y), a

        ; get object direction
        ld c, (iy+Obj.mo.direction)
        ld a, (iy+Obj.mo.type)
        cp Motion.general
        jr Z, .notTrajectory
        ld c, (iy+Obj.mo.trajDir)
.notTrajectory:
        ld a, c
        and Dir.horizontal
        ret Z

        ld a, (iy+Obj.mo.horizSpeed)
        ld d, 0
        bit Dir.right, c
        jr NZ, .skipNeg
        neg
        ld d, -1
.skipNeg:
        ld e, a
        push de                 ; object's signed horizontal velocity
        bit Dir.right, c
        jr NZ, .right

.left:
        call isObstacleToTheLeft
        pop de
        or a
        jr Z, .applyVelocity
        ret

.right:
        call isObstacleToTheRight
        pop de
        ret NZ

.applyVelocity:
        ; `de`: object's signed horizontal velocity
        ld l, (ix+Obj.x+0)
        ld h, (ix+Obj.x+1)
        add hl, de
        ld (ix+Obj.x+0), l
        ld (ix+Obj.x+1), h
        ret


; Check if the hero's bottom is near the top of a rideable object
;   arg `ix`: hero
;       `iy`: object
;   ret `a`: #FF and flag NZ if is, `a`: 0 and flag Z if isn't
; Used by c_d308.
isHeroOnTopObject:  ; #d3bb
        bit Flag.exists, (iy+Obj.flags)
        ret Z
        bit Flag.riding, (iy+Obj.auxFlags)
        ret Z

        ld a, (ix+Obj.y)
        add (ix+Obj.height)
        sub (iy+Obj.y)
        jp P, .l_0
        ; hero's bottom is above object's top
        neg
.l_0:
        cp 5
        jr NC, .false
        ; hero's bottom is 5 pixels apart from object's top

        ld l, (ix+Obj.x+0)
        ld h, (ix+Obj.x+1)
        ld de, 20
        add hl, de
        ld e, (iy+Obj.x+0)
        ld d, (iy+Obj.x+1)
        xor a
        sbc hl, de
        jr C, .false
        ; hero's right - object's left >= 4
        ld l, (iy+Obj.width)
        ld h, 0
        add hl, de
        ld e, (ix+Obj.x+0)
        ld d, (ix+Obj.x+1)
    .4  inc de
        xor a
        sbc hl, de
        jr C, .false
        ; object's right - hero's left >= 4
.true:
        ld a, #FF
        or a
        ret
.false:
        xor a
        ret


; Return flag C if object is in the visible area or to the right of it
;   `ix`: object
; Used by c_ef72 and c_f37e.
isObjectVisibleOrWaiting:  ; #d407
        ld hl, 352
        ld (isObjectVisibleRaw.de), hl
        jr isObjectVisibleRaw

; Return flag C if object is in the visible area
;   `ix`: object
; used by c_df85 and c_f618.
isObjectVisible:
        ld hl, 288
        ld (isObjectVisibleRaw.de), hl
        ; continue

isObjectVisibleRaw:
        ld a, (ix+Obj.y)
        cp 224                  ; screen bottom
        jr NC, .offScreen
        ld c, (ix+Obj.height)
        add c
        cp 32                   ; screen top
        jr C, .offScreen

        ld l, (ix+Obj.x+0)
        ld h, (ix+Obj.x+1)
        push hl
        ld d, 0
        ld e, (ix+Obj.width)
        add hl, de
        ld de, 32
        xor a
        sbc hl, de
        pop hl
        jr C, .offScreen

.de+*   ld de, 288              ; or 352
        xor a
        sbc hl, de
        ret C

.offScreen:
        xor a
        ret


; Make object big
;   `ix`: object
; Used by c_ec00 and c_ed08.
makeObjectBig:  ; #d443
        ; adjust coords
        ld l, (ix+Obj.x+0)
        ld h, (ix+Obj.x+1)
        ld de, -4
        add hl, de
        ld (ix+Obj.x+0), l
        ld (ix+Obj.x+1), h
        ld a, -2
        add (ix+Obj.y)
        ld (ix+Obj.y), a

        set Flag.isBig, (ix+Obj.flags)
        ret


; Get addr in `Tables.scrTiles` for object
;   arg `ix`: object
;   ret `hl`: tile addr in `Tables.scrTiles`
;   spoils `af`
; Used by c_dce1, c_dd09, c_dd46, c_dd73, c_df85, c_f1d7, c_f2e7 and  c_f618.
getScrTileAddr:  ; #d460
        push bc
        push de
        ld a, (ix+Obj.y)
        cp 32
        jr NC, .l_0
        ld a, 33
        jr .l_1
.l_0:
        cp 224
        jr C, .l_1
        ld a, 223
.l_1:
        and %11111000           ; `a`: y coord clamped and floored to tiles
        ld l, a
        ld h, 0
        ld e, a
        ld d, h
        srl d
        rr e
        ld c, a
        ld b, h
    .2  add hl, hl
        add hl, bc
        add hl, de
        ld (.hl), hl            ; `a`/ 8 * 44 (row offset in Tables.scrTiles)

        ld l, (ix+Obj.x+0)
        ld h, (ix+Obj.x+1)
        ld a, (ix+Obj.objType)
        cp ObjType.pressPlatf
        jr Z, .divideBy8        ; (why?)
.checkLeftBound
        ld de, 32
        xor a
        sbc hl, de
        jr NC, .checkRightBound
        ld hl, 32
        jr .divideBy8
.checkRightBound:
        ld de, 256
        xor a
        sbc hl, de
        jp P, .l_3
        ld l, (ix+Obj.x+0)
        ld h, (ix+Obj.x+1)
        jr .divideBy8
.l_3:
        ld hl, 288
        ; `hl`: x coord clamped to visible screen
.divideBy8:
    DUP 3
        srl h
        rr l
    EDUP
        ex de, hl
        ; `de` x coord in tiles
.hl+*   ld hl, -0               ; row offset in Tables.scrTiles
        add hl, de
        ld de, Tables.scrTiles
        add hl, de
        ; `hl`: tile addr in `Tables.scrTiles`
        pop de
        pop bc
        ret


; Remove objects from the scene that should be removed (?)
; Used by c_cc25.
cleanUpScene:  ; #d4cd
        ld ix, Scene.obj1
        ld b, 7                 ; object count
        ld de, Obj              ; object size
.object:
        bit Flag.cleanUp, (ix+Obj.flags)
        jr Z, .skip
        ld (ix+Obj.flags), 0    ; remove object
.skip:
        add ix, de
        djnz .object
        ret


; Used by c_cc25.
performSmartIfPressed:  ; #d4e5
        call Control.checkSmartKey
        ret NZ
        ld a, (State.hasSmart)
        or a
        ret Z
        ld a, (State.bossFight)
        or a
        ret NZ

        ; perform smart
        ld iy, Scene.obj2
        ld b, 6                 ; object count
.object:
        push bc
        bit Flag.nonEnemy, (iy+Obj.auxFlags)
        jr NZ, .next

        ; check if object is visible
        ld l, (iy+Obj.x+0)
        ld h, (iy+Obj.x+1)
        ld de, 288
        xor a
        sbc hl, de
        jr NC, .next

        call damageEnemy.kill

.next:
        ld de, Obj              ; object size
        add iy, de
        pop bc
        djnz .object

    IFNDEF _MOD ; TODO: Remove!
        xor a
        ld (State.hasSmart), a
    ENDIF

    IFDEF _MOD
        jp Panel.printSmart
    ELSE
        ret
    ENDIF


    ENDMODULE
