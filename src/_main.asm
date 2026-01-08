    SLDOPT COMMENT WPMEM, LOGPOINT, ASSERTION
    DEVICE ZXSPECTRUM128

; Definitions
    INCLUDE "orig/basic.inc"
    INCLUDE "orig/level.inc"
    INCLUDE "orig/ay.inc"

; Loading screen
    ORG #4000
    INCLUDE "orig/data/loading_screen.asm"

; Basic loader
    ORG #5CCB
    INCLUDE "basic_loader.asm"

; Code
    ORG #5E00
codeStart:
    INCLUDE "orig/code/detect_model.asm"

    ORG #5E80
    INCLUDE "orig/code/ay_sound.asm"

    ORG Level.start
    INCLUDE "orig/data/0_klondike/map.asm"
    INCLUDE "orig/data/common_sprites.asm"
    INCLUDE "orig/data/0_klondike/sprites.asm"
    INCLUDE "orig/data/0_klondike/transits.asm"
    ORG Level.trajVelTable
    INCLUDE "orig/data/0_klondike/types_traj.asm"

    ORG #BDDF
    INCLUDE "orig/code/sound.asm"
    ORG #BEB4
    INCLUDE "orig/code/init_interrupts.asm"
    INCLUDE "orig/code/interrupt.asm"
    ORG #C044
    INCLUDE "orig/code/drawing.asm"
    INCLUDE "orig/code/game_menu.asm"
    INCLUDE "orig/code/utils.asm"
    INCLUDE "orig/code/controls.asm"
    INCLUDE "orig/code/level_loading.asm"
    ORG #CAA5
    INCLUDE "orig/data/font.asm"
    ORG #CC25
    INCLUDE "orig/code/entry_point.asm"
    INCLUDE "orig/code/code.asm"


    SAVESNA "impossamod.sna", #CC25

; Save game
    EMPTYTAP "impossamod.tap"
    SAVETAP "impossamod.tap", BASIC, "ImpossaMod", Basic.start, Basic.length, 1
    SAVETAP "impossamod.tap", CODE, "screen", Screen.start, Screen.length
    SAVETAP "impossamod.tap", CODE, "impossamod", codeStart, #9F00

; Save levels
    ORG 0
    INCLUDE "orig/data/headers.asm"

