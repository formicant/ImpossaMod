    MODULE Hero

; Time after which new trajectory correction will occur
selfGuidedTime:  ; #e308
        db -0

; Table for converting angle to direction
; (angles are measured clockwise from the rightward direction
; in eights of a revolution)
angleToDir:  ; #e309
.a0:    db 1<<Dir.right
.a1:    db (1<<Dir.down) | (1<<Dir.right)
.a2:    db 1<<Dir.down
.a3:    db (1<<Dir.down) | (1<<Dir.left)
.a4:    db 1<<Dir.left
.a5:    db (1<<Dir.up) | (1<<Dir.left)
.a6:    db 1<<Dir.up
.a7:    db (1<<Dir.up) | (1<<Dir.right)

; Table for converting direction to angle
; (angles are measured clockwise from the rightward direction
; in eights of a revolution)
dirToAngle:  ; #e311
        db 0
.right: db 0
.left:  db 4
        db 0
.down:  db 2
.downR: db 1
.downL: db 3
        db 0
.up:    db 6
.upR:   db 7
.upL:   db 5

; Control a self-guided bullet (power gun with 3 soup cans)
selfGuidedBullet:  ; #e31c
        ld a, (selfGuidedTime)
        or a
        jr Z, .l_0

        dec a
        ld (selfGuidedTime), a
        ret

.l_0:
        ld ix, Scene.obj1       ; bullet

        ; search for target object
        ld iy, Scene.obj2
        ld de, Obj              ; object size
        ld b, 6                 ; object count
.object:
        ; skip non-existent objects
        bit Flag.exists, (iy+Obj.flags)
        jr Z, .nextObject
        ld a, (iy+Obj.spriteSet)
        cp SpriteSet.explosion
        jr Z, .nextObject
        bit Flag.cleanUp, (iy+Obj.flags)
        jr NZ, .nextObject

        ; skip non-damageable objects
        ld a, (iy+Obj.health)
        cp -2
        jr Z, .nextObject
        cp -1
        jr Z, .nextObject

        ; skip left off-screen objects
        ld l, (iy+Obj.x+0)
        ld h, (iy+Obj.x+1)
        ld de, 32
        xor a
        sbc hl, de
        jr NC, .found

.nextObject:
        add iy, de
        djnz .object

.notFound:
        ; continue moving horizontally
        ld a, (ix+Obj.mo.direction)
        and Dir.horizontal
        ld (ix+Obj.mo.direction), a
        ret

.found:
        ; `ix`: bullet
        ; `iy`: target object
        ld a, (ix+Obj.mo.direction)
        ld l, a
        ld h, 0
        ld de, dirToAngle
        add hl, de
        ld b, (hl)              ; previous direction angle

        ; calculate target direction
        ld (ix+Obj.mo.direction), 0
        ld l, (ix+Obj.x+0)
        ld h, (ix+Obj.x+1)
        ld e, (iy+Obj.x+0)
        ld d, (iy+Obj.x+1)
        xor a
        sbc hl, de
        jp P, .left

.right:
        ; TODO: is this correct?
        ld a, h
        neg
        ld h, a
        ld a, l
        neg
        ld l, a
        inc hl
        set Dir.right, (ix+Obj.mo.direction)
        jr .l_5
.left:
        set Dir.left, (ix+Obj.mo.direction)

.l_5:
        ; `hl`: unsigned horiz distance(?)
        ld de, 4
        xor a
        sbc hl, de
        jr NC, .vertical
        ld (ix+Obj.mo.direction), 0

.vertical:
        ld a, (ix+Obj.y)
        sub (iy+Obj.y)
        jp P, .up

.down:
        neg
        set Dir.down, (ix+Obj.mo.direction)
        jr .l_8
.up:
        set Dir.up, (ix+Obj.mo.direction)

.l_8:
        cp 4
        jr NC, .l_9
        res Dir.down, (ix+Obj.mo.direction)
        res Dir.up, (ix+Obj.mo.direction)

.l_9:
        ld a, (ix+Obj.mo.direction)
        ld l, a
        ld h, 0
        ld de, dirToAngle
        add hl, de
        ld c, (hl)              ; target direction angle

        ld a, b
        sub c                   ; `a`: signed angle difference with target
        jp Z, .sameDirection

        and %00000111
        ld d, a                 ; anti-clockwise angle difference
        ld a, c
        sub b
        and %00000111           ; clockwise angle difference
        cp d
        ld a, 1                 ; clockwise angle step
        jp C, .clockwise
        neg                     ; anti-clockwise angle step
.clockwise:

        ; set new direction
        add b
        and %00000111           ; new direction angle
        ld l, a
        ld h, 0
        ld de, angleToDir
        add hl, de
        ld a, (hl)              ; new direction
        ld (ix+Obj.mo.direction), a

.sameDirection:
        ld a, 1
        ld (selfGuidedTime), a
        ret

    ENDMODULE
