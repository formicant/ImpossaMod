; Level data addresses
    MODULE Level

start           EQU #6C00

tilePixels      EQU #6C00
tileAttrs       EQU #7400
tileTypes       EQU #7500
tileBlocks      EQU #7600
objectTable     EQU #8600
blockMap        EQU #8A00

sprites         EQU #A59E - #11C6
transitTable    EQU #B282 - #11C6

trajVelTable    EQU #B373 - #11C6
trajDirTable    EQU #B395 - #11C6

levObjectTypes  EQU #B4BB - #11C6

end             EQU #BDDF - #11C6
length          EQU end - start

    ENDMODULE
