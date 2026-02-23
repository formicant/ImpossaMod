    MODULE Code

; Init level / game state
; Used by c_cc25.
initLevel:  ; #d1c1
        ld a, 1
        ld (State.soupCans), a
        ld a, (State.maxEnergy)
        ld (State.energy), a
        xor a
        ld (State.coins), a
        ld (State.weapon), a

    IFNDEF _MOD
        ; panel info
        call Panel.printCoinCount
        call Panel.printScore
        call Panel.printEnergy
        call Panel.printSoupCans
    ENDIF

        xor a
        ld (State.bossFight), a
        ld (State.inShop), a
        ld (State.bossKilled), a
        inc a
        ld (State.hasSmart), a

    IFDEF _MOD
        call Panel.printPanel
    ENDIF

        ; set hero's start position
        ld a, (State.level)
    .2  add a
        ld l, a
        ld h, 0
        ld de, startPositions
        add hl, de

        ld b, (hl)              ; start x coord, blocks
        inc hl
        ld c, (hl)              ; start y coord, blocks
        push bc
        inc hl
        ld a, (hl)              ; map span start, blocks
        inc hl
        ld l, (hl)              ; map span end, blocks
        ld h, 0
    .2  add hl, hl
        ex de, hl
        ld l, a
        ld h, 0
    .2  add hl, hl
        ; `hl`: map span start, tiles
        ; `de`: map span end, tiles
        call moveToMapSpan

        pop bc                  ; hero's start position, blocks
        call initHero
        ret

    ENDMODULE
