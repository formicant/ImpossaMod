    MODULE Menu

textSelectLevel:
        db "SELECT  LEVEL"C

levelNames:
        db "KLONDIKE"C
        db " ORIENT "C
        db " AMAZON "C
        db "ICELAND "C
.bermuda:
        db "BERMUDA "C


; Show level selection menu and let the user select a level
levelSelectionMenu:
        call Utils.clearScreenPixels
        ld a, Colour.brWhite    ; bright white ink, black paper
        call Utils.fillScreenAttrs

        ld hl, _ROW 8 _COL 9
        ld de, textSelectLevel
        ld c, Colour.brYellow
        call Utils.printString

        ld hl, State.levelsDone
        ld b, Level.count
        xor a
.isLevelDone:
        add (hl)
        inc hl
        djnz .isLevelDone

        cp Level.bermuda + 1
        jp Z, gameWin

        cp Level.bermuda
        jr NZ, .selectLevel

        ; all but Bermuda done
        ld de, levelNames.bermuda
        ld hl, _ROW 11 _COL 12
        ld c, Colour.brWhite
        call Utils.printString

        ld a, Level.bermuda
        ld (State.level), a
.waitFirePress:
        ld a, (Control.state)
        bit Key.fire, a
        jr NZ, .waitFirePress
.waitFireRelease:
        ld a, (Control.state)
        bit Key.fire, a
        jr Z, .waitFireRelease
        jp .startLevel

.selectLevel:
        ld a, (Control.state)
        ld c, a
        ld a, (State.level)
        bit Key.down, c
        jr Z, .notDown
        ; down
        dec a                   ; previous level
        jr .checkLevel
.notDown:
        bit Key.up, c
        jr Z, .checkLevel
        ; up
        inc a                   ; next level

.checkLevel:
        and %00000011           ; mod 4
        ld (State.level), a

        ; check if the level is already done
        ld l, a
        ld h, 0
        ld de, State.levelsDone
        add hl, de
        ld a, (hl)
        or a
        jr Z, .printLevelName
        ld a, (State.level)
        inc a                   ; next level
        jr .checkLevel

.printLevelName:
        ld a, (State.level)
    .3  add a
        ld l, a
        ld h, 0
        ld de, levelNames
        add hl, de
        ex de, hl
        ; `de`: level name addr
        ld hl, _ROW 11 _COL 12
        ld c, Colour.brWhite
        call Utils.printString

        ld bc, 250
        call Utils.delay

        ld a, (Control.state)
        bit Key.fire, a
        jr Z, .selectLevel

.startLevel:
        call loadLevelIfNeeded
        ; if loading error
        jp NC, levelSelectionMenu

        ld a, Colour.black
        out (Port.general), a   ; set black border
        call Utils.clearScreenPixels

        ld hl, _ROW 14 _COL 11
        ld de, textPressFire
        ld c, Colour.brWhite
        call Utils.printString

.waitFire:
        ld a, (Control.state)
        bit Key.fire, a
        jr Z, .waitFire
        ret


; Messages
textLoadError:
        db "LOAD ERROR"C
textPressFire:
        db "PRESS FIRE"C
textStartTape:
        db "START TAPE"C
textLoading:
        db " LOADING"C


; Load level if needed
loadLevelIfNeeded:
        ld a, (State.loadedLevel)
        ld b, a
        ld a, (State.level)
        cp b
        jr NZ, .loadingNeeded

        ; already loaded
        scf                     ; no error
        ret

.loadingNeeded:
        call Utils.clearScreenPixels
        ld de, textStartTape
        ld hl, _ROW 12 _COL 11
        ld c, Colour.brWhite
        call Utils.printString

        call loadLevel
        jr NC, .error
        ld a, (State.level)
        ld (State.loadedLevel), a
        scf                     ; no error
        ret

.error:
        push af
        ld a, -1                ; no level loaded
        ld (State.loadedLevel), a

        call Utils.clearScreenPixels
        ld hl, _ROW 12 _COL 11
        ld de, textLoadError
        ld c, Colour.brYellow
        call Utils.printString

        inc de                  ; `textPressFire`
        ld hl, _ROW 14 _COL 11
        ld c, Colour.brWhite
        call Utils.printString

.waitFire:
        ld a, (Control.state)
        bit Key.fire, a
        jr Z, .waitFire

        pop af                  ; flag C (error)
        ret

    ENDMODULE
