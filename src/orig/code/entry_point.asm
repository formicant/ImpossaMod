    MODULE Code


; Entry point
entryPoint:  ; #cc25
        di
        ld a, #FF
        ld (#FE8A), a
        ld sp, 0
        call initInterrupts
        call detectSpectrumModel
        
        ; init mirroring table
        ld b, 0
        ld h, #6A
.l_0:
        ld l, b
        ld a, b
        ld c, 0
    DUP 8
        rla
        rr c
    EDUP
        ld (hl), c
        djnz .l_0
        jp gameStart


    ENDMODULE
