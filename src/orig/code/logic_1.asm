    MODULE Code


; (Some call table)
c_d6e7:  ; #d6e7
        dw c_d7f6
        dw c_d94c
        dw c_da95
        dw c_db4e
        dw c_dbfc

; Data block at D6F1
c_d6f1:  ; #d6f1
        db #F8, #F8, #F8, #F9, #F9, #F9, #F9, #FA
        db #FD, #FE, #FF, #00, #00, #00, #01, #01
        db #02, #02, #04, #07, #07, #08, #08, #7F

; (Some game logic, calls from call table #D6E7?)
; Used by c_cc25.
c_d709:  ; #d709
        ld ix, scene
        call c_dd73
        ld a, (State.s_28)
        add a
        ld l, a
        ld h, #00
        ld de, c_d6e7
        add hl, de
        ld e, (hl)
        inc hl
        ld d, (hl)
        ld (.call), de
.call+* call -0
        ld a, (State.s_28)
        cp #02
        jp NC, .l_4
        ld a, (State.s_39)
        or a
        jr Z, .l_0
        dec a
        ld (State.s_39), a
        ld a, (State.s_38)
        cp #01
        jp NZ, .l_7
        jp .l_6
.l_0:
        ld a, (State.s_31)
        call c_eaee
        cp #05
        jp Z, .l_6
        cp #06
        jp Z, .l_7
        ld a, (State.s_32)
        call c_eaee
        cp #05
        jp Z, .l_6
        cp #06
        jp Z, .l_7
        ld a, (State.s_31)
        call c_eaee
        cp #09
        jr Z, .l_1
        ld a, (State.s_32)
        call c_eaee
        cp #09
        jr NZ, .l_4
.l_1:
        call decEnergy
        ld a, #02
        ld (State.s_28), a
        ld a, (controlState)
        and #03
        jp Z, .l_2
        ld b, a
        ld a, (ix+21)
        and #FC
        or b
        ld (ix+21), a
        ld (ix+19), #02
.l_2:
        ld a, #03
        ld (State.s_27), a
        xor a
        ld (State.s_41), a
        ld hl, cS.heroJumps
        ld a, (State.weapon)
        cp 2
        jr C, .l_3
        ld hl, cS.armedHeroJumps
.l_3:
        ld (ix+3), l
        ld (ix+4), h
.l_4:
        xor a
        ld (State.s_05), a
        ld de, (State.screenX)
        ld hl, (State.mapSpanEnd)
        xor a
        sbc hl, de
        jr Z, .l_5
        jr C, .l_5
        ld l, (ix+0)
        ld h, (ix+1)
        ld de, -200
        add hl, de
        jr NC, .l_5
        ld a, #FF
        ld (State.s_05), a
.l_5:
        jp c_e419
.l_6:
        call c_de37
        jr NZ, .l_4
        ld a, (ix+0)
        add #FF
        ld (ix+0), a
        jp .l_4
.l_7:
        call c_deb1
        jr NZ, .l_4
        ld a, (ix+0)
        add #01
        ld (ix+0), a
        jp .l_4

; (Some game logic from call table #D6E7?)
c_d7f6:  ; #d7f6
        ld a, (controlState)
        bit 3, a
        jr Z, .l_0
        ld a, (State.s_33)
        call c_eaee
        cp #01
        jp Z, .l_12
        cp #02
        jp Z, .l_12
        jp .l_9
.l_0:
        bit 2, a
        jr Z, .l_1
        ld a, (State.s_34)
        call c_eaee
        cp #02
        jp Z, .l_12
.l_1:
        ld a, (controlState)
        bit 1, a
        jp NZ, .l_7
        bit 0, a
        jp NZ, .l_8
        bit 0, (ix+24)
        ret NZ
        ld a, (State.s_31)
        call c_eaee
        cp #02
        jr NC, .l_2
        ld a, (State.s_32)
        call c_eaee
        cp #02
        jp C, c_d94c.l_13
.l_2:
        ld a, (State.s_31)
        call c_eaee
        cp #07
        jr Z, .l_3
        ld a, (State.s_32)
        call c_eaee
        cp #07
        jr Z, .l_3
        ld a, (State.s_31)
        call c_eaee
        cp #05
        ret NC
        ld a, (State.s_32)
        call c_eaee
        cp #05
        jp C, c_d94c.l_11
        ret
.l_3:
        bit 0, (ix+21)
        jr NZ, .l_4
        call c_de37
        jp NZ, c_d94c.l_11
        ld a, (ix+0)
        add #FE
        ld (ix+0), a
        jp .l_5
.l_4:
        call c_deb1
        jp NZ, c_d94c.l_11
        ld a, (ix+0)
        add #02
        ld (ix+0), a
.l_5:
        ld hl, cS.heroWalks1
        ld a, (State.weapon)
        cp 2
        jr C, .l_6
        ld hl, cS.armedHeroWalks1
.l_6:
        ld (ix+3), l
        ld (ix+4), h
        ret
.l_7:
        ld a, #01
        ld (State.s_28), a
        ld a, #02
        ld (State.s_41), a
        xor a
        ld (State.s_42), a
        ld (ix+6), a
        set 1, (ix+21)
        res 0, (ix+21)
        ret
.l_8:
        ld a, #01
        ld (State.s_28), a
        ld a, #02
        ld (State.s_41), a
        xor a
        ld (State.s_42), a
        ld (ix+6), a
        set 0, (ix+21)
        res 1, (ix+21)
        ret
.l_9:
        ld a, (State.s_45)
        or a
        ret NZ
        res 0, (ix+24)
        ld a, #02
        ld (State.s_28), a
        ld a, (controlState)
        and #03
        jp Z, .l_10
        ld b, a
        ld a, (ix+21)
        and #FC
        or b
        ld (ix+21), a
        ld (ix+19), #02
.l_10:
        ld a, #03
        ld (State.s_27), a
        xor a
        ld (State.s_41), a
        ld hl, cS.heroJumps
        ld a, (State.weapon)
        cp 2
        jr C, .l_11
        ld hl, cS.armedHeroJumps
.l_11:
        ld (ix+3), l
        ld (ix+4), h
        ld a, #05
        call playSound
        jp c_da95
; This entry point is used by c_d94c, c_da95 and c_db4e.
.l_12:
        ld a, (State.s_45)
        or a
        ret NZ
        ld a, #04
        ld (State.s_28), a
        xor a
        ld (State.s_3E), a
        ld hl, cS.heroClimbs
        ld a, (State.weapon)
        cp 2
        jr C, .l_13
        ld hl, cS.armedHeroClimbs
.l_13:
        ld (ix+3), l
        ld (ix+4), h
        xor a
        ld (State.s_41), a
        jp c_dbfc

; (Some game logic from call table #D6E7?)
c_d94c:  ; #d94c
        bit 0, (ix+24)
        jr NZ, .l_0
        ld a, (State.s_31)
        call c_eaee
        cp #02
        jr NC, .l_0
        ld a, (State.s_32)
        call c_eaee
        cp #02
        jp C, .l_13
.l_0:
        ld a, (controlState)
        bit 3, a
        jp NZ, .l_11
        bit 2, a
        jr Z, .l_1
        ld a, (State.s_34)
        call c_eaee
        cp #02
        jp Z, c_d7f6.l_12
.l_1:
        bit 0, (ix+21)
        jp NZ, .l_5
        call c_de37
        or a
        jp NZ, .l_11
        ld a, (State.s_31)
        call c_eaee
        cp #08
        jr Z, .l_2
        ld a, (State.s_32)
        call c_eaee
        cp #08
        jr NZ, .l_3
.l_2:
        ld a, (ix+0)
        add #FF
        ld (ix+0), a
        ld a, #04
        ld (State.s_41), a
        jr .l_4
.l_3:
        ld a, (ix+0)
        add #FE
        ld (ix+0), a
        ld a, #02
        ld (State.s_41), a
        ld a, (State.s_42)
        and #01
        ld (State.s_42), a
.l_4:
        ld a, (controlState)
        bit 1, a
        jp Z, .l_11
        jr .l_9
.l_5:
        call c_deb1
        or a
        jp NZ, .l_11
        ld a, (State.s_31)
        call c_eaee
        cp #08
        jr Z, .l_6
        ld a, (State.s_32)
        call c_eaee
        cp #08
        jr NZ, .l_7
.l_6:
        ld a, (ix+0)
        add #01
        ld (ix+0), a
        ld a, #04
        ld (State.s_41), a
        jr .l_8
.l_7:
        ld a, (ix+0)
        add #02
        ld (ix+0), a
        ld a, #02
        ld (State.s_41), a
        ld a, (State.s_42)
        and #01
        ld (State.s_42), a
.l_8:
        ld a, (controlState)
        bit 0, a
        jp Z, .l_11
.l_9:
        ld a, (State.s_31)
        call c_eaee
        cp #07
        jr Z, .l_10
        ld a, (State.s_32)
        call c_eaee
        cp #07
        ret NZ
.l_10:
        ld a, #01
        ld (State.s_41), a
        xor a
        ld (State.s_42), a
        ret
; This entry point is used by c_d7f6, c_da95, c_db4e and c_dbfc.
.l_11:
        xor a
        ld (State.s_28), a
        ld (State.s_41), a
        ld a, (ix+2)
        and #F8
        or #03
        ld (ix+2), a
        ld (ix+19), #00
        ld hl, cS.heroStands
        ld a, (State.weapon)
        cp 2
        jr C, .l_12
        ld hl, cS.armedHeroStands
.l_12:
        ld (ix+3), l
        ld (ix+4), h
        ret
; This entry point is used by c_d7f6, c_da95, c_dbfc and c_e6e1.
.l_13:
        xor a
        ld (State.s_45), a
        ld a, #03
        ld (State.s_28), a
        xor a
        ld (State.s_41), a
        ld a, (controlState)
        and #03
        jp Z, .l_14
        ld b, a
        ld a, (ix+21)
        and #FC
        or b
        ld (ix+21), a
        ld a, #02
        ld (ix+19), a
.l_14:
        ld hl, cS.heroFalls
        ld a, (State.weapon)
        cp 2
        jr C, .l_15
        ld hl, cS.armedHeroFalls
.l_15:
        ld (ix+3), l
        ld (ix+4), h
        jp c_db4e

; (Some game logic from call table #D6E7?)
; Used by c_d7f6.
c_da95:  ; #da95
        ld hl, cS.heroJumps
        ld a, (State.weapon)
        cp 2
        jr C, .l_0
        ld hl, cS.armedHeroJumps
.l_0:
        ld (ix+3), l
        ld (ix+4), h
        ld a, (controlState)
        bit 3, a
        jr Z, .l_1
        ld a, (State.s_33)
        call c_eaee
        cp #01
        jp Z, c_d7f6.l_12
        cp #02
        jp Z, c_d7f6.l_12
.l_1:
        ld a, (ix+19)
        or a
        jr Z, .l_3
        bit 0, (ix+21)
        jr NZ, .l_2
        call c_de37
        or a
        jr NZ, .l_3
        ld a, (ix+19)
        neg
        add (ix+0)
        ld (ix+0), a
        jr .l_3
.l_2:
        call c_deb1
        or a
        jr NZ, .l_3
        ld a, (ix+19)
        add (ix+0)
        ld (ix+0), a
.l_3:
        ld a, (State.s_27)
        ld e, a
        ld d, #00
        ld hl, c_d6f1
        add hl, de
        ld a, (hl)
        ld (State.s_37), a
        cp #7F
        jp Z, c_d94c.l_13
        add (ix+2)
        ld (ix+2), a
        ld a, (hl)
        ld hl, State.s_27
        inc (hl)
        or a
        jp P, .l_4
        exa
        call c_dd46
        ld a, (State.s_35)
        call c_eaee
        cp #04
        jr NC, .l_5
        ld a, (State.s_36)
        call c_eaee
        cp #04
        jr NC, .l_5
        ret
.l_4:
        call c_dd09
        ld a, (State.s_31)
        call c_eaee
        cp #02
        jp NC, c_d94c.l_11
        ld a, (State.s_32)
        call c_eaee
        cp #02
        jp NC, c_d94c.l_11
        ret
.l_5:
        exa
        neg
        add (ix+2)
        and #F8
        ld (ix+2), a
        ret

; (Some game logic from call table #D6E7?)
; Used by c_d94c.
c_db4e:  ; #db4e
        ld a, (controlState)
        bit 3, a
        jr Z, .l_0
        ld a, (State.s_33)
        call c_eaee
        cp #01
        jp Z, c_d7f6.l_12
        cp #02
        jp Z, c_d7f6.l_12
.l_0:
        ld l, (ix+0)
        ld h, (ix+1)
        push hl
        ld a, (ix+19)
        or a
        jr Z, .l_2
        bit 0, (ix+21)
        jr NZ, .l_1
        call c_de37
        or a
        jr NZ, .l_2
        ld a, (ix+19)
        neg
        add (ix+0)
        ld (ix+0), a
        jr .l_2
.l_1:
        call c_deb1
        or a
        jr NZ, .l_2
        ld a, (ix+19)
        add (ix+0)
        ld (ix+0), a
.l_2:
        exx
        ld l, (ix+0)
        ld h, (ix+1)
        exx
        pop hl
        ld (ix+0), l
        ld (ix+1), h
        ld a, (ix+2)
        add #04
        ld (ix+2), a
        call c_dd09
        exx
        ld (ix+0), l
        ld (ix+1), h
        exx
        ld a, (State.s_31)
        call c_eaee
        cp #02
        jp NC, c_d94c.l_11
        ld a, (State.s_32)
        call c_eaee
        cp #02
        jp NC, c_d94c.l_11
        ld a, (controlState)
        bit 1, a
        jr NZ, .l_3
        bit 0, a
        jr NZ, .l_4
        ld (ix+19), #00
        ret
.l_3:
        ld (ix+19), #02
        set 1, (ix+21)
        res 0, (ix+21)
        ret
.l_4:
        ld (ix+19), #02
        set 0, (ix+21)
        res 1, (ix+21)
        ret

; (Some game logic from call table #D6E7?)
; Used by c_d7f6.
c_dbfc:  ; #dbfc
        ld a, (controlState)
        bit 3, a
        jr Z, .l_1
        ld a, (State.s_33)
        call c_eaee
        or a
        jr NZ, .l_0
        ld a, (State.s_34)
        call c_eaee
        or a
        jp Z, c_d94c.l_13
.l_0:
        call c_dd46
        ld a, (State.s_35)
        call c_eaee
        cp #04
        jr NC, .l_1
        ld a, (State.s_36)
        call c_eaee
        cp #04
        jr NC, .l_1
        call c_dcce
        ld a, (ix+2)
        add #FE
        ld (ix+2), a
.l_1:
        ld a, (controlState)
        bit 2, a
        jr Z, .l_3
        ld a, (State.s_33)
        call c_eaee
        or a
        jr NZ, .l_2
        ld a, (State.s_34)
        call c_eaee
        or a
        jp Z, c_d94c.l_13
.l_2:
        call c_dcce
        ld a, (ix+2)
        add #02
        ld (ix+2), a
.l_3:
        ld a, (ix+2)
        or #01
        ld (ix+2), a
        and #07
        cp #03
        jr NZ, .l_4
        call c_dce1
        ld a, (State.s_34)
        call c_eaee
        cp #02
        jp NC, c_d94c.l_11
.l_4:
        ld a, (controlState)
        bit 1, a
        jr Z, .l_6
        ld a, (State.s_33)
        call c_eaee
        or a
        jr NZ, .l_5
        ld a, (State.s_34)
        call c_eaee
        or a
        jp Z, c_d94c.l_13
.l_5:
        call c_de37
        jr NZ, .l_6
        call c_dcce
        ld a, (ix+0)
        add #FE
        ld (ix+0), a
.l_6:
        ld a, (controlState)
        bit 0, a
        jr Z, .l_8
        ld a, (State.s_33)
        call c_eaee
        or a
        jr NZ, .l_7
        ld a, (State.s_34)
        call c_eaee
        or a
        jp Z, c_d94c.l_13
.l_7:
        call c_deb1
        jr NZ, .l_8
        call c_dcce
        ld a, (ix+0)
        add #02
        ld (ix+0), a
.l_8:
        ret

; ?
; Used by c_dbfc.
c_dcce:  ; #dcce
        ld a, (State.s_42)
        inc a
        and #03
        ld (State.s_42), a
        ret NZ
        ld a, (ix+21)
        xor #03
        ld (ix+21), a
        ret

; ?
; Used by c_dbfc.
c_dce1:  ; #dce1
        ld a, (ix+0)
        add #0C
        ld (ix+0), a
        ld a, (ix+2)
        add #15
        ld (ix+2), a
        call c_d460
        ld a, (hl)
        ld (State.s_34), a
        ld a, (ix+0)
        add #F4
        ld (ix+0), a
        ld a, (ix+2)
        add #EB
        ld (ix+2), a
        ret

; ?
; Used by c_da95 and c_db4e.
c_dd09:  ; #dd09
        ld a, (ix+0)
        add #06
        ld (ix+0), a
        ld a, (ix+1)
        adc a, #00
        ld (ix+1), a
        ld a, (ix+2)
        add #18
        ld (ix+2), a
        call c_d460
        ld a, (hl)
        ld (State.s_31), a
        inc hl
        ld a, (hl)
        ld (State.s_32), a
        ld a, (ix+0)
        add #FA
        ld (ix+0), a
        ld a, (ix+1)
        adc a, #FF
        ld (ix+1), a
        ld a, (ix+2)
        add #E8
        ld (ix+2), a
        ret

; ?
; Used by c_da95 and c_dbfc.
c_dd46:  ; #dd46
        ld a, (ix+0)
        add #06
        ld (ix+0), a
        ld a, (ix+2)
        add #FF
        ld (ix+2), a
        call c_d460
        ld a, (hl)
        ld (State.s_35), a
        inc hl
        ld a, (hl)
        ld (State.s_36), a
        ld a, (ix+0)
        add #FA
        ld (ix+0), a
        ld a, (ix+2)
        add #01
        ld (ix+2), a
        ret

; ?
; Used by c_d709.
c_dd73:  ; #dd73
        ld a, (ix+0)
        add #04
        ld (ix+0), a
        ld a, (ix+1)
        adc a, #00
        ld (ix+1), a
        call c_d460
        ld bc, #002C
        ld a, (hl)
        ld (State.s_29), a
        add hl, bc
        ld a, (hl)
        ld (State.s_2A), a
        add hl, bc
        ld a, (hl)
        ld (State.s_2B), a
        add hl, bc
        ld a, (hl)
        ld (State.s_2C), a
        ld a, (ix+0)
        add #0C
        ld (ix+0), a
        ld a, (ix+1)
        adc a, #00
        ld (ix+1), a
        call c_d460
        ld bc, #002C
        ld a, (hl)
        ld (State.s_2D), a
        add hl, bc
        ld a, (hl)
        ld (State.s_2E), a
        add hl, bc
        ld a, (hl)
        ld (State.s_2F), a
        add hl, bc
        ld a, (hl)
        ld (State.s_30), a
        ld a, (ix+0)
        add #F6
        ld (ix+0), a
        ld a, (ix+1)
        adc a, #FF
        ld (ix+1), a
        ld a, (ix+2)
        add #15
        ld (ix+2), a
        call c_d460
        ld a, (hl)
        ld (State.s_31), a
        inc hl
        ld a, (hl)
        ld (State.s_32), a
        ld a, (ix+0)
        add #06
        ld (ix+0), a
        ld a, (ix+1)
        adc a, #00
        ld (ix+1), a
        ld a, (ix+2)
        add #F8
        ld (ix+2), a
        call c_d460
        ld a, (hl)
        ld (State.s_33), a
        add hl, bc
        ld a, (hl)
        ld (State.s_34), a
        ld a, (ix+0)
        add #F4
        ld (ix+0), a
        ld a, (ix+1)
        adc a, #FF
        ld (ix+1), a
        ld a, (ix+2)
        add #F3
        ld (ix+2), a
        ld a, (ix+2)
        and #07
        cp #03
        jr NZ, .l_0
        xor a
        ld (State.s_2C), a
        ld (State.s_30), a
        ret
.l_0:
        ret

; (Checks something?)
; Used by c_d308, c_d709, c_d7f6, c_d94c, c_da95, c_db4e and c_dbfc.
c_de37:  ; #de37
        ld l, (ix+0)
        ld h, (ix+1)
        ld de, -32
        add hl, de
        jr NC, .l_2
        ld a, (State.s_28)
        cp #04
        jr NZ, .l_0
        ld a, (State.s_29)
        call c_eaee
        cp #03
        jr NC, .l_2
        ld a, (State.s_2A)
        call c_eaee
        cp #03
        jr NC, .l_2
        ld a, (State.s_2B)
        call c_eaee
        cp #03
        jr NC, .l_2
        ld a, (State.s_2C)
        call c_eaee
        cp #03
        jr NC, .l_2
        jp .l_1
.l_0:
        ld a, (State.s_29)
        call c_eaee
        cp #04
        jr NC, .l_2
        ld a, (State.s_2A)
        call c_eaee
        cp #04
        jr NC, .l_2
        ld a, (State.s_2B)
        call c_eaee
        cp #04
        jr NC, .l_2
        ld a, (State.s_28)
        cp #02
        jr NZ, .l_1
        ld a, (State.s_37)
        or a
        jp M, .l_1
        ld a, (State.s_30)
        call c_eaee
        cp #04
        jr NC, .l_2
.l_1:
        xor a
        ret
.l_2:
        ld a, #FF
        or a
        ret

; (Checks something?)
; Used by c_d308, c_d709, c_d7f6, c_d94c, c_da95, c_db4e and c_dbfc.
c_deb1:  ; #deb1
        ld l, (ix+0)
        ld h, (ix+1)
        ld de, -252
        add hl, de
        jr C, .l_2
        ld a, (State.s_28)
        cp #04
        jr NZ, .l_0
        ld a, (State.s_2D)
        call c_eaee
        cp #03
        jr NC, .l_2
        ld a, (State.s_2E)
        call c_eaee
        cp #03
        jr NC, .l_2
        ld a, (State.s_2F)
        call c_eaee
        cp #03
        jr NC, .l_2
        ld a, (State.s_30)
        call c_eaee
        cp #03
        jr NC, .l_2
        jp .l_1
.l_0:
        ld a, (State.s_2D)
        call c_eaee
        cp #04
        jr NC, .l_2
        ld a, (State.s_2E)
        call c_eaee
        cp #04
        jr NC, .l_2
        ld a, (State.s_2F)
        call c_eaee
        cp #04
        jr NC, .l_2
        ld a, (State.s_28)
        cp #02
        jr NZ, .l_1
        ld a, (State.s_37)
        or a
        jp M, .l_1
        ld a, (State.s_30)
        call c_eaee
        cp #04
        jr NC, .l_2
.l_1:
        xor a
        ret
.l_2:
        ld a, #FF
        or a
        ret

; (Some data on enemies?)
c_df2b:  ; #df2b
        db #FC, #FE, #FF, #FF, #00, #01, #01, #01
        db #01, #02, #03, #04, #06, #07, #08, #0A
        db #0B, #0C, #0E, #0F, #10, #80

kickBubbles:  ; #df41
        dw cS.kickBubble1
        dw cS.kickBubble2
        dw cS.kickBubble3

c_df47:  ; #df47
        db 0, 1, 0, -1
        db 0, 0, 0, 0, 0, 1, 2, 1, 0, -1
        db 0, 0, 0, 1, 2, 3, 2, 1, 0, -1

explosionBubbles:  ; #df5f
        dw cS.explosion1
        dw cS.explosion2
        dw cS.explosion3
        dw cS.explosion4

lazerBulletTable:  ; #df67            w   h
        dw cS.lazerBullet1 : db 16,  7, 8
        dw cS.lazerBullet2 : db 16, 11, 6
        dw cS.lazerBullet3 : db 16, 15, 4
powerBulletTable:  ; #df76
        dw cS.powerBullet1 : db  4,  4, 9
        dw cS.powerBullet2 : db  4, 16, 4
        dw cS.powerBullet3 : db  8,  8, 8

; (Some logic for enemies?)
; Used by c_cc25.
c_df85:  ; #df85
        ld a, (State.s_45)
        or a
        ret NZ
        ld a, (State.s_46)
        or a
        ret NZ
        ld a, (State.weapon)
        or a
        jr Z, .l_1
        ld hl, (State.s_3A)
        ld a, h
        or l
        jr NZ, .l_0
        ld a, (State.s_3D)
        or a
        jr NZ, .l_1
        xor a
        ld (State.weapon), a
        ret
.l_0:
        dec hl
        ld (State.s_3A), hl
.l_1:
        ld a, (State.s_3D)
        or a
        jp NZ, .l_9
        ld a, (State.s_28)
        cp #03
        ret NC
        ld a, (controlState)
        bit 4, a
        ret Z
        ld ix, scene
        ld iy, scene.obj1
        ld a, (State.weapon)
        or a
        jp NZ, .l_3
        ld a, #04
        call playSound
        ld hl, cS.heroKicks
        ld (ix+3), l
        ld (ix+4), h
        ld (iy+5), #02
        ld (iy+9), #47
        ld (iy+21), #01
        ld (iy+19), #00
        ld (iy+7), #00
        ld l, (ix+0)
        ld h, (ix+1)
        ld de, #0010
        bit 0, (ix+21)
        jr NZ, .l_2
        ld de, -16
.l_2:
        add hl, de
        ld (iy+0), l
        ld (iy+1), h
        ld a, (ix+2)
        ld (iy+2), a
        ld a, (State.soupCans)
        dec a
        add a
        ld l, a
        ld h, #00
        ld de, kickBubbles
        add hl, de
        ld a, (hl)
        ld (iy+3), a
        inc hl
        ld a, (hl)
        ld (iy+4), a
        ld a, #01
        ld (State.s_3D), a
        ld a, #03
        ld (State.s_3E), a
        jp c_eb00
.l_3:
        cp #01
        jp NZ, .l_5
        ld a, #04
        call playSound
        ld hl, cS.heroThrows
        ld (ix+3), l
        ld (ix+4), h
        ld hl, cS.shatterbomb
        ld (iy+3), l
        ld (iy+4), h
        ld (iy+5), #01
        ld (iy+9), #45
        ld (iy+7), #00
        ld (iy+10), #08
        ld (iy+11), #08
        ld l, (ix+0)
        ld h, (ix+1)
        ld de, #0008
        bit 0, (ix+21)
        jr NZ, .l_4
        ld de, -6
.l_4:
        add hl, de
        ld (iy+0), l
        ld (iy+1), h
        ld a, (ix+2)
        add #FC
        ld (iy+2), a
        ld (iy+19), #04
        ld a, (ix+21)
        and #03
        ld (iy+21), a
        xor a
        ld (State.s_3F), a
        ld a, #02
        ld (State.s_3D), a
        ld a, #03
        ld (State.s_3E), a
        jp c_eb00
.l_5:
        cp #02
        jp NZ, .l_7
        ld a, #0A
        call playSound
        ld a, (State.soupCans)
        dec a
        ld l, a
        add a
        add a
        add l
        ld l, a
        ld h, #00
        ld de, powerBulletTable
        add hl, de
        ld c, (hl)
        inc hl
        ld b, (hl)
        ld (iy+3), c
        ld (iy+4), b
        inc hl
        ld a, (hl)
        ld (iy+10), a
        inc hl
        ld a, (hl)
        ld (iy+11), a
        inc hl
        ld a, (hl)
        add (ix+2)
        ld (iy+2), a
        ld l, (ix+0)
        ld h, (ix+1)
        ld de, #0018
        bit 0, (ix+21)
        jr NZ, .l_6
        ld de, -16
.l_6:
        add hl, de
        ld (iy+0), l
        ld (iy+1), h
        ld (iy+5), #01
        ld (iy+9), #47
        ld (iy+19), #08
        ld (iy+20), #08
        ld (iy+7), #00
        ld a, (ix+21)
        and #03
        ld (iy+21), a
        ld (State.s_38), a
        ld a, #03
        ld (State.s_3D), a
        ld a, #01
        ld (c_e308), a
        ld a, #04
        ld (State.s_39), a
        jp c_eb00
.l_7:
        ld a, #08
        call playSound
        ld a, (State.soupCans)
        dec a
        ld l, a
        add a
        add a
        add l
        ld l, a
        ld h, #00
        ld de, lazerBulletTable
        add hl, de
        ld c, (hl)
        inc hl
        ld b, (hl)
        ld (iy+3), c
        ld (iy+4), b
        inc hl
        ld a, (hl)
        ld (iy+10), a
        inc hl
        ld a, (hl)
        ld (iy+11), a
        inc hl
        ld a, (hl)
        add (ix+2)
        ld (iy+2), a
        ld l, (ix+0)
        ld h, (ix+1)
        ld de, #0010
        bit 0, (ix+21)
        jr NZ, .l_8
        ld de, -6
.l_8:
        add hl, de
        ld (iy+0), l
        ld (iy+1), h
        ld (iy+7), #00
        ld (iy+5), #01
        ld (iy+9), #45
        ld (iy+19), #08
        ld a, (ix+21)
        and #03
        ld (iy+21), a
        ld (State.s_38), a
        ld a, #04
        ld (State.s_3D), a
        ld a, #04
        ld (State.s_39), a
        jp c_eb00
.l_9:
        ld ix, scene.obj1
        cp #01
        jr NZ, .l_12
        ld ix, scene
        ld hl, State.s_3E
        ld a, (hl)
        or a
        jr Z, .l_10
        dec (hl)
        ld hl, cS.heroKicks
        ld (ix+3), l
        ld (ix+4), h
        ret
.l_10:
        ld a, (State.s_28)
        or a
        jr NZ, .l_11
        ld hl, cS.heroStands
        ld (ix+3), l
        ld (ix+4), h
.l_11:
        xor a
        ld (State.s_3D), a
        ld ix, scene.obj1
        ld (ix+5), a
        ret
.l_12:
        cp #02
        jp NZ, .l_19
        ld hl, State.s_3E
        ld a, (hl)
        or a
        jr Z, .l_13
        dec (hl)
        push ix
        ld ix, scene
        ld hl, cS.heroThrows
        ld (ix+3), l
        ld (ix+4), h
        pop ix
.l_13:
        ld a, (State.s_40)
        or a
        jp NZ, .l_16
        call c_eb00
        jr NC, .l_15
        ld a, (State.s_3F)
        ld l, a
        ld h, #00
        ld de, c_df2b
        add hl, de
        ld a, (hl)
        cp #80
        jr Z, .l_14
        ld hl, State.s_3F
        inc (hl)
        ld (ix+20), a
.l_14:
        ld a, (ix+20)
        add (ix+2)
        ld (ix+2), a
        call c_d407.l_0
        jp NC, .l_18
        ld a, (ix+0)
        add #04
        ld (ix+0), a
        ld a, (ix+1)
        adc a, #00
        ld (ix+1), a
        call c_d460
        ld a, (ix+0)
        add #FC
        ld (ix+0), a
        ld a, (ix+1)
        adc a, #FF
        ld (ix+1), a
        ld a, (hl)
        call c_eaee
        cp #02
        ret C
.l_15:
        ld a, #06
        call playSound
        ld a, (ix+0)
        add #FC
        ld (ix+0), a
        ld a, (ix+1)
        adc a, #FF
        ld (ix+1), a
        ld a, (ix+2)
        add #F8
        ld (ix+2), a
        xor a
        ld (State.s_40), a
        ld (ix+21), a
        set 1, (ix+5)
        ld a, (State.soupCans)
        dec a
        ld (.l), a
.l_16:
.l+*    ld l, #00
        ld h, #00
        add hl, hl
        add hl, hl
        add hl, hl
        ld de, c_df47
        add hl, de
        ex de, hl
        ld a, (State.s_40)
        inc a
        ld (State.s_40), a
        srl a
        jr Z, .l_17
        dec a
.l_17:
        ld l, a
        ld h, #00
        add hl, de
        ld a, (hl)
        cp #FF
        jr Z, .l_18
        ld l, a
        ld h, #00
        add hl, hl
        ld de, explosionBubbles
        add hl, de
        ld a, (hl)
        inc hl
        ld h, (hl)
        ld (ix+3), a
        ld (ix+4), h
        ld (ix+9), #47
        jp c_eb00
.l_18:
        xor a
        ld (ix+5), a
        ld (State.s_3D), a
        ld (State.s_40), a
        ld (c_e308), a
        ret
.l_19:
        call c_d407.l_0
        jr NC, .l_18
        ld a, (ix+0)
        add #04
        ld (ix+0), a
        ld a, (ix+1)
        adc a, #00
        ld (ix+1), a
        ld a, (ix+2)
        add #08
        ld (ix+2), a
        call c_d460
        ld a, (ix+0)
        add #FC
        ld (ix+0), a
        ld a, (ix+1)
        adc a, #FF
        ld (ix+1), a
        ld a, (ix+2)
        add #F8
        ld (ix+2), a
        ld a, (hl)
        call c_eaee
        cp #02
        jp NC, .l_18
        call c_eb00
        jr NC, .l_18
        ld a, (State.s_3D)
        cp #03
        ret NZ
        ld a, (State.soupCans)
        cp #03
        jr Z, c_e31c
        ret

; (Some data on enemies?)
c_e308:  ; #e308
        db 0
c_e309:  ; #e309
        db 1, 5, 4, 6, 2, 10, 8, 9
c_e311:  ; #e311
        db 0, 0, 4, 0, 2, 1, 3, 0, 6, 7, 5

; (Some logic for enemies?)
; Used by c_df85.
c_e31c:  ; #e31c
        ld a, (c_e308)
        or a
        jr Z, .l_0
        dec a
        ld (c_e308), a
        ret
.l_0:
        ld ix, scene.obj1
        ld iy, scene.obj2
        ld de, #0032
        ld b, #06
.l_1:
        bit 0, (iy+5)
        jr Z, .l_2
        ld a, (iy+7)
        cp #FF
        jr Z, .l_2
        bit 7, (iy+5)
        jr NZ, .l_2
        ld a, (iy+12)
        cp #FE
        jr Z, .l_2
        cp #FF
        jr Z, .l_2
        ld l, (iy+0)
        ld h, (iy+1)
        ld de, #0020
        xor a
        sbc hl, de
        jr NC, .l_3
.l_2:
        add iy, de
        djnz .l_1
        ld a, (ix+21)
        and #03
        ld (ix+21), a
        ret
.l_3:
        ld a, (ix+21)
        ld l, a
        ld h, #00
        ld de, c_e311
        add hl, de
        ld b, (hl)
        ld (ix+21), #00
        ld l, (ix+0)
        ld h, (ix+1)
        ld e, (iy+0)
        ld d, (iy+1)
        xor a
        sbc hl, de
        jp P, .l_4
        ld a, h
        neg
        ld h, a
        ld a, l
        neg
        ld l, a
        inc hl
        set 0, (ix+21)
        jr .l_5
.l_4:
        set 1, (ix+21)
.l_5:
        ld de, #0004
        xor a
        sbc hl, de
        jr NC, .l_6
        ld (ix+21), #00
.l_6:
        ld a, (ix+2)
        sub (iy+2)
        jp P, .l_7
        neg
        set 2, (ix+21)
        jr .l_8
.l_7:
        set 3, (ix+21)
.l_8:
        cp #04
        jr NC, .l_9
        res 2, (ix+21)
        res 3, (ix+21)
.l_9:
        ld a, (ix+21)
        ld l, a
        ld h, #00
        ld de, c_e311
        add hl, de
        ld c, (hl)
        ld a, b
        sub c
        jp Z, .l_11
        and #07
        ld d, a
        ld a, c
        sub b
        and #07
        cp d
        ld a, #01
        jp C, .l_10
        neg
.l_10:
        add b
        and #07
        ld l, a
        ld h, #00
        ld de, c_e309
        add hl, de
        ld a, (hl)
        ld (ix+21), a
.l_11:
        ld a, #01
        ld (c_e308), a
        ret

; (Some data on weapons?)
heroWalkPhases:  ; #e401
        dw cS.heroWalks1
        dw cS.heroWalks2
        dw cS.heroStands
        dw cS.heroWalks3
        dw cS.heroWalks4
        dw cS.heroStands
.armed:
        dw cS.armedHeroWalks1
        dw cS.armedHeroWalks2
        dw cS.armedHeroStands
        dw cS.armedHeroWalks3
        dw cS.armedHeroWalks4
        dw cS.armedHeroStands

; (Some game logic with weapons?)
; Used by c_d709.
c_e419:  ; #e419
        ld a, (State.s_45)
        or a
        jr Z, .l_1
        dec a
        ld (State.s_45), a
        ld de, cS.heroSmallWalks
        ld a, (State.s_41)
        or a
        jr Z, .l_0
        inc (ix+6)
        ld a, (ix+6)
        and #02
        jr NZ, .l_0
        ld de, cS.heroSmallStands
.l_0:
        ld (ix+3), e
        ld (ix+4), d
        ret
.l_1:
        ld a, (State.s_41)
        or a
        ret Z
        ld hl, State.s_42
        inc (hl)
        ld a, (State.s_41)
        cp (hl)
        ret NZ
        ld (hl), #00
        inc (ix+6)
        ld a, (ix+6)
        cp #06
        jr C, .l_2
        xor a
        ld (ix+6), a
.l_2:
        add a
        ld l, a
        ld h, #00
        ld de, heroWalkPhases
        ld a, (State.weapon)
        cp 2
        jr C, .l_3
        ld de, heroWalkPhases.armed
.l_3:
        add hl, de
        ld e, (hl)
        inc hl
        ld d, (hl)
        ld (ix+3), e
        ld (ix+4), d
        ret


    ENDMODULE
