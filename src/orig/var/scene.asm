    MODULE Code


; Variable used in `drawObjectsChecked` and `drawObjectsUnchecked`
; Possible values: 2..127 like in `objTileAttrs`
objTileIndex: ; #BEB3
        db -0

; Up to 8 objects appearing on the screen
scene: ; #BEB4
.hero:  Obj                     ; #BEB4
.obj1:  Obj                     ; #BEE6
.obj2:  Obj                     ; #BF18
.obj3:  Obj                     ; #BF4A
.obj4:  Obj                     ; #BF7C
.obj5:  Obj                     ; #BFAE
.obj6:  Obj                     ; #BFE0
.obj7:  Obj                     ; #C012


    ENDMODULE
