; Level data addresses
    MODULE Level


start           EQU #6D00   ; #C000

levObjectTypes  EQU #6D00   ; #C000
objectTable     EQU #71E0   ; #C4E0

tilePixels      EQU #7500   ; #C800
tileAttrs       EQU #7D00   ; #D000
tileTypes       EQU #7E00   ; #D100
tileBlocks      EQU #7F00   ; #D200

trajVelTable    EQU #8FFA   ; #E2FA
trajDirTable    EQU #901C   ; #E31C

blockMap        EQU #9040   ; #E340
transitTable    EQU #9A18   ; #ED18

end             EQU #A7E2   ; #FAE2
length          EQU end - start


    ENDMODULE
