    MODULE Key

; bits in `controlState`
right       EQU 0
left        EQU 1
down        EQU 2
up          EQU 3
fire        EQU 4
; mod only:
smart       EQU 5
pause       EQU 6
quit        EQU 7

    ENDMODULE


    MODULE TileType

space       EQU 0
ladder      EQU 1
ladderTop   EQU 2
platform    EQU 3
wall        EQU 4
conveyorL   EQU 5
conveyorR   EQU 6
ice         EQU 7
slow        EQU 8
waterSpikes EQU 9

    ENDMODULE
