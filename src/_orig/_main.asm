    SLDOPT COMMENT WPMEM, LOGPOINT, ASSERTION
    DEVICE ZXSPECTRUM48

; Definitions
    INCLUDE "inc/macros.inc"
    INCLUDE "inc/basic.inc"
    INCLUDE "inc/structs.inc"
    INCLUDE "inc/level.inc"
    INCLUDE "inc/ay.inc"

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
    ORG #CAA5
    INCLUDE "data/font.asm"
    ORG #CC25
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

    ORG #FE01
    INCLUDE "var/state.asm"

; Save game
    EMPTYTAP "original.tap"
    SAVETAP "original.tap", BASIC, "Monty", Basic.start, Basic.length, 0
    SAVETAP "original.tap", CODE, "$", Screen.start, Screen.length
    SAVETAP "original.tap", CODE, "code", codeStart, #9F00, #6000

; Save levels
    ORG 0
    INCLUDE "data/headers.asm"

; Save level 0 Klondike
    ORG Level.transitTable
    INCLUDE "data/4_bermuda/transits.asm"   ; junk from 4_bermuda
    ORG Level.transitTable
    INCLUDE "data/0_klondike/transits.asm"

    SAVETAP "original.tap", HEADLESS, Headers.level0, 1, #80
    SAVETAP "original.tap", HEADLESS, Level.start, Level.length

; Save level 1 Orient
    ORG Level.start
    INCLUDE "data/1_orient/tiles.asm"
        block Level.objectTable - $         ; cleanup
    ORG Level.objectTable
    INCLUDE "data/1_orient/object_table.asm"
        block Level.blockMap - $            ; cleanup
    ORG Level.blockMap
    INCLUDE "data/1_orient/block_map.asm"
    ORG Level.sprites
    INCLUDE "data/1_orient/sprites.asm"
        block Level.transitTable - $        ; cleanup
    ORG Level.transitTable
    INCLUDE "data/1_orient/transits.asm"
    INCLUDE "data/1_orient/traj_table.asm"
    ORG Level.levObjectTypes
    INCLUDE "data/1_orient/object_types.asm"
    INCLUDE "data/1_orient/trajectories.asm"
        block Level.end - $                 ; cleanup

    SAVETAP "original.tap", HEADLESS, Headers.level1, 1, #80
    SAVETAP "original.tap", HEADLESS, Level.start, Level.length

; Save level 2 Amazon
    ORG Level.start
    INCLUDE "data/2_amazon/tiles.asm"
    ORG Level.objectTable
    INCLUDE "data/2_amazon/object_table.asm"
    ORG Level.blockMap
    INCLUDE "data/2_amazon/block_map.asm"
    ORG Level.sprites
    INCLUDE "data/2_amazon/sprites.asm"
        block Level.transitTable - $        ; cleanup
    ORG Level.transitTable
    INCLUDE "data/2_amazon/transits.asm"
    ; junk from 1_orient here
    ORG Level.trajVelTable
    INCLUDE "data/2_amazon/traj_table.asm"
    ORG Level.levObjectTypes
    INCLUDE "data/2_amazon/object_types.asm"
    INCLUDE "data/2_amazon/trajectories.asm"
        dh 9E 47 00 01 10 10 FF             ; junk
        block 13 : db 1                     ; junk
        block Level.end - $                 ; cleanup

    SAVETAP "original.tap", HEADLESS, Headers.level2, 1, #80
    SAVETAP "original.tap", HEADLESS, Level.start, Level.length

; Save level 3 Iceland
    ORG Level.start
    INCLUDE "data/3_iceland/tiles.asm"
        block Level.objectTable - $         ; cleanup
    ORG Level.objectTable
    INCLUDE "data/3_iceland/object_table.asm"
        block Level.blockMap - $            ; cleanup
    ORG Level.blockMap
    INCLUDE "data/3_iceland/block_map.asm"
    ORG Level.sprites
    INCLUDE "data/3_iceland/sprites.asm"
    ORG Level.transitTable
    INCLUDE "data/0_klondike/transits.asm"  ; junk from 0_klondike
        block Level.trajVelTable - $        ; cleanup
    ORG Level.transitTable
    INCLUDE "data/3_iceland/transits.asm"
    ORG Level.trajVelTable
    INCLUDE "data/3_iceland/traj_table.asm"
    ORG Level.levObjectTypes
    INCLUDE "data/3_iceland/object_types.asm"
    INCLUDE "data/3_iceland/trajectories.asm"

    SAVETAP "original.tap", HEADLESS, Headers.level3, 1, #80
    SAVETAP "original.tap", HEADLESS, Level.start, Level.length

; Save level 4 Bermuda
    ORG Level.start
    INCLUDE "data/4_bermuda/tiles.asm"
    ORG Level.objectTable
    INCLUDE "data/4_bermuda/object_table.asm"
    ORG Level.blockMap
    INCLUDE "data/4_bermuda/block_map.asm"
    ORG Level.sprites
    INCLUDE "data/4_bermuda/sprites.asm"
    ORG Level.transitTable
    INCLUDE "data/4_bermuda/transits.asm"
    ORG Level.trajVelTable
    INCLUDE "data/4_bermuda/traj_table.asm"
    ORG Common.objectTypes + 10
        db 8    ; overridden property (TODO: is it significant?)
    ORG Level.levObjectTypes
    INCLUDE "data/4_bermuda/object_types.asm"
    INCLUDE "data/4_bermuda/trajectories.asm"

    SAVETAP "original.tap", HEADLESS, Headers.level4, 1, #80
    SAVETAP "original.tap", HEADLESS, Level.start, Level.length
