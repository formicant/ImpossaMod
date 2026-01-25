    MODULE Code


; Contains parts of objects drawn on top of map tiles
objTiles: ; #6600
        block 16                ; unused
        block 1008              ; 126 tiles × 8 pixelRows


    ALIGN 256
; Bit mirroring. Initialized in the code
mirrorTable: ; #6A00
        block 256


    ALIGN 256
; Attributes for `objTiles`
objTileAttrs: ; #6B00
        block 2                 ; unused
        block 126               ; 126 tiles


    ENDMODULE
