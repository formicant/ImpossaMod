    MODULE Code


; (Some boss logic?)
; Used by Orient, Iceland
c_fbb9:  ; #fbb9
        push ix
        ld b, #04
        ld ix, scene.obj2
        ld de, Obj
.l_0:
        ld a, (ix+Obj.o_21)
        xor c
        ld (ix+Obj.o_21), a
        add ix, de
        djnz .l_0
        pop ix
        ret


    ENDMODULE
