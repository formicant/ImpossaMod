; Code that is executed or moved at the start and then overwritten with `Tables`

    INCLUDE "Main/entryPoint.asm"
    INCLUDE "Utils/loadLevelFromMemory.asm"

ayStored:
    DISP Level.start
    ; INCLUDE "orig/data/AY/_index.asm"
    INCLUDE "../data/AY.asm"
    INCLUDE "orig/code/AY/_index.asm"
    ENT
ayLength    EQU $ - ayStored
