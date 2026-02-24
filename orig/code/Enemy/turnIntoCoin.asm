    MODULE Enemy

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

    ENDMODULE
