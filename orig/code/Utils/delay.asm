    MODULE Utils

; Wait for a specified period of time
;   `bc`: delay time in milliseconds
; spoils: `af`, `bc`
delay:
        push bc
        ld b, 255
.loop:
        djnz .loop
        pop bc
        dec bc
        ld a, b
        or c
        jr NZ, delay
        ret

    ENDMODULE
