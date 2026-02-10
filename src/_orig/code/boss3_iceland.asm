    MODULE Code


; Iceland boss logic
; Used by c_f8cb.
bossLogicIceland:  ; #fad3
        ld a, (State.bossFight)
        cp #01
        jr NZ, .l_0
        ld a, (State.bossKilled)
        or a
        ret NZ
        ld ix, scene.obj2
        ld a, #37
        call createObject
        ld ix, scene.obj3
        ld a, #38
        call createObject
        ld ix, scene.obj2
        ld iy, scene.obj3
        ld (ix+Obj.y), #60
        ld l, (ix+Obj.x+0)
        ld h, (ix+Obj.x+1)
        ld (iy+Obj.x+0), l
        ld (iy+Obj.x+1), h
        ld a, #13
        add (ix+Obj.y)
        ld (iy+Obj.y), a
        ld a, #02
        ld (State.bossFight), a
        xor a
        ld (State.s_56), a
        ld a, #3C
        ld (State.bulletTime), a
        ret
.l_0:
        ld ix, scene.obj2
        ld l, (ix+Obj.x+0)
        ld h, (ix+Obj.x+1)
        bit 1, (ix+Obj.o_21)
        jr NZ, .l_2
        ld de, #0108
        xor a
        sbc hl, de
        ret C
.l_1:
        ld c, #03
        jp c_fbb9
.l_2:
        ld de, #0020
        xor a
        sbc hl, de
        jr C, .l_1
        ret


    ENDMODULE
