    MODULE Interrupt


; Initialise interrupts
; This procedure is overwritten by some buffer(?) after execution
; Used by entryPoint
init:  ; #beb4
        di

        ; move the interrupt routine from #BED4 to #FEFE
        ld hl, storedInterruptRoutine
        ld de, routine
        ld bc, length
        ldir

        ; create the interrupt table (257 bytes at #FD00..#FE00)
        ld hl, Tables.interruptTable
        ld b, 0  ; 256
.l_0:
        ld (hl), high(routine)
        inc hl
        djnz .l_0
        ld (hl), high(routine)

        ; enable interrupts
        ld a, high(Tables.interruptTable)
        ld i, a
        im 2
        ei

        ret

storedInterruptRoutine:  ; #bed4


    ENDMODULE
