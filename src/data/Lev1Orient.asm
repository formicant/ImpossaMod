    ORG Level.start
    _NEXT_ORG Level.levObjectTypes: INCLUDE "src/_orig/data/Lev1Orient/object_types.asm"
    _NEXT_ORG Level.blockMap      : INCLUDE "src/_orig/data/Lev1Orient/block_map.asm"
    _NEXT_ORG Level.transitTable  : INCLUDE "src/_orig/data/Lev1Orient/transits.asm"
    _NEXT_ORG Level.sprites       : INCLUDE "src/_orig/data/Lev1Orient/sprites.asm"
    _NEXT_ORG Level.tilePixels    : INCLUDE "src/_orig/data/Lev1Orient/tiles.asm"
    _NEXT_ORG Level.objectTable   : INCLUDE "src/_orig/data/Lev1Orient/object_table.asm"
    _NEXT_ORG Level.bossLogicAddr : dw Code.bossLogicOrient
    _NEXT_ORG Level.trajVelTable  : INCLUDE "src/_orig/data/Lev1Orient/traj_table.asm"
                                    INCLUDE "src/_orig/data/Lev1Orient/trajectories.asm"
                                    INCLUDE "src/_orig/code/boss1_orient.asm"
    _NEXT_ORG Code.bossLogicExtra : INCLUDE "src/_orig/code/boss1_extra.asm"
    _NEXT_ORG Level.end
