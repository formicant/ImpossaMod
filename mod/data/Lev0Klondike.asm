    ORG Level.start
    _NEXT_ORG Level.levObjectTypes: INCLUDE "orig/data/Lev0Klondike/object_types.asm"
    _NEXT_ORG Level.blockMap      : INCLUDE "orig/data/Lev0Klondike/block_map.asm"
    _NEXT_ORG Level.transitTable  : INCLUDE "orig/data/Lev0Klondike/transits.asm"
    _NEXT_ORG Level.sprites       : INCLUDE "orig/data/Lev0Klondike/sprites.asm"
    _NEXT_ORG Level.tilePixels    : INCLUDE "orig/data/Lev0Klondike/tiles.asm"
    _NEXT_ORG Level.objectTable   : INCLUDE "orig/data/Lev0Klondike/object_table.asm"
    _NEXT_ORG Level.bossLogicAddr : dw Code.bossLogicKlondike
    _NEXT_ORG Level.trajVelTable  : INCLUDE "orig/data/Lev0Klondike/traj_table.asm"
                                    INCLUDE "orig/data/Lev0Klondike/trajectories.asm"
                                    INCLUDE "orig/code/boss0_klondike.asm"
    _NEXT_ORG Level.end
