    ORG Level.start
    _NEXT_ORG Level.levObjectTypes: INCLUDE "src/_orig/data/Lev4Bermuda/object_types.asm"
    _NEXT_ORG Level.blockMap      : INCLUDE "src/_orig/data/Lev4Bermuda/block_map.asm"
    _NEXT_ORG Level.transitTable  : INCLUDE "src/_orig/data/Lev4Bermuda/transits.asm"
    _NEXT_ORG Level.sprites       : INCLUDE "src/_orig/data/Lev4Bermuda/sprites.asm"
    _NEXT_ORG Level.tilePixels    : INCLUDE "src/_orig/data/Lev4Bermuda/tiles.asm"
    _NEXT_ORG Level.objectTable   : INCLUDE "src/_orig/data/Lev4Bermuda/object_table.asm"
    _NEXT_ORG Level.bossLogicAddr : dw Code.bossLogicBermuda
    _NEXT_ORG Level.trajVelTable  : INCLUDE "src/_orig/data/Lev4Bermuda/traj_table.asm"
                                    INCLUDE "src/_orig/data/Lev4Bermuda/trajectories.asm"
                                    INCLUDE "src/_orig/code/boss4_bermuda.asm"
    _NEXT_ORG Level.end
