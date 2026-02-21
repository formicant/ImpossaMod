    ORG Level.start
    _NEXT_ORG Level.levObjectTypes: INCLUDE "orig/data/Lev4Bermuda/object_types.asm"
    _NEXT_ORG Level.blockMap      : INCLUDE "orig/data/Lev4Bermuda/block_map.asm"
    _NEXT_ORG Level.transitTable  : INCLUDE "orig/data/Lev4Bermuda/transits.asm"
    _NEXT_ORG Level.sprites       : INCLUDE "orig/data/Lev4Bermuda/sprites.asm"
    _NEXT_ORG Level.tilePixels    : INCLUDE "orig/data/Lev4Bermuda/tiles.asm"
    _NEXT_ORG Level.objectTable   : INCLUDE "orig/data/Lev4Bermuda/object_table.asm"
    _NEXT_ORG Level.bossLogicAddr : dw Code.bossLogicBermuda
    _NEXT_ORG Level.trajVelTable  : INCLUDE "orig/data/Lev4Bermuda/traj_table.asm"
                                    INCLUDE "orig/data/Lev4Bermuda/trajectories.asm"
                                    INCLUDE "orig/code/boss4_bermuda.asm"
    _NEXT_ORG Level.end
