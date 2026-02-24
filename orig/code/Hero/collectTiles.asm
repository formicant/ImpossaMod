    MODULE Hero

; Get one central tile below the object and store it in the state
; Used by c_dbfc.
collectCentreTileBelow:  ; #dce1
        ld a, (ix+Obj.x)
        add 12
        ld (ix+Obj.x), a
        ld a, (ix+Obj.y)
        add 21
        ld (ix+Obj.y), a

        call Tiles.getScrTileAddr
        ld a, (hl)
        ld (State.tileFootC), a

        ld a, (ix+Obj.x)
        add -12
        ld (ix+Obj.x), a
        ld a, (ix+Obj.y)
        add -21
        ld (ix+Obj.y), a
        ret

; Get two tiles below the object and store them in the state
; Used by c_da95 and c_db4e.
collectTwoTilesBelow:  ; #dd09
        ld a, (ix+Obj.x)
        add 6
        ld (ix+Obj.x), a
        ld a, (ix+Obj.x+1)
        adc a, 0
        ld (ix+Obj.x+1), a
        ld a, (ix+Obj.y)
        add 24
        ld (ix+Obj.y), a

        call Tiles.getScrTileAddr
        ld a, (hl)
        ld (State.tileFootL), a
        inc hl
        ld a, (hl)
        ld (State.tileFootR), a

        ld a, (ix+Obj.x)
        add -6
        ld (ix+Obj.x), a
        ld a, (ix+Obj.x+1)
        adc a, -1
        ld (ix+Obj.x+1), a
        ld a, (ix+Obj.y)
        add -24
        ld (ix+Obj.y), a
        ret

; Get tiles above the object and store them in the state
;   arg `ix`: object
; Used by c_da95 and c_dbfc.
collectTilesAbove:  ; #dd46
        ld a, (ix+Obj.x)
        add 6
        ld (ix+Obj.x), a
        ld a, (ix+Obj.y)
        add -1
        ld (ix+Obj.y), a

        call Tiles.getScrTileAddr
        ld a, (hl)
        ld (State.tileAbovL), a
        inc hl
        ld a, (hl)
        ld (State.tileAbovR), a

        ld a, (ix+Obj.x)
        add -6
        ld (ix+Obj.x), a
        ld a, (ix+Obj.y)
        add 1
        ld (ix+Obj.y), a
        ret

; Get tiles behind different parts of the object and store them in the state
;   arg `ix`: object
; Used by c_d709.
collectStateTiles:  ; #dd73
        ld a, (ix+Obj.x)
        add 4
        ld (ix+Obj.x), a
        ld a, (ix+Obj.x+1)
        adc a, 0
        ld (ix+Obj.x+1), a

        call Tiles.getScrTileAddr
        ld bc, 44
        ld a, (hl)
        ld (State.tileTopL), a
        add hl, bc              ; move down
        ld a, (hl)
        ld (State.tileMidL), a
        add hl, bc              ; move down
        ld a, (hl)
        ld (State.tileBotL), a
        add hl, bc              ; move down
        ld a, (hl)
        ld (State.tileUndrL), a

        ld a, (ix+Obj.x)
        add 12
        ld (ix+Obj.x), a
        ld a, (ix+Obj.x+1)
        adc a, 0
        ld (ix+Obj.x+1), a

        call Tiles.getScrTileAddr
        ld bc, 44
        ld a, (hl)
        ld (State.tileTopR), a
        add hl, bc              ; move down
        ld a, (hl)
        ld (State.tileMidR), a
        add hl, bc              ; move down
        ld a, (hl)
        ld (State.tileBotR), a
        add hl, bc              ; move down
        ld a, (hl)
        ld (State.tileUndrR), a

        ld a, (ix+Obj.x)
        add -10
        ld (ix+Obj.x), a
        ld a, (ix+Obj.x+1)
        adc a, -1
        ld (ix+Obj.x+1), a

        ld a, (ix+Obj.y)
        add 21
        ld (ix+Obj.y), a

        call Tiles.getScrTileAddr
        ld a, (hl)
        ld (State.tileFootL), a
        inc hl                  ; move right
        ld a, (hl)
        ld (State.tileFootR), a

        ld a, (ix+Obj.x)
        add 6
        ld (ix+Obj.x), a
        ld a, (ix+Obj.x+1)
        adc a, 0
        ld (ix+Obj.x+1), a

        ld a, (ix+Obj.y)
        add -8
        ld (ix+Obj.y), a

        call Tiles.getScrTileAddr
        ld a, (hl)
        ld (State.tileCentre), a
        add hl, bc              ; move down
        ld a, (hl)
        ld (State.tileFootC), a

        ld a, (ix+Obj.x)
        add -12
        ld (ix+Obj.x), a
        ld a, (ix+Obj.x+1)
        adc a, -1
        ld (ix+Obj.x+1), a

        ld a, (ix+Obj.y)
        add -13
        ld (ix+Obj.y), a

        ld a, (ix+Obj.y)
        and 7
        cp 3
        jr NZ, .l_0

        xor a
        ld (State.tileUndrL), a
        ld (State.tileUndrR), a
        ret
.l_0:
        ret


; Check if tiles to the left are impenetrable
;   arg `ix`: hero
;   ret `a`: #FF and flag NZ if true, `a`: 0 and flag Z if false
; Used by c_d308, c_d709, c_d7f6, c_d94c, c_da95, c_db4e and c_dbfc.
isObstacleToTheLeft:  ; #de37
        ld l, (ix+Obj.x+0)
        ld h, (ix+Obj.x+1)
        ld de, -32
        add hl, de
        jr NC, .true             ; x < 32

        ; x >= 32
        ld a, (State.heroState)
        cp HeroState.climb
        jr NZ, .climbing

        ld a, (State.tileTopL)
        call Tiles.getTileType
        cp TileType.platform
        jr NC, .true
        ld a, (State.tileMidL)
        call Tiles.getTileType
        cp TileType.platform
        jr NC, .true
        ld a, (State.tileBotL)
        call Tiles.getTileType
        cp TileType.platform
        jr NC, .true
        ld a, (State.tileUndrL)
        call Tiles.getTileType
        cp TileType.platform
        jr NC, .true
        jp .false

.climbing:
        ld a, (State.tileTopL)
        call Tiles.getTileType
        cp TileType.wall
        jr NC, .true
        ld a, (State.tileMidL)
        call Tiles.getTileType
        cp TileType.wall
        jr NC, .true
        ld a, (State.tileBotL)
        call Tiles.getTileType
        cp TileType.wall
        jr NC, .true

        ld a, (State.heroState)
        cp HeroState.jump
        jr NZ, .false
        ld a, (State.jumpVel)
        or a
        jp M, .false            ; moving upwards

        ld a, (State.tileUndrR)
        call Tiles.getTileType
        cp TileType.wall
        jr NC, .true

.false:
        xor a
        ret
.true:
        ld a, #FF
        or a
        ret


; Check if tiles to the right are impenetrable
;   arg `ix`: hero
;   ret `a`: #FF and flag NZ if true, `a`: 0 and flag Z if false
; Used by c_d308, c_d709, c_d7f6, c_d94c, c_da95, c_db4e and c_dbfc.
isObstacleToTheRight:  ; #deb1
        ld l, (ix+Obj.x+0)
        ld h, (ix+Obj.x+1)
        ld de, -252
        add hl, de
        jr C, .true

        ld a, (State.heroState)
        cp HeroState.climb
        jr NZ, .climbing

        ld a, (State.tileTopR)
        call Tiles.getTileType
        cp TileType.platform
        jr NC, .true
        ld a, (State.tileMidR)
        call Tiles.getTileType
        cp TileType.platform
        jr NC, .true
        ld a, (State.tileBotR)
        call Tiles.getTileType
        cp TileType.platform
        jr NC, .true
        ld a, (State.tileUndrR)
        call Tiles.getTileType
        cp TileType.platform
        jr NC, .true
        jp .false

.climbing:
        ld a, (State.tileTopR)
        call Tiles.getTileType
        cp TileType.wall
        jr NC, .true
        ld a, (State.tileMidR)
        call Tiles.getTileType
        cp TileType.wall
        jr NC, .true
        ld a, (State.tileBotR)
        call Tiles.getTileType
        cp TileType.wall
        jr NC, .true
        ld a, (State.heroState)
        cp HeroState.jump
        jr NZ, .false
        ld a, (State.jumpVel)
        or a
        jp M, .false            ; moving upwards
        ld a, (State.tileUndrR)
        call Tiles.getTileType
        cp TileType.wall
        jr NC, .true

.false:
        xor a
        ret
.true:
        ld a, #FF
        or a
        ret

    ENDMODULE
