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
mirror      byte    ; o_19
ot_18       byte    ; o_20
ot_19       byte    ; o_21
ot_20       byte    ; o_22
ot_21       byte    ; o_23
ot_22       byte    ; o_25
ot_23       byte    ; o_26
ot_24       byte    ; o_27
ot_25       byte    ; o_28
    ENDS


    STRUCT Obj      ; length: 50
x           word    ; x coord in pixels (from -32 ?)
y           byte    ; y coord in pixels (from -32 ?)
sprite      word    ; base sprite addr
flags       byte    ; bit 0: exists, 1: is big, 4: blink once, 5: waiting, 6: mirror(?), 7: should be removed(?)
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
o_19        byte    ; ot_17
o_20        byte    ; ot_18
o_21        byte    ; ot_19, bit 1: mirror(?)
o_22        byte    ; ot_20
o_23        byte    ; ot_21, ? (possibly, value 1 means that object moves horizontally)
o_24        byte    ; ot_10, bit 0: ?, 1: ? 3: smart-killable, 4: gives coin; 5: ?
o_25        byte    ; ot_22
o_26        byte    ; ot_23
o_27        byte    ; ot_24
o_28        byte    ; ot_25
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
