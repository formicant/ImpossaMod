    MODULE Code


; Indices of the tiles currently on the screen
; 4 top and 4 bottom rows are off-screen, row 0 is behind the panel
; 4 left and 8 right columns are off-screen
scrTiles: ; #5B00
        block 44                ; #5B00
        block 44                ; #5B2C
        block 44                ; #5B58
        block 44                ; #5B84
.row0:  block 44                ; #5BB0
.row1:  block 44                ; #5BDC
.row2:  block 44                ; #5C08
.row3:  block 44                ; #5C34
.row4:  block 44                ; #5C60
.row5:  block 44                ; #5C8C
.row6:  block 44                ; #5CB8
.row7:  block 44                ; #5CE4
.row8:  block 44                ; #5D10
.row9:  block 44                ; #5D3C
.row10: block 44                ; #5D68
.row11: block 44                ; #5D94
.row12: block 44                ; #5DC0
.row13: block 44                ; #5DEC
.row14: block 44                ; #5E18
.row15: block 44                ; #5E44
.row16: block 44                ; #5E70
.row17: block 44                ; #5E9C
.row18: block 44                ; #5EC8
.row19: block 44                ; #5EF4
.row20: block 44                ; #5F20
.row21: block 44                ; #5F4C
.row22: block 44                ; #5F78
.row23: block 44                ; #5FA4
.stop:  block 44                ; #5FD0
        block 44                ; #5FFC
        block 44                ; #6028
        block 44                ; #6054
.end:                           ; #6080
.length EQU $ - scrTiles        ; #580 = 1408

; Which tiles should be updated
; Layout is the same as in `scrTiles`
; Possible values:
;  -3: screen end marker
;  -2: screen third end marker
;  -1: screen row end marker
;   0: don't update
;   1: update
;   2..160: object tile index in `objTiles`
scrTileUpd: ; #6080
        block 44                ; #6080
        block 44                ; #60AC
        block 44                ; #60D8
        block 44                ; #6104
.row0:  block 44                ; #6130
.row1:  block 44                ; #615C
.row2:  block 44                ; #6188
.row3:  block 44                ; #61B4
.row4:  block 44                ; #61E0
.row5:  block 44                ; #620C
.row6:  block 44                ; #6238
.row7:  block 44                ; #6264
.row8:  block 44                ; #6290
.row9:  block 44                ; #62BC
.row10: block 44                ; #62E8
.row11: block 44                ; #6314
.row12: block 44                ; #6340
.row13: block 44                ; #636C
.row14: block 44                ; #6398
.row15: block 44                ; #63C4
.row16: block 44                ; #63F0
.row17: block 44                ; #641C
.row18: block 44                ; #6448
.row19: block 44                ; #6474
.row20: block 44                ; #64A0
.row21: block 44                ; #64CC
.row22: block 44                ; #64F8
.row23: block 44                ; #6524
        block 44                ; #6550
        block 44                ; #657C
        block 44                ; #65A8
        block 44                ; #65D4
.end:                           ; #6600
.length EQU $ - scrTileUpd      ; #580 = 1408


; Contains parts of objects drawn on top of map tiles
objTiles: ; #6600
        block 16                ; unused
        block 1008              ; 126 tiles × 8 pixelRows


    ALIGN 256
; Bit mirroring. Initialised in the code
mirrorTable: ; #6A00
        block 256


    ALIGN 256
; Attributes for `objTiles`
objTileAttrs: ; #6B00
        block 2                 ; unused
        block 126               ; 126 tiles


    ENDMODULE
