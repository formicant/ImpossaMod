    MODULE Code

; Code that executes once at game start and can be disposed of afterwards


ldBytes EQU #0556               ; ROM tape loading procedure


entryPoint:
        ; Detect Spectrum model (48K/128K)
        ld bc, #7FFD            ; memory paging port
        ld hl, Level.end        ; an unused address in RAM slot 3

        ld (hl), #00
        ld a, #11
        out (c), a              ; set RAM page 1
        ld (hl), #FF
        dec a
        out (c), a              ; set RAM page 0 again

        ld a, (hl)              ; #FF if 48K, #00 if 128K
        ld (is48k), a           ; copy the value to permanent `is48k` variable
        or a
        jp NZ, .initInterrupts  ; skip if 48K

        ; if 128K
.loadAllLevels:
        ; load all levels into memory pages
        ld hl, levelMemPages
.level:
        ld a, (hl)
        out (c), a              ; set level RAM page
        push bc, hl

        ; load level header
        ld ix, Level.end
        ld de, 1
        ld a, #80               ; non-standard flag
        scf
        call ldBytes
        jr NC, .loadingError

        ; load level
        ld ix, Level.start
        ld de, Level.length
        ld a, #FF               ; code block flag
        scf
        call ldBytes
        jr NC, .loadingError

        pop hl, bc
        inc l
        ld a, l
        cp low(levelMemPages.end)
        jr C, .level

        ld a, #10
        out (c), a              ; set RAM page 0
        di

; entry point used in the .sna snapshot
.sna:
        ; replace tape level loader with memory level loader
        ld hl, loadLevelFromMemory
        ld bc, loadLevelFromMemory.length
        ld de, loadLevel
        ldir

        ; move AY-related code and data
        ; TODO !

.initInterrupts:
        ld sp, stackTop
        ld a, high(interruptTable)
        ld i, a
        im 2
        ei

.initGame:
        ld a, -1                ; no level is loaded into page 0
        ld (State.loadedLevel), a
        jp gameStart

.loadingError:
        jp 0


    ENDMODULE
