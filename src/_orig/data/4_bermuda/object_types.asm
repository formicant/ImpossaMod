    MODULE Lev4Bermuda


; #B4BB
levObjectTypes:
        ;            spriteAddr       attr 3  4  w  h   7  8  9 10  ot 12 tr 14 15 16 mr 18 19 20 21 22 23  24 25
        ObjTypeDescr lS.skull       , #47,  , 1,16,16, -2,  , 3, 8, 10,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,   ,   ; #A59E
        ObjTypeDescr lS.nose        , #47,  , 1,16,16, -2,  , 4, 8, 11,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,   ,   ; #A5DE
        ObjTypeDescr lS.chest       , #46,  , 1,16,16, -2,  , 5, 8, 12,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,   ,   ; #A61E
        ObjTypeDescr lS.coconut     , #44,  , 1,16,16, -2,  , 6, 8, 13,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,   ,   ; #A65E
        ObjTypeDescr lS.press       , #47,  , 3,24, 8, -1,  ,  , 8, 14,  ,  ,  , 1,  ,  ,  ,  ,  , 2,  ,  ,   ,   ; #A81E
        ObjTypeDescr lS.ufo         , #45,  , 3,24,21, -1,  ,  , 4,203, 1, 8,  , 1,  ,  ,  ,  ,  , 2,  ,  ,   ,   ; #AA16
        ObjTypeDescr lS.pirate      , #47, 2, 3,24,21,  6,  , 2, 4,204,  ,  ,  ,  ,  , 1,  , 4,-2, 3,  ,  ,   ,   ; #AF80
        ObjTypeDescr lS.pirate      , #47, 2, 3,24,21,  6,  , 3, 4,205,  ,  ,  ,  ,  , 1,  , 4,-1, 3,  ,  ,   ,   ; #AF80
        ObjTypeDescr lS.pirate      , #47, 2, 3,24,21,  4,  , 4,  ,206,  ,  ,  ,  ,  , 2,  , 4,-2, 3,  ,  ,   ,   ; #AF80
        ObjTypeDescr lS.pirate      , #47, 2, 3,24,21,  4,  , 4,  ,207,  ,  ,  ,  ,  , 2,  , 4,-1, 3,  ,  ,   ,   ; #AF80
        ObjTypeDescr lS.canon       , #47,  , 3,24,17, -1,  ,  , 5,208, 2,  ,  ,  ,  ,  ,  , 4,  ,  ,  ,  ,   ,   ; #AA94
        ObjTypeDescr lS.canon       , #47,  , 3,24,17, -1,  ,  , 5,209, 2,  ,  ,  ,  ,  ,  , 8,  ,  ,  ,  ,   ,   ; #AA94
        ObjTypeDescr lS.parrot      , #47, 3, 1,16,16,  1,  , 2,32,210,  , 3,  ,  ,  , 2, 2, 6,-4, 3,  ,  ,   ,   ; #A69E
        ObjTypeDescr lS.parrot      , #47, 3, 1,16,16, -1,  , 2,  ,211,  ,  ,30,  ,  ,  , 1, 2,-5, 3,  ,  ,   ,   ; #A69E
        ObjTypeDescr lS.parrot      , #47, 3, 1,16,16, -1,  , 2,  ,212,  ,  ,30,  ,  , 1, 1, 6,-5, 3,  ,  ,   ,   ; #A69E
        ObjTypeDescr lS.parrot      , #47, 3, 1,16,16, -1,  , 2,  ,213,  ,  ,30,  ,  , 1, 1, 5,-5, 3,  ,  ,   ,   ; #A69E
        ObjTypeDescr lS.parrot      , #47, 3, 1,16,16, -1,  , 2,  ,214,  ,  ,30,  ,  , 1,  , 4,-5, 3,  ,  ,   ,   ; #A69E
        ObjTypeDescr lS.parrot      , #47, 3, 1,16,16, -1,  , 2,  ,215,  ,  ,20,  ,  ,  , 3, 2,-5, 3,  ,  ,   ,   ; #A69E
        ObjTypeDescr lS.parrot      , #47, 3, 1,16,16, -1,  , 2,  ,216,  ,  ,30,  ,  , 2, 2, 6,-5, 3,  ,  ,   ,   ; #A69E
        ObjTypeDescr lS.parrot      , #47, 3, 1,16,16, -1,  , 2,  ,217,  ,  ,30,  ,  , 2, 2, 5,-5, 3,  ,  ,   ,   ; #A69E
        ObjTypeDescr lS.parrot      , #47, 3, 1,16,16, -1,  , 2, 4,218,  ,  ,20,  ,  , 3,  , 4,-5, 3,  ,  ,   ,   ; #A69E
        ObjTypeDescr lS.tornado     , #47, 2, 1,16,16, -1,  ,  ,32,219,  , 2,  ,  ,  , 2,  , 4,-2, 3,  ,  ,   ,   ; #A75E
        ObjTypeDescr lS.barrel      , #44,  , 3,24,21, -1,  ,  ,  ,220,  ,  ,  ,  ,  , 3,  , 4,-2, 3,  ,  ,   ,   ; #A91A
        ObjTypeDescr lS.barrel      , #44,  , 3,24,21, -1, 1,  ,  ,221,  ,  ,  ,  ,  , 3,  , 4,-1, 3,  ,  ,   ,   ; #A91A
        ObjTypeDescr lS.ghost       , #47, 2, 3,24,21,  1,  ,  ,  ,222,  ,  ,  ,  ,  , 1, 2, 2, 3, 5,  ,  ,   ,   ; #AD88
        ObjTypeDescr lS.ghost       , #47, 2, 3,24,21,  1,  ,  ,  ,223,  ,  ,  ,  ,  ,  , 2, 2, 1, 5,  ,  ,   ,   ; #AD88
        ObjTypeDescr lS.ghost       , #47, 2, 3,24,21,  1, 1,  ,  ,224,  , 7,  , 1,  ,  ,  ,  ,  , 2,  ,64, 40,85 ; #AD88
        ObjTypeDescr lS.lamp        , #46,  , 1,16,16, -1, 1,  , 4,225,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,16,16, 54,32 ; #A7DE
        ObjTypeDescr lS.lamp        , #46,  , 1,16,16, -1, 1,  ,  ,226,  , 2,  , 1,  ,  ,  ,  ,  , 2,48,16,118,16 ; #A7DE
        ObjTypeDescr lS.pilot       , #47, 2, 3,24,21, 20,  , 4,16,227,  ,  ,  ,  ,  , 2,  , 4,-1, 3,  ,  ,   ,   ; #AC8C
        ObjTypeDescr lS.dinosaur    , #46, 2, 3,24,21,  7,  , 3,32,228,  , 2,  ,  ,  , 2,  , 4,-2, 3,  ,  ,   ,   ; #AE84
        ObjTypeDescr lS.airplane    , #47, 4, 3,24,21, -1,  ,  ,  ,229,  , 9,  , 1,  , 3,  , 4,  , 4,  ,  ,   ,   ; #AB12
        ObjTypeDescr lS.airplane    , #45, 4, 3,24,21, -1,  ,  ,  ,230,  ,  ,  ,  ,  , 3, 1, 6,  , 3,  ,  ,   ,   ; #AB12
        ObjTypeDescr lS.airplane    , #47, 4, 3,24,21, -1,  ,  ,  ,231,  ,  ,  ,  ,  , 3, 1, 5,  , 3,  ,  ,   ,   ; #AB12
        ObjTypeDescr lS.boat        , #44,  , 3,24,10, -2, 1,  , 9,232,  , 3,  , 1,  ,  ,  ,  ,  , 2,  , 1, 24, 9 ; #A89C
        ObjTypeDescr lS.sabre       , #47,  , 3,24, 4, -2, 1,  , 9,233,  , 4,  , 1,  ,  ,  ,  ,  , 2,  , 1, 24, 6 ; #A998
        ObjTypeDescr lS.sabre       , #47,  , 3,24, 4, -2, 1,  , 9,234,  , 5,  , 1,  ,  ,  ,  ,  , 2,  , 1, 24, 6 ; #A998
        ObjTypeDescr lS.sabre       , #47,  , 3,24, 4, -2, 1,  , 9,235,  , 6,  , 1,  ,  ,  ,  ,  , 2,  , 1, 24, 6 ; #A998
        ObjTypeDescr cS.powerBullet1, #47,  , 1,16,16, -1,  ,  ,  ,   ,  ,  ,  ,  ,  ,  , 4, 2,-3, 3,  ,  ,   ,   ; #9EEE
        ObjTypeDescr cS.powerBullet1, #47,  , 1,16,16, -1,  ,  ,  ,   ,  ,  ,  ,  ,  ,  , 4, 2,-3, 3,  ,  ,   ,   ; #9EEE
        ObjTypeDescr cS.powerBullet1, #47,  , 1,16,16, -1,  ,  ,  ,   ,  ,  ,  ,  ,  ,  , 4, 2,-3, 3,  ,  ,   ,   ; #9EEE
        ObjTypeDescr cS.powerBullet1, #47,  , 1,16,16, -1,  ,  ,  ,   ,  ,  ,  ,  ,  ,  , 4, 2,-3, 3,  ,  ,   ,   ; #9EEE
        ObjTypeDescr cS.powerBullet1, #47,  , 1,16,16, -1,  ,  ,  ,   ,  ,  ,  ,  ,  ,  , 4, 2,-3, 3,  ,  ,   ,   ; #9EEE
        ObjTypeDescr cS.powerBullet1, #47,  , 1,16,16, -1,  ,  ,  ,   ,  ,  ,  ,  ,  ,  , 4, 2,-3, 3,  ,  ,   ,   ; #9EEE
        ObjTypeDescr cS.powerBullet1, #47,  , 1,16,16, -1,  ,  ,  ,   ,  ,  ,  ,  ,  ,  , 4, 2,-3, 3,  ,  ,   ,   ; #9EEE
        ObjTypeDescr cS.powerBullet1, #47,  , 1,16,16, -1,  ,  ,  ,   ,  ,  ,  ,  ,  ,  , 4, 2,-3, 3,  ,  ,   ,   ; #9EEE
        ObjTypeDescr lS.bossTornado1, #47, 2, 3,24,21,-17,  ,  ,  ,237, 1,10,  ,  ,  ,  ,  ,  ,  , 2,  ,  ,   ,   ; #B07C
        ObjTypeDescr lS.bossTornado3, #47, 2, 3,24,21,-17,  ,  ,  ,238,  ,10,  ,  ,  ,  ,  ,  ,  , 2,  ,  ,   ,   ; #B178


    ENDMODULE
