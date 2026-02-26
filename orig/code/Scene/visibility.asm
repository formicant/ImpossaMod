    MODULE Scene

; Return flag C if object is in the visible area or to the right of it
;   `ix`: object
isObjectVisibleOrWaiting:  ; #d407
        ld hl, 352
        ld (isObjectVisibleRaw.de), hl
        jr isObjectVisibleRaw

; Return flag C if object is in the visible area
;   `ix`: object
isObjectVisible:
        ld hl, 288
        ld (isObjectVisibleRaw.de), hl
        ; continue

isObjectVisibleRaw:
        ld a, (ix+Obj.y)
        cp 224                  ; screen bottom
        jr NC, .offScreen
        ld c, (ix+Obj.height)
        add c
        cp 32                   ; screen top
        jr C, .offScreen

        ld l, (ix+Obj.x+0)
        ld h, (ix+Obj.x+1)
        push hl
        ld d, 0
        ld e, (ix+Obj.width)
        add hl, de
        ld de, 32
        xor a
        sbc hl, de
        pop hl
        jr C, .offScreen

.de+*   ld de, 288              ; or 352
        xor a
        sbc hl, de
        ret C

.offScreen:
        xor a
        ret


; Make object big
;   `ix`: object
makeObjectBig:  ; #d443
        ; adjust coords
        ld l, (ix+Obj.x+0)
        ld h, (ix+Obj.x+1)
        ld de, -4
        add hl, de
        ld (ix+Obj.x+0), l
        ld (ix+Obj.x+1), h
        ld a, -2
        add (ix+Obj.y)
        ld (ix+Obj.y), a

        set Flag.isBig, (ix+Obj.flags)
        ret

    ENDMODULE
