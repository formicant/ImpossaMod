    MODULE Lev1Orient


; #B4BB
levObjectTypes:
        ;       spriteAddr        attr 3  4  w  h  7  8  9 10  ot 12 tr 14 15 16 mr 18 19 20 21 22  23  24 25
        ObjType lS.cup          , #45,  , 1,16,16,-2,  , 3, 8, 10,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,   ,   ,   ; #A59E
        ObjType lS.figurine     , #46,  , 1,16,16,-2,  , 4, 8, 11,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,   ,   ,   ; #A5DE
        ObjType lS.umbrella     , #45,  , 1,16,16,-2,  , 5, 8, 12,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,   ,   ,   ; #A61E
        ObjType lS.pepper       , #47,  , 1,16,16,-2,  , 6, 8, 13,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,   ,   ,   ; #A65E
        ObjType lS.platform     , #46,  , 3,24, 8,-1,  ,  , 8, 14,  ,  ,  , 1,  ,  ,  ,  ,  , 2,  ,   ,   ,   ; #AD0A
        ObjType lS.panda        , #44,  ,67,24,21,-1,  ,  ,  , 64, 2,  ,  ,  ,  ,  ,  , 4,  ,  ,  ,   ,   ,   ; #A81E
        ObjType lS.panda        , #45,  , 3,24,21,-1,  ,  ,  , 65, 2,  ,  ,  ,  ,  ,  , 8,  ,  ,  ,   ,   ,   ; #A81E
        ObjType lS.headOverHeels, #47, 4, 3,24,21,-1, 1,  ,  , 66,  ,  ,  ,  ,  , 2,  , 4,-2, 3,40,   ,104,21 ; #A89C
        ObjType lS.headOverHeels, #47, 4, 3,24,21,-1, 1,  ,  , 67,  ,  ,  ,  ,  , 2,  , 4,-1, 3,40,   ,104,21 ; #A89C
        ObjType lS.ninja        , #47, 2, 3,24,21, 8,  , 4,  , 68, 2,  ,  ,  ,  , 2,  , 4,-1, 3,  ,   ,   ,   ; #AA94
        ObjType lS.karateist    , #46, 2, 3,24,21, 3,  , 2,  , 69,  ,  ,  ,  ,  , 2,  , 4,-2, 3,  ,   ,   ,   ; #AB90
        ObjType lS.karateist    , #46, 2, 3,24,21, 3,  , 3,  , 70,  ,  ,  ,  ,  , 2,  , 4,-1, 3,  ,   ,   ,   ; #AB90
        ObjType lS.cloud        , #47,  , 3,24,21,-2, 1,  ,  , 71, 4, 4,  , 1, 4,  ,  ,  ,  , 2,16,-16, 56,52 ; #AC8C
        ObjType lS.cloud        , #47,  , 3,24,21,-2, 1,  ,  , 72, 4, 5,  , 1,  ,  ,  ,  ,  , 2,16,-16, 56,52 ; #AC8C
        ObjType lS.hatMan       , #46, 2, 3,24,21,12,  , 1,50, 73,  , 2,  ,  ,  , 1,  , 4,-1, 3,  ,   ,   ,   ; #AE84
        ObjType lS.photographer , #47, 2, 3,24,21,-1,  ,  ,36, 74, 1, 2,  ,  ,  , 1,  , 4,-1, 3,  ,   ,   ,   ; #AD88
        ObjType lS.paperBird    , #43, 2, 1,16,16, 1,  , 1,32, 75,  , 3,  ,  ,  , 2, 2, 6,-4, 3,  ,   ,   ,   ; #A69E
        ObjType lS.paperBird    , #47, 2, 1,16,16, 1,  , 1,  , 76,  ,  ,  ,  ,  , 2, 2,  , 3, 5,  ,   ,   ,   ; #A69E
        ObjType lS.paperBird    , #44, 2, 1,16,16, 3,  , 5,  , 77,  , 6,  , 1,  , 2,  , 4,  , 4,  ,   ,   ,   ; #A69E
        ObjType lS.paperBird    , #45, 2, 1,16,16,-1,  , 1,  , 78,  ,  ,30,  ,  ,  , 1, 2,-5, 3,  ,   ,   ,   ; #A69E
        ObjType lS.paperBird    , #46, 2, 1,16,16,-1,  , 1,  , 79,  ,  ,30,  ,  , 1, 1, 6,-5, 3,  ,   ,   ,   ; #A69E
        ObjType lS.paperBird    , #47, 2, 1,16,16,-1,  , 1,  , 80,  ,  ,30,  ,  , 1, 1, 5,-5, 3,  ,   ,   ,   ; #A69E
        ObjType lS.paperBird    , #47, 2, 1,16,16,-1,  , 1,  , 81,  ,  ,30,  ,  , 1,  , 4,-5, 3,  ,   ,   ,   ; #A69E
        ObjType lS.paperBird    , #47, 2, 1,16,16,-1,  , 1,  , 82,  ,  ,20,  ,  ,  , 3, 2,-5, 3,  ,   ,   ,   ; #A69E
        ObjType lS.paperBird    , #43, 2, 1,16,16,-1,  , 1,  , 83,  ,  ,30,  ,  , 2, 2, 6,-5, 3,  ,   ,   ,   ; #A69E
        ObjType lS.paperBird    , #45, 2, 1,16,16,-1,  , 1,  , 84,  ,  ,30,  ,  , 2, 2, 5,-5, 3,  ,   ,   ,   ; #A69E
        ObjType lS.paperBird    , #44, 2, 1,16,16,-1,  , 1,  , 85,  ,  ,20,  ,  , 3,  , 4,-5, 3,  ,   ,   ,   ; #A69E
        ObjType lS.safe         , #47, 4, 1,16,16,15,  , 4,  , 85,  ,  ,  ,  ,  , 2,  , 4,-2, 3,  ,   ,   ,   ; #A71E
        ObjType lS.safe         , #47, 4, 1,16,16,15,  , 3,32, 85,  , 2,  ,  ,  , 2,  , 4,-1, 3,  ,   ,   ,   ; #A71E
        ObjType lS.sumoist      , #47, 2,67,24,21, 8, 1, 1,  , 88,  , 7,  , 1,  ,  ,  ,  ,  , 2,16,   , 24,21 ; #AF80
        ObjType lS.sumoist      , #47, 2,67,24,21, 8, 1, 3,  , 88,  , 7,  , 1,  ,  ,  ,  ,  , 2,16,   , 24,21 ; #AF80
        ObjType lS.sumoist      , #46, 2,67,24,21, 8, 1,  ,  , 88,  , 8,  , 1,  ,  ,  ,  ,-2, 2, 8,-32,  8,53 ; #AF80
        ObjType lS.platform     , #46,  , 3,24, 8,-2,  ,  , 9, 90,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,   ,   ,   ; #AD0A
        ObjType lS.platform     , #46,  , 3,24, 8,-2, 1,  , 9, 91,  , 3,  , 1,  ,  ,  ,  ,  , 2,  ,  1, 24,10 ; #AD0A
        ObjType lS.platform     , #46,  , 3,24, 8,-2,  ,  , 9, 92,  , 2,  , 1,  ,  ,  ,  ,  , 2,  ,   ,   ,   ; #AD0A
        ObjType cS.powerBullet1 , #47,  , 1,16,16,-2,  ,  ,  , 93,  ,  ,  ,  ,  ,  ,  ,  ,  , 1,  ,   ,   ,   ; #9EEE
        ObjType cS.powerBullet1 , #47,  , 1,16,16,-2,  ,  ,  , 93,  ,  ,  ,  ,  ,  ,  ,  ,  , 1,  ,   ,   ,   ; #9EEE
        ObjType cS.powerBullet1 , #47,  , 1,16,16,-2,  ,  ,  , 93,  ,  ,  ,  ,  ,  ,  ,  ,  , 1,  ,   ,   ,   ; #9EEE
        ObjType cS.powerBullet1 , #47,  , 1,16,16,-2,  ,  ,  , 93,  ,  ,  ,  ,  ,  ,  ,  ,  , 1,  ,   ,   ,   ; #9EEE
        ObjType cS.powerBullet1 , #47,  , 1,16,16,-2,  ,  ,  , 93,  ,  ,  ,  ,  ,  ,  ,  ,  , 1,  ,   ,   ,   ; #9EEE
        ObjType lS.bossDragon2  , #44,  , 3,24,21,  ,  ,  ,  , 94, 1,  ,  ,  ,  , 2, 2, 6,  , 3,  ,   ,   ,   ; #B0FA
        ObjType lS.bossDragon1  , #44,  , 3,24,21,  ,  ,  ,  , 95,  ,  ,  ,  ,  , 2, 2, 6,  , 3,  ,   ,   ,   ; #B07C
        ObjType lS.bossDragon4  , #44,  , 3,24,21,  ,  ,  ,  , 96,  ,  ,  ,  ,  , 2, 2, 6,  , 3,  ,   ,   ,   ; #B1F6
        ObjType lS.bossDragon3  , #44,  , 3,24,21,  ,  ,  ,  , 97,  ,  ,  ,  ,  , 2, 2, 6,  , 3,  ,   ,   ,   ; #B178


    ENDMODULE
