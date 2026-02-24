; Variables used for enemy bullets aimed at the hero
;   length: 19 (ridiculous!)
    STRUCT AimVars

speed   byte
curX    word
curY    word
tgtX    word    ; (unused)
tgtY    word    ; (local)
distX   word
distY   word
dirX    word
dirY    word
phase   word

    ENDS


; Game object
;   length: 50
    STRUCT Obj

x           word    ; x coord in pixels
y           byte    ; y coord in pixels
sprite      word    ; base sprite addr
flags       byte    ; main flags, values of `Flag` enum
walkPhase   byte    ; enemy's walk phase
spriteSet   byte    ; values of `SpriteSet` enum
objType     byte    ; object type with offset
colour      byte    ; object colour attribute
width       byte    ; width in pixels
height      byte    ; height in pixels
health      byte    ; enemy's health
score       byte    ; index 1..6 in `scoreTable`
blinkTime   byte    ; time during which the object will blink
mo          MotionOptions
auxFlags    byte    ; additional flags, values of `Flag` enum
activeZone  Zone    ; still enemy activation zone
aim         AimVars ; variables used for enemy bullets aimed at the hero
stillTime   byte    ; time when enemy stands still
emitBullets byte    ; values of `EmitBullets` enum

    ENDS
