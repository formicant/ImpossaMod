    ORG Level.start
    INCLUDE "tiles.asm"
    ORG Level.objectTable
    INCLUDE "objectTable.asm"
    ORG Level.blockMap
    INCLUDE "blockMap.asm"
    ORG Level.sprites
    INCLUDE "sprites.asm"
    ORG Level.transitTable
    INCLUDE "transits.asm"
    ORG Level.trajVelTable
    INCLUDE "trajTable.asm"
    ORG Common.objectTypes + OT.auxFlags
        db 1<<Flag.nonEnemy     ; overridden property (TODO: is it significant?)
    ORG Level.levObjectTypes
    INCLUDE "objectTypes.asm"
    INCLUDE "trajectories.asm"
