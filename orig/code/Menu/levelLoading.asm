    MODULE Menu

textFound:
        db "FOUND"C


; Load selected level from tape
;   `State.level`: selected level
; returns:
;   flag C: success, NC: error
; disables interrupts
loadLevel:
    IFDEF _MOD
        ld a, (State.is48k)
        or a
        jp Z, Utils.loadLevelFromMemory
    ENDIF

        ; load level header
        di
        ld ix, Level.start
        ld de, 1                ; header length
        scf
        ld a, #80               ; non-standard header flag
        call Utils.loadBytes
        jr C, .found
        ei
        ret                     ; error

.found:
        call Utils.clearScreenPixels
        ld hl, _ROW 12 _COL 9
        ld de, textFound
        ld c, Colour.brWhite
        call Utils.printString

        ld a, (Level.start)     ; found level index
    .3  add a
        ld l, a
        ld h, 0
        ld de, levelNames
        add hl, de
        ex de, hl               ; `de`: level name addr

        ld hl, _ROW 12 _COL 15
        ld c, Colour.brYellow
        call Utils.printString

        ld a, (Level.start)     ; found level index
        ld b, a
        ld a, (State.level)     ; selected level
        cp b
        jr NZ, loadLevel        ; skip and load another level

        ; load level data block
        ld ix, Level.start
        ld de, Level.length
        scf
        ld a, #FF               ; code block flag
        call Utils.loadBytes
        ei
        ret

    ENDMODULE
