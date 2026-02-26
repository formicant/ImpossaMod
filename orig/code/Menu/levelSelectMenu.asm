    MODULE Menu

textSelectLevel:  ; #d51e
        db "SELECT  LEVEL"C

levelNames:  ; #d52b
        db "KLONDIKE"C
        db " ORIENT "C
        db " AMAZON "C
        db "ICELAND "C
.bermuda
        db "BERMUDA "C

; Show level selection menu
levelSelectionMenu:  ; #d553
        call Utils.clearScreenPixels
        ld a, Colour.brWhite    ; bright white ink, black paper
        call Utils.fillScreenAttrs
        ld hl, _ROW 8 _COL 9
        ld de, textSelectLevel
        ld c, Colour.brYellow
        call Utils.printString
        ld hl, State.levelsDone
        ld b, #05
        xor a
.l_0:
        add (hl)
        inc hl
        djnz .l_0
        cp 5
        jp Z, gameWin
        cp 4
        jr NZ, .l_3
        ld de, levelNames.bermuda
        ld hl, _ROW 11 _COL 12
        ld c, Colour.brWhite
        call Utils.printString
        ld a, Level.bermuda
        ld (State.level), a
.l_1:
        ld a, (Control.state)
        bit Key.fire, a
        jr NZ, .l_1
.l_2:
        ld a, (Control.state)
        bit Key.fire, a
        jr Z, .l_2
        jp .l_7
.l_3:
        ld a, (Control.state)
        ld c, a
        ld a, (State.level)
        bit Key.down, c
        jr Z, .l_4
        dec a
        jr .l_5
.l_4:
        bit Key.up, c
        jr Z, .l_5
        inc a
.l_5:
        and #03
        ld (State.level), a
        ld l, a
        ld h, 0
        ld de, State.levelsDone
        add hl, de
        ld a, (hl)
        or a
        jr Z, .l_6
        ld a, (State.level)
        inc a
        jr .l_5
.l_6:
        ld a, (State.level)
    .3  add a
        ld l, a
        ld h, 0
        ld de, levelNames
        add hl, de
        ex de, hl
        ld hl, _ROW 11 _COL 12
        ld c, Colour.brWhite
        call Utils.printString
        ld bc, 250
        call Utils.delay
        ld a, (Control.state)
        bit Key.fire, a
        jr Z, .l_3
.l_7:
        call loadLevelIfNeeded
        jp NC, levelSelectionMenu
        ld a, Colour.black
        out (Port.general), a   ; set black border
        call Utils.clearScreenPixels
        ld hl, _ROW 14 _COL 11
        ld de, textPressFire
        ld c, Colour.brWhite
        call Utils.printString
.l_8:
        ld a, (Control.state)
        bit Key.fire, a
        jr Z, .l_8
        ret


; Tape messages
textLoadError:  ; #d606
        db "LOAD ERROR"C
textPressFire:  ; #d610
        db "PRESS FIRE"C
textStartTape:  ; #d61A
        db "START TAPE"C
textLoading:  ; #d624
        db " LOADING"C

; Load level if needed
loadLevelIfNeeded:  ; #d62c
        ld a, (State.loadedLevel)
        ld b, a
        ld a, (State.level)
        cp b
        jr NZ, .l_0
        scf
        ret
.l_0:
        call Utils.clearScreenPixels
        ld de, textStartTape
        ld hl, _ROW 12 _COL 11
        ld c, Colour.brWhite
        call Utils.printString
        call loadLevel
        jr NC, .l_1
        ld a, (State.level)
        ld (State.loadedLevel), a
        scf
        ret
.l_1:
        push af
        ld a, #FF
        ld (State.loadedLevel), a
        call Utils.clearScreenPixels
        ld hl, _ROW 12 _COL 11
        ld de, textLoadError
        ld c, Colour.brYellow
        call Utils.printString
        inc de
        ld hl, _ROW 14 _COL 11
        ld c, Colour.brWhite
        call Utils.printString
.l_2:
        ld a, (Control.state)
        bit Key.fire, a
        jr Z, .l_2
        pop af
        ret

    ENDMODULE
