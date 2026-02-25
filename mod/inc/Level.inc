; Level data addresses
    MODULE Level

; Level indices
klondike    EQU 0
orient      EQU 1
amazon      EQU 2
iceland     EQU 3
bermuda     EQU 4


; Level data addresses
start           EQU #C228

levObjectTypes  EQU #C228
objectTable     EQU #C708
blockMap        EQU #CA28
tilePixels      EQU #D400
tileAttrs       EQU #DC00
tileTypes       EQU #DD00
tileBlocks      EQU #DE00
sprites         EQU #EB44
transitTable    EQU #F820
trajVelTable    EQU #F916
trajDirTable    EQU #F938
; trajectories  (variable)

end             EQU #FDE5
length          EQU end - start

    ENDMODULE
