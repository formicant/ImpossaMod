    MODULE Lev2Amazon


; #B4BB
levObjectTypes:
        ;       spriteAddr        attr 3  4  w  h  7  8  9 10  ot 12 tr 14 15 16 mr 18 19 20 21 22  23  24   25
        ObjType lS.banana       , #46,  , 1,16,16,-2,  , 3, 8, 10,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,   ,     ; #A59E
        ObjType lS.apple        , #44,  , 1,16,16,-2,  , 4, 8, 11,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,   ,     ; #A5DE
        ObjType lS.grape        , #43,  , 1,16,16,-2,  , 5, 8, 12,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,   ,     ; #A61E
        ObjType lS.watermelon   , #44,  , 1,16,16,-2,  , 6, 8, 13,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,   ,     ; #A65E
        ObjType lS.press        , #47,  , 3,24, 8,-1,  ,  , 8, 14,  ,  ,  , 1,  ,  ,  ,  ,  , 2,  ,  ,   ,     ; #A79E
        ObjType lS.hangingMonkey, #44, 2, 3,24,21, 8, 1, 2,16,110,  , 5,  , 1,  ,  ,  ,  ,-2, 2,  ,  , 24,-126 ; #A81C
        ObjType lS.tail         , #44, 4, 3,24,21, 8, 1,  ,  ,111,  ,  ,  ,  ,  ,  ,  ,  ,  ,  , 8,16, 40,  37 ; #AD86
        ObjType lS.flower       , #44, 2, 3,24,21, 3,  , 4,38,112, 1, 3,  ,  ,  , 2,  , 4,-1, 3,  ,  ,   ,     ; #A996
        ObjType lS.block        , #47,  , 3,24,21,-1, 1,  ,  ,113,  , 6,  , 1,  ,  ,  ,  ,-1, 2,16,  , 24,  85 ; #AA92
        ObjType lS.hummingbird  , #C6, 2, 1,16,16, 1,  , 1,  ,114,  , 3,  ,  ,  , 2, 2, 6,-4, 3,  ,  ,   ,     ; #A69E
        ObjType lS.hummingbird  , #47, 2, 1,16,16, 1,  , 1,  ,115,  ,  ,  ,  ,  , 1, 2, 2, 3, 5,  ,  ,   ,     ; #A69E
        ObjType lS.hummingbird  , #44, 2,65,16,16,-1,  ,  ,  ,116,  , 2,  , 1,  ,  ,  ,  ,  , 2,  ,  ,   ,     ; #A69E
        ObjType lS.hummingbird  , #43, 2, 1,16,16,-1,  ,  ,  ,117,  , 3,  , 1,  ,  ,  ,  ,  , 2,  ,  ,   ,     ; #A69E
        ObjType lS.hummingbird  , #47, 2, 1,16,16,-1,  ,  ,  ,118,  ,  ,30,  ,  ,  , 1, 2,-5, 3,  ,  ,   ,     ; #A69E
        ObjType lS.hummingbird  , #46, 2, 1,16,16,-1,  ,  ,  ,119,  ,  ,30,  ,  , 1, 1, 6,-5, 3,  ,  ,   ,     ; #A69E
        ObjType lS.hummingbird  , #44, 2, 1,16,16,-1,  ,  ,  ,120,  ,  ,30,  ,  , 1, 1, 5,-5, 3,  ,  ,   ,     ; #A69E
        ObjType lS.hummingbird  , #45, 2, 1,16,16,-1,  ,  ,  ,121,  ,  ,30,  ,  , 1,  , 4,-5, 3,  ,  ,   ,     ; #A69E
        ObjType lS.hummingbird  , #47, 2, 1,16,16,-1,  ,  ,  ,122,  ,  ,20,  ,  ,  , 3, 2,-5, 3,  ,  ,   ,     ; #A69E
        ObjType lS.hummingbird  , #42, 2, 1,16,16,-1,  ,  ,  ,123,  ,  ,30,  ,  , 2, 2, 6,-5, 3,  ,  ,   ,     ; #A69E
        ObjType lS.hummingbird  , #44, 2, 1,16,16,-1,  ,  ,  ,124,  ,  ,30,  ,  , 2, 2, 5,-5, 3,  ,  ,   ,     ; #A69E
        ObjType lS.hummingbird  , #45, 2, 1,16,16,-1,  ,  ,  ,125,  ,  ,20,  ,  , 3,  , 4,-5, 3,  ,  ,   ,     ; #A69E
        ObjType lS.snake        , #44, 2, 1,16,16, 4,  , 2,  ,126,  ,  ,  ,  ,  , 2,  , 4,-2, 3,  ,  ,   ,     ; #A71E
        ObjType lS.snake        , #42, 2, 1,16,16, 4,  , 2,  ,127,  ,  ,  ,  ,  , 2,  , 4,-1, 3,  ,  ,   ,     ; #A71E
        ObjType lS.chameleon    , #44, 2,67,24,21,-1, 1,  , 4,128, 2,  ,  ,  ,  ,  ,  , 4,  ,  ,40,16,104,  32 ; #AB10
        ObjType lS.chameleon    , #46, 2, 3,24,21,-1, 1,  , 4,129, 2,  ,  ,  ,  ,  ,  , 8,  ,  ,40,16,104,  32 ; #AB10
        ObjType lS.crocodile    , #44,  , 3,24, 8,-1,  ,  , 9,130,  ,  ,  ,  ,  , 1,  , 4,-1, 3,  ,  ,   ,     ; #AC0C
        ObjType lS.porcupine    , #44, 2, 3,24,21,10,  , 5,  ,131,  ,  ,  ,  ,  , 1,  , 4,-1, 3,  ,  ,   ,     ; #AC8A
        ObjType lS.porcupine    , #46, 2, 3,24,21,10, 1, 5,  ,132,  ,  ,  ,  ,  , 3,  , 4,-1, 3,48,  , 88,  21 ; #AC8A
        ObjType lS.porcupine    , #46, 2, 3,24,21,10, 1,  ,  ,132,  ,  ,  ,  ,  , 3,  , 4,-1, 3,48,  , 88,  21 ; #AC8A
        ObjType lS.porcupine    , #46, 2, 3,24,21,10, 1,  ,  ,132,  ,  ,  ,  ,  , 3,  , 4,-1, 3,48,  , 88,  21 ; #AC8A
        ObjType lS.porcupine    , #46, 2, 3,24,21,10, 1,  ,  ,132,  ,  ,  ,  ,  , 3,  , 4,-1, 3,48,  , 88,  21 ; #AC8A
        ObjType lS.porcupine    , #46, 2, 3,24,21,10, 1,  ,  ,132,  ,  ,  ,  ,  , 3,  , 4,-1, 3,48,  , 88,  21 ; #AC8A
        ObjType lS.porcupine    , #46, 2, 3,24,21,10, 1,  ,  ,132,  ,  ,  ,  ,  , 3,  , 4,-1, 3,48,  , 88,  21 ; #AC8A
        ObjType lS.bossTree1    , #46,  , 3,24,21,  ,  ,  ,  ,138, 1,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,   ,     ; #AF7E
        ObjType lS.bossTree3    , #46,  , 3,24,21,  ,  ,  ,  ,139, 1,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,   ,     ; #B07A
        ObjType cS.powerBullet1 , #47,  , 1,16,16,-1,  ,  ,  ,   ,  ,  ,  ,  ,  ,  ,  ,  ,  , 1,  ,  ,   ,     ; #9EEE


    ENDMODULE
