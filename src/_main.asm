    SLDOPT COMMENT WPMEM, LOGPOINT, ASSERTION
    DEVICE ZXSPECTRUM128

    DEFINE _MOD
    DEFINE _DEBUG

; Definitions
    INCLUDE "_orig/inc/macros.inc"
    INCLUDE "_orig/inc/basic.inc"
    INCLUDE "_orig/inc/structs.inc"
    INCLUDE "inc/memory.inc"
    INCLUDE "inc/level.inc"
    INCLUDE "_orig/inc/ay.inc"


; Slow memory
    ORG #4000
; Loading screen
    INCLUDE "_orig/data/loading_screen.asm"

; Basic loader
    ORG #5CCB
    INCLUDE "basic_loader.asm"

; Code
    ORG #6200   ; #BEFC
codeStart:
    INCLUDE "_orig/code/code.asm"
    INCLUDE "_orig/code/game_menu.asm"
    INCLUDE "_orig/code/utils.asm"
    INCLUDE "code/controls.asm"
    INCLUDE "_orig/code/logic_1.asm"
    INCLUDE "code/boss_switch.asm"
    INCLUDE "code/sound.asm"

    DISPLAY "Slow free: ", Common.font - $

    _NEXT_ORG #7E80
    INCLUDE "_orig/data/font.asm"


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

    INCLUDE "_orig/code/drawing.asm"
    INCLUDE "_orig/code/select_sprite.asm"
    INCLUDE "_orig/code/logic_2.asm"
    INCLUDE "_orig/code/beeper_sound.asm"
    INCLUDE "_orig/code/level_loading.asm"

    DISPLAY "Fast free: ", stackTop - $

    _NEXT_ORG #AEAE
stackTop:
; Data
    INCLUDE "_orig/data/sprites.asm"
    INCLUDE "_orig/data/object_types.asm"
    _NEXT_ORG Level.start

codeLength = $ - codeStart

; Variables
    ORG Level.end
    INCLUDE "_orig/var/state.asm"
    INCLUDE "_orig/var/scene.asm"

    DISPLAY Level.length

; Levels
    ORG 0
    INCLUDE "_orig/data/headers.asm"

    PAGE MemPage.level0           ; Klondike
    ORG Level.start
    _NEXT_ORG Level.levObjectTypes: INCLUDE "_orig/data/0_klondike/object_types.asm"
    _NEXT_ORG Level.blockMap      : INCLUDE "_orig/data/0_klondike/block_map.asm"
    _NEXT_ORG Level.transitTable  : INCLUDE "_orig/data/0_klondike/transits.asm"
    _NEXT_ORG Level.sprites       : INCLUDE "_orig/data/0_klondike/sprites.asm"
    _NEXT_ORG Level.tilePixels    : INCLUDE "_orig/data/0_klondike/tiles.asm"
    _NEXT_ORG Level.objectTable   : INCLUDE "_orig/data/0_klondike/object_table.asm"
    _NEXT_ORG Level.bossLogicAddr : dw Code.bossLogicKlondike
    _NEXT_ORG Level.trajVelTable  : INCLUDE "_orig/data/0_klondike/traj_table.asm"
                                    INCLUDE "_orig/data/0_klondike/trajectories.asm"
                                    INCLUDE "_orig/code/boss0_klondike.asm"
    _NEXT_ORG Level.end

    PAGE MemPage.level1           ; Orient
    ORG Level.start
    _NEXT_ORG Level.levObjectTypes: INCLUDE "_orig/data/1_orient/object_types.asm"
    _NEXT_ORG Level.blockMap      : INCLUDE "_orig/data/1_orient/block_map.asm"
    _NEXT_ORG Level.transitTable  : INCLUDE "_orig/data/1_orient/transits.asm"
    _NEXT_ORG Level.sprites       : INCLUDE "_orig/data/1_orient/sprites.asm"
    _NEXT_ORG Level.tilePixels    : INCLUDE "_orig/data/1_orient/tiles.asm"
    _NEXT_ORG Level.objectTable   : INCLUDE "_orig/data/1_orient/object_table.asm"
    _NEXT_ORG Level.bossLogicAddr : dw Code.bossLogicOrient
    _NEXT_ORG Level.trajVelTable  : INCLUDE "_orig/data/1_orient/traj_table.asm"
                                    INCLUDE "_orig/data/1_orient/trajectories.asm"
                                    INCLUDE "_orig/code/boss1_orient.asm"
    _NEXT_ORG Code.bossLogicExtra : INCLUDE "_orig/code/boss1_extra.asm"
    _NEXT_ORG Level.end

    PAGE MemPage.level2           ; Amazon
    ORG Level.start
    _NEXT_ORG Level.levObjectTypes: INCLUDE "_orig/data/2_amazon/object_types.asm"
    _NEXT_ORG Level.blockMap      : INCLUDE "_orig/data/2_amazon/block_map.asm"
    _NEXT_ORG Level.transitTable  : INCLUDE "_orig/data/2_amazon/transits.asm"
    _NEXT_ORG Level.sprites       : INCLUDE "_orig/data/2_amazon/sprites.asm"
    _NEXT_ORG Level.tilePixels    : INCLUDE "_orig/data/2_amazon/tiles.asm"
    _NEXT_ORG Level.objectTable   : INCLUDE "_orig/data/2_amazon/object_table.asm"
    _NEXT_ORG Level.bossLogicAddr : dw Code.bossLogicAmazon
    _NEXT_ORG Level.trajVelTable  : INCLUDE "_orig/data/2_amazon/traj_table.asm"
                                    INCLUDE "_orig/data/2_amazon/trajectories.asm"
                                    INCLUDE "_orig/code/boss2_amazon.asm"
    _NEXT_ORG Level.end

    PAGE MemPage.level3           ; Iceland
    ORG Level.start
    _NEXT_ORG Level.levObjectTypes: INCLUDE "_orig/data/3_iceland/object_types.asm"
    _NEXT_ORG Level.blockMap      : INCLUDE "_orig/data/3_iceland/block_map.asm"
    _NEXT_ORG Level.transitTable  : INCLUDE "_orig/data/3_iceland/transits.asm"
    _NEXT_ORG Level.sprites       : INCLUDE "_orig/data/3_iceland/sprites.asm"
    _NEXT_ORG Level.tilePixels    : INCLUDE "_orig/data/3_iceland/tiles.asm"
    _NEXT_ORG Level.objectTable   : INCLUDE "_orig/data/3_iceland/object_table.asm"
    _NEXT_ORG Level.bossLogicAddr : dw Code.bossLogicIceland
    _NEXT_ORG Level.trajVelTable  : INCLUDE "_orig/data/3_iceland/traj_table.asm"
                                    INCLUDE "_orig/data/3_iceland/trajectories.asm"
                                    INCLUDE "_orig/code/boss3_iceland.asm"
                                    INCLUDE "_orig/code/boss3_extra.asm"
    _NEXT_ORG Level.end

    PAGE MemPage.level4           ; Bermuda
    ORG Level.start
    _NEXT_ORG Level.levObjectTypes: INCLUDE "_orig/data/4_bermuda/object_types.asm"
    _NEXT_ORG Level.blockMap      : INCLUDE "_orig/data/4_bermuda/block_map.asm"
    _NEXT_ORG Level.transitTable  : INCLUDE "_orig/data/4_bermuda/transits.asm"
    _NEXT_ORG Level.sprites       : INCLUDE "_orig/data/4_bermuda/sprites.asm"
    _NEXT_ORG Level.tilePixels    : INCLUDE "_orig/data/4_bermuda/tiles.asm"
    _NEXT_ORG Level.objectTable   : INCLUDE "_orig/data/4_bermuda/object_table.asm"
    _NEXT_ORG Level.bossLogicAddr : dw Code.bossLogicBermuda
    _NEXT_ORG Level.trajVelTable  : INCLUDE "_orig/data/4_bermuda/traj_table.asm"
                                    INCLUDE "_orig/data/4_bermuda/trajectories.asm"
                                    INCLUDE "_orig/code/boss4_bermuda.asm"
    _NEXT_ORG Level.end
    
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
