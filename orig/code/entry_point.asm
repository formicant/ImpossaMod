    MODULE Code


; Entry point
entryPoint:  ; #cc25
        di
.lev+*  ld a, #FF
        ld (State.loadedLevel), a
        ld sp, 0
        call Interrupt.init
        call detectSpectrumModel

        ; init mirroring table
        ld b, 0
        ld h, high(Tables.mirror)
.byte:
        ld l, b
        ld a, b
        ld c, 0
    DUP 8
        rla
        rr c
    EDUP
        ld (hl), c
        djnz .byte

        jp gameStart


    ENDMODULE
