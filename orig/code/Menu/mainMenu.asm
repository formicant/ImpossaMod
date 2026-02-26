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
        jr Z, .l_6              ; already set

        ld hl, Screen.attrs.row9 + 11
        xor a                   ; controlType: keyboard
        jr .l_5
.not1:
        bit Port.key2, a        ; select [2] (kempston)
        jr NZ, .not2

        exa
        cp 1
        jr Z, .l_6
        ld hl, Screen.attrs.row10 + 11
        ld a, 1                 ; controlType: kempston
        jr .l_5
.not2:
        bit Port.key3, a        ; select [3] (cursor)
        jr NZ, .l_4
        exa
        cp 2
        jr Z, .l_6
        ld hl, Screen.attrs.row11 + 11
        ld a, 2                 ; controlType: cursor
        jr .l_5
.l_4:
        bit Port.key4, a        ; select [4] (interface 2)
        jr NZ, .l_6
        exa
        cp 3
        jr Z, .l_6
        ld hl, Screen.attrs.row12 + 11
        ld a, 3                 ; controlType: interface 2
.l_5:
        ld (activeMenuItemAttrAddr), hl
        ld (Control.type), a

        call printMainMenuText
        call clampActiveMenuItemAttrs

.l_6:   ; change active item's colour
        ld hl, (activeMenuItemAttrAddr)
        ld b, 12
.l_7:
        ld a, (hl)
        inc a                   ; next ink colour
        cp Colour.brWhite + 1
        jr C, .l_8              ; if greater than bright white
        ld a, Colour.brBlue       ;   return to blue
.l_8:
        ld (hl), a
        inc l
        djnz .l_7

        ld bc, 20
        call Utils.delay              ; delay ~20 ms
        call Control.checkStartKey
        jp NZ, .menuLoop
.l_9:
        call Control.checkStartKey
        jr Z, .l_9

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
        ld hl, Screen.attrs.row9 + 9
        ld b, 5
.l_0:
        ld (hl), Colour.brWhite
        ld de, 32
        add hl, de
        djnz .l_0

        ; print last score
        ld hl, _ROW 15 _COL 7
        ld de, textLastScore
        ld c, Colour.brMagenta
        call Utils.printString

    IFDEF _MOD
        ld hl, Screen.pixels.row15 + 18
        jp Panel.printScoreAt
    ELSE
        ld hl, _ROW 15 _COL 18
        ld (Panel.printScore.yx), hl
        call Panel.printScore
        ld hl, _ROW 0 _COL 0
        ld (Panel.printScore.yx), hl
        ret
    ENDIF


; Checks attributes of the active menu item
; and sets them to bright blue if greater than bright white
clampActiveMenuItemAttrs:  ; #c7e1
        ld hl, (activeMenuItemAttrAddr)
        ld b, #0C
        ld a, (hl)
        cp Colour.brWhite + 1
        jr C, .l_0
        ld a, Colour.brBlue
.l_0:
        ld (hl), a
        inc l
        djnz .l_0
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
