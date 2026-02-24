    MODULE ObjType

; common object types
hero        EQU -1
bullet      EQU  0
shatterbomb EQU  1
powerGun    EQU  2
laserGun    EQU  3
soupCan     EQU  4
slimyWorms  EQU  5
coin        EQU  6
pintaADay   EQU  7
diary       EQU  8
shopMole    EQU  9
scoreItem1  EQU 10
scoreItem2  EQU 11
scoreItem3  EQU 12
scoreItem4  EQU 13
pressPlatf  EQU 14  ; press or platform

; level-specific object types

klondike
.dynamite1      EQU  15
.dynamite2      EQU  16
.emptyMineCart  EQU  17
.fullMineCart   EQU  18
.stalactite     EQU  40
.bossBurrow     EQU 51
.boss           EQU  53

orient
.boss           EQU  94

amazon
.hangingMonkey  EQU 110
.crocodile      EQU 130
.boss           EQU 138

iceland
.snowBall1      EQU 163
.boss           EQU 191

bermuda
.boss           EQU 237

    ENDMODULE


    MODULE ObjTypeOffset

klondike    EQU 0
orient      EQU 49
amazon      EQU 95
iceland     EQU 136
bermuda     EQU 188

    ENDMODULE


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
