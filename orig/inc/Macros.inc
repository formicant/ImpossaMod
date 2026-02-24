; `ORG` that checks possible overlap
    MACRO _NEXT_ORG addr?
    ASSERT $ <= addr?
    ORG addr?
    ENDM


; In debug mode, set border colour
;   spoils: `a`
;   time: debug 18, release 0
;   size: debug 4, release 0
    MACRO _DEBUG_BORDER colour?
    IFDEF _DEBUG
        ld a, colour?
        out (Port.general), a
    ENDIF
    ENDM


; Add unsigned `a` to a register pair
;   spoils: `af`
;   time: 20, length: 5
    MACRO _ADD_RR_A regH?, regL?
        add regL?
        ld regL?, a
        adc regH?
        sub regL?
        ld regH?, a
    ENDM

; `bc <- bc + a` (unsigned)
;   spoils: `af`
;   time: 20, length: 5
    MACRO _ADD_BC_A
        _ADD_RR_A b, c
    ENDM

; `de <- de + a` (unsigned)
;   spoils: `af`
;   time: 20, length: 5
    MACRO _ADD_DE_A
        _ADD_RR_A d, e
    ENDM

; `hl <- hl + a` (unsigned)
;   spoils: `af`
;   time: 20, length: 5
    MACRO _ADD_HL_A
        _ADD_RR_A h, l
    ENDM

; Substitutions for print coordinates
; ```
;   ld hl, _ROW 12 _COL 7
;   call Utils.printString
; ```
    DEFINE _ROW #100 *
    DEFINE _COL +