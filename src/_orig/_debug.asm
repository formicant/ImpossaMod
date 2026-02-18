    SLDOPT COMMENT WPMEM, LOGPOINT, ASSERTION
    DEVICE ZXSPECTRUM48

    DEFINE _DEBUG

; Definitions
    INCLUDE "inc/macros.inc"
    INCLUDE "inc/basic.inc"
    INCLUDE "inc/enums.inc"
    INCLUDE "inc/structs.inc"
    INCLUDE "inc/port.inc"
    INCLUDE "inc/ay.inc"
    INCLUDE "inc/level.inc"

; Loading screen
    ORG #4000
    INCLUDE "data/loading_screen.asm"
    INCLUDE "var/tables.asm"

; Basic loader
    ORG #5CCB   ; overlap
    INCLUDE "basic_loader.asm"

; Code
    ORG #5E00
codeStart:
    INCLUDE "code/detect_model.asm"

    ORG #5E80
    DISP #C000
    INCLUDE "code/ay_sound.asm"
    ENT

    ORG Level.start
    INCLUDE "data/0_klondike/tiles.asm"
    ORG Level.objectTable
    INCLUDE "data/0_klondike/object_table.asm"
    ORG Level.blockMap
    INCLUDE "data/0_klondike/block_map.asm"
    INCLUDE "data/sprites.asm"
    INCLUDE "data/0_klondike/sprites.asm"
    ORG Level.transitTable
    INCLUDE "data/0_klondike/transits.asm"
    ORG Level.trajVelTable
    INCLUDE "data/0_klondike/traj_table.asm"
    INCLUDE "data/object_types.asm"
    INCLUDE "data/0_klondike/object_types.asm"
    INCLUDE "data/0_klondike/trajectories.asm"
    ORG #BDDF
    INCLUDE "code/sound.asm"
    INCLUDE "code/beeper_sound.asm"
    INCLUDE "var/scene.asm"
    ORG #BEB4   ; overlap
    INCLUDE "code/init_interrupts.asm"
    INCLUDE "code/interrupt.asm"
    ORG #C044
    INCLUDE "code/drawing.asm"
    INCLUDE "code/game_menu.asm"
    INCLUDE "code/utils.asm"
    INCLUDE "code/controls.asm"
    INCLUDE "code/level_loading.asm"

    INCLUDE "data/font.asm"

    INCLUDE "code/entry_point.asm"
    INCLUDE "code/game_loop.asm"
    INCLUDE "code/code.asm"
    INCLUDE "code/panel.asm"
    INCLUDE "code/logic_0.asm"
    INCLUDE "code/level_select_menu.asm"
    INCLUDE "code/game_win.asm"
    INCLUDE "code/logic_1.asm"
    INCLUDE "code/select_sprite.asm"
    INCLUDE "code/logic_2.asm"
    INCLUDE "code/boss_switch.asm"
    INCLUDE "code/boss0_klondike.asm"
    INCLUDE "code/boss1_orient.asm"
    INCLUDE "code/boss2_amazon.asm"
    INCLUDE "code/boss3_iceland.asm"
    INCLUDE "code/boss4_bermuda.asm"
    INCLUDE "code/boss1_extra.asm"

    DISPLAY #FE01 - $

    ORG #FE01
    INCLUDE "var/state.asm"

; Fixes
    ORG Code.entryPoint.lev:
        db 0

    MODULE Lev2Amazon
lS:
.sittingMonkey  EQU 0
    ENDMODULE

; Save game
    SAVESNA "orig_debug.sna", Code.entryPoint
