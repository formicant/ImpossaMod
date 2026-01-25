    MODULE Code


; Variable used in `drawObjectsChecked` and `drawObjectsUnchecked`
; Possible values: 2..127 like in `objTileAttrs`
objTileIndex: ; #BEB3
        db -0

; Up to 8 objects appearing on the screen
scene: ; #BEB4
.hero:  block 50                ; #BEB4
.obj1:  block 50                ; #BEE6
.obj2:  block 50                ; #BF18
.obj3:  block 50                ; #BF4A
.obj4:  block 50                ; #BF7C
.obj5:  block 50                ; #BFAE
.obj6:  block 50                ; #BFE0
.obj7:  block 50                ; #C012

;  0    \ x coord in pixels (from -32 ?)
;  1    /
;  2    y coord in pixels (from -32 ?)
;  3    \ base sprite addr
;  4    /
;  5    bit 0: exists, 1: is big, 4: blink once, 6: mirror(?)
;  6    ?
;  7    ?
;  8    ?
;  9    attribute
; 10    ?
; 11    ?
; 12
; 13
; 14    blink timer
; 15
; 16
; 17
; 18
; 19
; 20
; 21    bit 1: mirror(?)
; 22
; 23    ? (possibly, value 1 means that object moves horizontally)
; 24
; 25
; 26
; 27
; 28
; 29
; 30    \ ? (possible, horizontal trajectory limit)
; 31    /
; 32
; 33
; 34
; 35
; 36
; 37
; 38
; 39
; 40
; 41
; 42
; 43
; 44
; 45
; 46
; 47
; 48    ?
; 49

    ENDMODULE
