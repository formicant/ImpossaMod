    MODULE Code


; Set flag Z if [C] key is pressed
; Used by c_cd5c.
checkCheatKey:  ; #c8c2
        ld bc, #FEFE            ; keyboard half-row [cs]..[V]
        in a, (c)
        bit 3, a                ; key [C]
        ret

; Set flag Z if [Q] key is pressed
; Used by c_cc25.
checkQuitKey:  ; #c8ca
        ld bc, #FBFE            ; keyboard half-row [Q]..[T]
        in a, (c)
        bit 0, a                ; key [Q]
        ret

; Set flag Z if [0] key is pressed
; Used by c_c6d5.
checkStartKey:  ; #c8d2
        ld bc, #EFFE            ; keyboard half-row [0]..[6]
        in a, (c)
        bit 0, a                ; key [0]
        ret

; Set flag Z if [H] key is pressed
; Used by c_cd5c.
checkPauseKey:  ; #c8da
        ld bc, #BFFE            ; keyboard half-row [en]..[H]
        in a, (c)
        bit 4, a                ; key [H]
        ret

; Set flag Z if [space] is pressed
; Used by c_d4e5.
checkSmartKey:  ; #c8e2
        ld bc, #7FFE            ; keyboard half-row [sp]..[B]
        in a, (c)
        bit 0, a                ; key [sp]
        ret

; Wait until all keys released
waitKeyRelease:  ; #c8ea
        ld bc, #00FE            ; all keyboard half-rows together
        in a, (c)
        and #1F
        xor #1F
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
        ld bc, #DFFE            ; keyboard half-row [P]..[Y]
        in a, (c)
        bit 1, a                ; key [O]
        jr NZ, .l_0
        set 3, (hl)             ; up
        jr .l_1
.l_0:
        ld bc, #BFFE            ; keyboard half-row [en]..[H]
        in a, (c)
        bit 2, a                ; key [K]
        jr NZ, .l_1
        set 2, (hl)             ; down
.l_1:
        ld bc, #FEFE            ; keyboard half-row [cs]..[V]
        in a, (c)
        bit 1, a                ; key [Z]
        jr NZ, .l_2
        set 1, (hl)             ; left
        jr .l_3
.l_2:
        ld bc, #FEFE            ; keyboard half-row [cs]..[V]
        in a, (c)
        bit 2, a                ; key [X]
        jr NZ, .l_3
        set 0, (hl)             ; right
.l_3:
        ld bc, #EFFE            ; keyboard half-row [0]..[6]
        in a, (c)
        bit 0, a                ; key [0]
        jr NZ, .l_4
        set 4, (hl)             ; fire
.l_4:
        pop hl
        ret
        
.notKeyboard:
        dec a
        jr NZ, .notKempston
        
.kempston:
        in a, (#1F)             ; kempston port
        and #1F                 ; bits 0..4
        ld (hl), a
        pop hl
        ret
        
.notKempston:
        dec a
        jr NZ, .interface2
        
.cursor:
        ld bc, #EFFE            ; keyboard half-row [0]..[6]
        in a, (c)
        bit 0, a                ; key [0]
        jr NZ, .l_7
        set 4, (hl)             ; fire
.l_7:
        bit 2, a                ; key [8]
        jr NZ, .l_8
        set 0, (hl)             ; right
.l_8:
        bit 3, a                ; key [7]
        jr NZ, .l_9
        set 3, (hl)             ; up
        jr .l_10
.l_9:
        bit 4, a                ; key [6]
        jr NZ, .l_10
        set 2, (hl)             ; down
.l_10:
        bit 0, (hl)
        jr NZ, .l_11
        ld bc, #F7FE            ; keyboard half-row [1]..[5]
        in a, (c)
        bit 4, a                ; key [5]
        jr NZ, .l_11
        set 1, (hl)             ; left
.l_11:
        pop hl
        ret
        
.interface2:
        ld bc, #EFFE            ; keyboard half-row [0]..[6]
        in a, (c)
        and #1F
        bit 0, a                ; key [0]
        jr NZ, .l_13
        set 4, (hl)             ; fire
.l_13:
        bit 4, a                ; key [6]
        jr NZ, .l_14
        set 1, (hl)             ; left
.l_14:
        bit 3, a                ; key [7]
        jr NZ, .l_15
        set 0, (hl)             ; right
.l_15:
        bit 1, a                ; key [9]
        jr NZ, .l_16
        set 3, (hl)             ; up
        jr .l_17
.l_16:
        bit 2, a                ; key [8]
        jr NZ, .l_17
        set 2, (hl)             ; down
.l_17:
        pop hl
        ret


    ENDMODULE
