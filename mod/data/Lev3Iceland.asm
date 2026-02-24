    ORG Level.start
    _NEXT_ORG Level.levObjectTypes: INCLUDE "orig/data/Lev3Iceland/objectTypes.asm"
    _NEXT_ORG Level.blockMap      : INCLUDE "orig/data/Lev3Iceland/blockMap.asm"
    _NEXT_ORG Level.transitTable  : INCLUDE "orig/data/Lev3Iceland/transits.asm"
    _NEXT_ORG Level.sprites       : INCLUDE "orig/data/Lev3Iceland/sprites.asm"
    _NEXT_ORG Level.tilePixels    : INCLUDE "orig/data/Lev3Iceland/tiles.asm"
    _NEXT_ORG Level.objectTable   : INCLUDE "orig/data/Lev3Iceland/objectTable.asm"
    _NEXT_ORG Level.bossLogicAddr : dw Boss.bossLogicIceland
    _NEXT_ORG Level.trajVelTable  : INCLUDE "orig/data/Lev3Iceland/trajTable.asm"
                                    INCLUDE "orig/data/Lev3Iceland/trajectories.asm"
                                    INCLUDE "orig/code/Boss/lev3Iceland.asm"
                                    INCLUDE "orig/code/Boss/lev3Extra.asm"
    _NEXT_ORG Level.end
