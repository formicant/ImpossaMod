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


    ENDMODULE
