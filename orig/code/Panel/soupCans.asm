    MODULE Panel

soupCanStrings:
.one:   db "/  "C
.two:   db "// "C
.three: db "///"C

; Print soup cans in the panel
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
        ld hl, _ROW 0 _COL 7
        ld c, Colour.brMagenta
        jp Utils.printString

    ENDMODULE
