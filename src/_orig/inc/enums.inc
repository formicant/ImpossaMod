    MODULE Colour

; ink colours on black paper
; non-bright
black       EQU #00
blue        EQU #01
red         EQU #02
magenta     EQU #03
green       EQU #04
cyan        EQU #05
yellow      EQU #06
white       EQU #07
; bright
brBlue      EQU #41
brRed       EQU #42
brMagenta   EQU #43
brGreen     EQU #44
brCyan      EQU #45
brYellow    EQU #46
brWhite     EQU #47

    ENDMODULE


    MODULE Key

; bits in `controlState`
right   EQU 0
left    EQU 1
down    EQU 2
up      EQU 3
fire    EQU 4
; mod only
smart   EQU 5
pause   EQU 6
quit    EQU 7

    ENDMODULE


    MODULE Level

klondike    EQU 0
orient      EQU 1
amazon      EQU 2
iceland     EQU 3
bermuda     EQU 4

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
; bit mask
typeMask    EQU %01111111

    ENDMODULE


    MODULE ObjType

; common object types
hero        EQU -1
bullet      EQU  0
shatterbomb EQU  1
powerGun    EQU  2
laserGun    EQU  3
soupCan     EQU  4
slimyWorms  EQU  5
coin        EQU  6
pintaADay   EQU  7
diary       EQU  8
shopMole    EQU  9
scoreItem1  EQU 10
scoreItem2  EQU 11
scoreItem3  EQU 12
scoreItem4  EQU 13
pressPlatf  EQU 14  ; press or platform

; level-specific object types

klondike
.dynamite1      EQU  15
.dynamite2      EQU  16
.emptyMineCart  EQU  17
.fullMineCart   EQU  18
.stalactite     EQU  40
.boss           EQU  53

orient
.boss           EQU  94

amazon
.hangingMonkey  EQU 110
.crocodile      EQU 130
.boss           EQU 138

iceland
.snowBall1      EQU 163
.boss           EQU 191

bermuda
.boss           EQU 237

    ENDMODULE


    MODULE Flag

; bits in `Obj.flags`
exists      EQU 0   ; 0: object is absent, 1: object is present
isBig       EQU 1   ; 0: small sprite (16×16), 1: big sprite (24×21)
fixedX      EQU 2   ; cannot move horizontally
fixedY      EQU 3   ; cannot move vertically
blink       EQU 4   ; blinking phase when the sprite is not drawn
waiting     EQU 5   ; object is not active (invisible yet or in still phase)
mirror      EQU 6   ; draw sprite mirrored
cleanUp     EQU 7   ; object should be removed

; bits in `Obj.o_24`
fo_0        EQU 0
fo_1        EQU 1
destroyable EQU 3   ; can be killed by smart
givesCoin   EQU 4
fo_5        EQU 5
fo_7        EQU 7

    ENDMODULE


    MODULE Behaviour

; values of `Obj.behaviour`
be_0        EQU 0
be_1        EQU 1
be_2        EQU 2
be_3        EQU 3
be_4        EQU 4
be_5        EQU 5
be_6        EQU 6

    ENDMODULE


    MODULE Dir      ; object direction

; bits in `Obj.direction`
right       EQU 0
left        EQU 1
down        EQU 2
up          EQU 3
; bit masks
horizontal  EQU (1<<left) | (1<<right)
vertical    EQU (1<<up) | (1<<down)

    ENDMODULE
