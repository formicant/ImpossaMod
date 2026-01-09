    MODULE Lev3Iceland


; #B282 transitTable:
;       isDown fromX toLeft toRight toX
        db 1 : dw  87, 127, 141 : db 1
        db 1 : dw 139,  98, 126 : db 4
        db 1 : dw 116, 309, 319 : db 1
        db 1 : dw 123, 141, 309 : db 1
        db 1 : dw 221, 318, 332 : db 1
        db 0 : dw 329, 229, 309 : db 2
        db 1 : dw 242, 331, 341 : db 1
        db 0 : dw 338, 256, 308 : db 3
        db 0 : dw 293, 342, 352 : db 4
        db 1 : dw 342, 294, 308 : db 0
        db 1 : dw 343, 294, 308 : db 0
        db 1 : dw 349, 294, 308 : db 0
        db 1 : dw 350, 294, 308 : db 0
        db 0 : dw 314, 151, 309 : db 1
        db 0 : dw 272, 352, 362 : db 4
        db 0 : dw 273, 352, 362 : db 5
        db 1 : dw 359, 280, 308 : db 5
        db 1 : dw 360, 280, 308 : db 5
        db 1 : dw 361, 280, 308 : db 5
        db 1 : dw 306, 364, 402 : db 1
        db 1 : dw 398, 402, 410 : db 0
        db #80                  ; stop mark


    ENDMODULE
