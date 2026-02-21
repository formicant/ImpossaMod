    ORG Level.start
    _NEXT_ORG Level.levObjectTypes: INCLUDE "src/_orig/data/Lev2Amazon/object_types.asm"
    _NEXT_ORG Level.blockMap      : INCLUDE "src/_orig/data/Lev2Amazon/block_map.asm"
    _NEXT_ORG Level.transitTable  : INCLUDE "src/_orig/data/Lev2Amazon/transits.asm"
    _NEXT_ORG Level.sprites       : INCLUDE "src/_orig/data/Lev2Amazon/sprites.asm"
    _NEXT_ORG Level.tilePixels    : INCLUDE "src/_orig/data/Lev2Amazon/tiles.asm"
    _NEXT_ORG Level.objectTable   : INCLUDE "src/_orig/data/Lev2Amazon/object_table.asm"
    _NEXT_ORG Level.bossLogicAddr : dw Code.bossLogicAmazon
    _NEXT_ORG Level.trajVelTable  : INCLUDE "src/_orig/data/Lev2Amazon/traj_table.asm"
                                    INCLUDE "src/_orig/data/Lev2Amazon/trajectories.asm"
                                    INCLUDE "src/_orig/code/boss2_amazon.asm"
    _NEXT_ORG Level.end
