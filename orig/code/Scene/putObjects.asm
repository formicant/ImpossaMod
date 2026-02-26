    MODULE Scene

; Object type offset by level
levelObjTypeOffests:  ; #f6b5
        db ObjTypeOffset.klondike
        db ObjTypeOffset.orient
        db ObjTypeOffset.amazon
        db ObjTypeOffset.iceland
        db ObjTypeOffset.bermuda


; Find position in level object table and put objects to the scene
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
;   `a`: object type (index in `objectTypes`)
;   `ix`: object addr in the scene
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
        ld de, Enemy.directionTransform
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
