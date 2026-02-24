    MODULE Panel

; Energy characters
energyChars:  ; #d03d
        db "(((****,,,,,,,,,,"  ; energy full, they look all the same

; Print energy in the panel
; Used by c_d09a, c_d0af, c_d1c1, c_e9b1 and c_f618.
printEnergy:  ; #d04e
        ld hl, State.energyText
        push hl
        ld b, 17
.l_0:
        ld (hl), " "
        inc hl
        djnz .l_0

        pop hl
        ld de, energyChars
        ld a, (State.energy)
        ld c, a
        cp 2
        jr C, .l_2

        srl a
        ld b, a
.l_1:
        ld a, (de)
        ld (hl), a
        inc hl
        inc de
        djnz .l_1
.l_2:
        bit 0, c
        jr Z, .l_3
        ld a, (de)
        inc a
        ld (hl), a
        inc hl
.l_3:
        ld a, (State.energy)
        ld b, a
        ld a, (State.maxEnergy)
        sub b
        srl a
        jr Z, .l_5

        ld b, a
.l_4:
        ld (hl), "."            ; energy empty
        inc hl
        djnz .l_4
.l_5:
        ld hl, State.energyText + 16
        set 7, (hl)

        ld hl, _ROW 0 _COL 15
        ld de, State.energyText
        call Utils.printString
        call Panel.applyLifeIndicatorAttrs
        ret

    ENDMODULE
