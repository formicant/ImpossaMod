    MODULE State


; Game state variables
start:

screenX:    dw -0       ; x coord of the left screen edge in the map
mapSpanEnd: dw -0       ; x coord of the current map span right limit - 32
advance:    db -0       ; advance in map
coins:      db -0       ; 0, 25, …, 250
coinDigits: block 3     ; 3 decimal digits in ascii
soupCans:   db -0       ; 1..3
energy:     db -0       ; 0..34
maxEnergy:  db -0       ; 18, 22, 26, 30, 34
energyText: block 17    ; characters representing energy indicator bars
level:      db -0       ; 0..4
isDead:     db -0       ; 0|#FF
hasDiary:   db -0
hasSmart:   db -0       ; 0|1
levelsDone: block 5     ; 0|1 for each level
jumpPhase:       db -0       ; jump phase (?)
heroState:  db -0       ; values of `HeroState` enum
tileTopL:   db -0       ;
tileMidL:   db -0       ;      AL       AR
tileBotL:   db -0       ; ┌───TL─────────TR──────┐
tileUndrL:  db -0       ; │                      │
tileTopR:   db -0       ; │                      │
tileMidR:   db -0       ; │   ML         MR      │
tileBotR:   db -0       ; │                      │
tileUndrR:  db -0       ; │          Ce          │
tileFootL:  db -0       ; │   BL         BR      │
tileFootR:  db -0       ; │                      │
tileCentre: db -0       ; └──────────────────────┘
tileFootC:  db -0       ;      FL    FC FR
tileAbovL:  db -0       ;     UL         UR
tileAbovR:  db -0       ;
jumpVel:    db -0       ; signed jump vertical velocity
recoilDir:  db -0
recoilTime: db -0
weaponTime: dw -0
weapon:     db -0       ; 0..4
attack:     db -0       ; values of `Attack` enum
attackTime: db -0
s_3F:       db -0
s_40:       db -0
stepPeriod: db -0       ; time between walk phases
stepTime:   db -0       ; time elapsed since last step
tmpY:       db -0       ; y coord is saved here temporarily during transit check
tmpJumpPh:  db -0       ; (loc) jumpPhase is stored here temporarily
pressTime:  db -0       ; time during which the hero is small after a press
inShop:     db -0       ; 0: not in shop, #FF: entering shop, #7F in shop
shopItem:   db -0       ; active item in the shop (objType - 1)
shopPrice:  db -0       ; active item price in the shop
tTypeTop:   db -0
tTypeBot:   db -0
tTypeLeft:  db -0
tTypeRight: db -0
tTypeBotL:  db -0
tTypeBotR:  db -0
trajVel:    db -0       ; (loc) object's current trajectory velocity
trajDir:    db -0       ; (loc) object's current trajectory direction (in untransformed format)
bulletTime: db -0       ; enemy bullet emission timer
nextObject: dw -0       ; addr of the next object in level object table
bossFight:  db -0       ; 0 if no boss, 1 or higher when fighting a boss
bossHealth: db -0
bossInvinc: db -0       ; boss is invincible
bossKilled: db -0
s_58:       db -0
s_59:       db -0
conveyors:  block 48    ; 16 × 3 (addr, length)

length  EQU $ - start

loadedLevel:   db -0


    ENDMODULE
