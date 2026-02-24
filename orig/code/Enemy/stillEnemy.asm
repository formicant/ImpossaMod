    MODULE Enemy

; Check if hero is inside the activation zone of a still enemy
; Used by c_ecee.
checkStillEnemyActivation:  ; #f488
        ld a, (ix+Obj.activeZone.w)
        or a
        ret Z                   ; not a still enemy

        ; test vertical zone range
        ; hero_top <= obj_y - stillActY + stillActH
        ld iy, Scene.hero
        ld a, (ix+Obj.activeZone.y)
        neg
        add (ix+Obj.y)
        ld c, a
        add (ix+Obj.activeZone.h)
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
        ld e, (ix+Obj.activeZone.x)
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
        ld l, (ix+Obj.activeZone.w)
        ld h, 0
        add hl, de
        ld e, (iy+Obj.x+0)
        ld d, (iy+Obj.x+1)
        xor a
        sbc hl, de
        ret C

        ; if in range, activate the enemy
        res Flag.waiting, (ix+Obj.flags)
        res Flag.fixedX, (ix+Obj.flags)
        res Flag.fixedY, (ix+Obj.flags)
        ld (ix+Obj.activeZone.w), 0
        ret

    ENDMODULE
