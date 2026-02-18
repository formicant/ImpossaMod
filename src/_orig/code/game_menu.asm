    MODULE Code


; Attribute address of active menu item
activeMenuItemAttrAddr:  ; #c6d3
        dw Screen.attrs.row9 + 11

; Game menu
; Used by c_cc25.
gameMenu:  ; #c6d5
        xor a
        call callPlayMenuMusic

        call clearScreenPixels
        ld a, Colour.brWhite    ; bright white ink, black paper
        call fillScreenAttrs
        ld a, 0
        out (Port.general), a   ; set border black

        call printGameMenuText
        call clampActiveMenuItemAttrs

.l_0:   ; menu loop
        call hasMusicEnded
        jr NZ, .l_1             ; skip if not ended
        xor a
        call callPlayMenuMusic
.l_1:
        ld a, (controlType)
        exa
        ld bc, Port.keys_54321
        in a, (c)
        and Port.keyMask
        bit Port.key1, a
        jr NZ, .l_2
        exa
        or a
        jr Z, .l_6
        ld hl, Screen.attrs.row9 + 11
        xor a                   ; controlType: keyboard
        jr .l_5
.l_2:
        bit 1, a                ; key [2] (kempston)
        jr NZ, .l_3
        exa
        cp 1
        jr Z, .l_6
        ld hl, Screen.attrs.row10 + 11
        ld a, 1                 ; controlType: kempston
        jr .l_5
.l_3:
        bit 2, a                ; key [3] (cursor)
        jr NZ, .l_4
        exa
        cp 2
        jr Z, .l_6
        ld hl, Screen.attrs.row11 + 11
        ld a, 2                 ; controlType: cursor
        jr .l_5
.l_4:
        bit 3, a                ; key [4] (interface 2)
        jr NZ, .l_6
        exa
        cp 3
        jr Z, .l_6
        ld hl, Screen.attrs.row12 + 11
        ld a, 3                 ; controlType: interface 2
.l_5:
        ld (activeMenuItemAttrAddr), hl
        ld (controlType), a

        call printGameMenuText
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
        call delay              ; delay ~20 ms
        call checkStartKey
        jp NZ, .l_0
.l_9:
        call checkStartKey
        jr Z, .l_9

        ld a, 1
        call callPlayMenuMusic
        ret

; Print game menu text
; Used by c_c6d5.
printGameMenuText:  ; #c76f
        ld hl, #040A
        ld de, gameMenuText     ; 'impossamole'
        ld c, Colour.brWhite
        call printString
        ld hl, #1605
        inc de                  ; '@ 1990 gremlin graphics'
        ld c, Colour.brCyan
        call printString
        ld hl, #0809
        inc de                  ; '0 start game'
        ld c, Colour.brWhite
        call printString
        ld hl, #0909
        inc de                  ; '1 keyboard'
        ld c, Colour.brYellow
        call printString
        ld hl, #0A09
        inc de                  ; '2 kempston'
        ld c, Colour.brMagenta
        call printString
        ld hl, #0B09
        inc de                  ; '3 cursor'
        ld c, Colour.brGreen
        call printString
        ld hl, #0C09
        inc de                  ; '4 interface 2'
        ld c, Colour.brCyan
        call printString
        ld hl, #1305
        inc de                  ; 'written by core design'
        ld c, Colour.brGreen
        call printString

        ; make digits (0..4) white
        ld hl, Screen.attrs.row9 + 9
        ld b, 5
.l_0:
        ld (hl), Colour.brWhite
        ld de, 32
        add hl, de
        djnz .l_0

        ; print last score
        ld hl, #0F07            ; at 15, 7
        ld de, textLastScore
        ld c, Colour.brMagenta
        call printString
        ld hl, #0F12            ; at 15, 18
        ld (printScore.yx), hl
        call printScore
        ld hl, #0000            ; at 0, 0
        ld (printScore.yx), hl
        ret

; Checks attributes of the active menu item
; and sets them to bright blue if greater than bright white
; Used by c_c6d5.
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
