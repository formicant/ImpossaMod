    MODULE Scene

; Get address for a new object in `Scene`
;   ret `ix`: object addr
;       `C` flag iff there is place for a new object
; Used by c_f564 and c_f74a.
allocateObject:  ; #e6c2
        push de
        push bc
        ld b, 6                 ; object count
        ld ix, obj2
        ld de, Obj              ; object size
.object:
        bit Flag.exists, (ix+Obj.flags)
        jr Z, .free
        add ix, de
        djnz .object

        xor a
        pop bc
        pop de
        ret
.free:
        scf
        pop bc
        pop de
        ret

    ENDMODULE
