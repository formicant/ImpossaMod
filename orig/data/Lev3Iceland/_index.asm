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
    ORG Level.transitTable
    INCLUDE "../Lev0Klondike/transits.asm"  ; junk from Klondike
        block Level.trajVelTable - $        ; cleanup
    ORG Level.transitTable
    INCLUDE "transits.asm"
    ORG Level.trajVelTable
    INCLUDE "trajTable.asm"
    ORG Level.levObjectTypes
    INCLUDE "objectTypes.asm"
    INCLUDE "trajectories.asm"
