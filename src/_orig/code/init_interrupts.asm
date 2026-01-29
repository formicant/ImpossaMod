    MODULE Code


; Initialize interrupts
; This procedure is overwritten by some buffer(?) after execution
; Used by entryPoint
initInterrupts:  ; #beb4
        di
        
        ; move the interrupt routine from #BED4 to #FEFE
        ld hl, storedInterruptRoutine
        ld de, interruptRoutine
        ld bc, interruptLength
        ldir
        
        ; create the interrupt table (257 bytes at #FD00..#FE00)
        ld hl, interruptTable
        ld b, 0  ; 256
.l_0:
        ld (hl), high(interruptRoutine)
        inc hl
        djnz .l_0
        ld (hl), high(interruptRoutine)
        
        ; enable interrupts
        ld a, high(interruptTable)
        ld i, a
        im 2
        ei
        
        ret

storedInterruptRoutine:  ; #bed4


    ENDMODULE
