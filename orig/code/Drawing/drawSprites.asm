    MODULE Drawing

; Draw a small (16×16) sprite into `Tables.objTiles`
;   `ix`: object addr in `Scene`
;   `iy`: pixel row addr in `Tables.objTiles`
; (Disables interrupts!)
drawSmallSprite:
        ld a, (ix+Obj.x)
        and %00000111           ; x pixel shift
        jr NZ, drawShiftedSmallSprite

        ld hl, #0000            ; `nop : nop`
        ld (.jrMir), hl
        bit Dir.left, (ix+Obj.mo.direction)
        jr NZ, .skip
        bit Flag.mirror, (ix+Obj.flags)
        jr NZ, .skip

        ld hl, #0A18            ; `jr .skipMirror`
        ld (.jrMir), hl
.skip:

        ld c, 24
        ld a, (ix+Obj.y)
        and %00000111           ; y pixel shift
        jr NZ, .yShift
        ld c, 16
.yShift:
        ld a, c                 ; offset of the tile to the right (16 or 24)
        ld (.off1), a
        ld (.off2), a

        call Enemy.getSpriteAddr
        ; `hl`: sprite addr

        di
        ld (.sp), sp
        ld sp, hl
        ld h, high(Tables.mirror)
        ld a, 16                ; sprite pixel height

.pixelRow:
        exa
        pop de                  ; `e`: msk1, `d`: msk0
        pop bc                  ; `c`: spr1, `b`: spr0

.jrMir: jr .skipMirror          ; `jr` or `nop`
.mirror:
        ld a, e                 ; msk1
        ld l, d                 ; msk0
        ld e, (hl)              ; mirror(msk0)
        ld l, a                 ; msk1
        ld d, (hl)              ; mirror(msk1)
        ld a, c                 ; spr1
        ld l, b                 ; spr0
        ld c, (hl)              ; mirror(spr0)
        ld l, a                 ; spr1
        ld b, (hl)              ; mirror(spr1)
.skipMirror:

        ld a, (iy)              ; left tile pixel row
        and d                   ; draw msk
        or b                    ; draw spr
        ld (iy), a

.off1+2 ld a, (iy-0)            ; right tile pixel row
        and e                   ; draw msk
        or c                    ; draw spr
.off2+2 ld (iy-0), a

        inc iy                  ; move one pixel row down
        exa
        dec a
        jp NZ, .pixelRow

.sp+*   ld sp, -0
        ei
        ret


; Draw a small (16×16) sprite into `Tables.objTiles` with pixel shift
;   `ix`: object addr in `Scene`
;   `iy`: pixel row addr in `Tables.objTiles`
;   `a`: pixel shift (1..7)
; (Disables interrupts!)
drawShiftedSmallSprite:  ; #c245
        ld b, a
    .3  add a
        add b                   ; `a`: jump size = (pixel shift) * 9
        ld (.jrSh), a

        ld hl, #0000            ; `nop : nop`
        ld (.jrMir), hl
        bit Dir.left, (ix+Obj.mo.direction)
        jr NZ, .skip
        bit Flag.mirror, (ix+Obj.flags)
        jr NZ, .skip

        ld hl, #0F18            ; `jr .pixelShift`
        ld (.jrMir), hl
.skip:

        ld c, 24
        ld a, (ix+Obj.y)
        and %00000111           ; y pixel shift
        jr NZ, .yShift
        ld c, 16
.yShift:
        ld a, c                 ; offset of the middle tile
        ld (.of11), a
        ld (.of12), a
        add a                   ; offset of the right tile
        ld (.of21), a
        ld (.of22), a

        call Enemy.getSpriteAddr
        ; `hl`: sprite addr

        di
        ld (.sp), sp
        ld sp, hl
        ld h, high(Tables.mirror)
        ld ixh, 16              ; sprite pixel height

.pixelRow:
        pop de                  ; `e`: msk1, `d`: msk0
        pop hl                  ; `l`: spr1, `h`: spr0

.jrMir: jr .pixelShift          ; `jr` or `nop`
.mirror:
        ld b, h                 ; spr0
        ld c, l                 ; spr1
        ld h, high(Tables.mirror)
        ld a, e                 ; msk1
        ld l, d                 ; msk0
        ld e, (hl)              ; mirror(msk0)
        ld l, a                 ; msk1
        ld d, (hl)              ; mirror(msk1)
        ld a, c                 ; spr1
        ld l, b                 ; spr0
        ld c, (hl)              ; mirror(spr0)
        ld l, a                 ; spr1
        ld h, (hl)              ; mirror(spr1)
        ld l, c                 ; mirror(spr0)

.pixelShift:
        ld a, #FF               ; msk padding
        exa
        xor a                   ; spr padding

.jrSh+1 jr $-0
    .9  nop
    DUP 7
        exa                     ; msk
        sll e
        rl d
        rla
        exa                     ; spr
        add hl, hl
        rla
    EDUP

        ld b, (iy)              ; left tile pixel row
        exa
        and b
        ld b, a                 ; draw msk
        exa
        or b                    ; draw spr
        ld (iy), a

.of11+2 ld a, (iy-0)            ; middle tile pixel row
        and d                   ; draw msk
        or h                    ; draw spr
.of12+2 ld (iy-0), a

.of21+2 ld a, (iy-0)            ; right tile pixel row
        and e                   ; draw msk1
        or l                    ; draw spr1
.of22+2 ld (iy-0), a

        inc iy                  ; move one pixel row down
        dec ixh
        jp NZ, .pixelRow

.sp+*   ld sp, -0
        ei
        ret


; Draw a big (24×21) sprite into `Tables.objTiles`
;   `ix`: object addr in `Scene`
;   `iy`: pixel row addr in `Tables.objTiles`
; (Disables interrupts!)
drawBigSprite:  ; #c314
        ld a, (ix+Obj.x)
        and %00000111           ; x pixel shift
        jp NZ, drawShiftedBigSprite

        ld hl, #0000            ; `nop : nop`
        bit Dir.left, (ix+Obj.mo.direction)
        jr NZ, .skip
        bit Flag.mirror, (ix+Obj.flags)
        jr NZ, .skip

        ld hl, #2718            ; `jr .skipMirror`
.skip:
        ld (.jrMir), hl

        ld c, 32
        ld a, (ix+Obj.y)
        and %00000111           ; y pixel shift
        cp 4
        jr NC, .yShift
        ld c, 24
.yShift:
        ld a, c                 ; offset of the middle tile
        ld (.of11), a
        ld (.of12), a
        add a                   ; offset of the right tile
        ld (.of21), a
        ld (.of22), a

        call Enemy.getSpriteAddr
        ; `hl`: sprite addr

        di
        ld (.sp), sp
        ld sp, hl
        exx
        ld h, high(Tables.mirror)
        exx
        ld ixh, 21              ; sprite pixel height

.pixelRow:
        pop de                  ; `e`: msk2, `d`: msk1
        pop bc                  ; `c`: msk0, `b`: spr0
        pop hl                  ; `l`: spr2, `h`: spr1

.jrMir: jr .skipMirror          ; `jr` or `nop`
.mirror:
        ld a, d
        exa
        ld a, h
        exx
        ld l, a
        ld a, (hl)
        exa
        ld l, a
        ld a, (hl)
        exx
        ld d, a
        exa
        ld h, a
        ld a, c
        exa
        ld a, e
        exx
        ld l, a
        ld a, (hl)
        exa
        ld l, a
        ld a, (hl)
        exx
        ld e, a
        exa
        ld c, a
        ld a, b
        exa
        ld a, l
        exx
        ld l, a
        ld a, (hl)
        exa
        ld l, a
        ld a, (hl)
        exx
        ld l, a
        exa
        ld b, a
.skipMirror:

        ld a, (iy)              ; left tile pixel row
        and c                   ; draw msk
        or b                    ; draw spr
        ld (iy), a

.of11+2 ld a, (iy-0)            ; middle tile pixel row
        and d                   ; draw msk
        or h                    ; draw spr
.of12+2 ld (iy-0), a

.of21+2 ld a, (iy-0)            ; right tile pixel row
        and e                   ; draw msk
        or l                    ; draw spr
.of22+2 ld (iy-0), a

        inc iy                  ; move one pixel row down
        dec ixh
        jp NZ, .pixelRow

.sp+*   ld sp, -0
        ei
        ret


; Draw a big (24×21) sprite into `Tables.objTiles`
;   `ix`: object addr in `Scene`
;   `iy`: pixel row addr in `Tables.objTiles`
;   `a`: pixel shift (1..7)
; (Disables interrupts!)
drawShiftedBigSprite:  ; #c3ac
        ld b, a
    .2  add a
        ld c, a
        add b
        ld b, a
        ld a, c
        add a
        add b
        ; `a`: jump size = (pixel shift) * 13
        ld (.jrSh), a

        ld hl, #0000            ; `nop : nop`
        ld (.jrMir), hl
        bit Dir.left, (ix+Obj.mo.direction)
        jr NZ, .skip
        bit Flag.mirror, (ix+Obj.flags)
        jr NZ, .skip

        ld hl, #1418            ; `jr .pixelShift`
        ld (.jrMir), hl
.skip:

        ld c, 32
        ld a, (ix+Obj.y)
        and %00000111           ; y pixel shift
        cp 4
        jr NC, .yShift
        ld c, 24
.yShift:
        ld a, c                 ; offset of the middle-left tile
        ld (.of11), a
        ld (.of12), a
        add a                   ; offset of the middle-right tile
        ld (.of21), a
        ld (.of22), a
        add c                   ; offset of the right tile
        ld (.of31), a
        ld (.od32), a

        call Enemy.getSpriteAddr
        ; `hl`: sprite addr

        di
        ld (.sp), sp
        ld sp, hl
        ld ixh, 21              ; sprite pixel height

.pixelRow:
        pop de                  ; `e`: msk2, `d`: msk1
        pop hl                  ; `l`: msk0, `h`: spr0
        ld a, h
        exx
        pop hl                  ; `l`: spr2, `h`: spr1
        ld e, a                 ; `e`: spr0
        exx

.jrMir: jr .pixelShift          ; `jr` or `nop`
.mirror:
        ld h, high(Tables.mirror)
        ld a, (hl)
        ld l, d
        ld d, (hl)
        ld l, e
        ld l, (hl)
        ld e, a
        exx
        ld b, h
        ld h, high(Tables.mirror)
        ld a, (hl)
        ld l, b
        ld b, (hl)
        ld l, e
        ld l, (hl)
        ld e, a
        ld h, b
        exx

.pixelShift:
        ld h, #FF               ; msk padding
        exx
        ld d, #00               ; spr padding

.jrSh+1  jr $-0
    .13 nop
    DUP 7
        exx                     ; msk
        sll e
        rl d
        adc hl, hl
        exx                     ; spr
        add hl, hl
        ex de, hl
        adc hl, hl
        ex de, hl
    EDUP

        ld a, e
        exa
        ld a, d
        exx
        ld b, a

        ld a, (iy)              ; left tile pixel row
        and h                   ; draw msk
        or b                    ; draw spr
        ld (iy), a
        exa
        ld b, a

.of11+2 ld a, (iy-0)
        and l                   ; draw msk
        or b                    ; draw spr
.of12+2 ld (iy-0), a
        ld a, e
        exa
        ld a, d
        exx
                                ; middle-right tile pixel row
.of21+2 and (iy-0)              ; draw msk
        or h                    ; draw spr
.of22+2 ld (iy-0), a
        exa
                                ; right tile pixel row
.of31+2 and (iy-0)              ; draw msk
        or l                    ; draw spr
.od32+2 ld (iy-0), a

        inc iy                  ; move one pixel row down
        dec ixh
        jp NZ, .pixelRow

.sp+*   ld sp, -0
        ei
        ret

    ENDMODULE
