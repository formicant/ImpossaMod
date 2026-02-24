    MODULE Enemy

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
        call Scene.isObjectVisibleOrWaiting
        ret C
        ; if the object became invisible
        ld (ix+Obj.flags), 0    ; remove object
        ret

    ENDMODULE
