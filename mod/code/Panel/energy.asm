    MODULE Panel

; Display energy in the panel
printEnergy:
        ld hl, Screen.pixels.row0 + 15
        ld e, 0

        ld a, (State.energy)
        ld d, a
.fullChar:
        ld a, e
        sub d
        jr Z, .empty
        inc a
        jr Z, .half

        ld a, '[' - '0'         ; energy full (font char code)
        call Utils.printChar
        inc l
    .2  inc e
        jp .fullChar

.half:
        ld a, '\' - '0'         ; energy half (font char code)
        call Utils.printChar
        inc l
    .2  inc e

.empty:
        ld a, (State.maxEnergy)
        ld d, a
.emptyChar:
        ld a, e
        cp d
        ret Z

        ld a, ']' - '0'         ; energy empty (font char code)
        call Utils.printChar
        inc l
    .2  inc e
        jp .emptyChar


; Used in the shop before printing item name and price
clearEnergy:
        ld hl, Screen.pixels.row0 + 15
        ld e, 17
.space:
        call Utils.printChar.space
        inc l
        dec e
        jr NZ, .space
        dec l

        ld h, high(Screen.attrs)
        ld b, 17
        ld a, Colour.brWhite
.attr:
        ld (hl), a
        dec l
        djnz .attr
        ret

    ENDMODULE
