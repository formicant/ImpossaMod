    MODULE Panel

; Display an icon on the panel if there is smart capability
printSmart:
        ld hl, Screen.pixels.row0 + 0
        ld a, (State.hasSmart)
        or a
        ld a, -1                ; space
        jp Z, Utils.printChar
        ld a, ';' - '0'         ; smart (font char code)
        jp Utils.printChar


; Display soup cans in the panel (right to left)
printSoupCans:
        ld hl, Screen.pixels.row0 + 9
        ld a, (State.soupCans)
        ld e, a
.can:
        ld a, ':' - '0'         ; soup can char code
        call Utils.printChar
        dec l
        dec e
        jp NZ, .can
        ret

    ENDMODULE
