    MODULE Code


; Amazon boss positions
c_fa61:  ; #fa61
        db #E4, #7B, #44, #7B

; Amazon boss logic
; Used by c_f8cb.
c_fa65:  ; #fa65
        ld a, (State.s_54)
        cp #01
        jr NZ, .l_0
        ld a, (State.s_57)
        or a
        ret NZ
        ld ix, sceneObjects.obj2
        ld a, #2B
        call c_f74a.l_1
        ld ix, sceneObjects.obj3
        ld a, #2C
        call c_f74a.l_1
        call generateRandom
        and #01
        add a
        ld l, a
        ld h, #00
        ld de, c_fa61
        add hl, de
        ld e, (hl)
        inc hl
        ld a, (hl)
        ld ix, sceneObjects.obj2
        ld iy, sceneObjects.obj3
        ld (ix+0), e
        ld (iy+0), e
        ld (ix+1), #00
        ld (iy+1), #00
        ld (ix+2), a
        add #18
        ld (iy+2), a
        ld a, #02
        ld (State.s_54), a
        xor a
        ld (State.s_56), a
        ld a, #3C
        ld (State.s_51), a
        ret
.l_0:
        ld a, (State.s_58)
        or a
        jr Z, .l_1
        dec a
        ld (State.s_58), a
        ret
.l_1:
        ld a, #50
        ld (State.s_58), a
        jp c_f8f4.l_4


    ENDMODULE
