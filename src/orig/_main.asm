    SLDOPT COMMENT WPMEM, LOGPOINT, ASSERTION
    DEVICE ZXSPECTRUM48

; Definitions
    INCLUDE "basic.inc"
    INCLUDE "level.inc"
    INCLUDE "ay.inc"

; Loading screen
    ORG #4000
    INCLUDE "data/loading_screen.asm"

; Basic loader
    ORG #5CCB
    INCLUDE "basic_loader.asm"

; Code
    ORG #5E00
codeStart:
    INCLUDE "code/detect_model.asm"

    ORG #5E80
    INCLUDE "code/ay_sound.asm"

    ORG Level.start
    INCLUDE "data/0_klondike/tiles.asm"
    INCLUDE "data/0_klondike/object_table.asm"
    INCLUDE "data/0_klondike/block_map.asm"
    INCLUDE "data/common_sprites.asm"
    INCLUDE "data/0_klondike/sprites.asm"
    INCLUDE "data/0_klondike/transits.asm"
    ORG Level.trajVelTable
    INCLUDE "data/0_klondike/traj_table.asm"
    INCLUDE "data/common_object_types.asm"
    INCLUDE "data/0_klondike/object_types.asm"
    INCLUDE "data/0_klondike/trajectories.asm"

    ORG #BDDF
    INCLUDE "code/sound.asm"
    ORG #BEB4
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
    INCLUDE "code/code.asm"

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
    INCLUDE "data/1_orient/map.asm"
    ORG Level.sprites
    INCLUDE "data/1_orient/sprites.asm"
    INCLUDE "data/1_orient/transits.asm"
    INCLUDE "data/1_orient/types_traj.asm"
        block Level.end - $                 ; cleanup

    SAVETAP "original.tap", HEADLESS, Headers.level1, 1, #80
    SAVETAP "original.tap", HEADLESS, Level.start, Level.length

; Save level 2 Amazon
    ORG Level.start
    INCLUDE "data/2_amazon/map.asm"
    ORG Level.sprites
    INCLUDE "data/2_amazon/sprites.asm"
    INCLUDE "data/2_amazon/transits.asm"
    ; junk from 1_orient here
    ORG Level.trajVelTable
    INCLUDE "data/2_amazon/types_traj.asm"
        dh 9E 47 00 01 10 10 FF             ; junk
        block 13 : db 1                     ; junk
        block Level.end - $                 ; cleanup

    SAVETAP "original.tap", HEADLESS, Headers.level2, 1, #80
    SAVETAP "original.tap", HEADLESS, Level.start, Level.length

; Save level 3 Iceland
    ORG Level.start
    INCLUDE "data/3_iceland/map.asm"
    ORG Level.sprites
    INCLUDE "data/3_iceland/sprites.asm"
    INCLUDE "data/0_klondike/transits.asm"  ; junk from 0_klondike
        block Level.end - $                 ; cleanup
    ORG Level.transitTable
    INCLUDE "data/3_iceland/transits.asm"
    ORG Level.trajVelTable
    INCLUDE "data/3_iceland/types_traj.asm"

    SAVETAP "original.tap", HEADLESS, Headers.level3, 1, #80
    SAVETAP "original.tap", HEADLESS, Level.start, Level.length

; Save level 4 Bermuda
    ORG Level.start
    INCLUDE "data/4_bermuda/map.asm"
    ORG Level.sprites
    INCLUDE "data/4_bermuda/sprites.asm"
        block Level.end - $                 ; cleanup
    ORG Level.transitTable
    INCLUDE "data/4_bermuda/transits.asm"
    ORG Level.trajVelTable
    INCLUDE "data/4_bermuda/types_traj.asm"

    SAVETAP "original.tap", HEADLESS, Headers.level4, 1, #80
    SAVETAP "original.tap", HEADLESS, Level.start, Level.length
