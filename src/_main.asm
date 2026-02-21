    SLDOPT COMMENT WPMEM, LOGPOINT, ASSERTION
    DEVICE ZXSPECTRUM128

    DEFINE _MOD
    DEFINE _DEBUG

; Definitions
    INCLUDE "_orig/inc/macros.inc"
    INCLUDE "_orig/inc/basic.inc"
    INCLUDE "_orig/inc/enums.inc"
    INCLUDE "_orig/inc/structs.inc"
    INCLUDE "_orig/inc/port.inc"
    INCLUDE "_orig/inc/ay.inc"
    INCLUDE "inc/memory.inc"
    INCLUDE "data/Level.inc"


; Slow memory
    ORG #4000
; Loading screen
    INCLUDE "_orig/data/Screen.asm"

; Basic loader
    ORG #5CCB
    INCLUDE "basic_loader.asm"

; Code
    ORG #6000
codeStart:
    INCLUDE "data/Font.asm"

    INCLUDE "_orig/code/game_loop.asm"
    INCLUDE "_orig/code/code.asm"
    INCLUDE "_orig/code/logic_0.asm"
    INCLUDE "_orig/code/level_select_menu.asm"
    INCLUDE "_orig/code/game_win.asm"
    INCLUDE "_orig/code/utils.asm"
    INCLUDE "_orig/code/logic_1.asm"
    INCLUDE "code/game_menu.asm"
    INCLUDE "code/panel.asm"
    INCLUDE "code/boss_switch.asm"
    INCLUDE "code/controls.asm"
    INCLUDE "code/sound.asm"

    DISPLAY "Slow free: ", #8000 - $

; Fast memory
    _NEXT_ORG #8000
    INCLUDE "data/tables.asm"

    ORG Code.disposable         ; will be overwritten with tables
    INCLUDE "code/entry_point.asm"
    INCLUDE "code/memory_loading.asm"
    ; INCLUDE "_orig/code/ay_sound.asm"    ; length: #D78 = 3448

    DISPLAY "Disp free: ", Code.interruptRoutine - $

    _NEXT_ORG #9191
    INCLUDE "code/interrupt.asm"

    INCLUDE "_orig/code/select_sprite.asm"
    INCLUDE "_orig/code/logic_2.asm"
    ; INCLUDE "_orig/code/beeper_sound.asm"
    INCLUDE "_orig/code/level_loading.asm"
    INCLUDE "code/drawing.asm"

    DISPLAY "Fast free: ", stackTop - $

    _NEXT_ORG #AEAE
stackTop:
; Data
    INCLUDE "data/Common.asm"
    _NEXT_ORG Level.start

codeLength = $ - codeStart

; Variables
    ORG Level.end
    INCLUDE "_orig/var/state.asm"
    INCLUDE "_orig/var/scene.asm"

; Levels
    ORG 0
    INCLUDE "_orig/data/Headers.asm"

    PAGE MemPage.level0           ; Klondike
    INCLUDE "data/Lev0Klondike.asm"

    PAGE MemPage.level1           ; Orient
    INCLUDE "data/Lev1Orient.asm"

    PAGE MemPage.level2           ; Amazon
    INCLUDE "data/Lev2Amazon.asm"

    PAGE MemPage.level3           ; Iceland
    INCLUDE "data/Lev3Iceland.asm"

    PAGE MemPage.level4           ; Bermuda
    INCLUDE "data/Lev4Bermuda.asm"

    PAGE 0


; Output
    SAVESNA "impossamod.sna", Code.entryPoint.sna

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
