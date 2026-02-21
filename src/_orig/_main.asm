    SLDOPT COMMENT WPMEM, LOGPOINT, ASSERTION
    DEVICE ZXSPECTRUM48

; Definitions
    INCLUDE "inc/macros.inc"
    INCLUDE "inc/basic.inc"
    INCLUDE "inc/enums.inc"
    INCLUDE "inc/structs.inc"
    INCLUDE "inc/port.inc"
    INCLUDE "inc/ay.inc"
    INCLUDE "data/Level.inc"

; Loading screen
    ORG #4000
    INCLUDE "data/Screen.asm"
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

    INCLUDE "data/Lev0Klondike/_index.asm"

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

    INCLUDE "data/Font.asm"

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
    INCLUDE "data/Headers.asm"

; Save level 0 Klondike
    INCLUDE "data/Lev0Klondike/_junk.asm"
    SAVETAP "original.tap", HEADLESS, Headers.level0, 1, #80
    SAVETAP "original.tap", HEADLESS, Level.start, Level.length

; Save level 1 Orient
    INCLUDE "data/Lev1Orient/_index.asm"
    SAVETAP "original.tap", HEADLESS, Headers.level1, 1, #80
    SAVETAP "original.tap", HEADLESS, Level.start, Level.length

; Save level 2 Amazon
    INCLUDE "data/Lev2Amazon/_index.asm"
    SAVETAP "original.tap", HEADLESS, Headers.level2, 1, #80
    SAVETAP "original.tap", HEADLESS, Level.start, Level.length

; Save level 3 Iceland
    INCLUDE "data/Lev3Iceland/_index.asm"
    SAVETAP "original.tap", HEADLESS, Headers.level3, 1, #80
    SAVETAP "original.tap", HEADLESS, Level.start, Level.length

; Save level 4 Bermuda
    INCLUDE "data/Lev4Bermuda/_index.asm"
    SAVETAP "original.tap", HEADLESS, Headers.level4, 1, #80
    SAVETAP "original.tap", HEADLESS, Level.start, Level.length
