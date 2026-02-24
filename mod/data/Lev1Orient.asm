    ORG Level.start
    _NEXT_ORG Level.levObjectTypes: INCLUDE "orig/data/Lev1Orient/object_types.asm"
    _NEXT_ORG Level.blockMap      : INCLUDE "orig/data/Lev1Orient/block_map.asm"
    _NEXT_ORG Level.transitTable  : INCLUDE "orig/data/Lev1Orient/transits.asm"
    _NEXT_ORG Level.sprites       : INCLUDE "orig/data/Lev1Orient/sprites.asm"
    _NEXT_ORG Level.tilePixels    : INCLUDE "orig/data/Lev1Orient/tiles.asm"
    _NEXT_ORG Level.objectTable   : INCLUDE "orig/data/Lev1Orient/object_table.asm"
    _NEXT_ORG Level.bossLogicAddr : dw Boss.bossLogicOrient
    _NEXT_ORG Level.trajVelTable  : INCLUDE "orig/data/Lev1Orient/traj_table.asm"
                                    INCLUDE "orig/data/Lev1Orient/trajectories.asm"
                                    INCLUDE "orig/code/Boss/lev1Orient.asm"
    _NEXT_ORG Boss.bossLogicExtra : INCLUDE "orig/code/Boss/lev1Extra.asm"
    _NEXT_ORG Level.end
