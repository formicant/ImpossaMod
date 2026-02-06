    STRUCT ObjType  ; length: 26
spriteAddr  dw
attr        db
ot_3        db
flags       db
width       db
height      db
health      db
ot_8        db
ot_9        db      ; o_13
ot_10       db      ; o_24
objType     db      ; object type with offset
ot_12       db      ; o_49
trajectory  db
ot_14       db      ; o_16
ot_15       db      ; o_17
ot_16       db      ; o_18
mirror      db      ; o_19
ot_18       db      ; o_20
ot_19       db      ; o_21
ot_20       db      ; o_22
ot_21       db      ; o_23
ot_22       db      ; o_25
ot_23       db      ; o_26
ot_24       db      ; o_27
ot_25       db      ; o_28
    ENDS


    STRUCT Obj      ; length: 50
x           dw      ; x coord in pixels (from -32 ?)
y           db      ; y coord in pixels (from -32 ?)
sprite      dw      ; base sprite addr
flags       db      ; bit 0: exists, 1: is big, 4: blink once, 5: waiting, 6: mirror(?), 7: should be removed(?)
o_6         db
o_7         db
objType     db      ; object type with offset
color       db      ; object color attribute
width       db      ; width(?)
height      db      ; gravity (?)
health      db      ; enemy's health
o_13        db      ; ot_9
blinkTime   db      ; time during which the object will blink
trajectory  db
o_16        db      ; ot_14
o_17        db      ; ot_15
o_18        db      ; ot_16
o_19        db      ; ot_17
o_20        db      ; ot_18
o_21        db      ; ot_19, bit 1: mirror(?)
o_22        db      ; ot_20
o_23        db      ; ot_21, ? (possibly, value 1 means that object moves horizontally)
o_24        db      ; ot_10, bit 0: ?, 1: ? 3: smart-killable, 4: gives coin; 5: ?
o_25        db      ; ot_22
o_26        db      ; ot_23
o_27        db      ; ot_24
o_28        db      ; ot_25
o_29        db
o_30        dw      ; ? (possibly, horizontal trajectory limit; possibly, addr of some scene object ?)
o_32        db
o_33        db
o_34        db
o_35        db
o_36        db
o_37        db
o_38        db
o_39        db
o_40        db
o_41        db
o_42        db
o_43        db
o_44        db
o_45        db
o_46        db
o_47        db
o_48        db
o_49        db      ; ot_12
    ENDS


    STRUCT Transit  ; length: 8
isDown      db      ; 0: upward, 1: downward
fromX       dw      ; x block coord of the entrance
toStart     dw      ; exit map span start
toEnd       dw      ; exit map span end
toX         db      ; exit x block coord (relative to span start)
    ENDS


    STRUCT Conveyor ; length: 3
start       dw      ; addr in `scrTiles` of the first conveyor tile
length      db      ; number of consequent conveyor tiles
    ENDS
