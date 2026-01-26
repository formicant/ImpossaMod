    MODULE Code


; Bermuda boss logic
; Used by c_f8cb.
boss_logic_bermuda:  ; #fb45
        ld a, (State.s_54)
        cp #01
        jr NZ, .l_0
        ld a, (State.s_57)
        or a
        ret NZ
        ld ix, scene.obj2
        ld a, #38
        call putObjectToScene.l_1
        ld ix, scene.obj3
        ld a, #39
        call putObjectToScene.l_1
        ld ix, scene.obj2
        ld iy, scene.obj3
        ld l, (ix+Obj.x+0)
        ld h, (ix+Obj.x+1)
        ld (iy+Obj.x+0), l
        ld (iy+Obj.x+1), h
        ld (ix+Obj.y), #92
        ld (iy+Obj.y), #A7
        ld a, #02
        ld (State.s_54), a
        xor a
        ld (State.s_56), a
        ld a, #C8
        ld (State.s_51), a
        ret
.l_0:
        ld ix, scene.obj2
        ld iy, scene.obj3
        ld a, (State.s_59)
        inc a
        and #07
        ld (State.s_59), a
        cp #04
        jr Z, .l_1
        cp #05
        jr NZ, .l_2
.l_1:
        set 6, (ix+Obj.flags)
        set 6, (iy+Obj.flags)
        ret
.l_2:
        res 6, (ix+Obj.flags)
        res 6, (iy+Obj.flags)
        ret


    ENDMODULE
