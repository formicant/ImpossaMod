    STRUCT ObjType  ; length: 26
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
ot_12       byte    ; o_49
trajectory  byte
ot_14       byte    ; o_16
ot_15       byte    ; o_17
ot_16       byte    ; o_18
horizSpeed  byte
vertSpeed   byte
direction   byte    ; bit 0: up, 1: down, 2: left, 3: right
ot_20       byte    ; o_22
behaviour   byte    ; behaviour type (0..5)
stillActX   byte    ; still enemy activation zone left offset
stillActY   byte    ; still enemy activation zone top offset
stillActW   byte    ; still enemy activation zone width
stillActH   byte    ; still enemy activation zone height
    ENDS


    STRUCT Obj      ; length: 50
x           word    ; x coord in pixels
y           byte    ; y coord in pixels
sprite      word    ; base sprite addr
flags       byte    ; bit 0: exists, 1: is big, 2: fixed horizontally, 3: fixed vertically, 4: blink once, 5: waiting, 6: mirror(?), 7: should be removed(?)
o_6         byte
o_7         byte
objType     byte    ; object type with offset
colour      byte    ; object colour attribute
width       byte    ; width(?)
height      byte    ; gravity (?)
health      byte    ; enemy's health
score       byte    ; index 1..6 in `scoreTable`
blinkTime   byte    ; time during which the object will blink
trajectory  byte
o_16        byte    ; ot_14
o_17        byte    ; ot_15
o_18        byte    ; ot_16
horizSpeed  byte
vertSpeed   byte
direction   byte    ; bit 0: right, 1: left, 2: down, 3: up
o_22        byte    ; ot_20
behaviour   byte    ; behaviour type (0..6)
o_24        byte    ; ot_10, bit 0: ?, 1: ? 3: smart-killable, 4: gives coin; 5: ?
stillActX   byte    ; still enemy activation zone left offset
stillActY   byte    ; still enemy activation zone top offset
stillActW   byte    ; still enemy activation zone width
stillActH   byte    ; still enemy activation zone height
o_29        byte
o_30        word
o_32        word
o_34        word    ; unused(?)
o_36        word
o_38        word
o_40        word
o_42        word
o_44        word
o_46        word
o_48        byte
o_49        byte    ; ot_12
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
