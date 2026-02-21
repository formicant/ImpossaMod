    ORG Level.start
    INCLUDE "tiles.asm"
        block Level.objectTable - $         ; cleanup
    ORG Level.objectTable
    INCLUDE "object_table.asm"
        block Level.blockMap - $            ; cleanup
    ORG Level.blockMap
    INCLUDE "block_map.asm"
    ORG Level.sprites
    INCLUDE "sprites.asm"
    ORG Level.transitTable
    INCLUDE "../Lev0Klondike/transits.asm"  ; junk from Klondike
        block Level.trajVelTable - $        ; cleanup
    ORG Level.transitTable
    INCLUDE "transits.asm"
    ORG Level.trajVelTable
    INCLUDE "traj_table.asm"
    ORG Level.levObjectTypes
    INCLUDE "object_types.asm"
    INCLUDE "trajectories.asm"
