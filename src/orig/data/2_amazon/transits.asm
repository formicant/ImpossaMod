    MODULE Lev2Amazon


; #B282 transitTable:
;       isDown fromX toLeft toRight toX
        db 0 : dw 112, 139, 157 : db 3
        db 1 : dw 151, 118, 138 : db 3
        db 1 : dw 131, 156, 162 : db 2
        db 1 : dw 135, 160, 174 : db 2
        db 1 : dw 158, 173, 187 : db 1
        db 0 : dw 185, 164, 174 : db 5
        db 0 : dw 168, 188, 286 : db 2
        db 0 : dw 169, 188, 286 : db 3
        db 0 : dw 214, 328, 378 : db 3
        db 1 : dw 223, 378, 410 : db 2
        db 0 : dw 407, 246, 286 : db 4
        db 1 : dw 371, 252, 286 : db 3
        db 1 : dw 372, 252, 286 : db 4
        db 1 : dw 373, 252, 286 : db 5
        db 1 : dw 261, 286, 300 : db 2
        db 0 : dw 283, 298, 318 : db 4
        db 0 : dw 297, 267, 285 : db 3
        db 1 : dw 317, 318, 326 : db 0
        db 1 : dw 355, 236, 286 : db 2
        db 1 : dw 356, 236, 286 : db 3
        db 1 : dw 357, 236, 286 : db 4
        db #80                  ; stop mark


    ENDMODULE
