    MODULE Scene

; Decrement blinking time for all scene objects
decBlinkTime:  ; #d0d0
        ld ix, Scene.objects
        ld b, 8                 ; object count
        ld de, Obj              ; object size
.object:
        ld a, (ix+Obj.blinkTime)
        or a
        jr Z, .skip

        dec a
        ld (ix+Obj.blinkTime), a
        and 1                   ; even/odd
        jr NZ, .skip
        set Flag.blink, (ix+Obj.flags)
.skip:
        add ix, de
        djnz .object
        ret

    ENDMODULE
