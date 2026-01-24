    MODULE Code


; (Some boss logic?)
; Used by Orient
c_fbd2:  ; #fbd2
        push ix
        ld ix, sceneObjects.obj2
        ld iy, sceneObjects.obj3
        call c_fbf9
        ld a, (ix+49)
        ld c, (iy+49)
        ld (ix+49), c
        ld (iy+49), a
        ld ix, sceneObjects.obj4
        ld iy, sceneObjects.obj5
        call c_fbf9
        pop ix
        ret

; (Some boss logic?)
; Used by c_fbd2.
c_fbf9:  ; #fbf9
        ld l, (ix+3)
        ld h, (ix+4)
        ld e, (iy+3)
        ld d, (iy+4)
        ld (ix+3), e
        ld (ix+4), d
        ld (iy+3), l
        ld (iy+4), h
        ret


    ENDMODULE
