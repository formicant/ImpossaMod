    MODULE Lev0Klondike


; #B282 transitTable:
;       isDown fromX toLeft toRight toX
        db 1 : dw  48,  55,  63 : db 2
        db 1 : dw  51,  65,  77 : db 1
        db 1 : dw  52,  77,  93 : db 1
        db 1 : dw  59,  77,  93 : db 1
        db 1 : dw  74,  77,  93 : db 1
        db 1 : dw  78,  93, 163 : db 1
        db 1 : dw  91, 106, 162 : db 1
        db 1 : dw 156, 163, 197 : db 1
        db 1 : dw 193, 197, 261 : db 5
        db 1 : dw 258, 261, 269 : db 2
        db 1 : dw 259, 270, 292 : db 3
        db 0 : dw 266, 270, 292 : db 3
        db 1 : dw 289, 291, 299 : db 2
        db 1 : dw 293, 300, 310 : db 1
        db 0 : dw 304, 291, 299 : db 5
        db 0 : dw 296, 310, 326 : db 3
        db 1 : dw 324, 326, 334 : db 1
        db 0 : dw 332, 335, 361 : db 1
        db 0 : dw 359, 388, 396 : db 2
        db 1 : dw 393, 362, 372 : db 1
        db 1 : dw 370, 372, 376 : db 2
        db 1 : dw 374, 384, 408 : db 1
        db 1 : dw 406, 375, 383 : db 1
        db #80                  ; stop mark


    ENDMODULE
