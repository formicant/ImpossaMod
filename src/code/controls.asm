    MODULE Code


; Never works
checkCheatKey:
        ld a, 1
        or a
        ret

; Set flag Z if quit key is pressed
checkQuitKey:
        ld a, (controlState)
        cpl
        bit Key.quit, a
        ret

; Set flag Z if [0] key is pressed
checkStartKey:
        ld bc, #EFFE            ; keyboard half-row [0]..[6]
        in a, (c)
        bit 0, a                ; key [0]
        ret

; Set flag Z if pause key is pressed
checkPauseKey:
        ld a, (controlState)
        cpl
        bit Key.pause, a
        ret

; Set flag Z if smart key is pressed
checkSmartKey:
        ld a, (controlState)
        cpl
        bit Key.smart, a
        ret

; Wait until all keys released
waitKeyRelease:
        xor a                   ; all half-rows
        in a, (#FE)
        cpl
        and %00011111           ; check all keys
        jr NZ, waitKeyRelease
        ret


; Modify the interrupt routine key polling instructions
setControlKeys:
        ld de, controlKeys
        ld a, (controlType)
    .3  add a
        _ADD_DE_A
        
        ld hl, interruptRoutine.keyPollInstructions
        push hl
        
        di                      ; modifying interrupt routine
        ld b, 8
.key:
        ld hl, keyTable
        ld a, (de)              ; key index
    .2  add a
        _ADD_HL_A
        ld a, (hl)              ; half-row (or 0 for Kempston)
        inc hl
        ld c, (hl)              ; key bit mask
        
        pop hl
        or a
        jr Z, .kempston
        
.keyboard:
        ld (hl), #3E : inc hl   ; ld a,
        ld (hl), a   : inc hl   ;   <halfRow>
        ld (hl), #DB : inc hl   ; in a,
        ld (hl), #FE : inc hl   ;   (#FE)
        jr .bitMask
        
.kempston:
        ld (hl), #AF : inc hl   ; xor a
        ld (hl), #DB : inc hl   ; in a,
        ld (hl), #1F : inc hl   ;   (#1F)
        ld (hl), #2F : inc hl   ; cpl
        
.bitMask:
        inc hl
        ld (hl), c              ; <bitMask>
    .4  inc hl
        push hl
        
        inc de
        djnz .key
        pop hl
        
        ei                      ; interrupt routine is ready
        ret


keyTable: ; half-row   mask   name   index
        db 0,         0,      "  "C  ; 0
        db %11111110, %10000, "V "C  ; 1
        db %11111110, %01000, "C "C  ; 2
        db %11111110, %00100, "X "C  ; 3
        db %11111110, %00010, "Z "C  ; 4
        db %11111110, %00001, "CS"C  ; 5
        db %11111101, %10000, "G "C  ; 6
        db %11111101, %01000, "F "C  ; 7
        db %11111101, %00100, "D "C  ; 8
        db %11111101, %00010, "S "C  ; 9
        db %11111101, %00001, "A "C  ; 10
        db %11111011, %10000, "T "C  ; 11
        db %11111011, %01000, "R "C  ; 12
        db %11111011, %00100, "E "C  ; 13
        db %11111011, %00010, "W "C  ; 14
        db %11111011, %00001, "Q "C  ; 15
        db %11110111, %10000, "5 "C  ; 16
        db %11110111, %01000, "4 "C  ; 17
        db %11110111, %00100, "3 "C  ; 18
        db %11110111, %00010, "2 "C  ; 19
        db %11110111, %00001, "1 "C  ; 20
        db %11101111, %10000, "6 "C  ; 21
        db %11101111, %01000, "7 "C  ; 22
        db %11101111, %00100, "8 "C  ; 23
        db %11101111, %00010, "9 "C  ; 24
        db %11101111, %00001, "0 "C  ; 25
        db %11011111, %10000, "Y "C  ; 26
        db %11011111, %01000, "U "C  ; 27
        db %11011111, %00100, "I "C  ; 28
        db %11011111, %00010, "O "C  ; 29
        db %11011111, %00001, "P "C  ; 30
        db %10111111, %10000, "H "C  ; 31
        db %10111111, %01000, "J "C  ; 32
        db %10111111, %00100, "K "C  ; 33
        db %10111111, %00010, "L "C  ; 34
        db %10111111, %00001, "EN"C  ; 35
        db %01111111, %10000, "B "C  ; 36
        db %01111111, %01000, "N "C  ; 37
        db %01111111, %00100, "M "C  ; 38
        db %01111111, %00010, "SS"C  ; 39
        db %01111111, %00001, "SP"C  ; 40
        db 0,      %10000000, " S"C  ; 41
        db 0,      %01000000, " A"C  ; 42
        db 0,      %00100000, " C"C  ; 43
        db 0,      %00010000, " F"C  ; 44
        db 0,      %00001000, " ^"C  ; 45
        db 0,      %00000100, " _"C  ; 46
        db 0,      %00000010, " <"C  ; 47
        db 0,      %00000001, " >"C  ; 48

controlKeys:
.keyb:  db 11, 31, 40, 38, 15, 10, 29, 30   ; T  H  sp M  Q  A  O  P
.kemp:  db 11, 31, 40, 44, 45, 46, 47, 48   ; T  H  sp fi up dn lf rt
.curs:  db 11, 31, 40, 25, 22, 21, 16, 23   ; T  H  sp 0  7  6  5  8
.sinc:  db 11, 31, 40, 25, 24, 23, 21, 22   ; T  H  sp 0  9  8  6  7
.defi:  db -0, -0, -0, -0, -0, -0, -0, -0

controlType:
        db 0    ; 0: keyboard, 1: kempston, 2: cursor, 3: interface2, 4: redefined

controlState:   ; set every frame in the interrupt routine
        db -0   ; bit 0: right, 1: left, 2: down, 3: up, 4: fire, 5: smart, 6: pause, 7: quit


    ENDMODULE
