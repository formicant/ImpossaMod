    MODULE Code


; Get phase sprite address for an object
;   arg `ix`: object
;   ret `hl`: sprite addr
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

        ld a, (ix+Obj.spriteSet)
        or a
        ret Z                   ; single sprite

        cp SpriteSet.explosion
        jr Z, getExplosionSprite

        exa
        ld a, (ix+Obj.stillTime)
        or a
        ret NZ
        exa
        ; `a`: spriteSet

        cp SpriteSet.turnAround ; (unused?)
        jp Z, turnAround

        cp SpriteSet.burrow
        jp Z, getBurrowSprite

        cp SpriteSet.frog
        jr Z, getFrogSprite

        cp SpriteSet.twoPhase
        jr NZ, .moreThan2Phases

        ld a, (ix+Obj.walkPhase)
        and %00000010
        srl a                   ; `a`: 0 or 1
        jr Z, .end

.getSpriteByIndex:
        ld b, a                 ; sprite index > 0
.next:
        add hl, de              ; add sprite size in bytes
        djnz .next

.end:
        ; `hl`: phase sprite addr
        inc (ix+Obj.walkPhase)
        ret

.moreThan2Phases:
        cp SpriteSet.threePhase
        jr NZ, .fourPhase

.threePhase:
        ld a, (ix+Obj.walkPhase)
        and %00000111
        srl a                   ; `a`: 0..3
        or a
        jr Z, .end
        cp 3
        jr C, .getSpriteByIndex
        ; reset walk phase
        ld (ix+Obj.walkPhase), 0
        jr .end

.fourPhase:
        ld a, (ix+Obj.walkPhase)
        and %00000110
        srl a                   ; `a`: 0..3
        jr Z, .end
        cp 3
        jr NZ, .getSpriteByIndex
        ; 4th phase sprite is the same as 2nd
        ld a, 1
        jr .getSpriteByIndex


; Explosion cloud phase sprite addresses
explosionPhases:  ; #e4ee
        dw cS.explosion1
        dw cS.explosion2
        dw cS.explosion3
        dw cS.explosion4
        dw cS.explosion3
        dw cS.explosion2
        dw cS.explosion1

; Get explosion cloud phase sprite address
;   arg `ix`: object
;   ret `hl`: phase sprite addr
; Used by c_e47a.
getExplosionSprite:  ; #e4fc
        set Flag.waiting, (ix+Obj.flags)
        set Flag.fixedX, (ix+Obj.flags)
        set Flag.fixedY, (ix+Obj.flags)

        ld a, (ix+Obj.walkPhase)
        add a
        ld l, a
        ld h, 0
        ld de, explosionPhases
        add hl, de              ; `hl`: addr in sprite table

        ld a, (hl)
        inc hl
        ld h, (hl)
        ld l, a                 ; `hl`: sprite addr

        ; next phase
        inc (ix+Obj.walkPhase)
        ld a, (ix+Obj.walkPhase)
        cp 7                    ; phase count
        ret C

        set Flag.cleanUp, (ix+Obj.flags)
        push hl

        ; add score
        ld a, (ix+Obj.score)
        call addScore

        pop hl
        ret


; Get frog sprite address
;   arg `ix`: frog object
;       `hl`: base sprite addr
;       `de`: sprite size in bytes
;   ret `hl`: phase sprite addr
; Used by c_e47a.
getFrogSprite:  ; #e52d
        ld a, (ix+Obj.mo.trajDir)
        or a
        jr NZ, .jumping

.breathing:
        call generateRandom
        bit 7, a
        jr NZ, .setMirror

        add hl, de
        jr .setMirror

.jumping:
    .2  add hl, de

.setMirror:
        ; TODO: fix mirroring
        bit Dir.right, (ix+Obj.mo.trajDir)
        jr NZ, .right
.left:
        set Flag.mirror, (ix+Obj.flags)
        ret
.right:
        res Flag.mirror, (ix+Obj.flags)
        ret


; Get burrow or shop mole sprite address
;   arg `ix`: burrow object
;       `hl`: burrow sprite addr
;   ret `hl`: burrow or shop mole sprite addr
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


; Invert object's mirror flag (unused?)
;   arg `ix`: object
; Used by c_e47a.
turnAround:  ; #e566
        ld a, (ix+Obj.flags)
        xor 1<<Flag.mirror
        ld (ix+Obj.flags), a
        ret


    ENDMODULE
