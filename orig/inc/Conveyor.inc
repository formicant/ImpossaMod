; Location of a conveyor on the screen
;   length: 3
    STRUCT Conveyor

start       word    ; addr in `Tables.scrTiles` of the first conveyor tile
length      byte    ; number of consequent conveyor tiles

    ENDS
