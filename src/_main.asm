    SLDOPT COMMENT WPMEM, LOGPOINT, ASSERTION
    ; DEVICE ZXSPECTRUM128
    DEVICE ZXSPECTRUM48
    
    DEFINE _MOD

; Definitions
    INCLUDE "macros.inc"
    INCLUDE "orig/basic.inc"
    INCLUDE "level.inc"
    INCLUDE "orig/ay.inc"

; Loading screen
    ORG #4000
    INCLUDE "orig/data/loading_screen.asm"
    INCLUDE "orig/var/buffers.asm"

; Basic loader
    ORG #5CCB
    INCLUDE "basic_loader.asm"

; Code
    ORG #6BFC   ; #BEFC
codeStart:
    INCLUDE "orig/data/object_types.asm"
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

    _NEXT_ORG #A7E4
    INCLUDE "orig/data/sprites.asm"
    
    _NEXT_ORG #B9AA ; #BDDF
    INCLUDE "orig/code/sound.asm"
    DISPLAY $
    _NEXT_ORG #BEB3
    INCLUDE "orig/var/scene_objects.asm"
    _NEXT_ORG #C044
    INCLUDE "orig/code/drawing.asm"
    INCLUDE "orig/code/game_menu.asm"
    INCLUDE "orig/code/utils.asm"
    INCLUDE "orig/code/controls.asm"
    INCLUDE "orig/code/level_loading.asm"
    _NEXT_ORG #CAA5
    INCLUDE "orig/data/font.asm"
    INCLUDE "orig/code/code.asm"
    _NEXT_ORG #FC12
    ; empty space, 238 bytes
    _NEXT_ORG #FD00
    INCLUDE "interrupt_table.asm"
    ORG #FE01
    INCLUDE "orig/var/state.asm"
    ORG #FE01
    INCLUDE "disposable.asm"
    _NEXT_ORG #FEFE
    INCLUDE "interrupt.asm"



codeLength = $ - codeStart

    ORG #CC27
        db 0

    SAVESNA "impossamod.sna", #CC25

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

