    MODULE Enemy

; Decide whether to blow up a dynamite
; Used by c_ed08.
checkDynamiteExplosion:  ; #f4e9
        ld a, (ix+Obj.objType)
        cp ObjType.klondike.dynamite1
        jr Z, .isDynamite
        cp ObjType.klondike.dynamite2
        ret NZ

.isDynamite:
        call Utils.generateRandom
        cp 2
        ret NC
        ; explosion cloud
        ld (ix+Obj.walkPhase), 0
        ld (ix+Obj.spriteSet), -1
        ld (ix+Obj.colour), Colour.brWhite
        ret

    ENDMODULE
