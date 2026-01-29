    MODULE Lev3Iceland


; #B4BB
levObjectTypes:
        ;       spriteAddr        attr 3  4  w  h   7  8  9 10  ot 12 tr 14 15 16 mr 18 19 20 21 22 23   24  25
        ObjType lS.iceCream     , #47,  , 1,16,16, -2,  , 3, 8, 10,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,    ,    ; #A59E
        ObjType lS.icePop       , #42,  , 1,16,16, -2,  , 4, 8, 11,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,    ,    ; #A5DE
        ObjType lS.snowman      , #47,  , 1,16,16, -2,  , 5, 8, 12,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,    ,    ; #A61E
        ObjType lS.sundae       , #47,  , 1,16,16, -2,  , 6, 8, 13,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,    ,    ; #A65E
        ObjType lS.pressPlatform, #47,  , 3,24, 8, -1,  ,  , 8, 14,  ,  ,  , 1,  ,  ,  ,  ,  , 2,  ,  ,    ,    ; #A81E
        ObjType lS.bullfinch    , #47, 2, 1,16,16,  1,  , 1,32,151,  , 3,  ,  ,  , 2, 2, 6,-4, 3,  ,  ,    ,    ; #A69E
        ObjType lS.bullfinch    , #47, 2, 1,16,16,  1,  , 1,  ,152,  ,  ,  ,  ,  , 1, 2, 2, 3, 5,  ,  ,    ,    ; #A69E
        ObjType lS.bullfinch    , #47, 2, 1,16,16, -1,  , 1,  ,153,  ,  ,30,  ,  ,  , 1, 2,-5, 3,  ,  ,    ,    ; #A69E
        ObjType lS.bullfinch    , #47, 2, 1,16,16, -1,  , 1,  ,154,  ,  ,30,  ,  , 1, 1, 6,-5, 3,  ,  ,    ,    ; #A69E
        ObjType lS.bullfinch    , #47, 2, 1,16,16, -1,  , 1,  ,155,  ,  ,30,  ,  , 1, 1, 5,-5, 3,  ,  ,    ,    ; #A69E
        ObjType lS.bullfinch    , #47, 2, 1,16,16, -1,  , 1,  ,156,  ,  ,30,  ,  , 1,  , 4,-5, 3,  ,  ,    ,    ; #A69E
        ObjType lS.bullfinch    , #47, 2, 1,16,16, -1,  , 1,  ,157,  ,  ,20,  ,  ,  , 3, 2,-5, 3,  ,  ,    ,    ; #A69E
        ObjType lS.bullfinch    , #47, 2, 1,16,16, -1,  , 1,  ,158,  ,  ,30,  ,  , 2, 2, 6,-5, 3,  ,  ,    ,    ; #A69E
        ObjType lS.bullfinch    , #47, 2, 1,16,16, -1,  , 1,  ,159,  ,  ,30,  ,  , 2, 2, 5,-5, 3,  ,  ,    ,    ; #A69E
        ObjType lS.bullfinch    , #47, 2, 1,16,16, -1,  , 1,  ,160,  ,  ,20,  ,  , 3,  , 4,-5, 3,  ,  ,    ,    ; #A69E
        ObjType lS.snowOwl      , #47, 2, 3,24,21,  3,  , 3,32,161,  , 2,  ,  ,  , 2,  , 4,-2, 3,  ,  ,    ,    ; #A89C
        ObjType lS.snowOwl      , #47, 2, 3,24,21,  3,  , 1,32,162,  , 2,  ,  ,  , 2,  , 4,-1, 3,  ,  ,    ,    ; #A89C
        ObjType lS.snowBall     , #47, 2, 3,24,21, -2,  ,  ,  ,163,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,64,16,-104, 37 ; #AFFE
        ObjType lS.snowBall     , #47, 2, 3,24,21, -1,  ,  ,  ,164,  ,  ,  ,  ,  , 4,  , 4,-2, 3,  ,  ,    ,    ; #AFFE
        ObjType lS.snowBall     , #47, 2, 3,24,21, -1, 1,  ,  ,165,  ,  ,  ,  ,  , 4,  , 4,-2, 3,  ,  ,  24,100 ; #AFFE
        ObjType lS.santa        , #47,  , 3,24,21,  2,  ,  ,  ,166,  ,  ,  ,  ,  , 3,  , 4,-2, 3,  ,  ,    ,    ; #AA94
        ObjType lS.inuit        , #47, 2, 3,24,21,  9,  , 8, 4,167, 2,  ,  ,  ,  , 2,  , 4,-2, 3,  ,  ,    ,    ; #AB12
        ObjType lS.inuit        , #45, 2, 3,24,21,  9,  , 4, 4,168, 2,  ,  ,  ,  , 2,  , 4,-1, 3,  ,  ,    ,    ; #AB12
        ObjType lS.piranha      , #47, 2, 1,16,16, -1,  ,  ,  ,169,  , 3,  , 1,  ,  ,  ,  ,  , 2,  ,  ,    ,    ; #A79E
        ObjType lS.piranha      , #44, 2, 1,16,16, -1,  ,  ,  ,170,  , 4,  , 1,  ,  ,  ,  ,  , 2,  ,  ,    ,    ; #A79E
        ObjType lS.penguin      , #47, 2, 1,16,16,  1,  , 1,  ,171,  ,  ,  ,  ,  , 1,  , 4,-2, 3,  ,  ,    ,    ; #A71E
        ObjType lS.penguin      , #47, 2, 1,16,16,  1,  , 1,  ,172,  ,  ,  ,  ,  , 1,  , 4,-1, 3,  ,  ,    ,    ; #A71E
        ObjType lS.icicle       , #47,  , 3, 4,21, -1, 1,  ,  ,173,  , 2,  , 1,  ,  ,  ,  ,-2, 2,  ,  ,  10, 85 ; #AD0A
        ObjType lS.viking       , #47, 2, 3,24,21,  5,  , 3, 4,174, 2,  ,  ,  ,  , 2,  , 4,-2, 3,  ,  ,    ,    ; #AC0E
        ObjType lS.viking       , #47, 2, 3,24,21,  5,  , 2, 4,175, 2,  ,  ,  ,  , 2,  , 4,-1, 3,  ,  ,    ,    ; #AC0E
        ObjType lS.polarBear    , #47, 2, 3,24,21, 15,  , 2,50,176,  , 2,  ,  ,  , 1,  , 4,-1, 3,  ,  ,    ,    ; #AD88
        ObjType lS.fountain     , #47, 2, 3,24,21, -2,  ,  , 8,177,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,    ,    ; #AE84
        ObjType lS.fountain     , #47, 2, 3,24,21, -2,  ,  , 9,178,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,    ,    ; #AE84
        ObjType lS.pressPlatform, #47,  , 3,24, 8, -2,  ,  , 9,179,  , 6,  , 1,  ,  ,  ,  ,  , 2,  ,  ,    ,    ; #A81E
        ObjType lS.pressPlatform, #47,  , 3,24, 8, -2, 1,  , 9,180,  , 5,  , 1,  ,  ,  ,  ,  , 2,  , 1,  24, 10 ; #A81E
        ObjType lS.cableCar     , #47, 2, 3,24,21, -2,  ,  , 9,181,  , 7,  , 1,  ,  ,  ,  ,  , 2,  ,  ,    ,    ; #A998
        ObjType lS.cableCar     , #43, 2, 3,24,21, -2,  ,  , 9,182,  , 8,  , 1,  ,  ,  ,  ,  , 2,  ,  ,    ,    ; #A998
        ObjType lS.iceCube      , #47,  , 3,24,21, -1, 1,  ,  ,183,  , 2,  , 1,  ,  ,  ,  ,-1, 2,  ,  ,  24, 85 ; #AF80
        ObjType cS.powerBullet1 , #47,  , 1,16,16, -1,  ,  ,  ,184,  ,  ,  ,  ,  ,  ,  ,  ,  , 1,  ,  ,    ,    ; #9EEE
        ObjType cS.powerBullet1 , #47,  , 1,16,16, -1,  ,  ,  ,185,  ,  ,  ,  ,  ,  ,  ,  ,  , 1,  ,  ,    ,    ; #9EEE
        ObjType cS.powerBullet1 , #47,  , 1,16,16, -1,  ,  ,  ,186,  ,  ,  ,  ,  ,  ,  ,  ,  , 1,  ,  ,    ,    ; #9EEE
        ObjType cS.powerBullet1 , #47,  , 1,16,16, -1,  ,  ,  ,187,  ,  ,  ,  ,  ,  ,  ,  ,  , 1,  ,  ,    ,    ; #9EEE
        ObjType cS.powerBullet1 , #47,  , 1,16,16, -1,  ,  ,  ,188,  ,  ,  ,  ,  ,  ,  ,  ,  , 1,  ,  ,    ,    ; #9EEE
        ObjType cS.powerBullet1 , #47,  , 1,16,16, -1,  ,  ,  ,189,  ,  ,  ,  ,  ,  ,  ,  ,  , 1,  ,  ,    ,    ; #9EEE
        ObjType cS.powerBullet1 , #47,  , 1,16,16, -1,  ,  ,  ,190,  ,  ,  ,  ,  ,  ,  ,  ,  , 1,  ,  ,    ,    ; #9EEE
        ObjType lS.bossIceCream1, #47,  , 3,24,21,-17,  ,  ,12,191, 1, 9,  , 1,  , 1,  , 4,  , 4,  ,  ,    ,    ; #B0FA
        ObjType lS.bossIceCream2, #47,  , 3,24,21,-17,  ,  , 8,192, 4, 9,  , 1,  , 1,  , 4,  , 4,  ,  ,    ,    ; #B178


    ENDMODULE
