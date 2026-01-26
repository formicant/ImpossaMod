    MODULE Code


    ALIGN 256

; Bit mirroring. Const, initialized at runtime
mirrorTable:                    ; #8000
        block 256


; Interrupt table. Const, initialized at runtime
interruptTable:                 ; #8100
        block 256               ; 257th byte is in `objTiles`


; Contains parts of objects drawn on top of map tiles
objTiles:                       ; #8200
        db -0                   ; 257th byte of `interruptTable`
        block 15                ; unused
        block 1008              ; 126 tiles × 8 pixelRows

; Attributes for `objTiles`
objTileAttrs:                   ; #8600
        block 2                 ; unused
        block 126               ; 126 tiles


; Indices of the tiles currently on the screen
; 4 top and 4 bottom rows are off-screen, row 0 is behind the panel
; 4 left and 8 right columns are off-screen
scrTiles:                       ; #8680
        block 44 * 4
.row0:  block 44
.row1:  block 44 * 23
.stop:  block 44 * 4

; Which tiles should be updated
; Layout is the same as in `scrTiles`
; Possible values:
;  -3: screen end marker
;  -2: screen third end marker
;  -1: screen row end marker
;   0: don't update
;   1: update
;   2..160: object tile index in `objTiles`
scrTileUpd:                     ; #8C00
        block 44 * 4
.row0:  block 44
.row1:  block 44 * 6
.row7:  block 44 * 8
.row15: block 44 * 8
.row23: block 44 * 5
.length EQU $ - scrTileUpd      ; #580 = 1408
.end:                           ; #9180


    ENDMODULE
