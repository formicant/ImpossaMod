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
    INCLUDE "var/Tables.asm"

; Basic loader
    ORG #5CCB   ; overlap
    INCLUDE "basic_loader.asm"

; Code
    ORG #5E00
codeStart:
    INCLUDE "code/Utils/detectModel.asm"

    ORG #5E80
    DISP #C000
    INCLUDE "code/ay_sound.asm"
    ENT

    INCLUDE "data/Lev0Klondike/_index.asm"

    ORG #BDDF
    INCLUDE "code/Sound/_index.asm"
    
    INCLUDE "var/State_objTileIndex.asm"
    INCLUDE "var/Scene.asm"
    
    ORG #BEB4   ; overlap
    INCLUDE "code/Interrupt/_index.asm"
    ORG #C044
    INCLUDE "code/Drawing/_index.asm"
    INCLUDE "code/Utils/printString.asm"
    INCLUDE "code/Menu/mainMenu.asm"
    INCLUDE "code/Utils/clearScreen.asm"
    INCLUDE "code/Tiles/rollConveyorTiles.asm"
    INCLUDE "code/Control.asm"
    INCLUDE "code/Menu/levelLoading.asm"
    INCLUDE "code/Loading.asm"

    INCLUDE "data/Font.asm"

    INCLUDE "code/entry_point.asm"
    INCLUDE "code/game_loop.asm"
    INCLUDE "code/Menu/gameOver.asm"
    INCLUDE "code/Menu/pause.asm"
    INCLUDE "code/moveToMapSpan.asm"
    INCLUDE "code/advanceInMap.asm"
    INCLUDE "code/Tiles/tiles.asm"
    INCLUDE "code/advanceObjectsInMap.asm"
    INCLUDE "code/Panel/_index.asm"
    INCLUDE "code/energy.asm"
    INCLUDE "code/Utils/delay.asm"
    INCLUDE "code/Utils/random.asm"
    INCLUDE "code/initHero.asm"
    INCLUDE "code/Tiles/conveyorTileIndices.asm"
    INCLUDE "code/initLevel.asm"
    INCLUDE "code/Tiles/conveyors.asm"
    INCLUDE "code/Scene/clearScene.asm"
    INCLUDE "code/logic_0.asm"
    INCLUDE "code/Scene/visibility.asm"
    INCLUDE "code/Tiles/getScrTileAddr.asm"
    INCLUDE "code/Scene/cleanUpScene.asm"
    INCLUDE "code/smart.asm"
    INCLUDE "code/Menu/levelSelectMenu.asm"
    INCLUDE "code/Menu/gameWin.asm"
    INCLUDE "code/logic_1.asm"
    INCLUDE "code/select_sprite.asm"
    INCLUDE "code/Scene/moveObjects.asm"
    INCLUDE "code/transit.asm"
    INCLUDE "code/Scene/allocateObject.asm"
    INCLUDE "code/heroCollisions.asm"
    INCLUDE "code/Scene/collisions.asm"
    INCLUDE "code/logic_2.asm"
    INCLUDE "code/Tiles/getTileType.asm"
    INCLUDE "code/enemy.asm"
    INCLUDE "code/boss_switch.asm"
    INCLUDE "code/boss0_klondike.asm"
    INCLUDE "code/boss1_orient.asm"
    INCLUDE "code/boss2_amazon.asm"
    INCLUDE "code/boss3_iceland.asm"
    INCLUDE "code/boss4_bermuda.asm"
    INCLUDE "code/boss1_extra.asm"

    ORG #FE01
    INCLUDE "var/State.asm"

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
