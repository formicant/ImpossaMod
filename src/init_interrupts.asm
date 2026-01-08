    MODULE Code


; Sets interrupt vector and mode
initInterrupts:  ; #beb4
        ld a, high(interruptTable)
        ld i, a
        im 2
        ret


    ENDMODULE
