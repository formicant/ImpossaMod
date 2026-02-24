    MODULE Scene

; Clear the `Scene` in some crazy way
; Used by c_cc25.
clearScene:  ; #d29a
        ld hl, 0
        ld de, Obj              ; object size
        ld b, 8                 ; object count
.multiplyLoop:
        add hl, de
        djnz .multiplyLoop
        ld c, l
        ld b, h
        ; `bc`: number of bytes to clear

        ld hl, objects
.clearByte:
        ld (hl), 0
        inc hl
        dec bc
        ld a, b
        or c
        jr NZ, .clearByte
        ret

    ENDMODULE
