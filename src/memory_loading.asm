    MODULE Code


; Copy level from its memory page into fast memory page 0
; Screen is used as temporary buffer
loadLevelFromMemory:

; In 128K mode, this code should replace `loadLevel`
    DISP loadLevel

        ; set black attrs to hide the artifacts
        ; xor a
        ; call fillScreenAttrs

        ; get level memory page
        ld hl, levelMemPages
        ld a, (State.level)
        add l
        ld l, a
        ld a, (hl)
        exa                     ; `a'`: level page
        
        ld a, #10
        
        exa
        ld bc, #7FFD
        out (c), a
        ld bc, Screen.pixLength
        ld hl, Level.start
        ld de, Screen.start
        ldir
        exa
        ld bc, #7FFD
        out (c), a
        ld bc, Screen.pixLength
        ld hl, Screen.start
        ld de, Level.start
        ldir
        
        exa
        ld bc, #7FFD
        out (c), a
        ld bc, Screen.pixLength
        ld hl, Level.start + Screen.pixLength
        ld de, Screen.start
        ldir
        exa
        ld bc, #7FFD
        out (c), a
        ld bc, Screen.pixLength
        ld hl, Screen.start
        ld de, Level.start + Screen.pixLength
        ldir
        
        exa
        ld bc, #7FFD
        out (c), a
        ld bc, Level.length - 2 * Screen.pixLength
        ld hl, Level.start + 2 * Screen.pixLength
        ld de, Screen.start
        ldir
        exa
        ld bc, #7FFD
        out (c), a
        ld bc, Level.length - 2 * Screen.pixLength
        ld hl, Screen.start
        ld de, Level.start + 2 * Screen.pixLength
        ldir
        
        scf
        ret

;         ; data to copy
;         ld hl, Level.start
;         ld bc, Level.length

;         ; copy the data, 6 kB per step
; .step:
;         ld a, b
;         sub high(Screen.pixLength)
;         jr C, .lastStep

;         ld b, a
;         push bc                 ; next step length
;         ld bc, Screen.pixLength ; current length

; .copy:
;         push hl, bc, hl, bc, hl

;         ld bc, #7FFD
;         exa
;         out (c), a              ; set level page
;         exa
;         pop hl, bc
;         ld de, Screen.start
;         ldir                    ; copy from level page to screen

;         ld bc, #7FFD
;         ld a, #10
;         out (c), a              ; set page 0
;         pop de, bc
;         ld hl, Screen.start
;         ldir                    ; copy from screen to page 0

;         pop hl, bc
;         ld a, h
;         add high(Screen.pixLength)
;         ld h, a                 ; `hl`: next step start

;         ld a, b
;         or c
;         jr NZ, .step            ; if next step length != 0

;         scf                     ; no loading error
;         ret

; .lastStep:
;         ld de, 0
;         push de                 ; next step length
;                                 ; `bc`: current length
;         jr .copy

    ASSERT $ <= loadLevelEnd
    ENT

.length EQU $ - loadLevelFromMemory


    ENDMODULE
