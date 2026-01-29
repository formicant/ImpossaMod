    MODULE Code


; Never works
checkCheatKey:
        ld a, 1
        or a
        ret

; Never works
checkQuitKey:
        ld a, 1
        or a
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
        bit 6, a
        ret

; Set flag Z if smart key is pressed
checkSmartKey:
        ld a, (controlState)
        cpl
        bit 5, a
        ret

; Wait until all keys released
waitKeyRelease:
        xor a                   ; all half-rows
        in a, (#FE)
        cpl
        and %00011111           ; check all keys
        jr NZ, waitKeyRelease
        ret

; Control vars
controlType:
        db 0    ; 0: keyboard, 1: kempston, 2: cursor, 3: interface2

controlState:
        db 0    ; bit 0: right, 1: left, 2: down, 3: up, 4: fire, 5: smart, 6: pause

; Get control key state
; Used in interrupts
pollControlKeys:
        ld c, 0
        ; actual code is inserted here in `setControlKeys`
    DUP 7
        nop ; for keyboard:     ; for Kempston:
        nop ;   ld a, <halfRow> ;   xor a
        nop ;   in a, (#FE)     ;   in a, (#1F)
        nop ;                   ;   cpl
        and -0                  ; bit mask placeholder
        sub b                   ; flag `C` is set iff the key is pressed
        rl c                    ; add bit to the control state
    EDUP
        ld a, c
        ld (controlState), a
        ret


    ENDMODULE
