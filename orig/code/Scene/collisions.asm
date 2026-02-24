    MODULE Scene

; Check if there is a collision between two objects
;   arg `ix`: object 1
;       `iy`: object 2
;   ret flag C: no collision, NC: collision
; Used by c_e6e1, c_e9b1, c_eb19 and c_f618.
checkObjectCollision:  ; #e80a
        bit Flag.exists, (iy+Obj.flags)
        jr NZ, .obj2Exists
        scf
        ret

.obj2Exists:
        ; object 1 size
        ld d, (ix+Obj.height)
        ld e, (ix+Obj.width)
        ; object 2 size
        ld b, (iy+Obj.height)
        ld c, (iy+Obj.width)

        ld a, (ix+Obj.y)
        ld l, a                 ; `l`: object 1 top
        add d                   ; `a`: object 1 bottom
        ld h, (iy+Obj.y)        ; `h`: object 2 top
        cp h
        ret C                   ; object 2 is below object 1

        ld a, h
        add b                   ; `a`: object 2 bottom
        cp l
        ret C                   ; object 1 is above object 1

        ld l, (ix+Obj.x+0)
        ld h, (ix+Obj.x+1)
        push hl                 ; object 1 left
        ld d, 0
        add hl, de              ; `hl`: object 1 right
        ld e, (iy+Obj.x+0)
        ld d, (iy+Obj.x+1)      ; `de`: object 2 left
        ld a, (iy+Obj.objType)
        cp ObjType.pressPlatf
        jr NZ, .notPressLeft
        ld a, e
        add 6
        ld e, a
.notPressLeft:
        or a
        sbc hl, de
        pop hl                  ; object 1 left
        ret C                   ; object 2 is to the right from object 1

        ex de, hl
        ld b, 0
        ld a, (iy+Obj.objType)
        cp ObjType.pressPlatf
        jr NZ, .notPressRight
        ld a, c                 ; object 2 width
        sub 12
        ld c, a
.notPressRight:
        add hl, bc              ; `hl`: object 2 right
        or a
        sbc hl, de              ; C if object 2 is to the left from object 1
        ret                     ; NC if there is a collision

    ENDMODULE
