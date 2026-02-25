    MODULE Boss


; (Some boss logic?)
; Used by Orient, Iceland
c_fbb9:  ; #fbb9
        push ix
        ld b, #04
        ld ix, Scene.obj2
        ld de, Obj
.l_0:
        ld a, (ix+Obj.mo.direction)
        xor c
        ld (ix+Obj.mo.direction), a
        add ix, de
        djnz .l_0
        pop ix
        ret


; (Some boss logic?)
; Used by Orient
c_fbd2:  ; #fbd2
        push ix
        ld ix, Scene.obj2
        ld iy, Scene.obj3
        call c_fbf9
        ld a, (ix+Obj.emitBullets)
        ld c, (iy+Obj.emitBullets)
        ld (ix+Obj.emitBullets), c
        ld (iy+Obj.emitBullets), a
        ld ix, Scene.obj4
        ld iy, Scene.obj5
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
