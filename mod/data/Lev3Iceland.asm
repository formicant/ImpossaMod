    ORG Level.start
    _NEXT_ORG Level.levObjectTypes: INCLUDE "orig/data/Lev3Iceland/object_types.asm"
    _NEXT_ORG Level.blockMap      : INCLUDE "orig/data/Lev3Iceland/block_map.asm"
    _NEXT_ORG Level.transitTable  : INCLUDE "orig/data/Lev3Iceland/transits.asm"
    _NEXT_ORG Level.sprites       : INCLUDE "orig/data/Lev3Iceland/sprites.asm"
    _NEXT_ORG Level.tilePixels    : INCLUDE "orig/data/Lev3Iceland/tiles.asm"
    _NEXT_ORG Level.objectTable   : INCLUDE "orig/data/Lev3Iceland/object_table.asm"
    _NEXT_ORG Level.bossLogicAddr : dw Code.bossLogicIceland
    _NEXT_ORG Level.trajVelTable  : INCLUDE "orig/data/Lev3Iceland/traj_table.asm"
                                    INCLUDE "orig/data/Lev3Iceland/trajectories.asm"
                                    INCLUDE "orig/code/boss3_iceland.asm"
                                    INCLUDE "orig/code/boss3_extra.asm"
    _NEXT_ORG Level.end
