    MODULE Boss


; Klondike boss possible positions
klondikePositions:
        ;   x    y
        db 152, 171
        db 216, 171
        db 152,  75
        db 216,  75

; Klondike boss logic
; Used by c_f8cb.
bossLogicKlondike:  ; #f8f4
        ld a, (State.bossFight)
        cp 1
        jr NZ, .l_1

        ld a, (State.bossKilled)
        or a
        ret NZ

.createBoss:
        ld ix, Scene.obj2
        ld a, 54
        call Scene.createObject

        ld ix, Scene.obj3
        ld a, 52
        call Scene.createObject

        ld ix, Scene.obj4
        ld a, 53
        call Scene.createObject

        ld ix, Scene.obj5
        ld a, ObjType.klondike.bossBurrow
        call Scene.createObject

        ; choose random position
        call Utils.generateRandom
        and %00000011
        add a
        ld l, a
        ld h, 0
        ld de, klondikePositions
        add hl, de
        ld a, (hl)
        inc hl
        ld h, (hl)              ; y
        ld l, a                 ; x
        
        ; set position (same for all parts)
        ld b, 4
        ld ix, Scene.obj2
        ld de, Obj              ; object size
.object:
        ld (ix+Obj.x+0), l
        ld (ix+Obj.x+1), 0
        ld (ix+Obj.y), h
        add ix, de
        djnz .object
        
        ld a, 2
        ld (State.bossFight), a
        xor a
        ld (State.bossInvinc), a
        ld a, -1
        ld (State.bulletTime), a
        ret
        
.l_1:
        ld hl, State.bossFight
        inc (hl)
        ld a, (hl)
        cp 65
        jr NZ, .l_2
        
        ld ix, Scene.obj4
        ld hl, Lev0Klondike.lS.bossAnt2
        ld (ix+Obj.sprite+0), l
        ld (ix+Obj.sprite+1), h
        
        ld a, -1
        ld (State.bossInvinc), a
        ld a, 2
        ld (State.bulletTime), a
        ret
        
.l_2:
        cp 105
        jr NZ, .l_3
        
        ld a, 1
        ld (State.bulletTime), a
        ret
        
.l_3:
        cp 150
        ret C
        
; This entry point is used by c_fa65.
.l_4:
        ld b, 4
        ld ix, Scene.obj2
        ld de, Obj              ; object size
.l_5:
        ld (ix+Obj.flags), 0    ; remove object
        djnz .l_5
        ld a, 1
        ld (State.bossFight), a
        ret


    ENDMODULE
