    MODULE Enemy

; Get tile types behind different parts of the object and store them in the state
;   arg `ix`: object
; Used by c_ed08, c_ef72, c_f0f3 and c_f518.
collectTileTypes:  ; #f1d7
        bit Flag.isBig, (ix+Obj.flags)
        jr NZ, .big

.small:
        ; x + 8, y
        ld a, (ix+Obj.x+0)
        add 8
        ld (ix+Obj.x+0), a
        ld a, (ix+Obj.x+1)
        adc a, 0
        ld (ix+Obj.x+1), a
        call Tiles.getScrTileAddr
        ld a, (hl)
        call Tiles.getTileType
        ld (State.tTypeTop), a

        ; x + 8, y + 16
        ld de, 44 * 2           ; 2 tiles down
        add hl, de
        ld a, (hl)
        call Tiles.getTileType
        ld (State.tTypeBot), a

        ; x, y + 8
        ld a, (ix+Obj.x+0)
        add -8
        ld (ix+Obj.x+0), a
        ld a, (ix+Obj.x+1)
        adc a, -1
        ld (ix+Obj.x+1), a
        call Tiles.getScrTileAddr
        ld de, 44               ; 1 tile down
        add hl, de
        ld a, (hl)
        call Tiles.getTileType
        ld (State.tTypeLeft), a

        ; x + 16, y + 8
    .2  inc hl                  ; 2 tiles right
        ld a, (hl)
        call Tiles.getTileType
        ld (State.tTypeRight), a

        ; x, y + 16
        ld de, 44 - 2           ; 2 tiles down, 2 tiles left
        add hl, de
        ld a, (hl)
        call Tiles.getTileType
        ld (State.tTypeBotL), a

        ; x + 16, y + 16
    .2  inc hl                  ; 2 tiles right
        ld a, (hl)
        call Tiles.getTileType
        ld (State.tTypeBotR), a

        ret

.big:
        ; x + 12|8, y
        ld a, (ix+Obj.x+0)
        add 12
        ld (ix+Obj.x+0), a
        ld a, (ix+Obj.x+1)
        adc a, 0
        ld (ix+Obj.x+1), a
        call Tiles.getScrTileAddr
        ld a, (ix+Obj.x+0)
        add -12
        ld (ix+Obj.x+0), a
        ld a, (ix+Obj.x+1)
        adc a, -1
        ld (ix+Obj.x+1), a
        bit Dir.left, (ix+Obj.mo.direction)
        jr NZ, .l_1
        dec hl                  ; 1 tile left
.l_1:
        ld a, (hl)
        call Tiles.getTileType
        ld (State.tTypeTop), a

        ; (x + 12|8)|(x + 20|8), y + 24 (?)
        ld de, 44 * 3           ; 3 tiles down
        add hl, de
        ld a, (hl)
        call Tiles.getTileType
        ld (State.tTypeBot), a
        inc hl                  ; 1 tile right
        bit Dir.left, (ix+Obj.mo.direction)
        jr NZ, .l_2
        dec hl                  ; 1 tile left
.l_2:
        ld a, (hl)
        call Tiles.getTileType
        ld c, a
        ld a, (State.tTypeBot)
        or c
        ld (State.tTypeBot), a

        ; x, y + 16
        call Tiles.getScrTileAddr
        ld a, (ix+Obj.objType)
        cp ObjType.amazon.crocodile
        jr Z, .l_3
        ld de, 44 * 2           ; 2 tiles down
        add hl, de
.l_3:
        ld a, (hl)
        call Tiles.getTileType
        ld (State.tTypeLeft), a

        ; x + 24, y + 16
    .3  inc hl                  ; 3 tiles right
        ld a, (hl)
        call Tiles.getTileType
        ld (State.tTypeRight), a

        ; x, y + 24
        ld de, 44 - 3           ; 1 tile down, 3 tiles left
        ld a, (ix+Obj.objType)
        cp ObjType.klondike.emptyMineCart
        jr Z, .l_4
        cp ObjType.klondike.fullMineCart
        jr NZ, .l_5
.l_4:
        ld de, 44 * 2 - 3       ; 2 tiles down, 3 tiles left
.l_5:
        add hl, de
        ld a, (hl)
        call Tiles.getTileType
        ld (State.tTypeBotL), a

        ; x + 24, y + 24
    .3  inc hl                  ; 3 tiles right
        ld a, (hl)
        call Tiles.getTileType
        ld (State.tTypeBotR), a

        ret

    ENDMODULE
