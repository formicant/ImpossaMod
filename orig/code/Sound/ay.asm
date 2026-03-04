    MODULE AY


; Copied to RAM page 1 #C000

scorePart0:
        db Note.instrument|0
        dh 2C 30 2D 30 2C 30 31 30 2C 30 2D 30 2C 30 25 30
        db Note.end

scorePart1:
        dh 7F 30
        db Note.end

scorePart2:
        db Note.instrument|0
        dh 91 1C 30 92 20 30 1F 30 22 30 20 30 93 23 30 22 30 94 27 30 90
        db Note.end

scorePart3:
        db Note.instrument|1
        dh 01 18 01 18
        db Note.end

scorePart4:
        db Note.instrument|1
        dh 01 18 01 18 01 18 01 18 01 18 01 18 01 0C 01 0C 01 0C 01 0C 01 18 01 18 01 18 01 18 01 18 01 18 01 0C 01 0C 01 0C 01 0C
        db Note.end

scorePart5:
        db Note.instrument|2
        dh 12 06 36 06 1E 06 2A 06 12 06 36 06 1E 06 2A 06 12 06 36 06 1E 06 2A 06 12 06 36 06 1E 06 2A 06 12 06 36 06 1E 06 2A 06 12 06 36 06 1E 06 2A 06 12 06 36 06 1E 06 2A 06 12 06 36 06 1E 06 2A 06 12 06 36 06 1E 06 2A 06 12 06 36 06 1E 06 2A 06 12 06 36 06 1E 06 2A 06 12 06 36 06 1E 06 2A 06 12 06 36 06 1E 06 2A 06 12 06 36 06 1E 06 12 06 12 06 12 06 12 0C 12 0C 12 06 12 06
        db Note.end

scorePart6:
        db Note.instrument|1
        dh 91 23 12 23 12 23 12 92 27 12 27 0C 27 0C 29 12 29 12 29 12 22 12 22 0C 22 0C 90
        db Note.end

scorePart7:
        db Note.instrument|1
        dh 0D 06 0D 06 0D 0C 0D 0C 0D 06 0D 0C 0D 0C 0D 06 08 0C 0B 0C
        db Note.end

scorePart8:
        db Note.instrument|1
        dh 10 06 10 06 10 0C 10 0C 10 06 10 06 0B 06 0B 06 0B 0C 0B 0C 0B 06 0B 06
        db Note.end

scorePart9:
        db Note.instrument|1
        dh 0D 06 19 0C 0D 06 19 0C 0D 06 19 0C 0D 06 19 0C 0B 0C 08 0C
        db Note.end

scorePart10:
        db Note.instrument|1
        dh 0D 06 0D 06 0D 0C 0D 12 0D 0C 0D 06 0D 0C 0D 0C 19 06 19 06
        db Note.end

scorePart11:
        db Note.instrument|1
        dh 10 06 10 06 10 0C 10 0C 10 06 10 06 0B 06 0B 06 0B 0C 0B 0C 0B 06 0B 06
        db Note.end

scorePart12:
        db Note.instrument|1
        dh 0D 06 0D 06 19 0C 0D 0C 19 06 0D 0C 0D 06 19 0C 0D 0C 19 0C 09 06 09 06 15 0C 09 0C 15 06 0B 0C 0B 06 17 0C 0B 0C 17 0C 0D 06 0D 06 19 0C 0D 0C 19 06 0D 0C 0D 06 19 0C 0D 0C 19 0C 10 06 10 06 1C 0C 10 0C 1C 06 0B 0C 0B 06 17 0C 0B 0C 17 0C
        db Note.end

scorePart13:
        db Note.instrument|1
        dh 0D 06 0D 0C 0D 06 0D 0C 0D 06 0D 12 0B 0C 10 0C 0B 0C 09 06 09 0C 09 0C 09 0C 09 06 0B 0C 08 0C 0B 0C 0D 0C
        db Note.end

scorePart14:
        db Note.instrument|3
        dh 2A 0C 2A 0C 1E 0C 2A 0C 2A 06 2A 0C 2A 06 1E 0C 1E 0C 2A 0C 2A 0C 1E 12 2A 0C 2A 06 2A 06 2A 06 1E 06 12 06 06 06 06 06 06 0C 06 0C 2A 0C 1E 0C 1E 0C 2A 0C 1E 0C 2A 0C 1E 0C 1E 0C 2A 0C 2A 06 2A 06 2A 06 36 06 36 06 2A 06 1E 06 12 06 06 06 06 06
        db Note.end

scorePart15:
        db Note.instrument|4
        dh 19 0C 20 06 20 06 1F 0C 20 0C 25 0C 24 0C 25 0C 27 0C 19 0C 21 06 21 06 20 0C 21 0C 23 0C 21 0C 20 0C 1C 0C 19 0C 20 06 20 06 1F 0C 20 0C 25 0C 24 0C 25 0C 27 0C 28 0C 2A 06 2C 06 2D 0C 2C 06 2A 06 2C 0C 2A 0C 28 0C 27 0C
        db Note.end

scorePart16:
        db Note.instrument|4
        dh 25 0C 20 0C 25 0C 2C 0C 28 18 27 18 25 0C 20 0C 25 0C 2C 0C 28 0C 27 0C 25 0C 23 0C 25 0C 20 0C 25 0C 2C 0C 28 18 27 0C 23 0C 21 30 20 30
        db Note.end

scorePart17:
        db Note.instrument|4
        dh 25 78 28 06 27 06 28 06 27 06 28 0C 2A 0C 28 0C 23 0C 25 78 28 06 27 06 28 06 27 06 28 0C 2A 0C 28 0C 29 0C
        db Note.end

scorePart18:
        db Note.instrument|0
        dh 2A 78 2D 06 2C 06 2D 06 2C 06 2D 0C 2F 0C 2D 0C 28 0C 2A 60
        db Note.instrument|5
        dh 2A 60
        db Note.end

scorePart19:
        db Note.instrument|4
        dh 14 0C 17 0C 16 0C 17 0C 14 0C 23 0C 22 0C 20 0C 1B 0C 1E 0C 1D 0C 1E 0C 1B 0C 2A 0C 29 0C 27 0C 1E 0C 21 0C 20 0C 21 0C 1E 0C 2D 0C 2C 0C 2A 0C 34 0C 33 0C 31 0C 28 0C 27 0C 25 0C 1C 0C 1B 0C
        db Note.end

scorePart20:
        db Note.instrument|4
        dh 14 0C 17 0C 16 0C 17 0C 14 0C 23 0C 22 0C 20 0C 1B 0C 1E 0C 1D 0C 1E 0C 1B 0C 2A 0C 29 0C 27 0C 1E 0C 21 0C 20 0C 21 0C 1E 0C 2D 0C 2C 0C 2A 0C 22 0C 25 0C 24 0C 25 0C 22 0C 25 0C 28 0C 2B 0C
        db Note.end

scorePart21:
        db Note.instrument|4
        dh 94 2C 0C 2C 18 2D 18 2C 18 2A 0C 2C 60 90
        db Note.instrument|6
        dh 01 03
        db Note.end

scorePart22:
        dh 7F 60 7F 60 7F 60 7F 60
        db Note.end

scorePart23:
        db Note.instrument|4
        dh 17 60
        db Note.instrument|5
        dh 17 60 7F 60 7F 60
        db Note.end

scorePart24:
scorePart25:
        db Note.instrument|2
        dh 12 60 12 60 12 60 12 06 12 06 12 06 12 06 12 06 12 06 12 06 12 06 12 06 12 06 12 06 12 06 12 06 12 06 12 06 12 06
        db Note.end

scorePart26:
        db Note.instrument|1
        dh  0D 0C 0D 0C 0D 0C 0D 0C 0D 0C 0D 0C 0D 0C 0D 0C 0D 0C 0D 0C 0D 0C 0D 0C 0D 0C 0D 06 0D 06 0D 0C 0D 06 0D 06 0D 0C 0D 0C 0D 0C 0D 0C 0D 0C 0D 0C 0D 0C 0D 0C 0D 06 0D 06 0D 0C 0D 0C 0D 06 0D 0C 0D 06 0D 06 0D 06 0D 0C 0D 06 0D 06
        db Note.end

scorePart27:
        db Note.instrument|1
        dh 14 06 14 06 14 0C 14 12 14 0C 14 06 14 0C 14 0C 14 06 14 06 0F 06 0F 06 0F 0C 0F 0C 0F 06 0F 0C 0F 0C 0F 06 0F 0C 0F 06 0F 06 12 06 12 06 12 0C 12 12 12 0C 12 06 12 0C 12 0C 12 06 12 06 0D 06 0D 06 0D 0C 0D 12 0D 0C 0D 06 0D 0C 0D 0C 0D 06 0D 06
        db Note.end

scorePart28:
        db Note.instrument|1
        dh 14 06 14 06 14 0C 14 12 14 0C 14 06 14 0C 14 0C 14 06 14 06 0F 06 0F 06 0F 0C 0F 0C 0F 06 0F 0C 0F 0C 0F 06 0F 0C 0F 06 0F 06 12 06 12 06 12 0C 12 12 12 0C 12 06 12 0C 12 0C 12 06 12 06 16 06 0A 06 0A 0C 0A 12 0A 0C 0A 06 0A 0C 0A 0C 0A 06 0A 06
        db Note.end

scorePart29:
        db Note.instrument|1
        dh 08 0C 08 18 09 18 08 18 06 0C 08 60
        db Note.end


; used in playMenuMusic
scoreInitAddrs: ; #C4CB
.start: dw scoreA, scoreB, scoreC
.stop:  dw scoreEnd, scoreEnd, scoreEnd

scoreA:
        db Part.repeat|8, 3
        db 4, 26
        db Part.repeat|3, 7
        db 8, 9
        db Part.transpose, -7
        db 9
        db Part.transpose, 0
        db 9
        db Part.transpose, -7
        db 9
        db Part.transpose, 0
        db Part.repeat|3, 10
        db 11, 12
        db Part.repeat|2, 13
        db 12
        db Part.repeat|3, 10
        db 11, 12
        db Part.repeat|2, 13
        db 12, 12
        db Part.transpose, 5
        db 12
        db Part.transpose, 0
        db 27, 28, 29
        db Part.end

scoreB:
        db 0, 2
        db Part.transpose, 5
        db 2
        db Part.repeat|14, 5
        db Part.end

scoreC:
        db 22, 22, 25, 23
        db Part.repeat|2, 6
        db 14, 15, 16, 22, 14, 15, 16, 16, 17, 18, 19, 20, 21
        db Part.end

scoreEnd:
        db 1
        db Part.end


partAddrsLow:
        db low(scorePart0),   low(scorePart1),   low(scorePart2)
        db low(scorePart3),   low(scorePart4),   low(scorePart5)
        db low(scorePart6),   low(scorePart7),   low(scorePart8)
        db low(scorePart9),   low(scorePart10),  low(scorePart11)
        db low(scorePart12),  low(scorePart13),  low(scorePart14)
        db low(scorePart15),  low(scorePart16),  low(scorePart17)
        db low(scorePart18),  low(scorePart19),  low(scorePart20)
        db low(scorePart21),  low(scorePart22),  low(scorePart23)
        db low(scorePart24),  low(scorePart25),  low(scorePart26)
        db low(scorePart27),  low(scorePart28),  low(scorePart29)
partAddrsHigh:
        db high(scorePart0),  high(scorePart1),  high(scorePart2)
        db high(scorePart3),  high(scorePart4),  high(scorePart5)
        db high(scorePart6),  high(scorePart7),  high(scorePart8)
        db high(scorePart9),  high(scorePart10), high(scorePart11)
        db high(scorePart12), high(scorePart13), high(scorePart14)
        db high(scorePart15), high(scorePart16), high(scorePart17)
        db high(scorePart18), high(scorePart19), high(scorePart20)
        db high(scorePart21), high(scorePart22), high(scorePart23)
        db high(scorePart24), high(scorePart25), high(scorePart26)
        db high(scorePart27), high(scorePart28), high(scorePart29)


; (?)
; 5 × 8 bytes
p_c55c: ; #C55C
        db (1<<7)|(1<<3)|2, (4<<3)|1, (9<<3)|1, 0, 0, 0, 0, 0
        db (1<<7)|(1<<3)|2, (3<<3)|1, (8<<3)|1, 0, 0, 0, 0, 0
        db (1<<7)|(1<<3)|2, (5<<3)|1, (9<<3)|1, 0, 0, 0, 0, 0
        db (1<<7)|(1<<3)|2, (4<<3)|1, (7<<3)|1, 0, 0, 0, 0, 0
        db (1<<7)|(4<<3)|1, (6<<3)|1,        0, 0, 0, 0, 0, 0

; Instruments used in the music (8 × 10 bytes)
instruments: ; #C584
        ;     env  dec sus rel envP  ?  viP viS flag
.i0:    Instr #60, -1, 48, -1, #30, #10, 6,  1, %001
.i1:    Instr #7F, -3,  0, -2, #37, #00, 0,  0, %001
.i2:    Instr #7F, -6,  0, -1, #28, #00, 1, 24, %010
.i3:    Instr #7F, -4,  0, -1, #28, #00, 1, 24, %010
.i4:    Instr #7F, -2, 50, -1, #3E, #20, 3,  2, %001
.i5:    Instr #7F, -1, 50, -1, #40, #00, 0,  1, %001
.i6:    Instr #7F, -2,  0, -1, #00, #20, 3,  2, %001
.i7:    Instr #60, -1,  0, -1, #30, #10, 6,  1, %001


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


; Period value for each note
noteTable:  ; #c697
        dw 3822 ; [ 0] A♯₀
        dw 3608 ; [ 1] B₀
        dw 3405 ; [ 2] C₁
        dw 3214 ; [ 3] C♯₁
        dw 3034 ; [ 4] D₁
        dw 2863 ; [ 5] D♯₁
        dw 2703 ; [ 6] E₁
        dw 2551 ; [ 7] F₁
        dw 2408 ; [ 8] F♯₁
        dw 2273 ; [ 9] G₁
        dw 2145 ; [10] G♯₁
        dw 2025 ; [11] A₁
        dw 1911 ; [12] A♯₁
        dw 1804 ; [13] B₁
        dw 1703 ; [14] C₂
        dw 1607 ; [15] C♯₂
        dw 1517 ; [16] D₂
        dw 1432 ; [17] D♯₂
        dw 1351 ; [18] E₂
        dw 1276 ; [19] F₂
.err20: dw 1236 ; [20] F♯₂ (should be 1204)
        dw 1136 ; [21] G₂
        dw 1073 ; [22] G♯₂
        dw 1012 ; [23] A₂
.err24: dw  988 ; [24] A♯₂ (should be 956)
        dw  902 ; [25] B₂
        dw  851 ; [26] C₃
        dw  804 ; [27] C♯₃
        dw  758 ; [28] D₃
        dw  716 ; [29] D♯₃
        dw  676 ; [30] E₃
        dw  638 ; [31] F₃
        dw  602 ; [32] F♯₃
        dw  568 ; [33] G₃
        dw  536 ; [34] G♯₃
        dw  506 ; [35] A₃
        dw  478 ; [36] A♯₃
        dw  451 ; [37] B₃
        dw  426 ; [38] C₄
        dw  402 ; [39] C♯₄
        dw  379 ; [40] D₄
        dw  358 ; [41] D♯₄
        dw  338 ; [42] E₄
        dw  319 ; [43] F₄
        dw  301 ; [44] F♯₄
        dw  284 ; [45] G₄
        dw  268 ; [46] G♯₄
        dw  253 ; [47] A₄
        dw  239 ; [48] A♯₄
        dw  225 ; [49] B₄
        dw  213 ; [50] C₅
        dw  201 ; [51] C♯₅
        dw  190 ; [52] D₅
        dw  179 ; [53] D♯₅
        dw  169 ; [54] E₅
        dw  159 ; [55] F₅
        dw  150 ; [56] F♯₅
        dw  142 ; [57] G₅
        dw  134 ; [58] G♯₅
        dw  127 ; [59] A₅
        dw  119 ; [60] A♯₅
        dw  113 ; [61] B₅
        dw  106 ; [62] C₆
        dw  100 ; [63] C♯₆
        dw   95 ; [64] D₆
        dw   89 ; [65] D♯₆
        dw   84 ; [66] E₆
        dw   80 ; [67] F₆
        dw   75 ; [68] F♯₆
        dw   71 ; [69] G₆
        dw   67 ; [70] G♯₆
        dw   63 ; [71] A₆
        dw   60 ; [72] A♯₆
        dw   56 ; [73] B₆
        dw   53 ; [74] C₇
        dw   50 ; [75] C♯₇
        dw   47 ; [76] D₇
        dw   45 ; [77] D♯₇
        dw   42 ; [78] E₇
        dw   40 ; [79] F₇
        dw   38 ; [80] F♯₇
        dw   36 ; [81] G₇
        dw   34 ; [82] G♯₇
        dw   32 ; [83] A₇
.err84: dw   24 ; [84] A♯₇ (should be 30)


mixerValue:  ; #c741
        db mixOff

; #c742    mxT  mxN  mxM  period vol  susT   ?  vCnt vValue vSlope phAddr inAddr flag
ayChA:  Ch #FE, #F7, #09, #6F6D, #6E, #74, #79, #0D, #090A, #646C, #6320, #282C, #69
ayChB:  Ch #FD, #EF, #12, #7470, #78, #73, #69, #7A, #2965, #0A0D, #6C09, #2064, #62
ayChC:  Ch #FB, #DF, #24, #090A, #61, #64, #64, #20, #6C68, #622C, #0963, #6D3B, #6F

noisePeriod:  ; #c778
        db 0


; Play tone
;   `ix`: channel addr
;   `iy`: instrument addr
;   `hl`: period
;   `c`: duration
; disables interrupts
playTone:  ; #c779
        di
        ld a, iyl
        ld (ix+Ch.instrAddr+0), a
        ld a, iyh
        ld (ix+Ch.instrAddr+1), a

        ld (ix+Ch.period+0), l
        ld (ix+Ch.period+1), h
        ld (ix+Ch.duration), c

        ld a, (iy+Instr.e_5)
        ld (ix+Ch.ch_7), a

        ; set vibrato
        ld a, (iy+Instr.vibrPeriod)
        and %01111111
        srl a
        jr NZ, .l_0
        ld a, 1
.l_0:
        ld (ix+Ch.vibrCounter), a   ; `vibrPeriod` / 2

        ld a, (iy+Instr.vibrSlope+0)
        ld (ix+Ch.vibrSlope+0), a
        ld a, (iy+Instr.vibrSlope+1)
        ld (ix+Ch.vibrSlope+1), a

        xor a
        ld (ix+Ch.vibrValue+0), a
        ld (ix+Ch.vibrValue+1), a

        ; set mixer
        ld a, (mixerValue)
        or (ix+Ch.mixMask)
        ld c, (iy+Instr.flags)
        ld (ix+Ch.flags), c
        bit Flag.tone, c
        jr Z, .noTone
        and (ix+Ch.mixTone)     ; tone on
.noTone:
        bit Flag.noise, c
        jr Z, .noNoise
        and (ix+Ch.mixNoise)    ; noise on
.noNoise:
        ld (mixerValue), a

        bit Flag.envelope, c
        jr NZ, .envelope

        ; set ADSR stage
        ld hl, attackStage
        ld (ix+Ch.adsrAddr+0), l
        ld (ix+Ch.adsrAddr+1), h
        ret

.envelope:
        ; set envelope
        call beginRegUpdate

        ld a, (iy+Instr.attackSpd)  ; here, envelope shape
        ld c, regEnvShape
        call setAyReg

        ld a, (iy+Instr.attackLev)  ; here, envelope period
        ld c, regEnvPer         ; (low)
        call setAyReg
        inc c                   ; (high)
        xor a
        call setAyReg

        ld (ix+Ch.volume), #FF

        jp endRegUpdate


; Initialise AY registers and some struct fields
initAy:  ; #c7fe
        call beginRegUpdate

        ld c, regMixer
        ld a, (mixerValue)
        or mixOff
        ld (mixerValue), a
        call setAyReg
        xor a
        inc c                   ; regVolumeA
        call setAyReg
        inc c                   ; regVolumeB
        call setAyReg
        inc c                   ; regVolumeC
        call setAyReg
        ld a, 1
        inc c                   ; regEnvPer (low)
        call setAyReg
        inc c                   ; regEnvPer (high)
        xor a
        call setAyReg
        inc c                   ; regEnvShape
        call setAyReg

        ld (ayChA.flags), a
        ld (ayChB.flags), a
        ld (ayChC.flags), a
        ld (ayChA.volume), a
        ld (ayChB.volume), a
        ld (ayChC.volume), a

        jp endRegUpdate


; Write values to AY registers
setAyValues:  ; #c83f
        ld a, (mixerValue)
        and mixOff
        cp mixOff
        ret Z

        ld ix, ayChA
        call applyEffect
        ld ix, ayChB
        call applyEffect
        ld ix, ayChC
        call applyEffect

        call beginRegUpdate
        ld ix, ayChA

        ; regMixer
        ld c, regMixer
        ld a, (mixerValue)
        call setAyReg

        ; regPeriodA
        ld c, regPeriodA
        ld a, (ayChA.period+0)
        add (ix+Ch.vibrValue+0)
        bit Flag.noise, (ix+Ch.flags)
        jp Z, .l_0
        ld (noisePeriod), a
.l_0:
        call setAyReg
        inc c
        ld a, (ayChA.period+1)
        adc a, (ix+Ch.vibrValue+1)
        call setAyReg

        ; regPeriodB
        inc c
        ld a, (ayChB.period+0)
        add (ix+Ch+Ch.vibrValue+0)
        bit Flag.noise, (ix+Ch+Ch.flags)
        jp Z, .l_1
        ld (noisePeriod), a
.l_1:
        call setAyReg
        inc c
        ld a, (ayChB.period+1)
        adc a, (ix+Ch+Ch.vibrValue+1)
        call setAyReg

        ; regPeriodC
        inc c
        ld a, (ayChC.period+0)
        add (ix+2*Ch+Ch.vibrValue+0)
        bit Flag.noise, (ix+2*Ch+Ch.flags)
        jp Z, .l_2
        ld (noisePeriod), a
.l_2:
        call setAyReg
        inc c
        ld a, (ayChC.period+1)
        adc a, (ix+2*Ch+Ch.vibrValue+1)
        call setAyReg

        ; regNoisePer
        inc c
        ld a, (noisePeriod)
    .3  rrca
        call setAyReg

        ; regVolumeA
        ld c, regVolumeA
        ld a, (ayChA.volume)
    .3  srl a
        call setAyReg

        ; regVolumeB
        inc c
        ld a, (ayChB.volume)
    .3  srl a
        call setAyReg

        ; regVolumeC
        inc c
        ld a, (ayChC.volume)
    .3  srl a
        call setAyReg

        jp endRegUpdate


applyEffect:  ; #c8fb
        ld a, (mixerValue)
        and (ix+Ch.mixMask)
        cp (ix+Ch.mixMask)
        ret Z

        ld a, (ix+Ch.instrAddr+0)
        ld iyl, a
        ld a, (ix+Ch.instrAddr+1)
        ld iyh, a
        ; `iy`: instrument

        ld a, (ix+Ch.duration)
        and a
        jr Z, .noDuration
        cp -1
        jr Z, .noDuration
        dec (ix+Ch.duration)
.noDuration:
        call doVibrato

        bit Flag.envelope, (iy+Instr.flags)
        jp NZ, switchOffIfEnded

        ; jump to the current ADSR stage
        ld l, (ix+Ch.adsrAddr+0)
        ld h, (ix+Ch.adsrAddr+1)
        jp hl
        ; possible jumps:
        ; `attackStage`, `decayStage`, `sustainStage`, `releaseStage`


; Attack - the initial ADSR stage
; Raise the volume until it reaches the peak level
;   `ix`: channel
;   `iy`: instrument
attackStage:  ; #c92d
        ld a, (ix+Ch.volume)
        add (iy+Instr.attackSpd)
        cp (iy+Instr.attackLev)
        jr NC, .end
        ld (ix+Ch.volume), a
        ret
.end:
        ld a, (iy+Instr.attackLev)
        ld (ix+Ch.volume), a

        ; set the next stage
        ld hl, decayStage
        ld (ix+Ch.adsrAddr+0), l
        ld (ix+Ch.adsrAddr+1), h
        ret


; Decay - the second ADSR stage
; Drop the volume until it reaches the sustain level
;   `ix`: channel
;   `iy`: instrument
decayStage:  ; #c94c
        ld a, (ix+Ch.volume)
        add (iy+Instr.decaySpd)
        jp M, .end
        cp (iy+Instr.sustainLev)
        jr C, .end
        ld (ix+Ch.volume), a
        ret
.end:
        ld a, (iy+Instr.sustainLev)
        ld (ix+Ch.volume), a

        ; set the next stage
        ld hl, sustainStage
        ld (ix+Ch.adsrAddr+0), l
        ld (ix+Ch.adsrAddr+1), h
        ret


; Sustain - the third ADSR stage
; Keep the volume during the duration of the note
;   `ix`: channel
sustainStage:  ; #c96e
        ld a, (ix+Ch.duration)
        and a
        ret NZ

        ; set the next stage
        ld hl, releaseStage
        ld (ix+Ch.adsrAddr+0), l
        ld (ix+Ch.adsrAddr+1), h
        ret


; Release - the final ADSR stage
; Drop the volume to zero
;   `ix`: channel
;   `iy`: instrument
releaseStage: ; #c967d
        ld a, (ix+Ch.volume)
        add (iy+Instr.releaseSpd)
        jp M, switchOff

        ld (ix+Ch.volume), a
        ret


; Switch off a channel
;   `ix`: channel
switchOff:
        ld (ix+Ch.volume), 0
        ld a, (mixerValue)
        or (ix+Ch.mixMask)
        ld (mixerValue), a
        res Flag.f_7, (ix+Ch.flags)
        ret


; Switch off a channel if the note has ended
;   `ix`: channel
switchOffIfEnded:  ; #c99c
        ld a, (ix+Ch.duration)
        and a
        ret NZ
        jr switchOff


doVibrato:  ; # c9a3
        ld a, (ix+Ch.ch_7)
        and a
        jr Z, .zero
        cp -1
        ret Z

        dec (ix+Ch.ch_7)
        ret NZ

.zero:
        ; update vibrato value
        ld l, (ix+Ch.vibrValue+0)
        ld h, (ix+Ch.vibrValue+1)
        ld c, (ix+Ch.vibrSlope+0)
        ld b, (ix+Ch.vibrSlope+1)
        add hl, bc
        ld (ix+Ch.vibrValue+0), l
        ld (ix+Ch.vibrValue+1), h

        dec (ix+Ch.vibrCounter)
        ret NZ

        ld a, (iy+Instr.vibrPeriod)
        and a
        ret Z

        jp P, .positive         ; always true?

        ld (ix+Ch.ch_7), -1     ; never happens?
        ret

.positive:
        ; reset vibrato counter with duration
        ld (ix+Ch.vibrCounter), a

        ; negate vibrato slope
        ld a, c
        cpl
        ld c, a
        ld a, b
        cpl
        ld b, a
        inc bc

        ld (ix+Ch.vibrSlope+0), c
        ld (ix+Ch.vibrSlope+1), b
        ret


; Do nothing
; Called before updating AY register values
; Apparently, contained some debug or abandoned code
beginRegUpdate:  ; #c9e5
        ret

; Do nothing
; Called after updating AY register values
; Apparently, contained some debug or abandoned code
endRegUpdate:  ; #c9e6
        ret


; Write a value to an AY register
;   `c`: AY register index
;   `a`: value to write
; spoils: `e`
setAyReg:  ; #c9e7
        push bc
        ld e, c
        ld bc, Port.ayRegister
        out (c), e
        ld b, high(Port.ayValue)
        out (c), a
        pop bc
        ret


; Unused
callPlayMenuMusic:  ; #c9f4
        jp Sound.callPlayMenuMusic

; Unused
callAySoundFrame:  ; #c9f7
        jp Sound.callAySoundFrame


; Non-zero if sound/music is playing, zero if silent
isPlaying:  ; #c9fa
        db 0


; (unused ? 50 bytes)
p_c9fb:  ; #c9fb
        dh C3 05 CA AF 32 FA C9 C3
        dh FE C7 F3 6F 5F 26 00 54
        dh 29 19 29 29 19 FD 21 D4
        dh C5 EB FD 19 FD 6E 0A FD
        dh 66 0B FD 4E 0C DD 21 42
        dh C7 CD 79 C7 DD CB 11 FE
        dh FB C9


; #ca2d
;              0      1      3      5      7    9   10   11   12   13   14   15     16   18   19   20
sectA:  Sect 0*8, #646F, #0D65, #090A, #646C, #20, #28, #69, #78, #2B, #73, #70, #6374, #6F, #6C, #29
sectB:  Sect 1*8, #3137, #0909, #733B, #7465, #20, #63, #6F, #6C, #6F, #75, #72, #7420, #6F, #20, #77
sectC:  Sect 2*8, #7469, #0D65, #090A, #6572, #74, #0D, #0A, #0D, #0A, #3B, #2D, #2D2D, #2D, #2D, #2D


; Table containing offsets in the `instruments` table pointing to instruments
; 3 × 8 bytes. Initialised at runtime as instruments 0 to 7
instrOffsets:  ; #ca6c
.chA:   dh 2D 2D 2D 2D 20 63 6F 69  ; junk values
.chB:   dh 6E 20 6A 75 6D 70 69 6E  ; junk values
.chC:   dh 67 20 2D 2D 2D 2D 2D 2D  ; junk values


; Initialise the menu AY music
;   `a`: 0 - start, 1 - stop
playMenuMusic:  ; #ca84
        push af
        call initAy
        pop af

        ld l, a
        add a
        add l
        add a
        ; `a` *= 6
        ld hl, scoreInitAddrs
        add l
        ld l, a
        jr NC, .noCarry
        inc h
.noCarry:
        ; `hl`: music init addr
        ld e, (hl)
        inc hl
        ld d, (hl)
        inc hl
        ld (sectA.scoreAddr), de

        ld e, (hl)
        inc hl
        ld d, (hl)
        inc hl
        ld (sectB.scoreAddr), de

        ld e, (hl)
        inc hl
        ld d, (hl)
        inc hl
        ld (sectC.scoreAddr), de

        ; init with 0
        xor a
        ld (sectA.transpose), a
        ld (sectB.transpose), a
        ld (sectC.transpose), a
        ld (sectA.i_15), a
        ld (sectB.i_15), a
        ld (sectC.i_15), a

        ; init with -1 (true)
        cpl
        ld (sectA.isPartEnd), a
        ld (sectB.isPartEnd), a
        ld (sectC.isPartEnd), a

        ; init with 1
        ld a, 1
        ld (sectA.repeatCount), a
        ld (sectB.repeatCount), a
        ld (sectC.repeatCount), a
        ld (sectA.duration), a
        ld (sectB.duration), a
        ld (sectC.duration), a

        ; init with (0 * Instr,  …, 7 * Instr)
        ld hl, instrOffsets
        ld bc, _HIGH 3 _LOW Instr
.channel:
        xor a
.instr:
        ld (hl), a
        inc hl
        add c
        ld (hl), a
        inc hl
        add c
        cp 8 * Instr
        jr NZ, .instr
        djnz .channel

        ; init with instrument 0
        ld hl, instruments.i0
        ld (sectA.instrAddr), hl
        ld (sectB.instrAddr), hl
        ld (sectC.instrAddr), hl

        ; init with -1 (true)
        ld a, -1
        ld (sectA.isPlaying), a
        ld (sectB.isPlaying), a
        ld (sectC.isPlaying), a
        ld (isPlaying), a

        ret


; Called in interrupts
aySoundFrame:  ; #cb0c
        call setAyValues

        ; check if ended
        ld a, (isPlaying)
        and a
        ret Z

        ld a, (sectA.isPlaying)
        ld hl, sectB.isPlaying
        or (hl)
        ld hl, sectC.isPlaying
        or (hl)
        ld (isPlaying), a
        jr NZ, .notEnded

        xor a
        ld (isPlaying), a
        ld a, (mixerValue)
        and mixOff
        cp mixOff
        ret Z

        ld a, 1
        ld (isPlaying), a
        ret

.notEnded:
        ld iy, sectA
        ld ix, ayChA
        call .proccessChannel

        ld iy, sectB
        ld ix, ayChB
        call .proccessChannel

        ld iy, sectC
        ld ix, ayChC

.proccessChannel:
        ; `ix`: channel
        ; `iy`: section
        call p_cc95

        ld a, (iy+Sect.isPartEnd)
        and a
        jr Z, .getNoteAddr

.partEnd:
        dec (iy+Sect.repeatCount)
        jr Z, .newPart

        ; repeat the part
        ld a, (iy+Sect.partAddr+0)
        ld (iy+Sect.noteAddr+0), a
        ld a, (iy+Sect.partAddr+1)
        ld (iy+Sect.noteAddr+1), a
        ld (iy+Sect.isPartEnd), 0
        jr .getNoteAddr

.newPart:
        ld (iy+Sect.repeatCount), 1
        ld l, (iy+Sect.scoreAddr+0)
        ld h, (iy+Sect.scoreAddr+1)

.getPartIndex:
        ld a, (hl)              ; part index or special value

        ; check special values
        cp Part.repeat
        jr C, .setScorePart

        cp Part.transpose
        jr NZ, .notTranspose

        ; set transposition
        inc hl
        ld a, (hl)              ; transposition value
        ld (iy+Sect.transpose), a
        inc hl
        jp .getPartIndex

.notTranspose:
        cp Part.end
        jr NZ, .notEnd

        ; end the music
        xor a
        ld (iy+Sect.isPlaying), a
        ret

.notEnd:
        cp Part.instrument
        jr NC, .setInstrument

        ; set repeat count
        and %00011111
        ld (iy+Sect.repeatCount), a
        inc hl
        jp .getPartIndex

.setInstrument:
        ; never used (?)
        and %00000111
        add (iy+Sect.chOffset)
        ld de, instrOffsets
        add e
        ld e, a
        jr NC, .noCarry
        inc d
.noCarry:
        inc hl                  ; points to the new instrument offset value
        ldi                     ; copy the value to `instrOffsets` table
        jp .getPartIndex

.setScorePart:
        ld (iy+Sect.isPartEnd), 0

        inc hl
        ld (iy+Sect.scoreAddr+0), l
        ld (iy+Sect.scoreAddr+1), h

        ; `a`: score part index
        ld c, a
        ld b, 0
        ld hl, partAddrsLow
        add hl, bc
        ld e, (hl)
        ld hl, partAddrsHigh
        add hl, bc
        ld d, (hl)
        ; `de`: start address of the score part
        ld (iy+Sect.partAddr+0), e
        ld (iy+Sect.partAddr+1), d
        jr .l_11

.getNoteAddr:
        ld e, (iy+Sect.noteAddr+0)
        ld d, (iy+Sect.noteAddr+1)

.l_11:
        ; `de`: note addr
        dec (iy+Sect.duration)
        jr Z, .zeroDuration

        ld a, (de)              ; note or special value
        cp Note.instrument
        call NC, p_cc5b

        ld (iy+Sect.noteAddr+0), e
        ld (iy+Sect.noteAddr+1), d
        ret

.zeroDuration:
        ld a, (de)              ; note or special value
        cp Note.instrument
        jr C, .l_13

        call p_cc5b

        ld a, (iy+Sect.isPartEnd)
        and a
        jr Z, .zeroDuration
        jp .partEnd

.l_13:
        cp Note.pause
        jr Z, .pause

        cp Note.microtonal
        jr NZ, .note

        ; get microtonal period
        inc de
        ld a, (de)
        ld l, a
        inc de
        ld a, (de)
        ld h, a
        jp .l_15

.note:
        ; `a`: note
        add (iy+Sect.transpose)
        add 12                  ; + octave
        ld (iy+Sect.note), a

        ld hl, noteTable
        add a
        ld c, a
        ld b, 0
        add hl, bc
        ; `hl` : addr in `noteTable`
        ld a, (hl)
        inc hl
        ld h, (hl)
        ld l, a
        ; `hl`: note period

.l_15:
        ; `hl`: period
        ld a, (iy+Sect.i_15)
        or %11000000
        ld (iy+Sect.i_20), a

        inc de
        ld a, (de)              ; duration
        inc de
        ld (iy+Sect.duration), a
        ld c, a

        ; next note addr
        ld (iy+Sect.noteAddr+0), e
        ld (iy+Sect.noteAddr+1), d

        ld e, (iy+Sect.instrAddr+0)
        ld a, (iy+Sect.instrAddr+1)
        ld iyh, a
        ld iyl, e
        ; `iy`: instrument addr
        bit Flag.f_7, (ix+Ch.flags)
        ret NZ

        jp playTone

.pause:
        inc de
        ld a, (de)
        inc de
        ld (iy+Sect.duration), a
        ld (iy+Sect.noteAddr+0), e
        ld (iy+Sect.noteAddr+1), d
        ret


;
;   `de`: note address
p_cc5b:  ; #cc5b
        ld a, (de)              ; note (>= #80)
        cp Note.something
        jr NC, .l_0

        ; `a`: #80..#87 - change instrument
        and %00000111
        add (iy+Sect.chOffset)
        ld c, a
        ld b, 0
        ld hl, instrOffsets
        add hl, bc
        ld c, (hl)
        ld hl, instruments
        add hl, bc
        ld (iy+Sect.instrAddr+0), l
        ld (iy+Sect.instrAddr+1), h

        inc de                  ; next note
        ret

.l_0:
        cp Note.end
        jr NZ, .l_1
        ld (iy+Sect.isPartEnd), -1
        ret

.l_1:
        cp Note.skip
        jr NC, .l_2

        ; `a`: #88..#BF
        and %00001111
        ld (iy+Sect.i_15), a

        inc de                  ; next note
        ret

.l_2:
        inc de                  ; next note
        cp Note.nothing         ; (?)
        ret Z

    .3  inc de                  ; skip 3 more notes (?)
        ret


;
;   `ix`: channel
;   `iy`: section
p_cc95:  ; #cc95
        bit Flag.f_7, (ix+Ch.flags)
        ret NZ

        ld a, (iy+Sect.i_20)
        bit 7, a
        ret Z

        and %00111111
        jr NZ, .l_0

        res 7, (iy+Sect.i_20)
        ret

.l_0:
        ld d, %00000111
        bit 6, (iy+Sect.i_20)
        jr NZ, .l_2

        dec (iy+Sect.i_18)
        ret NZ

        dec (iy+Sect.i_19)
        jp Z, .l_2

        ld l, (iy+Sect.i_16+0)
        ld h, (iy+Sect.i_16+1)
        inc l
        ld (iy+Sect.i_16+0), l
        jp NZ, .l_1
        inc h
        ld (iy+Sect.i_16+1), h
.l_1:
        ld a, (hl)
        and d
        ld (iy+Sect.i_18), a
        ld a, (hl)
    .3  rrca
        and %00011111
        add (iy+Sect.note)
        jp .setPeriodByNote

.l_2:
        ld hl, p_c55c - #0708   ; `d`= 7 is added to `h`, `a`&%00011111: 1..5
        ld a, (iy+Sect.i_20)
    .3  add a
        ld e, a
        add hl, de              ; `hl`: #p_c55c + 8 * (Sect.i_20 - 1)

        bit 7, (hl)
        jr NZ, .l_3

        bit 6, (iy+Sect.i_20)
        jr NZ, .l_3

        ld (iy+Sect.i_19), 1
        ret

.l_3:
        res 6, (iy+Sect.i_20)
        ld a, (hl)
    .3  rrca
        and d
        ld (iy+Sect.i_18), a

        ld a, (hl)
        and d
        inc a
        ld (iy+Sect.i_19), a
        ld (iy+Sect.i_16+0), l
        ld (iy+Sect.i_16+1), h

        ld a, (iy+Sect.note)
.setPeriodByNote:
        add a
        ld hl, noteTable
        add l
        ld l, a
        jr NC, .noCarry
        inc h
.noCarry:
        ld a, (hl)
        ld (ix+Ch.period+0), a
        inc hl
        ld a, (hl)
        ld (ix+Ch.period+1), a
        ret


; Initialises an AY sound effect
;   `a`: sound index (0..14)
playAySound:  ; #cd25
        push hl, de, bc, ix, iy

        ld e, a                 ; why?

        ; calculate sound effect addr
        ld l, a
        ld h, 0
    .2  add hl, hl
        ld c, l
        ld b, h
        add hl, hl
        add hl, bc
        ld c, a
        ld b, 0
        add hl, bc
        ; `hl`: a * 13
        ld bc, aySounds
        add hl, bc
        push hl : pop iy
        ; `iy`: sound effect addr

        ; choose next channel
        ld a, (lastUsedChannel)
        inc a
        cp 3
        jp C, .selectChannel
        xor a

.selectChannel:
        ld (lastUsedChannel), a
        ld ix, ayChA
        and a
        jp Z, .playTone
        ld ix, ayChB
        cp 1
        jp Z, .playTone
        ld ix, ayChC
        ; `ix`: channel struct addr

.playTone:
        ld l, (iy+Effect.period+0)
        ld h, (iy+Effect.period+1)
        ld c, (iy+Effect.duration)
        call playTone

        pop iy, ix, bc, de, hl
        ret


; Channel used for playing the last sound effect (0..2)
lastUsedChannel:  ; #cd77
        db 0


    ENDMODULE
