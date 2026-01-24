    MODULE Code


; Bermuda boss logic
; Used by c_f8cb.
c_fb45:  ; #fb45
        ld a, (State.s_54)
        cp #01
        jr NZ, .l_0
        ld a, (State.s_57)
        or a
        ret NZ
        ld ix, sceneObjects.obj2
        ld a, #38
        call c_f74a.l_1
        ld ix, sceneObjects.obj3
        ld a, #39
        call c_f74a.l_1
        ld ix, sceneObjects.obj2
        ld iy, sceneObjects.obj3
        ld l, (ix+0)
        ld h, (ix+1)
        ld (iy+0), l
        ld (iy+1), h
        ld (ix+2), #92
        ld (iy+2), #A7
        ld a, #02
        ld (State.s_54), a
        xor a
        ld (State.s_56), a
        ld a, #C8
        ld (State.s_51), a
        ret
.l_0:
        ld ix, sceneObjects.obj2
        ld iy, sceneObjects.obj3
        ld a, (State.s_59)
        inc a
        and #07
        ld (State.s_59), a
        cp #04
        jr Z, .l_1
        cp #05
        jr NZ, .l_2
.l_1:
        set 6, (ix+5)
        set 6, (iy+5)
        ret
.l_2:
        res 6, (ix+5)
        res 6, (iy+5)
        ret


    ENDMODULE
