    MODULE Code


; Get phase sprite address for an object
;   `ix`: object addr in `scene`
; (Called from drawing.asm)
; Used by c_c07c, c_c245, c_c314 and c_c3ac.
getSpriteAddr:  ; #e47a
        ld l, (ix+Obj.sprite+0)
        ld h, (ix+Obj.sprite+1) ; `hl`: base sprite addr
        
        ld de, 21 * 6           ; big sprite size in bytes
        bit Flag.isBig, (ix+Obj.flags)
        jr NZ, .l_0
        ld de, 16 * 4           ; small sprite size in bytes
.l_0:
        ld a, (ix+Obj.objType)
        cp ObjType.hero
        ret Z

        ld a, (ix+Obj.o_7)
        or a
        ret Z

        cp -1                   ; explosion cloud
        jr Z, getCloudSprite

        exa
        ld a, (ix+Obj.stillTime)
        or a
        ret NZ
        exa

        ; `a`: (ix+Obj.o_7)
        cp -4                   ; ?
        jp Z, c_e566
        cp -3                   ; burrow
        jp Z, getBurrowSprite
        cp -2                   ; frog
        jr Z, getFrogSprite
        cp 2                    ; 2 walk phases
        jr NZ, .moreThan2

        ld a, (ix+Obj.walkPhase)
        and %00000010
        srl a
        jr Z, .l_3
.l_1:
        ld b, a
.l_2:
        add hl, de              ; add sprite size in bytes
        djnz .l_2
.l_3:
        ; `hl`: phase sprite addr
        inc (ix+Obj.walkPhase)
        ret

.moreThan2:
        cp 3
        jr NZ, .four
        
.three:
        ld a, (ix+Obj.walkPhase)
        and %00000111
        srl a
        or a
        jr Z, .l_3
        cp 3
        jr C, .l_1

        ld (ix+Obj.walkPhase), 0
        jr .l_3

.four:
        ld a, (ix+Obj.walkPhase)
        and %00000110
        srl a
        jr Z, .l_3
        cp 3
        jr NZ, .l_1
        ld a, 1
        jr .l_1


; Cloud sprite phase addresses
c_e4ee:  ; #e4ee
        dw cS.explosion1
        dw cS.explosion2
        dw cS.explosion3
        dw cS.explosion4
        dw cS.explosion3
        dw cS.explosion2
        dw cS.explosion1

; Get cloud sprite phase address
; Used by c_e47a.
getCloudSprite:  ; #e4fc
        set Flag.waiting, (ix+Obj.flags)
        set Flag.fixedX, (ix+Obj.flags)
        set Flag.fixedY, (ix+Obj.flags)
        ld a, (ix+Obj.walkPhase)
        add a
        ld l, a
        ld h, #00
        ld de, c_e4ee
        add hl, de
        ld a, (hl)
        inc hl
        ld h, (hl)
        ld l, a
        inc (ix+Obj.walkPhase)
        ld a, (ix+Obj.walkPhase)
        cp #07
        ret C
        set Flag.cleanUp, (ix+Obj.flags)
        push hl
        ld a, (ix+Obj.score)
        call addScore
        pop hl
        ret


; Get frog sprite address
; Used by c_e47a.
getFrogSprite:  ; #e52d
        ld a, (ix+Obj.trajDir)
        or a
        jr NZ, .l_0
        call generateRandom
        bit 7, a
        jr NZ, .l_1
        add hl, de
        jr .l_1
.l_0:
        add hl, de
        add hl, de
.l_1:
        bit Dir.right, (ix+Obj.trajDir)
        jr NZ, .l_2
        set Flag.mirror, (ix+Obj.flags)
        ret
.l_2:
        res Flag.mirror, (ix+Obj.flags)
        ret


; Get burrow or shop mole sprite address
; Used by c_e47a.
getBurrowSprite:  ; #e54f
        bit Flag.waiting, (ix+Obj.flags)
        ret NZ
        ld (ix+Obj.colour), Colour.brWhite
        ld hl, cS.shopMole
        ld (ix+Obj.sprite+0), l
        ld (ix+Obj.sprite+1), h
        ld (ix+Obj.objType), ObjType.shopMole
        ret


; (Modifies some object properties?)
; Used by c_e47a.
c_e566:  ; #e566
        ld a, (ix+Obj.flags)
        xor 1<<Flag.mirror
        ld (ix+Obj.flags), a
        ret


    ENDMODULE
