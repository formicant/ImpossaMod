    ORG Level.start
    _NEXT_ORG Level.levObjectTypes: INCLUDE "orig/data/Lev4Bermuda/objectTypes.asm"
    _NEXT_ORG Level.blockMap      : INCLUDE "orig/data/Lev4Bermuda/blockMap.asm"
    _NEXT_ORG Level.transitTable  : INCLUDE "orig/data/Lev4Bermuda/transits.asm"
    _NEXT_ORG Level.sprites       : INCLUDE "orig/data/Lev4Bermuda/sprites.asm"
    _NEXT_ORG Level.tilePixels    : INCLUDE "orig/data/Lev4Bermuda/tiles.asm"
    _NEXT_ORG Level.objectTable   : INCLUDE "orig/data/Lev4Bermuda/objectTable.asm"
    _NEXT_ORG Level.bossLogicAddr : dw Boss.bossLogicBermuda
    _NEXT_ORG Level.trajVelTable  : INCLUDE "orig/data/Lev4Bermuda/trajTable.asm"
                                    INCLUDE "orig/data/Lev4Bermuda/trajectories.asm"
                                    INCLUDE "orig/code/Boss/lev4Bermuda.asm"
    _NEXT_ORG Level.end
