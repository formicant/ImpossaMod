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


    MODULE TrajMarker   ; trajectory end marker type

last    EQU -1  ; use the last vel/dir values forever
loop    EQU -2  ; start the trajectory from the beginning
stop    EQU -3  ; don't move any more
back    EQU -4  ; traverse the trajectory backwards

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


; Rectangular zone
;   length: 4
    STRUCT Zone

x   byte    ; zone left offset
y   byte    ; zone top offset
w   byte    ; zone width
h   byte    ; zone height

    ENDS


    MODULE EmitBullets

none    EQU 0
aim     EQU 1
forward EQU 2
up      EQU 3
down    EQU 4

    ENDMODULE


; Motion parameters of an object
;   length: 9
    STRUCT MotionOptions

coordConstr         ; (alias for `param1`)
step                ; (alias for `param1`)
trajetory           ; (alias for `param1`)
param1      byte    ; motion parameter with multiple semantics

range               ; (alias for `param2`)
trajStep            ; (alias for `param2`)
param2      byte    ; motion parameter with multiple semantics

trajBack    byte    ; -1: traverse trajectory backwards
trajDir     byte    ; current trajectory direction

horizSpeed  byte    ; horizontal speed
vertSpeed   byte    ; vertical speed
direction   byte    ; bits of `Dir` enum

subType     byte    ; motion subtype (`Motion` enum sub-labels)
type        byte    ; motion type (`Motion` enum)

    ENDS
