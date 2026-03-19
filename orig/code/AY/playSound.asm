    MODULE AY

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
        ; `hl`: `a` * 13
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
