; Level data addresses
    MODULE Level

start           EQU #C178

levObjectTypes  EQU #C178
blockMap        EQU #C658
transitTable    EQU #D030
sprites         EQU #D124
tilePixels      EQU #DE00
tileAttrs       EQU #E600
tileTypes       EQU #E700
tileBlocks      EQU #E800
objectTable     EQU #F544
bossLogicAddr   EQU #F862
trajVelTable    EQU #F864
trajDirTable    EQU #F886
; trajectories  (variable)
; bossLogic     (variable)

end             EQU #FDE5
length          EQU end - start

    ENDMODULE
