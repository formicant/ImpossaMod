    STRUCT ObjTypeDescr  ; length: 26
spriteAddr  word
attr        byte
ot_3        byte
flags       byte
width       byte
height      byte
health      byte
ot_8        byte
score       byte    ; index 1..6 in `scoreTable`
ot_10       byte    ; o_24
objType     byte    ; object type with offset
emitBullets byte    ; o_49
motionPar1  byte
motionPar2  byte
ot_15       byte    ; o_17
ot_16       byte    ; o_18
horizSpeed  byte
vertSpeed   byte
direction   byte    ; bit 0: up, 1: down, 2: left, 3: right
motionSub   byte    ; motion subtype (`Motion` enum sub-labels)
motion      byte    ; motion type (`Motion` enum)
stillActX   byte    ; still enemy activation zone left offset
stillActY   byte    ; still enemy activation zone top offset
stillActW   byte    ; still enemy activation zone width
stillActH   byte    ; still enemy activation zone height
    ENDS


    STRUCT Aim      ; variables used for enemy bullets aimed at the hero

speed       byte
curX        word
curY        word
tgtX        word    ; unused(?)
tgtY        word
distX       word
distY       word
dirX        word
dirY        word
phase       word

    ENDS


    STRUCT Obj      ; length: 50
x           word    ; x coord in pixels
y           byte    ; y coord in pixels
sprite      word    ; base sprite addr
flags       byte    ; values of `Flag` enum
o_6         byte
o_7         byte
objType     byte    ; object type with offset
colour      byte    ; object colour attribute
width       byte    ; width(?)
height      byte    ; gravity (?)
health      byte    ; enemy's health
score       byte    ; index 1..6 in `scoreTable`
blinkTime   byte    ; time during which the object will blink
coordConstr         ; (alias for `motionPar1`)
motionStep          ; (alias for `motionPar1`)
trajetory           ; (alias for `motionPar1`)
motionPar1  byte    ; motion parameter with multiple semantics
motionRange         ; (alias for `motionPar2`)
trajStep            ; (alias for `motionPar2`)
motionPar2  byte    ; motion parameter with multiple semantics
trajBack    byte    ; ot_15 -1: traverse trajectory backwards
o_18        byte    ; ot_16 (some direction ?)
horizSpeed  byte
vertSpeed   byte
direction   byte    ; bit 0: right, 1: left, 2: down, 3: up
motionSub   byte    ; motion subtype (`Motion` enum sub-labels)
motion      byte    ; motion type (`Motion` enum)
o_24        byte    ; ot_10, bit 0: ?, 1: ? 3: smart-killable, 4: gives coin; 5: ?
stillActX   byte    ; still enemy activation zone left offset
stillActY   byte    ; still enemy activation zone top offset
stillActW   byte    ; still enemy activation zone width
stillActH   byte    ; still enemy activation zone height
aim         Aim     ; variables used for enemy bullets aimed at the hero
stillTime   byte
emitBullets byte    ; ot_12
    ENDS


    STRUCT Transit  ; length: 8
isDown      byte    ; 0: upward, 1: downward
fromX       word    ; x block coord of the entrance
toStart     word    ; exit map span start
toEnd       word    ; exit map span end
toX         byte    ; exit x block coord (relative to span start)
    ENDS


    STRUCT ShopTransit  ; length: 12
shopStart   word    ; shop map span start in tiles
shopEnd     word    ; shop map span end in tiles
shopX       byte    ; shop x block coord (relative to span start)
shopY       byte    ; shop y block coord
exitStart   word    ; exit map span start in tiles
exitEnd     word    ; exit map span end in tiles
exitX       byte    ; exit x block coord (relative to span start)
exitY       byte    ; exit y block coord
    ENDS


    STRUCT Conveyor ; length: 3
start       word    ; addr in `scrTiles` of the first conveyor tile
length      byte    ; number of consequent conveyor tiles
    ENDS
