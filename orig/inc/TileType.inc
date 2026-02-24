    MODULE TileType

space       EQU 0   ; behaves as an empty tile
ladder      EQU 1   ; hero can climb
ladderTop   EQU 2   ; hero can climb and stand on
platform    EQU 3   ; hero can stand on and jump through
wall        EQU 4   ; not passable
conveyorL   EQU 5
conveyorR   EQU 6
ice         EQU 7   ; slippery
slow        EQU 8   ; slows down walking hero
waterSpikes EQU 9   ; water or spikes, damage and make jump

; bit mask
typeMask    EQU %01111111

    ENDMODULE
