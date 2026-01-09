    MODULE Lev1Orient


; #B282 transitTable:
;       isDown fromX toLeft toRight toX
        db 0 : dw  65, 109, 119 : db 4
        db 1 : dw 114,  64, 108 : db 3
        db 1 : dw 115,  64, 108 : db 3
        db 1 : dw  67, 119, 143 : db 1
        db 0 : dw 139,  84, 108 : db 2
        db 0 : dw  95, 144, 156 : db 2
        db 1 : dw 103, 156, 170 : db 1
        db 1 : dw 152,  99, 107 : db 4
        db 1 : dw 153,  99, 107 : db 4
        db 0 : dw 167, 171, 221 : db 3
        db 0 : dw 187, 328, 340 : db 0
        db 0 : dw 188, 328, 340 : db 1
        db 1 : dw 335, 192, 222 : db 3
        db 1 : dw 336, 192, 222 : db 3
        db 1 : dw 337, 192, 222 : db 4
        db 1 : dw 338, 192, 222 : db 5
        db 1 : dw 215, 223, 295 : db 2
        db 1 : dw 216, 223, 295 : db 3
        db 1 : dw 217, 223, 295 : db 4
        db 1 : dw 218, 223, 295 : db 5
        db 1 : dw 290, 312, 328 : db 2
        db 1 : dw 291, 312, 328 : db 5
        db 0 : dw 293, 296, 312 : db 2
        db 1 : dw 308, 341, 399 : db 1
        db 1 : dw 309, 341, 399 : db 2
        db 1 : dw 310, 341, 399 : db 3
        db 0 : dw 324, 346, 400 : db 2
        db 0 : dw 393, 400, 408 : db 0
        db 0 : dw 394, 400, 408 : db 1
        db 0 : dw 395, 400, 408 : db 2
        db #80                  ; stop mark


    ENDMODULE
