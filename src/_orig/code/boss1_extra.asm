    MODULE Code


; (Some boss logic?)
; Used by Orient, Iceland
c_fbb9:  ; #fbb9
        push ix
        ld b, #04
        ld ix, scene.obj2
        ld de, Obj
.l_0:
        ld a, (ix+Obj.direction)
        xor c
        ld (ix+Obj.direction), a
        add ix, de
        djnz .l_0
        pop ix
        ret


; (Some boss logic?)
; Used by Orient
c_fbd2:  ; #fbd2
        push ix
        ld ix, scene.obj2
        ld iy, scene.obj3
        call c_fbf9
        ld a, (ix+Obj.o_49)
        ld c, (iy+Obj.o_49)
        ld (ix+Obj.o_49), c
        ld (iy+Obj.o_49), a
        ld ix, scene.obj4
        ld iy, scene.obj5
        call c_fbf9
        pop ix
        ret

; (Some boss logic?)
; Used by c_fbd2.
c_fbf9:  ; #fbf9
        ld l, (ix+Obj.sprite+0)
        ld h, (ix+Obj.sprite+1)
        ld e, (iy+Obj.sprite+0)
        ld d, (iy+Obj.sprite+1)
        ld (ix+Obj.sprite+0), e
        ld (ix+Obj.sprite+1), d
        ld (iy+Obj.sprite+0), l
        ld (iy+Obj.sprite+1), h
        ret


    ENDMODULE
