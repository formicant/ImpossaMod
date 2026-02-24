    ORG Level.start
    INCLUDE "tiles.asm"
        block Level.objectTable - $         ; cleanup
    ORG Level.objectTable
    INCLUDE "objectTable.asm"
        block Level.blockMap - $            ; cleanup
    ORG Level.blockMap
    INCLUDE "blockMap.asm"
    ORG Level.sprites
    INCLUDE "sprites.asm"
        block Level.transitTable - $        ; cleanup
    ORG Level.transitTable
    INCLUDE "transits.asm"
    INCLUDE "trajTable.asm"
    ORG Level.levObjectTypes
    INCLUDE "objectTypes.asm"
    INCLUDE "trajectories.asm"
        block Level.end - $                 ; cleanup
