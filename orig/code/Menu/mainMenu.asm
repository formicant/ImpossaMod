    MODULE Menu

; Attribute address of active menu item
activeMenuItemAttrAddr:  ; #c6d3
        dw Screen.attrs.row9 _COL 11


; Show the main menu and let the user select options
mainMenu:  ; #c6d5
        xor a
        call Sound.callPlayMenuMusic

        call Utils.clearScreenPixels
        ld a, Colour.brWhite    ; bright white ink, black paper
        call Utils.fillScreenAttrs
        ld a, Colour.black
        out (Port.general), a   ; set black border

        call printMainMenuText
        call clampActiveMenuItemAttrs

.menuLoop:
        call Sound.hasMusicEnded
        jr NZ, .musicNotEnded
        xor a
        call Sound.callPlayMenuMusic
.musicNotEnded:

        ld a, (Control.type)

        ; check keys
        exa
        ld bc, Port.keys_12345
        in a, (c)
        and Port.keyMask

        bit Port.key1, a        ; select [1] (keyboard)
        jr NZ, .not1
        exa
        or a
        jr Z, .highlight        ; `a` = ControlType.keyboard
        ld hl, Screen.attrs.row9 _COL 11
        xor a                   ; `a`: ControlType.keyboard
        jr .select
.not1:
        bit Port.key2, a        ; select [2] (kempston)
        jr NZ, .not2
        exa
        cp ControlType.kempston
        jr Z, .highlight
        ld hl, Screen.attrs.row10 _COL 11
        ld a, ControlType.kempston
        jr .select
.not2:
        bit Port.key3, a        ; select [3] (cursor)
        jr NZ, .not3
        exa
        cp ControlType.cursor
        jr Z, .highlight
        ld hl, Screen.attrs.row11 _COL 11
        ld a, ControlType.cursor
        jr .select
.not3:
        bit Port.key4, a        ; select [4] (interface 2)
        jr NZ, .highlight
        exa
        cp ControlType.interface2
        jr Z, .highlight
        ld hl, Screen.attrs.row12 _COL 11
        ld a, ControlType.interface2

.select:
        ld (activeMenuItemAttrAddr), hl
        ld (Control.type), a
        call printMainMenuText
        call clampActiveMenuItemAttrs

.highlight:
        ; change active item's colour
        ld hl, (activeMenuItemAttrAddr)
        ld b, 12
.char:
        ld a, (hl)
        inc a                   ; next ink colour
        cp Colour.brWhite + 1
        jr C, .setColour        ; if greater than bright white
        ld a, Colour.brBlue     ;   return to blue
.setColour:
        ld (hl), a
        inc l
        djnz .char

        ld bc, 20
        call Utils.delay        ; delay ~1 frame

        call Control.checkStartKey
        jp NZ, .menuLoop

.startKeyPressed:
        call Control.checkStartKey
        jr Z, .startKeyPressed

        ld a, 1
        call Sound.callPlayMenuMusic
        ret


; Print game menu text
printMainMenuText:  ; #c76f
        ld hl, _ROW 4 _COL 10
        ld de, gameMenuText     ; 'impossamole'
        ld c, Colour.brWhite
        call Utils.printString

        ld hl, _ROW 22 _COL 5
        inc de                  ; '@ 1990 gremlin graphics'
        ld c, Colour.brCyan
        call Utils.printString

        ld hl, _ROW 8 _COL 9
        inc de                  ; '0 start game'
        ld c, Colour.brWhite
        call Utils.printString

        ld hl, _ROW 9 _COL 9
        inc de                  ; '1 keyboard'
        ld c, Colour.brYellow
        call Utils.printString

        ld hl, _ROW 10 _COL 9
        inc de                  ; '2 kempston'
        ld c, Colour.brMagenta
        call Utils.printString

        ld hl, _ROW 11 _COL 9
        inc de                  ; '3 cursor'
        ld c, Colour.brGreen
        call Utils.printString

        ld hl, _ROW 12 _COL 9
        inc de                  ; '4 interface 2'
        ld c, Colour.brCyan
        call Utils.printString

        ld hl, _ROW 19 _COL 5
        inc de                  ; 'written by core design'
        ld c, Colour.brGreen
        call Utils.printString

        ; make digits (0..4) white
        ld hl, Screen.attrs.row9 _COL 9
        ld b, 5
.row:
        ld (hl), Colour.brWhite
        ld de, 32
        add hl, de
        djnz .row

        ; print last score
        ld hl, _ROW 15 _COL 7
        ld de, textLastScore
        ld c, Colour.brMagenta
        call Utils.printString

    IFDEF _MOD
        ld hl, Screen.pixels.row15 _COL 18
        jp Panel.printScoreAt
    ELSE
        ld hl, _ROW 15 _COL 18
        ld (Panel.printScore.yx), hl
        call Panel.printScore
        ld hl, _ROW 0 _COL 0
        ld (Panel.printScore.yx), hl
        ret
    ENDIF


; Check attributes of the active menu item
; and set them to bright blue if greater than bright white
clampActiveMenuItemAttrs:  ; #c7e1
        ld hl, (activeMenuItemAttrAddr)
        ld b, 12
        ld a, (hl)
        cp Colour.brWhite + 1
        jr C, .setColour
        ld a, Colour.brBlue
.setColour:
        ld (hl), a
        inc l
        djnz .setColour
        ret


gameMenuText:  ; #c7f2
        db "IMPOSSAMOLE"C
        db "@ 1990 GREMLIN GRAPHICS"C
        db "0 START GAME"C
        db "1 KEYBOARD"C
        db "2 KEMPSTON"C
        db "3 CURSOR"C
        db "4 INTERFACE 2"C
        db "WRITTEN BY CORE DESIGN"C

textLastScore:
        db "LAST SCORE"C

    ENDMODULE
