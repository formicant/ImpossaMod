    MODULE Panel

soupCanStrings:
.one:   db "/  "C
.two:   db "// "C
.three: db "///"C

; Print soup cans in the panel
; Used by c_d1c1, c_e6e1 and c_e9b1.
printSoupCans:  ; #d026
        ld a, (State.soupCans)
        dec a
        ld l, a
        add a
        add l
        ld l, a
        ld h, #00
        ld de, soupCanStrings
        add hl, de
        ex de, hl
        ld hl, #0007
        ld c, Colour.brMagenta
        jp Utils.printString

    ENDMODULE
