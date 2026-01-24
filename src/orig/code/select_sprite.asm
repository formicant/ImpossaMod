    MODULE Code


; Get phase sprite address for an object
;   `ix`: object addr in `sceneObjects`
; (Called from drawing.asm)
; Used by c_c07c, c_c245, c_c314 and c_c3ac.
getSpriteAddr:  ; #e47a
        ld l, (ix+3)
        ld h, (ix+4)            ; `hl`: base sprite addr
        ld de, 21 * 6           ; big sprite size in bytes
        bit 1, (ix+5)           ; is sprite big
        jr NZ, .l_0
        ld de, 16 * 4           ; small sprite size in bytes
.l_0:
        ld a, (ix+8)
        cp -1
        ret Z
        
        ld a, (ix+7)
        or a
        ret Z
        
        cp -1
        jr Z, c_e4fc
        
        exa
        ld a, (ix+48)
        or a
        ret NZ
        exa
        
        ; `a`: (ix+7)
        cp -4
        jp Z, c_e566
        cp -3
        jp Z, c_e54f
        cp -2
        jr Z, c_e52d
        cp 2
        jr NZ, .l_4
        
        ld a, (ix+6)
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
        inc (ix+6)
        ret
        
.l_4:
        cp 3
        jr NZ, .l_5
        ld a, (ix+6)
        and %00000111
        srl a
        or a
        jr Z, .l_3
        cp 3
        jr C, .l_1
        
        ld (ix+6), 0
        jr .l_3
        
.l_5:
        ld a, (ix+6)
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
c_e4fc:  ; #e4fc
        set 5, (ix+5)
        set 2, (ix+5)
        set 3, (ix+5)
        ld a, (ix+6)
        add a
        ld l, a
        ld h, #00
        ld de, c_e4ee
        add hl, de
        ld a, (hl)
        inc hl
        ld h, (hl)
        ld l, a
        inc (ix+6)
        ld a, (ix+6)
        cp #07
        ret C
        set 7, (ix+5)
        push hl
        ld a, (ix+13)
        call addScore
        pop hl
        ret

; (Some game logic?)
; Used by c_e47a.
c_e52d:  ; #e52d
        ld a, (ix+18)
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
        bit 0, (ix+18)
        jr NZ, .l_2
        set 6, (ix+5)
        ret
.l_2:
        res 6, (ix+5)
        ret

; (Get Mole sprite address?)
; Used by c_e47a.
c_e54f:  ; #e54f
        bit 5, (ix+5)
        ret NZ
        ld (ix+9), #47
        ld hl, cS.shopMole
        ld (ix+3), l
        ld (ix+4), h
        ld (ix+8), #09
        ret

; (Modifies some object properties?)
; Used by c_e47a.
c_e566:  ; #e566
        ld a, (ix+5)
        xor %01000000           ; bit 6: mirror (?)
        ld (ix+5), a
        ret


    ENDMODULE
