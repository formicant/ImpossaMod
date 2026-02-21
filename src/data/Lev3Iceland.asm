    ORG Level.start
    _NEXT_ORG Level.levObjectTypes: INCLUDE "src/_orig/data/Lev3Iceland/object_types.asm"
    _NEXT_ORG Level.blockMap      : INCLUDE "src/_orig/data/Lev3Iceland/block_map.asm"
    _NEXT_ORG Level.transitTable  : INCLUDE "src/_orig/data/Lev3Iceland/transits.asm"
    _NEXT_ORG Level.sprites       : INCLUDE "src/_orig/data/Lev3Iceland/sprites.asm"
    _NEXT_ORG Level.tilePixels    : INCLUDE "src/_orig/data/Lev3Iceland/tiles.asm"
    _NEXT_ORG Level.objectTable   : INCLUDE "src/_orig/data/Lev3Iceland/object_table.asm"
    _NEXT_ORG Level.bossLogicAddr : dw Code.bossLogicIceland
    _NEXT_ORG Level.trajVelTable  : INCLUDE "src/_orig/data/Lev3Iceland/traj_table.asm"
                                    INCLUDE "src/_orig/data/Lev3Iceland/trajectories.asm"
                                    INCLUDE "src/_orig/code/boss3_iceland.asm"
                                    INCLUDE "src/_orig/code/boss3_extra.asm"
    _NEXT_ORG Level.end
