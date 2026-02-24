; Passage between different locations on the map
;   length: 8
    STRUCT Transit

isDown      byte    ; 0: upward, 1: downward
fromX       word    ; x block coord of the entrance
toStart     word    ; exit map span start
toEnd       word    ; exit map span end
toX         byte    ; exit x block coord (relative to span start)

    ENDS


; Map location of the shop and its entrance
;   length: 12
    STRUCT ShopTransit

shopStart   word    ; shop map span start in tiles
shopEnd     word    ; shop map span end in tiles
shopX       byte    ; shop x block coord (relative to span start)
shopY       byte    ; shop y block coord
exitStart   word    ; exit map span start in tiles
exitEnd     word    ; exit map span end in tiles
exitX       byte    ; exit x block coord (relative to span start)
exitY       byte    ; exit y block coord

    ENDS
