    MODULE Utils

; Delay for approximately `bc` milliseconds
delay:  ; #d0f0
        push bc
        ld b, #FF
.loop:
        djnz .loop
        pop bc
        dec bc
        ld a, b
        or c
        jr NZ, delay
        ret

    ENDMODULE
