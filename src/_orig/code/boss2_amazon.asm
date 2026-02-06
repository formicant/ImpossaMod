    MODULE Code


; Amazon boss positions
c_fa61:  ; #fa61
        db #E4, #7B, #44, #7B

; Amazon boss logic
; Used by c_f8cb.
bossLogicAmazon:  ; #fa65
        ld a, (State.bossFight)
        cp #01
        jr NZ, .l_0
        ld a, (State.s_57)
        or a
        ret NZ
        ld ix, scene.obj2
        ld a, #2B
        call createObject
        ld ix, scene.obj3
        ld a, #2C
        call createObject
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
        ld ix, scene.obj2
        ld iy, scene.obj3
        ld (ix+Obj.x+0), e
        ld (iy+Obj.x+0), e
        ld (ix+Obj.x+1), #00
        ld (iy+Obj.x+1), #00
        ld (ix+Obj.y), a
        add #18
        ld (iy+Obj.y), a
        ld a, #02
        ld (State.bossFight), a
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
        jp bossLogicKlondike.l_4


    ENDMODULE
