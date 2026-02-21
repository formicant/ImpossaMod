    MODULE Code


; Set flag Z if [C] key is pressed
; Used by c_cd5c.
checkCheatKey:  ; #c8c2
        ld bc, Port.keys_cZXCV
        in a, (c)
        bit Port.keyC, a
        ret

; Set flag Z if [Q] key is pressed
; Used by c_cc25.
checkQuitKey:  ; #c8ca
        ld bc, Port.keys_QWERT
        in a, (c)
        bit Port.keyQ, a
        ret

; Set flag Z if [0] key is pressed
; Used by c_c6d5.
checkStartKey:  ; #c8d2
        ld bc, Port.keys_67890
        in a, (c)
        bit Port.key0, a
        ret

; Set flag Z if [H] key is pressed
; Used by c_cd5c.
checkPauseKey:  ; #c8da
        ld bc, Port.keys_HJKLe
        in a, (c)
        bit Port.keyH, a
        ret

; Set flag Z if [space] is pressed
; Used by c_d4e5.
checkSmartKey:  ; #c8e2
        ld bc, Port.keys_BNMss
        in a, (c)
        bit Port.keySpace, a
        ret

; Wait until all keys released
waitKeyRelease:  ; #c8ea
        ld bc, Port.general     ; all keyboard half-rows together
        in a, (c)
        and Port.keyMask
        xor Port.keyMask
        jr NZ, waitKeyRelease
        ret

; Control vars
controlType:    ; #c8f6
        db 0    ; 0: keyboard, 1: kempston, 2: cursor, 3: interface2
controlState:   ; #c8f7
        db 0    ; bit 0: right, bit 1: left, bit 2: down, bit 3: up, bit 4: fire

; Get control key state
; Used in interrupts
pollControlKeys:  ; #c8f8
        push hl
        ld hl, controlState
        ld (hl), 0

        ld a, (controlType)
        or a
        jr NZ, .notKeyboard

.keyboard:
        ld bc, Port.keys_YUIOP
        in a, (c)
        bit Port.keyO, a
        jr NZ, .l_0
        set Key.up, (hl)
        jr .l_1
.l_0:
        ld bc, Port.keys_HJKLe
        in a, (c)
        bit Port.keyK, a
        jr NZ, .l_1
        set Key.down, (hl)
.l_1:
        ld bc, Port.keys_cZXCV
        in a, (c)
        bit Port.keyZ, a
        jr NZ, .l_2
        set Key.left, (hl)
        jr .l_3
.l_2:
        ld bc, Port.keys_cZXCV
        in a, (c)
        bit Port.keyX, a
        jr NZ, .l_3
        set Key.right, (hl)
.l_3:
        ld bc, Port.keys_67890
        in a, (c)
        bit Port.key0, a
        jr NZ, .l_4
        set Key.fire, (hl)
.l_4:
        pop hl
        ret

.notKeyboard:
        dec a
        jr NZ, .notKempston

.kempston:
        in a, (Port.kempston)
        and Port.kempston.mask
        ld (hl), a
        pop hl
        ret

.notKempston:
        dec a
        jr NZ, .interface2

.cursor:
        ld bc, Port.keys_67890
        in a, (c)
        bit Port.key0, a
        jr NZ, .l_7
        set Key.fire, (hl)
.l_7:
        bit Port.key8, a
        jr NZ, .l_8
        set Key.right, (hl)
.l_8:
        bit Port.key7, a
        jr NZ, .l_9
        set Key.up, (hl)
        jr .l_10
.l_9:
        bit Port.key6, a
        jr NZ, .l_10
        set Key.down, (hl)
.l_10:
        bit 0, (hl)
        jr NZ, .l_11
        ld bc, Port.keys_12345
        in a, (c)
        bit Port.key5, a
        jr NZ, .l_11
        set Key.left, (hl)
.l_11:
        pop hl
        ret

.interface2:
        ld bc, Port.keys_67890
        in a, (c)
        and Port.keyMask
        bit Port.key0, a
        jr NZ, .l_13
        set Key.fire, (hl)
.l_13:
        bit Port.key6, a
        jr NZ, .l_14
        set Key.left, (hl)
.l_14:
        bit Port.key7, a
        jr NZ, .l_15
        set Key.right, (hl)
.l_15:
        bit Port.key9, a
        jr NZ, .l_16
        set Key.up, (hl)
        jr .l_17
.l_16:
        bit Port.key8, a
        jr NZ, .l_17
        set Key.down, (hl)
.l_17:
        pop hl
        ret


    ENDMODULE
