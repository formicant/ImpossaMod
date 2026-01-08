    MODULE Code

; Code that executes once at game start
; and can be disposed of afterwards.


; Sets interrupt vector and mode
initInterrupts:
        ld a, high(interruptTable)
        ld i, a
        im 2
        ret                     ; do not enable interrupts yet


; 48K/128K detection
detectSpectrumModel:
        ld hl, .is48k           ; a temporary address in the RAM slot 3
        
        ld bc, #7FFD            ; memory paging port
        ld a, #11
        out (c), a              ; set ROM 48, RAM page 1
        ld (hl), #FF            ; if 48K, #FF wil be written into `.is48k`
        dec a
        out (c), a              ; set RAM page 0 again
        
        ld a, (hl)
        ld (is48k), a           ; copy the value to permanent `is48k` variable
        
        ; TODO: if 128K, move AY code
        ; TODO: if 128K, load all levels
        
        ei                      ; now, we can enable interrupts
        ret

.is48k:
        db 0


    ENDMODULE
