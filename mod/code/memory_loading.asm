    MODULE Loading

; In 128K mode, this code should replace `loadBytes`
loadLevelFromMemoryStored
    DISP Loading.loadBytes

; Copy level from its memory page into fast memory page 0
; Screen is used as temporary buffer
loadLevelFromMemory:
        di
        ; set black attrs to hide the artifacts
        xor a
        call Utils.fillScreenAttrs

        ; get level memory page
        ld hl, Tables.levelMemPages
        ld a, (State.level)
        add l
        ld l, a
        ld a, (hl)
        exa                     ; `a'`: level page

        ; data to copy
        ld hl, Level.start
        ld bc, Level.length

        ; copy the data, 6 kB per step
.step:
        ld a, b
        sub high(Screen.pixLength)
        jr C, .lastStep

        ld b, a
        push bc                 ; next step length
        ld bc, Screen.pixLength ; current length

.copy:
        push hl, bc, hl, bc, hl

        ld bc, Port.memory
        exa
        out (c), a              ; set level page
        exa
        pop hl, bc
        ld de, Screen.start
        call copyMemoryBlock    ; copy from level page to screen

        ld bc, Port.memory
        ld a, (1<<Port.memory.rom48) | 0
        out (c), a              ; set page 0
        pop de, bc
        ld hl, Screen.start
        call copyMemoryBlock    ; copy from screen to page 0

        pop hl, bc
        ld a, h
        add high(Screen.pixLength)
        ld h, a                 ; `hl`: next step start

        ld a, b
        or c
        jr NZ, .step            ; if next step length != 0

        scf                     ; no loading error
        ei
        ret

.lastStep:
        ld de, 0
        push de                 ; next step length
                                ; `bc`: current length
        jr .copy


; `ldir` but faster
copyMemoryBlock:
        xor a
        sub c
        and %00001111
        add a
        ld (.jump), a
.jump+1 jr $-0
.loop:
    .16 ldi
        jp PE, .loop
        ret

    ASSERT $ <= Loading.end
    ENT

loadLevelFromMemoryLength   EQU $ - loadLevelFromMemoryStored

    ENDMODULE
