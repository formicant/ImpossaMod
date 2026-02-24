    ORG Level.start
    INCLUDE "tiles.asm"
    ORG Level.objectTable
    INCLUDE "objectTable.asm"
    ORG Level.blockMap
    INCLUDE "blockMap.asm"
    ORG Level.sprites
    INCLUDE "sprites.asm"
        block Level.transitTable - $        ; cleanup
    ORG Level.transitTable
    INCLUDE "transits.asm"
    ; junk from 1_orient here
    ORG Level.trajVelTable
    INCLUDE "trajTable.asm"
    ORG Level.levObjectTypes
    INCLUDE "objectTypes.asm"
    INCLUDE "trajectories.asm"
        dh 9E 47 00 01 10 10 FF             ; junk
        block 13 : db 1                     ; junk
        block Level.end - $                 ; cleanup
