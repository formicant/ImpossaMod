    SLDOPT COMMENT WPMEM, LOGPOINT, ASSERTION
    ; DEVICE ZXSPECTRUM128
    DEVICE ZXSPECTRUM48
    
    DEFINE _MOD
    DEFINE _DEBUG

; Definitions
    INCLUDE "orig/macros.inc"
    INCLUDE "orig/basic.inc"
    INCLUDE "orig/structs.inc"
    INCLUDE "memory.inc"
    INCLUDE "level.inc"
    INCLUDE "orig/ay.inc"


; Slow memory

; Loading screen
    ORG #4000
    INCLUDE "orig/data/loading_screen.asm"

; Basic loader
    ORG #5CCB
    INCLUDE "basic_loader.asm"

; Code
    ORG #6200   ; #BEFC
codeStart:
    INCLUDE "orig/code/code.asm"
    INCLUDE "orig/code/game_menu.asm"
    INCLUDE "orig/code/utils.asm"
    INCLUDE "orig/code/controls.asm"
    INCLUDE "orig/code/logic_1.asm"
    INCLUDE "boss_switch.asm"

    _NEXT_ORG #7E80
    INCLUDE "orig/data/font.asm"


; Fast memory
    
    _NEXT_ORG #8000
    INCLUDE "tables.asm"
    
    ORG #8000   ; will be overwritten with tables
    INCLUDE "disposable.asm"
    DISP Level.end
    INCLUDE "orig/code/level_loading.asm"
    ENT
    
    _NEXT_ORG #9191
    INCLUDE "interrupt.asm"
    
    INCLUDE "orig/code/drawing.asm"
    INCLUDE "orig/code/select_sprite.asm"
    INCLUDE "orig/code/logic_2.asm"
    INCLUDE "sound.asm"
    
    DISPLAY "Stack size, words: ", (stackTop - $) / 2

; Data
    _NEXT_ORG #AD34
stackTop:
    INCLUDE "orig/data/sprites.asm"
    _NEXT_ORG #BEFC
    INCLUDE "orig/data/object_types.asm"
    
    _NEXT_ORG Level.start
    INCLUDE "orig/data/0_klondike/object_types.asm"
    _NEXT_ORG Level.objectTable
    INCLUDE "orig/data/0_klondike/object_table.asm"
    _NEXT_ORG Level.tilePixels
    INCLUDE "orig/data/0_klondike/tiles.asm"
    INCLUDE "orig/data/0_klondike/trajectories.asm"
    _NEXT_ORG Level.trajVelTable
    INCLUDE "orig/data/0_klondike/traj_table.asm"
    _NEXT_ORG Level.blockMap
    INCLUDE "orig/data/0_klondike/block_map.asm"
    INCLUDE "orig/data/0_klondike/transits.asm"
    ALIGN 4
    INCLUDE "orig/data/0_klondike/sprites.asm"
    _NEXT_ORG Level.end
    
    _NEXT_ORG #FDE5
    INCLUDE "orig/var/state.asm"
    INCLUDE "orig/var/scene.asm"

codeLength = $ - codeStart

    ORG Code.entryPoint.lev
        db 0

    SAVESNA "impossamod.sna", Code.entryPoint

; Save game
    EMPTYTAP "impossamod.tap"
    SAVETAP "impossamod.tap", BASIC, "ImpossaMod", Basic.start, Basic.length, 1
    SAVETAP "impossamod.tap", CODE, "screen", Screen.start, Screen.length
    SAVETAP "impossamod.tap", CODE, "impossamod", codeStart, codeLength

; ; Save levels
;     ORG 0
;     INCLUDE "orig/data/headers.asm"

; ; Save level 0 Klondike
;     SAVETAP "impossamod.tap", HEADLESS, Headers.level0, 1, #80
;     SAVETAP "impossamod.tap", HEADLESS, Level.start, Level.length

