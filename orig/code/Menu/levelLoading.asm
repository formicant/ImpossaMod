    MODULE Menu

textFound:  ; #c9a7
        db "FOUND"C

; Load level from tape
loadLevel:  ; #c9ac
    IFDEF _MOD
        ld a, (Sound.is48k)
        or a
        jp Z, Utils.loadBytes
    ENDIF

        di
        ld ix, Level.start
        ld de, 1                ; header length
        scf
        ld a, #80               ; non-standard header flag
        call Utils.loadBytes
        jr C, .found
        ei
        ret
.found:
        call Utils.clearScreenPixels
        ld hl, _ROW 12 _COL 9
        ld de, textFound
        ld c, Colour.brWhite
        call Utils.printString

        ld a, (Level.start)     ; found level
    .3  add a
        ld l, a
        ld h, 0
        ld de, levelNames
        add hl, de
        ex de, hl               ; `de`: level name

        ld hl, _ROW 12 _COL 15
        ld c, Colour.brYellow
        call Utils.printString

        ld a, (Level.start)     ; found level
        ld b, a
        ld a, (State.level)     ; selected level
        cp b
        jr NZ, loadLevel        ; don't load

        ld ix, Level.start
        ld de, Level.length
        scf
        ld a, #FF               ; code block flag
        call Utils.loadBytes
        ei
        ret

    ENDMODULE
