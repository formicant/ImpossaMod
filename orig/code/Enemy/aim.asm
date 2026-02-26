    MODULE Enemy

; Aim an enemy bullet shot at the hero
;   arg `ix`: bullet
;       `a`: bullet speed
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

    ENDMODULE
