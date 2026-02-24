; Performance-critical code located in the fast memory

    ; Must be in the fast memory
    INCLUDE "Interrupt/interrupt.asm"
    INCLUDE "orig/code/Utils/loadBytes.asm"
    INCLUDE "orig/code/Sound/beeper.asm"

    ; Benefit from being in the fast memory
    INCLUDE "orig/code/Drawing/_index.asm"
    INCLUDE "orig/code/Main/gameLoop.asm"
    INCLUDE "orig/code/Scene/decBlinkTime.asm"
    INCLUDE "orig/code/Tiles/getScrTileAddr.asm"
    INCLUDE "orig/code/Tiles/getTileType.asm"
    INCLUDE "orig/code/Scene/moveObjects.asm"
    INCLUDE "orig/code/Scene/allocateObject.asm"
    INCLUDE "orig/code/Scene/collisions.asm"
    INCLUDE "orig/code/Scene/putObjects.asm"
    INCLUDE "Hero/_fast.asm"
    INCLUDE "Enemy/_fast.asm"
