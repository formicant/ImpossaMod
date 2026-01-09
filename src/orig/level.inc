; Level data addresses
    MODULE Level

start           EQU #6C00

tilePixels      EQU #6C00
tileAttrs       EQU #7400
tileTypes       EQU #7500
tileBlocks      EQU #7600
objectTable     EQU #8600
blockMap        EQU #8A00

sprites         EQU #A59E
transitTable    EQU #B282

trajVelTable    EQU #B373
trajDirTable    EQU #B395
objectTypes     EQU #B3B7
levObjectTypes  EQU #B4BB

end             EQU #BDDF
length          EQU end - start

    ENDMODULE
