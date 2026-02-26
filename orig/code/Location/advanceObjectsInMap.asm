    MODULE Location

; Advance scene objects in map
advanceObjectsInMap:  ; #cf17
        ld b, 8                 ; object count
        ld ix, Scene.objects
.object:
        ld l, (ix+Obj.x+0)
        ld h, (ix+Obj.x+1)      ; `hl`: x coord in pixels
        ld de, -64
        add hl, de
        bit 7, h
        jr Z, .skip             ; if x >= 64, skip
        ld (ix+Obj.flags), 0    ; else, remove object
.skip:
        ld (ix+Obj.x+0), l
        ld (ix+Obj.x+1), h

        ld a, (ix+Obj.mo.type)
        cp Motion.bullet
        jr NZ, .nextObject

        ld l, (ix+Obj.aim.curX+0)
        ld h, (ix+Obj.aim.curX+1)
        add hl, de
        ld (ix+Obj.aim.curX+0), l
        ld (ix+Obj.aim.curX+1), h

.nextObject:
        ld de, Obj              ; object size
        add ix, de
        djnz .object
        ret

    ENDMODULE
