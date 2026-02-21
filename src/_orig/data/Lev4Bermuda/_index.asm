    ORG Level.start
    INCLUDE "tiles.asm"
    ORG Level.objectTable
    INCLUDE "object_table.asm"
    ORG Level.blockMap
    INCLUDE "block_map.asm"
    ORG Level.sprites
    INCLUDE "sprites.asm"
    ORG Level.transitTable
    INCLUDE "transits.asm"
    ORG Level.trajVelTable
    INCLUDE "traj_table.asm"
    ORG Common.objectTypes + 10
        db 8    ; overridden property (TODO: is it significant?)
    ORG Level.levObjectTypes
    INCLUDE "object_types.asm"
    INCLUDE "trajectories.asm"
