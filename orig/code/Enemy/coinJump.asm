    MODULE Enemy

; Velocity table for coin jump
coinJumpVelocity:  ; #f506
        db -6, -5, -4, -3, -2, -2, -1, -1, 0
        db  1,  1,  2,  2,  3,  4,  5,  6
        db #7F

; Precess the motion of a coin appearing from a defeated enemy
coinJumpMotion:  ; #f518
        ld a, (ix+Obj.mo.step)
        ld l, a
        ld h, 0
        ld de, coinJumpVelocity
        add hl, de
        ld a, (hl)
        cp #7F
        jr NZ, .jump

        ; falling
        dec (ix+Obj.mo.step)
        ld a, 8                 ; falling speed
.jump:
        add (ix+Obj.y)
        ld (ix+Obj.y), a
        ld a, (hl)
        cp #7F
        jr NZ, .end

        ; falling
        call collectTileTypes
        ld a, (State.tTypeBot)
        cp TileType.wall
        jr C, .end              ; space, ladder, ladderTop, platform

        ; impenetrable tiles
        ld a, (ix+Obj.y)
        and -8
        ld (ix+Obj.y), a
        ld (ix+Obj.mo.type), Motion.none
.end:
        inc (ix+Obj.mo.step)
        jp removeIfOffScreen

    ENDMODULE
