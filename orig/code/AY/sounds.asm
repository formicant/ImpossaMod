    MODULE AY

; Game sound effects (15 × 13 bytes)
aySounds:  ; #c5d4
        ;        env  dec sus  rel envP  ?  viP  viS  flag   period dur
        Effect { #7F, -23, 1,  -1, #7F, #00, 0,  163, %001 }, 1498,  1  ; (unused)
        Effect { #1B,  -1, 1,  -1, #50, #00, 0,    1, %001 },   47,  1  ; (unused)
        Effect { #7F, -23, 1,  -1, #7F, #00, 0, -215, %001 },  846,  1  ; (unused)
        Effect { #08, -14, 1,  -7, #6B, #FF, 0,    0, %101 }, 3900,  2  ; damageEnemy
        Effect { #0E, -14, 1,  -7, #29, #FF, 0,    0, %010 },   88,  1  ; kickOrThrow
        Effect { #7F,  -4, 1,  -1, #44, #00, 0,  -20, %001 }, 2154,  1  ; jump
        Effect { #7F,  -3, 1,  -1, #60, #00, 0, -256, %010 },  240,  1  ; killEnemy
        Effect { #0C,   0, 0,   0, #71, #00, 0,  156, %101 }, 4027, 15  ; (unused)
        Effect { #0A,  -6, 1, -10, #00, #00, 0,   -1, %101 },   35, 28  ; laserGun
        Effect { #14, -20, 1,  -1, #7F, #01, 0,    0, %010 },  124, 10  ; (unused)
        Effect { #7F,  -3, 1,  -1, #7F, #04, 0,  -32, %001 }, 2413,  1  ; powerGun
        Effect { #7F,  -6, 1,  -1, #7F, #00, 0,  -14, %001 },  637,  1  ; pickItem
        Effect { #7F, -10, 1,  -1, #7F, #00, 0,    0, %001 }, 3460,  1  ; energyLoss
        Effect { #7F,  -7, 1,  -1, #7F, #00, 0,    0, %001 },  200,  1  ; pickWeapon
        Effect { #7F,  -3, 8, -35, #7E, #00, 0, -803, %001 }, 1010,  1  ; (unused)

    ENDMODULE
