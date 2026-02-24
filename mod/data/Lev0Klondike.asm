    ORG Level.start
    _NEXT_ORG Level.levObjectTypes: INCLUDE "orig/data/Lev0Klondike/objectTypes.asm"
    _NEXT_ORG Level.blockMap      : INCLUDE "orig/data/Lev0Klondike/blockMap.asm"
    _NEXT_ORG Level.transitTable  : INCLUDE "orig/data/Lev0Klondike/transits.asm"
    _NEXT_ORG Level.sprites       : INCLUDE "orig/data/Lev0Klondike/sprites.asm"
    _NEXT_ORG Level.tilePixels    : INCLUDE "orig/data/Lev0Klondike/tiles.asm"
    _NEXT_ORG Level.objectTable   : INCLUDE "orig/data/Lev0Klondike/objectTable.asm"
    _NEXT_ORG Level.bossLogicAddr : dw Boss.bossLogicKlondike
    _NEXT_ORG Level.trajVelTable  : INCLUDE "orig/data/Lev0Klondike/trajTable.asm"
                                    INCLUDE "orig/data/Lev0Klondike/trajectories.asm"
                                    INCLUDE "orig/code/Boss/lev0Klondike.asm"
    _NEXT_ORG Level.end
