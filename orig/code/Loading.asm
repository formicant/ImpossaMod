    MODULE Loading

; Load block from tape
; (slightly modified ROM routine #0556)
;   arg `a`: block type (#80 level header, #FF data block)
;       `ix`: block start addr
;       `de`: block length
;       flag C should be set
;   ret flag C: ok, NC: error
; Used by c_c9ac.
loadBytes:  ; #c9fb
        inc d                   ; reset Z (`d` != #FF)
        exa                     ; `a'`: block type
        dec d                   ; restore `d` value
        
        di
        ld a, Colour.white | (1<<Port.tapeOut) ; ?
        out (Port.general), a
        
        in a, (Port.general)
        rra
        and (1<<Port.tapeIn)>>1
        or Colour.red
        ld c, a
        cp a                    ; set Z
.l_0:
        ret NZ                  ; ret if break pressed
.l_1:
        call c_ca84.l_0
        jr NC, .l_0
        ld hl, #0415
.l_2:
        djnz .l_2
        dec hl
        ld a, h
        or l
        jr NZ, .l_2
        call c_ca84
        jr NC, .l_0
.l_3:
        ld b, #9C
        call c_ca84
        jr NC, .l_0
        ld a, #C6
        cp b
        jr NC, .l_1
        inc h
        jr NZ, .l_3
.l_4:
        ld b, #C9
        call c_ca84.l_0
        jr NC, .l_0
        ld a, b
        cp #D4
        jr NC, .l_4
        call c_ca84.l_0
        ret NC
        ld a, c
        xor #03
        ld c, a
        ld h, #00
        ld b, #B0
        jr c_ca69

; (some tape loading subroutine?)
; Used by c_ca69.
c_ca4a:  ; #ca4a
        exa
        jr NZ, .l_0
        jr NC, .l_1
        ld (ix), l
        jr .l_2
.l_0:
        rl c
        xor l
        ret NZ
        ld a, c
        rra
        ld c, a
        inc de
        jr .l_3
.l_1:
        ld a, (ix)
        xor l
        ret NZ
.l_2:
        inc ix
.l_3:
        dec de
        exa
        ld b, #B2

; (some tape loading subroutine?)
; Used by c_c9fb.
c_ca69:  ; #ca69
        ld l, #01
.l_0:
        call c_ca84
        ret NC
        ld a, #CB
        cp b
        rl l
        ld b, #B0
        jp NC, .l_0
        ld a, h
        xor l
        ld h, a
        ld a, d
        or e
        jr NZ, c_ca4a
        ld a, h
        cp #01
        ret

; (some tape loading subroutine?)
; Used by c_c9fb and c_ca69.
c_ca84:  ; #ca84
        call .l_0
        ret NC
; This entry point is used by c_c9fb.
.l_0:
        ld a, #16
.l_1:
        dec a
        jr NZ, .l_1
        and a
.l_2:
        inc b
        ret Z
        ld a, high(Port.keys_BNMss)
        in a, (Port.general)
        rra
        xor c
        and #20
        jr Z, .l_2
        ld a, c
        cpl
        ld c, a
        and #07
        or #08
        out (Port.general), a
        scf
        ret

end:

    ENDMODULE
