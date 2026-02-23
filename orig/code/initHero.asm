    MODULE Code

; Clear the game state before the start of the game
; Used by c_cc25.
clearGameState:  ; #d133
        ld hl, State.start
        ld de, State.start + 1
        ld bc, State.length - 1
        ld (hl), 0
        ldir

        ld a, 18
        ld (State.maxEnergy), a

        call Panel.clearScore
        ld b, 5
        ld hl, State.levelsDone
.level:
        ld (hl), 0
        inc hl
        djnz .level
        ret


; Initialise the hero object and place it to the start position
;   `bc`: hero's position (x, y), blocks
; Used by c_d1c1.
initHero:  ; #d153
        ld ix, Scene.hero
        ld l, b
        ld h, 0
    .5  add hl, hl
        ld de, 32
        add hl, de              ; `hl` = `b` × 32 + 32
        ld (ix+Obj.x+0), l
        ld (ix+Obj.x+1), h      ; set x coord in pixels

        ld a, c
    .5  add a
        add 40                  ; `a` = `c` × 32 + 40
        ld (ix+Obj.y), a        ; set y coord in pixels

        ld hl, cS.heroStands
        ld a, (State.weapon)
        cp ObjType.powerGun
        jr C, .noGun
        ld hl, cS.armedHeroStands
.noGun:
        ld (ix+Obj.sprite+0), l
        ld (ix+Obj.sprite+1), h ; set sprite addr

        ld (ix+Obj.mo.direction), 1<<Dir.right
        ld (ix+Obj.flags), (1<<Flag.exists) | (1<<Flag.isBig)
        ld (ix+Obj.width), 16
        ld (ix+Obj.height), 21
        ld (ix+Obj.spriteSet), 0      ; ?
        ld (ix+Obj.colour), Colour.brWhite
        ld (ix+Obj.objType), ObjType.hero
        xor a
        ld (State.heroState), a
        ld (State.stepPeriod), a      ; ?
        ret


; Start position (x, y) and map span (start, end) by level
startPositions:  ; #d1ab
;          x  y start end
.lev0:  db 1, 4,  0,  54
.lev1:  db 1, 4,  0, 108
.lev2:  db 3, 4,  0, 138
.lev3:  db 2, 4,  0, 126
.lev4:  db 1, 3,  0,  40

    ENDMODULE
