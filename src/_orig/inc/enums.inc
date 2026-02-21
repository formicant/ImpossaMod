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

space       EQU 0   ; behaves as an empty tile
ladder      EQU 1   ; hero can climb
ladderTop   EQU 2   ; hero can climb and stand on
platform    EQU 3   ; hero can stand on and jump through
wall        EQU 4   ; not passable
conveyorL   EQU 5
conveyorR   EQU 6
ice         EQU 7   ; slippery
slow        EQU 8   ; slows down walking hero
waterSpikes EQU 9   ; water or spikes, damage and make jump

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

; bits in `Obj.auxFlags`
riding      EQU 0   ; object is rideable (or the hero is riding)
standsStill EQU 1   ; randomly stands still
unknown     EQU 2   ; (used in data but ignored in code)
nonEnemy    EQU 3   ; can't be destroyed by smart
givesCoin   EQU 4   ; a coin appears after defeat
changesDir  EQU 5   ; randomly changes direction
falling     EQU 7   ; walking enemy is falling down

    ENDMODULE


    MODULE HeroState

stand   EQU 0
walk    EQU 1
jump    EQU 2
fall    EQU 3
climb   EQU 4

    ENDMODULE


    MODULE Attack

none    EQU 0
kick    EQU 1
throw   EQU 2
power   EQU 3
laser   EQU 4

    ENDMODULE


    MODULE Motion

; values of `Obj.motion` (sub-labels are values of `Obj.motionSub`)
none        EQU  0  ; object does not move

bullet      EQU  1  ; enemy bullet flies

trajOrFall  EQU  2  ; object moves along a trajectory or falls
.andExplode EQU -1  ;   object falls and explodes at the bottom
.andStay    EQU -2  ;   object falls and stays at the bottom

general     EQU  3  ; `motionSub` defines motion type
.walk       EQU -1  ;   object walks avoiding falling
.walkOrFall EQU -2  ;   object walks and can fall down
.random     EQU -4  ;   object flies changing direction randomly
.range      EQU -5  ;   object moves back and forth within a range

trajectory  EQU  4  ; object moves along a trajectory

selfGuided  EQU  5  ; object flies always towards the hero
.vert       EQU  0  ;   (bit) allow vertical movements
.horiz      EQU  1  ;   (bit) allow horizontal movements

coinJump    EQU  6  ; coin jumps after defeating an enemy

    ENDMODULE


    MODULE EmitBullets

none    EQU 0
aim     EQU 1
forward EQU 2
up      EQU 3
down    EQU 4

    ENDMODULE


    MODULE TrajMarker   ; trajectory end marker type

last    EQU -1  ; use the last vel/dir values forever
loop    EQU -2  ; start the trajectory from the beginning
stop    EQU -3  ; don't move any more
back    EQU -4  ; traverse the trajectory backwards

    ENDMODULE


    MODULE Dir          ; object direction

; bits in `Obj.mo.direction`
right   EQU 0
left    EQU 1
down    EQU 2
up      EQU 3

; bit masks
horizontal  EQU (1<<left) | (1<<right)
vertical    EQU (1<<up) | (1<<down)

    ENDMODULE


    MODULE SpriteSet

turnAround  EQU -4  ; (unused?)
burrow      EQU -3
frog        EQU -2
explosion   EQU -1
single      EQU  0
twoPhase    EQU  2
threePhase  EQU  3
fourPhase   EQU  4

    ENDMODULE


    MODULE Sound

damageEnemy EQU  3
kickOrThrow EQU  4
jump        EQU  5
explosion   EQU  6
laserShot   EQU  8
powerShot   EQU 10
pickItem    EQU 11
energyLoss  EQU 12
pickWeapon  EQU 13

    ENDMODULE


    MODULE SoundType

rising  EQU 0
falling EQU 1   ; (unused)
noise   EQU 2
steady  EQU 3

    ENDMODULE
