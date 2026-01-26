    MODULE Code

; Code that executes once at game start
; and can be disposed of afterwards.


; Stub. Real interrupt initialization happens in `detectSpectrumModel`
initInterrupts:
        ret


; Detect Spectrum model, move things in memory, init interrupts
detectSpectrumModel:
        ; 48K/128K detection
        ld hl, Level.end        ; a temporary address in the RAM slot 3
        
        ld bc, #7FFD            ; memory paging port
        ld a, #11
        out (c), a              ; set ROM 48, RAM page 1
        ld (hl), #FF            ; if 48K, #FF wil be written into `(hl)`
        dec a
        out (c), a              ; set RAM page 0 again
        
        ld a, (hl)
        ld (is48k), a           ; copy the value to permanent `is48k` variable
        or a
        jp Z, if128k
        
.if48k:
        ; move tape loading procedures
        ld hl, Tape.start
        ld bc, Tape.length
        ld de, Level.end
        ldir
        ; continue


realInterruptInit:
        ; fill interrupt table
        ld hl, interruptTable
        ld b, 0
        ld a, high(interruptRoutine)
.loop:
        ld (hl), a
        inc l
        djnz .loop
        inc h
        ld (hl), a
        
        ld a, high(interruptTable)
        ld i, a
        im 2
        
        ex (sp), hl             ; ret addr
        ld sp, stackTop
        ei
        jp hl                   ; ret


if128k:
        ; TODO: move AY code
        ; TODO: load all levels
        jp realInterruptInit


    ENDMODULE
