    MODULE Enemy

; Press vertical speed by walk phase (22 phases)
pressSpeedTable:  ; #f2d1
        db 0, 1, 1, 1, 1, 2, 2, 2, 3, 3, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4

; Move a press or a platform
;   arg `ix`: press/platform object
pressPlatformMotion:  ; #f2e7
        ld a, (ix+Obj.mo.horizSpeed)
        or a
        jr Z, .vertical

        ; horizontal slow down
        dec (ix+Obj.mo.horizSpeed)
        ret

.vertical:
        bit Dir.down, (ix+Obj.mo.direction)
        jr NZ, .down

.notDown:
        ld a, (ix+Obj.walkPhase)
        or a
        jr NZ, .up

        ; change direction to horizontal
        ld (ix+Obj.mo.direction), 1<<Dir.down
        ld (ix+Obj.mo.vertSpeed), 0
        ld (ix+Obj.mo.horizSpeed), 32
        ret

.up:
        dec (ix+Obj.walkPhase)
        ld a, (ix+Obj.y)
        and %00000111
        jr NZ, .setVertSpeed

        ; clear press piston tiles
        call Tiles.getScrTileAddr
        inc hl
        ld (hl), 0
        inc hl
        ld (hl), 0
        ; set tile update
        ld de, Tables.scrTileUpd - Tables.scrTiles - 2
        add hl, de
        ld (hl), 1
        inc hl
        ld (hl), 1
        jr .setVertSpeed

.down:
        inc (ix+Obj.walkPhase)

        ; draw press piston tiles
        call Tiles.getScrTileAddr
        ; tile index
        ld c, 189
        ld a, (State.level)
        cp Level.iceland
        jr NZ, .drawPiston
        dec c
.drawPiston:
        inc hl
        ld (hl), c
        inc hl
        inc c                   ; next tile index
        ld (hl), c
        ; set tile update
        ld de, Tables.scrTileUpd - Tables.scrTiles - 2
        add hl, de
        ld (hl), 1
        inc hl
        ld (hl), 1

        ld a, (ix+Obj.y)
        and %00000111
        jr NZ, .setVertSpeed

        call Tiles.getScrTileAddr
        ld de, 44 + 1
        add hl, de
        ld a, (hl)
        call Tiles.getTileType
        or a
        jr NZ, .bottomReached

.setVertSpeed:
        ld a, (ix+Obj.walkPhase)
        ld l, a
        ld h, 0
        ld de, pressSpeedTable
        add hl, de
        ld a, (hl)
        ld (ix+Obj.mo.vertSpeed), a
        ret

.bottomReached:
        ; start moving up
        ld (ix+Obj.mo.direction), 1<<Dir.up
        ld (ix+Obj.mo.vertSpeed), 0
        ret

    ENDMODULE
