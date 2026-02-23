    MODULE Code

; Remove objects from the scene that should be removed (?)
; Used by c_cc25.
cleanUpScene:  ; #d4cd
        ld ix, Scene.obj1
        ld b, 7                 ; object count
        ld de, Obj              ; object size
.object:
        bit Flag.cleanUp, (ix+Obj.flags)
        jr Z, .skip
        ld (ix+Obj.flags), 0    ; remove object
.skip:
        add ix, de
        djnz .object
        ret

    ENDMODULE
