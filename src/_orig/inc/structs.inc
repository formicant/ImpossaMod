    STRUCT ObjType  ; length: 26
spriteAddr  dw
attr        db
ot_3        db
ot_4        db
width       db
height      db
ot_7        db
ot_8        db
ot_9        db
ot_10       db
ot          db
ot_12       db
trajectory  db
ot_14       db
ot_15       db
ot_16       db
mirror      db
ot_18       db
ot_19       db
ot_20       db
ot_21       db
ot_22       db
ot_23       db
ot_24       db
ot_25       db
    ENDS


    STRUCT Obj      ; length: 50
x           dw      ; x coord in pixels (from -32 ?)
y           db      ; y coord in pixels (from -32 ?)
sprite      dw      ; base sprite addr
flags       db      ; bit 0: exists, 1: is big, 4: blink once, 6: mirror(?), 7: should be removed(?)
o_6         db
o_7         db
o_8         db
color       db      ; object color attribute
o_10        db      ; width(?)
o_11        db      ; gravity (?)
health      db      ; enemy's health
o_13        db
blinkTime   db      ; time during which the object will blink
o_15        db
o_16        db
o_17        db
o_18        db
o_19        db
o_20        db
o_21        db      ; bit 1: mirror(?)
o_22        db
o_23        db      ; ? (possibly, value 1 means that object moves horizontally)
o_24        db      ; bit 0: ?, 3: smart-killable, 4: gives coin
o_25        db
o_26        db
o_27        db
o_28        db
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
o_49        db
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
