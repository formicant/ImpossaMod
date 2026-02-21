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
        block Level.transitTable - $        ; cleanup
    ORG Level.transitTable
    INCLUDE "transits.asm"
    INCLUDE "traj_table.asm"
    ORG Level.levObjectTypes
    INCLUDE "object_types.asm"
    INCLUDE "trajectories.asm"
        block Level.end - $                 ; cleanup
