; Level data addresses
    MODULE Level


start           EQU #C000

levObjectTypes  EQU #C000
objectTable     EQU #C4E0

tilePixels      EQU #C800
tileAttrs       EQU #D000
tileTypes       EQU #D100
tileBlocks      EQU #D200

trajVelTable    EQU #E2FA
trajDirTable    EQU #E31C

blockMap        EQU #E340
transitTable    EQU #ED18

end             EQU #FAE2
length          EQU end - start


    ENDMODULE
