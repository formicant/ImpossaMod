; `ORG` that checks possible overlap
    MACRO _NEXT_ORG addr?
    ASSERT $ <= addr?
    ORG addr?
    ENDM


; In debug mode, set border color
;   spoils: `a`
;   time: debug 18, release 0
;   size: debug 4, release 0
    MACRO _DEBUG_BORDER color?
    IFDEF _DEBUG
        ld a, color?
        out (#FE), a
    ENDIF
    ENDM
