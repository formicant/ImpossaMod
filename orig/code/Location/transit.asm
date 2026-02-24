    MODULE Location

; Check if the hero enters a transit
; Used by c_cc25.
checkTransitEnter:  ; #e60a
        ld ix, Scene.hero
        ld a, (State.jumpPhase)
        ld (State.tmpJumpPh), a

        ld a, (ix+Obj.y)
        ld (State.tmpY), a
        cp 11
        jp C, .up
        cp 224
        jr NC, .down
        ret
.up:
        xor a
        exa
        ld (ix+Obj.y), 224      ; appear from the bottom
        xor a
        ld (State.jumpPhase), a
        jr .l_2
.down:
        ld a, 1
        exa
        ld (ix+Obj.y), 12       ; appear from the top

.l_2:
        ld de, Level.transitTable
        ld l, (ix+Obj.x+0)
        ld h, (ix+Obj.x+1)
        ld bc, -22
        add hl, bc
    DUP 3
        sra h
        rr l
    EDUP
        ; `hl`: screen x coord in tiles
        ld bc, (State.screenX)
        add hl, bc
    DUP 2
        sra h
        rr l
    EDUP
        ld (.mapX), hl          ; map x coord in blocks

.findTransit:
        exa
        ld c, a                 ; 0: up, 1: down
        exa
        ld a, (de)              ; isDown
        cp c
        jr NZ, .next
        inc de
        ld a, (de)              ; fromX (low)
        ld c, a
        inc de
        ld a, (de)              ; fromX (high)
        ld b, a
        xor a
.mapX+* ld hl, -0
        sbc hl, bc
        jr Z, .found
    .2  dec de
.next:
        ld hl, Transit          ; struct size
        add hl, de
        ex de, hl
        ld a, (de)
        or a
        jp P, .findTransit

.notFound:
        ld a, (State.tmpY)
        ld (ix+Obj.y), a
        ld a, (State.tmpJumpPh)
        ld (State.jumpPhase), a
        ret

.found:
        ld a, 60
        ld (State.bulletTime), a
        call Scene.removeObjects

        ld hl, 5
        add hl, de
        ld a, (hl)              ; toX
    .5  add a
        add 32
        ld (ix+Obj.x+0), a
        ld (ix+Obj.x+1), 0

        ld de, -4
        add hl, de
        ld e, (hl)              ; toStart (low)
        inc hl
        ld d, (hl)              ; toStart (high)
        inc hl
        ld a, (hl)              ; toEnd (low)
        inc hl
        ld h, (hl)              ; toEnd (high)
        ld l, a
    .2  add hl, hl
        ex de, hl
    .2  add hl, hl
        ; `hl`: toStart in tiles, `de`: toEnd in tiles
        call Scene.removeObjects      ; unnecessary
        call moveToMapSpan
        xor a
        ret

    ENDMODULE
