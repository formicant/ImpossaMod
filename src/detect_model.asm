    MODULE Code


; 48K/128K detection
detectSpectrumModel:  ; #5e00
        ld a, #FF
        ld (is48k), a
        ei
        ret


    ENDMODULE
