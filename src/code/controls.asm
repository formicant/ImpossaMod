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
        ld bc, Port.keys_67890
        in a, (c)
        bit Port.key0, a
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
        in a, (Port.general)
        cpl
        and Port.keyMask        ; check all keys
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
        ld (hl), #FE : inc hl   ;   (Port.general)
        jr .bitMask

.kempston:
        ld (hl), #AF : inc hl   ; xor a
        ld (hl), #DB : inc hl   ; in a,
        ld (hl), #1F : inc hl   ;   (Port.kempston)
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


keyTable:
; index                half-row   bit mask           name
.i0:    db 0,                     0,                 "  "C
.i1:    db high(Port.keys_cZXCV), 1<<Port.keyV,      "V "C
.i2:    db high(Port.keys_cZXCV), 1<<Port.keyC,      "C "C
.i3:    db high(Port.keys_cZXCV), 1<<Port.keyX,      "X "C
.i4:    db high(Port.keys_cZXCV), 1<<Port.keyZ,      "Z "C
.i5:    db high(Port.keys_cZXCV), 1<<Port.keyCaps,   "CS"C
.i6:    db high(Port.keys_ASDFG), 1<<Port.keyG,      "G "C
.i7:    db high(Port.keys_ASDFG), 1<<Port.keyF,      "F "C
.i8:    db high(Port.keys_ASDFG), 1<<Port.keyD,      "D "C
.i9:    db high(Port.keys_ASDFG), 1<<Port.keyS,      "S "C
.i10:   db high(Port.keys_ASDFG), 1<<Port.keyA,      "A "C
.i11:   db high(Port.keys_QWERT), 1<<Port.keyT,      "T "C
.i12:   db high(Port.keys_QWERT), 1<<Port.keyR,      "R "C
.i13:   db high(Port.keys_QWERT), 1<<Port.keyE,      "E "C
.i14:   db high(Port.keys_QWERT), 1<<Port.keyW,      "W "C
.i15:   db high(Port.keys_QWERT), 1<<Port.keyQ,      "Q "C
.i16:   db high(Port.keys_12345), 1<<Port.key5,      "5 "C
.i17:   db high(Port.keys_12345), 1<<Port.key4,      "4 "C
.i18:   db high(Port.keys_12345), 1<<Port.key3,      "3 "C
.i19:   db high(Port.keys_12345), 1<<Port.key2,      "2 "C
.i20:   db high(Port.keys_12345), 1<<Port.key1,      "1 "C
.i21:   db high(Port.keys_67890), 1<<Port.key6,      "6 "C
.i22:   db high(Port.keys_67890), 1<<Port.key7,      "7 "C
.i23:   db high(Port.keys_67890), 1<<Port.key8,      "8 "C
.i24:   db high(Port.keys_67890), 1<<Port.key9,      "9 "C
.i25:   db high(Port.keys_67890), 1<<Port.key0,      "0 "C
.i26:   db high(Port.keys_YUIOP), 1<<Port.keyY,      "Y "C
.i27:   db high(Port.keys_YUIOP), 1<<Port.keyU,      "U "C
.i28:   db high(Port.keys_YUIOP), 1<<Port.keyI,      "I "C
.i29:   db high(Port.keys_YUIOP), 1<<Port.keyO,      "O "C
.i30:   db high(Port.keys_YUIOP), 1<<Port.keyP,      "P "C
.i31:   db high(Port.keys_HJKLe), 1<<Port.keyH,      "H "C
.i32:   db high(Port.keys_HJKLe), 1<<Port.keyJ,      "J "C
.i33:   db high(Port.keys_HJKLe), 1<<Port.keyK,      "K "C
.i34:   db high(Port.keys_HJKLe), 1<<Port.keyL,      "L "C
.i35:   db high(Port.keys_HJKLe), 1<<Port.keyEnter,  "EN"C
.i36:   db high(Port.keys_BNMss), 1<<Port.keyB,      "B "C
.i37:   db high(Port.keys_BNMss), 1<<Port.keyN,      "N "C
.i38:   db high(Port.keys_BNMss), 1<<Port.keyM,      "M "C
.i39:   db high(Port.keys_BNMss), 1<<Port.keySymbol, "SS"C
.i40:   db high(Port.keys_BNMss), 1<<Port.keySpace,  "SP"C
.i41:   db 0,            1<<Port.kempston.start,     " S"C
.i42:   db 0,            1<<Port.kempston.buttonA,   " A"C
.i43:   db 0,            1<<Port.kempston.buttonC,   " C"C
.i44:   db 0,            1<<Port.kempston.fire,      " F"C
.i45:   db 0,            1<<Port.kempston.up,        " ^"C
.i46:   db 0,            1<<Port.kempston.down,      " _"C
.i47:   db 0,            1<<Port.kempston.left,      " <"C
.i48:   db 0,            1<<Port.kempston.right,     " >"C

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
