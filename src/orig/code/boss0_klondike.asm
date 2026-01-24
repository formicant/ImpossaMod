    MODULE Code


; Klondike boss positions
c_f8ec:  ; #f8ec
        db #98, #AB, #D8, #AB, #98, #4B, #D8, #4B

; Klondike boss logic
; Used by c_f8cb.
c_f8f4:  ; #f8f4
        ld a, (State.s_54)
        cp #01
        jr NZ, .l_1
        ld a, (State.s_57)
        or a
        ret NZ
        ld ix, sceneObjects.obj2
        ld a, #36
        call c_f74a.l_1
        ld ix, sceneObjects.obj3
        ld a, #34
        call c_f74a.l_1
        ld ix, sceneObjects.obj4
        ld a, #35
        call c_f74a.l_1
        ld ix, sceneObjects.obj5
        ld a, #33
        call c_f74a.l_1
        call generateRandom
        and #03
        add a
        ld l, a
        ld h, #00
        ld de, c_f8ec
        add hl, de
        ld a, (hl)
        inc hl
        ld h, (hl)
        ld l, a
        ld b, #04
        ld ix, sceneObjects.obj2
        ld de, #0032
.l_0:
        ld (ix+0), l
        ld (ix+1), #00
        ld (ix+2), h
        add ix, de
        djnz .l_0
        ld a, #02
        ld (State.s_54), a
        xor a
        ld (State.s_56), a
        ld a, #FF
        ld (State.s_51), a
        ret
.l_1:
        ld hl, State.s_54
        inc (hl)
        ld a, (hl)
        cp #41
        jr NZ, .l_2
        ld ix, sceneObjects.obj4
        ld hl, Lev0Klondike.lS.bossAnt2
        ld (ix+3), l
        ld (ix+4), h
        ld a, #FF
        ld (State.s_56), a
        ld a, #02
        ld (State.s_51), a
        ret
.l_2:
        cp #69
        jr NZ, .l_3
        ld a, #01
        ld (State.s_51), a
        ret
.l_3:
        cp #96
        ret C
; This entry point is used by c_fa65.
.l_4:
        ld b, #04
        ld ix, sceneObjects.obj2
        ld de, #0032
.l_5:
        ld (ix+5), #00
        djnz .l_5
        ld a, #01
        ld (State.s_54), a
        ret


    ENDMODULE
