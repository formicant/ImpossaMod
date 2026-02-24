    MODULE Enemy

; Remove object if it moved outside the screen
;   arg `ix`: object
removeIfOffScreen:
        call Scene.isObjectVisibleOrWaiting
        ret C
        ; if object became invisible
        ld (ix+Obj.flags), 0    ; remove object
        ret

    ENDMODULE
