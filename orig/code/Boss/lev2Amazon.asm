    MODULE Boss


; Amazon boss positions
c_fa61:  ; #fa61
        db #E4, #7B, #44, #7B

; Amazon boss logic
bossAmazon:  ; #fa65
        ld a, (State.bossFight)
        cp #01
        jr NZ, .l_0
        ld a, (State.bossKilled)
        or a
        ret NZ
        ld ix, Scene.obj2
        ld a, #2B
        call Scene.createObject
        ld ix, Scene.obj3
        ld a, #2C
        call Scene.createObject
        call Utils.generateRandom
        and #01
        add a
        ld l, a
        ld h, #00
        ld de, c_fa61
        add hl, de
        ld e, (hl)
        inc hl
        ld a, (hl)
        ld ix, Scene.obj2
        ld iy, Scene.obj3
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
        ld (State.bossInvinc), a
        ld a, #3C
        ld (State.bulletTime), a
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
        jp removeBoss


    ENDMODULE
