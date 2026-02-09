    MODULE Code


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
; Used by c_cc25.
levelSelectionMenu:  ; #d553
        call clearScreenPixels
        ld a, Colour.white      ; bright white ink, black paper
        call fillScreenAttrs
        ld hl, #0809
        ld de, textSelectLevel
        ld c, Colour.yellow
        call printString
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
        ld hl, #0B0C
        ld c, Colour.white
        call printString
        ld a, #04
        ld (State.level), a
.l_1:
        ld a, (controlState)
        bit 4, a
        jr NZ, .l_1
.l_2:
        ld a, (controlState)
        bit 4, a
        jr Z, .l_2
        jp .l_7
.l_3:
        ld a, (controlState)
        ld c, a
        ld a, (State.level)
        bit 2, c
        jr Z, .l_4
        dec a
        jr .l_5
.l_4:
        bit 3, c
        jr Z, .l_5
        inc a
.l_5:
        and #03
        ld (State.level), a
        ld l, a
        ld h, #00
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
        add a
        add a
        add a
        ld l, a
        ld h, #00
        ld de, levelNames
        add hl, de
        ex de, hl
        ld hl, #0B0C
        ld c, Colour.white
        call printString
        ld bc, #00FA
        call delay
        ld a, (controlState)
        bit 4, a
        jr Z, .l_3
.l_7:
        call loadLevelIfNeeded
        jp NC, levelSelectionMenu
        ld a, #00
        out (#FE), a
        call clearScreenPixels
        ld hl, #0E0B
        ld de, textPressFire
        ld c, Colour.white
        call printString
.l_8:
        ld a, (controlState)
        bit 4, a
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
; Used by c_d553.
loadLevelIfNeeded:  ; #d62c
        ld a, (State.loadedLevel)
        ld b, a
        ld a, (State.level)
        cp b
        jr NZ, .l_0
        scf
        ret
.l_0:
        call clearScreenPixels
        ld de, textStartTape
        ld hl, #0C0B
        ld c, Colour.white
        call printString
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
        call clearScreenPixels
        ld hl, #0C0B
        ld de, textLoadError
        ld c, Colour.yellow
        call printString
        inc de
        ld hl, #0E0B
        ld c, Colour.white
        call printString
.l_2:
        ld a, (controlState)
        bit 4, a
        jr Z, .l_2
        pop af
        ret


    ENDMODULE
