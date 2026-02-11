    MODULE Colour

; Ink colours on black paper
; bright:
white   EQU #47
yellow  EQU #46
cyan    EQU #45
green   EQU #44
magenta EQU #43
red     EQU #42
blue    EQU #41
; non-bright, mod only:
gray    EQU #07
olive   EQU #06
teal    EQU #05
spruce  EQU #04
purple  EQU #03
maroon  EQU #02
navy    EQU #01
black   EQU #00

    ENDMODULE


    MODULE Key

; bits in `controlState`
right   EQU 0
left    EQU 1
down    EQU 2
up      EQU 3
fire    EQU 4
; mod only:
smart   EQU 5
pause   EQU 6
quit    EQU 7

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
