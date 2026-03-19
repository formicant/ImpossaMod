    MODULE AY

; (Unused)
unusedCallPlayMenuMusic:  ; #c9f4
        jp Sound.callPlayMenuMusic

; (Unused)
unusedCallAySoundFrame:  ; #c9f7
        jp Sound.callAySoundFrame


; Non-zero if sound/music is playing, zero if silent
isPlaying:  ; #c9fa
        db 0


; (Unused)
unusedJumpToPlayAySound:  ; #c9fb
        jp unusedPlayAySound

; (Unused)
; Initialise AY without playing anything
unusedInit:
        xor a
        ld (isPlaying), a
        jp initAy

; (Unused)
; Similar to `playAySound` but uses only channel A
;   `a`: sound index (0..14)
unusedPlayAySound:
        di
        ; calculate sound effect addr
        ld l, a
        ld e, a
        ld h, 0
        ld d, h
        add hl, hl
        add hl, de
    .2  add hl, hl
        add hl, de
        ; `hl`: `a` * 13
        ld iy, aySounds
        ex de, hl
        add iy, de
        ; `iy`: sound effect addr
        ld l, (iy+Effect.period+0)
        ld h, (iy+Effect.period+1)
        ld c, (iy+Effect.duration)
        ld ix, ayChA
        call playTone
        set Flag.unused, (ix+Ch.flags)
        ei
        ret


; #ca2d
;              0      1      3      5      7    9   10   11   12   13   14   15     16   18   19   20
sectA:  Sect 0*8, #646F, #0D65, #090A, #646C, #20, #28, #69, #78, #2B, #73, #70, #6374, #6F, #6C, #29
sectB:  Sect 1*8, #3137, #0909, #733B, #7465, #20, #63, #6F, #6C, #6F, #75, #72, #7420, #6F, #20, #77
sectC:  Sect 2*8, #7469, #0D65, #090A, #6572, #74, #0D, #0A, #0D, #0A, #3B, #2D, #2D2D, #2D, #2D, #2D


; Table containing offsets in the `instruments` table pointing to instruments
; 3 × 8 bytes. Initialised at runtime as instruments 0 to 7. Never changes
instrOffsets:  ; #ca6c
.chA:   dh 2D 2D 2D 2D 20 63 6F 69  ; junk values
.chB:   dh 6E 20 6A 75 6D 70 69 6E  ; junk values
.chC:   dh 67 20 2D 2D 2D 2D 2D 2D  ; junk values


; Initialise the menu AY music
;   `a`: 0 - start, 1 - stop
playMenuMusic:  ; #ca84
        push af
        call initAy
        pop af

        ld l, a
        add a
        add l
        add a
        ; `a` *= 6
        ld hl, scoreInitAddrs
        add l
        ld l, a
        jr NC, .noCarry
        inc h
.noCarry:
        ; `hl`: music init addr
        ld e, (hl)
        inc hl
        ld d, (hl)
        inc hl
        ld (sectA.scoreAddr), de

        ld e, (hl)
        inc hl
        ld d, (hl)
        inc hl
        ld (sectB.scoreAddr), de

        ld e, (hl)
        inc hl
        ld d, (hl)
        inc hl
        ld (sectC.scoreAddr), de

        ; init with 0
        xor a
        ld (sectA.transpose), a
        ld (sectB.transpose), a
        ld (sectC.transpose), a
        ld (sectA.i_15), a
        ld (sectB.i_15), a
        ld (sectC.i_15), a

        ; init with -1 (true)
        cpl
        ld (sectA.isPartEnd), a
        ld (sectB.isPartEnd), a
        ld (sectC.isPartEnd), a

        ; init with 1
        ld a, 1
        ld (sectA.repeatCount), a
        ld (sectB.repeatCount), a
        ld (sectC.repeatCount), a
        ld (sectA.duration), a
        ld (sectB.duration), a
        ld (sectC.duration), a

        ; init with (0 * Instr,  …, 7 * Instr)
        ld hl, instrOffsets
        ld bc, _HIGH 3 _LOW Instr
.channel:
        xor a
.instr:
        ld (hl), a
        inc hl
        add c
        ld (hl), a
        inc hl
        add c
        cp 8 * Instr
        jr NZ, .instr
        djnz .channel

        ; init with instrument 0
        ld hl, instruments.i0
        ld (sectA.instrAddr), hl
        ld (sectB.instrAddr), hl
        ld (sectC.instrAddr), hl

        ; init with -1 (true)
        ld a, -1
        ld (sectA.isPlaying), a
        ld (sectB.isPlaying), a
        ld (sectC.isPlaying), a
        ld (isPlaying), a

        ret

    ENDMODULE
