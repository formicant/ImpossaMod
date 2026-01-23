    MODULE Code


; Variable used in `drawObjectsChecked` and `drawObjectsUnchecked`
; Possible values: 2..127 like in `objTileAttrs`
objTileIndex: ; #BEB3
        db -0

sceneObjects: ; #BEB4
        block 400               ; 8 objects × 50 bytes

;  0    \ x coord in pixels (from -32 ?)
;  1    /
;  2    y coord in pixels (from -32 ?)
;  3    \ base sprite addr
;  4    /
;  5    bit 0: draw, 1: is big, 4: skip once, 6: ?
;  6    ?
;  7    ?
;  8    ?
;  9    attribute
; 10
; 11
; 12
; 13
; 14
; 15
; 16
; 17
; 18
; 19
; 20
; 21    bit 1: ?
; 22
; 23
; 24
; 25
; 26
; 27
; 28
; 29
; 30
; 31
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
