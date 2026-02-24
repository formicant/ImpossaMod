    MODULE Scene

; (Modifies some object properties?)
; Used by c_cc25.
moveObjects:  ; #e56f
        ld ix, obj1
        ld b, 7                 ; object count
.object:
        push bc
        call moveObject
        ld bc, Obj              ; object size
        add ix, bc
        pop bc
        djnz .object
        ret


; (Modifies some object properties?)
; Used by c_e56f.
moveObject:  ; #e582
        bit Flag.exists, (ix+Obj.flags)
        ret Z

        ld a, (ix+Obj.stillTime)
        or a
        ret NZ
        bit Flag.waiting, (ix+Obj.flags)
        ret NZ

.horizontal:
        bit Flag.fixedX, (ix+Obj.flags)
        jr NZ, .vertical

        bit Dir.right, (ix+Obj.mo.direction)
        jr Z, .left
        ; move right
        ld e, (ix+Obj.mo.horizSpeed)
        ld d, 0
        ld l, (ix+Obj.x+0)
        ld h, (ix+Obj.x+1)
        add hl, de
        ld (ix+Obj.x+0), l
        ld (ix+Obj.x+1), h
        jr .vertical
.left:
        bit Dir.left, (ix+Obj.mo.direction)
        jr Z, .vertical
        ; move left
        ld a, (ix+Obj.mo.horizSpeed)
        neg
        ld e, a
        ld d, -1
        ld l, (ix+Obj.x+0)
        ld h, (ix+Obj.x+1)
        add hl, de
        ld (ix+Obj.x+0), l
        ld (ix+Obj.x+1), h

.vertical:
        bit Flag.fixedY, (ix+Obj.flags)
        ret NZ

        bit Dir.up, (ix+Obj.mo.direction)
        jr Z, .down
        ; move up
        ld a, (ix+Obj.mo.vertSpeed)
        neg
        add (ix+Obj.y)
        ld (ix+Obj.y), a
        ret
.down:
        bit Dir.down, (ix+Obj.mo.direction)
        ret Z
        ; move down
        ld a, (ix+Obj.mo.vertSpeed)
        add (ix+Obj.y)
        ld (ix+Obj.y), a
        ret


; Mark all scene objects except the hero as non-existent
; Used by c_cc25, c_e60a, c_e920 and c_e9b1.
removeObjects:  ; #e5f2
        push ix
        push de
        ld de, Obj
        ld ix, obj1
        ld b, 7
.object:
        ld (ix+Obj.flags), 0    ; remove object
        add ix, de
        djnz .object

        pop de
        pop ix
        ret

    ENDMODULE
