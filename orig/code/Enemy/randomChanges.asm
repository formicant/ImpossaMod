    MODULE Enemy

; Change object direction with some probability
randomlyChangeDirection:  ; #f670
        bit Flag.changesDir, (ix+Obj.auxFlags)
        ret Z
        call Utils.generateRandom
        cp 8
        ret NC

        ; invert direction
.horizontal:
        bit 1, (ix+Obj.mo.coordConstr)
        jr Z, .vertical
        ld a, (ix+Obj.mo.direction)
        xor Dir.horizontal
        ld (ix+Obj.mo.direction), a
.vertical:
        bit 0, (ix+Obj.mo.coordConstr)
        ret Z
        ld a, (ix+Obj.mo.direction)
        xor Dir.vertical
        ld (ix+Obj.mo.direction), a
        ret


; (Some game logic?)
randomlyStandStill:  ; #f697
        bit Flag.standsStill, (ix+Obj.auxFlags)
        ret Z

        ld a, (ix+Obj.stillTime)
        or a
        jr Z, .l_0
        dec (ix+Obj.stillTime)
        ret
.l_0:
        call Utils.generateRandom
        cp 4
        ret NC

        call Utils.generateRandom
        and 31
        ld (ix+Obj.stillTime), a
        ret

    ENDMODULE
