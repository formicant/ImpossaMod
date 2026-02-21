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


; Rectangular zone
;   length: 4
    STRUCT Zone

x   byte    ; zone left offset
y   byte    ; zone top offset
w   byte    ; zone width
h   byte    ; zone height

    ENDS


; Variables used for enemy bullets aimed at the hero
;   length: 19 (ridiculous!)
    STRUCT AimVars

speed   byte
curX    word
curY    word
tgtX    word    ; (unused)
tgtY    word    ; (local)
distX   word
distY   word
dirX    word
dirY    word
phase   word

    ENDS


; Object type description
;   length: 26
    STRUCT OT

sprite      word
colour      byte
spriteSet   byte
flags       byte
width       byte
height      byte
health      byte
isWaiting   byte    ; (why? flags are enough)
score       byte
auxFlags    byte
objType     byte
emitBullets byte
mo          MotionOptions
activeZone  Zone

    ENDS


; Game object
;   length: 50
    STRUCT Obj

x           word    ; x coord in pixels
y           byte    ; y coord in pixels
sprite      word    ; base sprite addr
flags       byte    ; main flags, values of `Flag` enum
walkPhase   byte    ; enemy's walk phase
spriteSet   byte    ; values of `SpriteSet` enum
objType     byte    ; object type with offset
colour      byte    ; object colour attribute
width       byte    ; width in pixels
height      byte    ; height in pixels
health      byte    ; enemy's health
score       byte    ; index 1..6 in `scoreTable`
blinkTime   byte    ; time during which the object will blink
mo          MotionOptions
auxFlags    byte    ; additional flags, values of `Flag` enum
activeZone  Zone    ; still enemy activation zone
aim         AimVars ; variables used for enemy bullets aimed at the hero
stillTime   byte    ; time when enemy stands still
emitBullets byte    ; values of `EmitBullets` enum

    ENDS


; Passage between different locations on the map
;   length: 8
    STRUCT Transit

isDown      byte    ; 0: upward, 1: downward
fromX       word    ; x block coord of the entrance
toStart     word    ; exit map span start
toEnd       word    ; exit map span end
toX         byte    ; exit x block coord (relative to span start)

    ENDS


; Map location of the shop and its entrance
;   length: 12
    STRUCT ShopTransit

shopStart   word    ; shop map span start in tiles
shopEnd     word    ; shop map span end in tiles
shopX       byte    ; shop x block coord (relative to span start)
shopY       byte    ; shop y block coord
exitStart   word    ; exit map span start in tiles
exitEnd     word    ; exit map span end in tiles
exitX       byte    ; exit x block coord (relative to span start)
exitY       byte    ; exit y block coord

    ENDS


; Location of a conveyor on the screen
;   length: 3
    STRUCT Conveyor

start       word    ; addr in `Tables.scrTiles` of the first conveyor tile
length      byte    ; number of consequent conveyor tiles

    ENDS
