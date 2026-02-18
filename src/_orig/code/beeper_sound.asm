    MODULE Code


; Beeper sounds (15 × 3 bytes)
beeperSounds:  ; #be3a
;       length period
        db  20,  20, SoundType.rising   ; (unused)
        db  20,  20, SoundType.rising   ; (unused)
        db  20,  20, SoundType.rising   ; (unused)
        db  10,  50, SoundType.noise    ; damageEnemy
        db  10, 220, SoundType.steady   ; kickOrThrow
        db 100, 120, SoundType.rising   ; jump
        db  80,  80, SoundType.noise    ; killEnemy
        db  20,  20, SoundType.falling  ; (unused)
        db  20, 200, SoundType.rising   ; laserGun
        db  20,  20, SoundType.noise    ; (unused)
        db  10, 180, SoundType.rising   ; powerGun
        db  20, 200, SoundType.steady   ; pickItem
        db  60,  30, SoundType.rising   ; energyLoss
        db  20, 240, SoundType.steady   ; pickWeapon
        db  20,  20, SoundType.noise    ; (unused)


; Play beeper sound
;   `a`: sound index (0..14)
; Used by playSound.
playBeeperSound:  ; #be67
        ld l, a
        add a
        add l
        ld l, a
        ld h, 0
        ld de, beeperSounds
        add hl, de
        
        ld c, (hl)              ; length
        inc hl
        ld d, (hl)              ; period
        inc hl
        ld a, (hl)              ; type
        
        or a
        jr Z, .rising
        dec a
        jr Z, .falling
        dec a
        jr Z, .noise
        jr .flat
        
.rising:
        call .period
        dec d
        dec c
        jr NZ, .rising
        ret
        
.falling:
        call .period
        inc d
        dec c
        jr NZ, .falling
        ret
        
.noise:
        call .period
        rrc d
        ld a, d
        add 20
        ld d, a
        dec c
        jr NZ, .noise
        ret
        
.flat:
        call .period
        dec c
        jr NZ, .flat
        ret
        
.period:
        xor a
        out (#FE), a
        ld b, d
.low:   djnz .low
        
        ld a, #10
        out (#FE), a
        ld b, d
.high:  djnz .high
        
        ret


    ENDMODULE
