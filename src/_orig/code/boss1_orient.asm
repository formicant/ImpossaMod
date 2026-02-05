    MODULE Code


; Orient boss data
c_f99e:  ; #f99e
        db #18, #00, #00, #15, #18, #15

; Orient boss logic
; Used by c_f8cb.
bossLogicOrient:  ; #f9a4
        ld a, (State.bossFight)
        cp #01
        jr NZ, .l_1
        ld a, (State.s_57)
        or a
        ret NZ
        ld ix, scene.obj2
        ld a, #32
        call putObjectToScene.l_1
        ld ix, scene.obj3
        ld a, #33
        call putObjectToScene.l_1
        ld ix, scene.obj4
        ld a, #34
        call putObjectToScene.l_1
        ld ix, scene.obj5
        ld a, #35
        call putObjectToScene.l_1
        ld de, c_f99e
        ld b, #03
        ld ix, scene.obj2
        ld iy, scene.obj3
.l_0:
        push bc
        ld l, (ix+Obj.x+0)
        ld h, (ix+Obj.x+1)
        ld a, (de)
        inc de
        ld c, a
        ld b, #00
        add hl, bc
        ld (iy+Obj.x+0), l
        ld (iy+Obj.x+1), h
        ld a, (de)
        inc de
        add (ix+Obj.y)
        ld (iy+Obj.y), a
        ld bc, Obj
        add iy, bc
        pop bc
        djnz .l_0
        ld a, #02
        ld (State.bossFight), a
        xor a
        ld (State.s_56), a
        ld a, #3C
        ld (State.s_51), a
        ret
.l_1:
        ld ix, scene.obj2
        bit 3, (ix+Obj.o_21)
        jr Z, .l_2
        ld a, (ix+Obj.y)
        cp #20
        jr NC, .l_3
        ld c, #0C
        call c_fbb9
        jr .l_3
.l_2:
        ld a, (ix+Obj.y)
        cp #98
        jr C, .l_3
        ld c, #0C
        call c_fbb9
.l_3:
        ld l, (ix+Obj.x+0)
        ld h, (ix+Obj.x+1)
        bit 1, (ix+Obj.o_21)
        jr NZ, .l_4
        ld de, #00F0
        xor a
        sbc hl, de
        ret C
        ld c, #03
        call c_fbb9
        jp c_fbd2
.l_4:
        ld de, #0020
        xor a
        sbc hl, de
        ret NC
        ld c, #03
        call c_fbb9
        jp c_fbd2


    ENDMODULE
