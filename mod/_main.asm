    SLDOPT COMMENT WPMEM, LOGPOINT, ASSERTION
    DEVICE ZXSPECTRUM128

    DEFINE _MOD
    ; DEFINE _DEBUG

; Definitions
    INCLUDE "inc/_index.inc"

; Slow memory
    ORG #4000
; Loading screen
    INCLUDE "orig/data/Screen.asm"
; Basic loader
    ORG #5CCB
    INCLUDE "basicLoader.asm"

; Code block
    ORG #6000
codeStart:
    INCLUDE "data/Font.asm"
    INCLUDE "code/_slow.asm"
    DISPLAY "Slow free: ", #8000 - $

; Fast memory
    _NEXT_ORG #8000
    INCLUDE "var/Tables.asm"
    ORG Tables.disposable       ; will be overwritten with tables
    INCLUDE "code/_disp.asm"
    DISPLAY "Disp free: ", Interrupt.routine - $

    _NEXT_ORG #9191             ; interrupt routine addr
    INCLUDE "code/_fast.asm"
    DISPLAY "Fast free: ", stackTop - $

    _NEXT_ORG #AEAE
stackTop:
; Data
    INCLUDE "data/Common.asm"
    _NEXT_ORG Level.start

codeLength = $ - codeStart

; Variables
    ORG Level.end
    INCLUDE "var/_index.asm"

; Levels
    ORG 0
    INCLUDE "orig/data/Headers.asm"

    PAGE MemPage.level0         ; Klondike
    INCLUDE "data/Lev0Klondike.asm"
    PAGE MemPage.level1         ; Orient
    INCLUDE "data/Lev1Orient.asm"
    PAGE MemPage.level2         ; Amazon
    INCLUDE "data/Lev2Amazon.asm"
    PAGE MemPage.level3         ; Iceland
    INCLUDE "data/Lev3Iceland.asm"
    PAGE MemPage.level4         ; Bermuda
    INCLUDE "data/Lev4Bermuda.asm"
    PAGE 0

; Output
    SAVESNA "impossamod.sna", Main.entryPoint.sna

    EMPTYTAP "impossamod.tap"
    SAVETAP "impossamod.tap", BASIC, "ImpossaMod", Basic.start, Basic.length, 1
    SAVETAP "impossamod.tap", CODE, "screen", Screen.start, Screen.length
    SAVETAP "impossamod.tap", CODE, "impossamod", codeStart, codeLength
    PAGE MemPage.level0     ; Klondike
    SAVETAP "impossamod.tap", HEADLESS, Headers.level0, 1, #80
    SAVETAP "impossamod.tap", HEADLESS, Level.start, Level.length
    PAGE MemPage.level1     ; Orient
    SAVETAP "impossamod.tap", HEADLESS, Headers.level1, 1, #80
    SAVETAP "impossamod.tap", HEADLESS, Level.start, Level.length
    PAGE MemPage.level2     ; Amazon
    SAVETAP "impossamod.tap", HEADLESS, Headers.level2, 1, #80
    SAVETAP "impossamod.tap", HEADLESS, Level.start, Level.length
    PAGE MemPage.level3     ; Iceland
    SAVETAP "impossamod.tap", HEADLESS, Headers.level3, 1, #80
    SAVETAP "impossamod.tap", HEADLESS, Level.start, Level.length
    PAGE MemPage.level4     ; Bermuda
    SAVETAP "impossamod.tap", HEADLESS, Headers.level4, 1, #80
    SAVETAP "impossamod.tap", HEADLESS, Level.start, Level.length
