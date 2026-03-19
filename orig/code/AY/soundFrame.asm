    MODULE AY

; Called in interrupts
aySoundFrame:  ; #cb0c
        call setAyValues

        ; check if ended
        ld a, (isPlaying)
        and a
        ret Z

        ld a, (sectA.isPlaying)
        ld hl, sectB.isPlaying
        or (hl)
        ld hl, sectC.isPlaying
        or (hl)
        ld (isPlaying), a
        jr NZ, .notEnded

        xor a
        ld (isPlaying), a
        ld a, (mixerValue)
        and mixOff
        cp mixOff
        ret Z

        ld a, 1
        ld (isPlaying), a
        ret

.notEnded:
        ld iy, sectA
        ld ix, ayChA
        call .proccessChannel

        ld iy, sectB
        ld ix, ayChB
        call .proccessChannel

        ld iy, sectC
        ld ix, ayChC

.proccessChannel:
        ; `ix`: channel
        ; `iy`: section
        call p_cc95

        ld a, (iy+Sect.isPartEnd)
        and a
        jr Z, .getNoteAddr

.partEnd:
        dec (iy+Sect.repeatCount)
        jr Z, .newPart

        ; repeat the part
        ld a, (iy+Sect.partAddr+0)
        ld (iy+Sect.noteAddr+0), a
        ld a, (iy+Sect.partAddr+1)
        ld (iy+Sect.noteAddr+1), a
        ld (iy+Sect.isPartEnd), 0
        jr .getNoteAddr

.newPart:
        ld (iy+Sect.repeatCount), 1
        ld l, (iy+Sect.scoreAddr+0)
        ld h, (iy+Sect.scoreAddr+1)

.getPartIndex:
        ld a, (hl)              ; part index or special value

        ; check special values
        cp Part.repeat
        jr C, .setScorePart

        cp Part.transpose
        jr NZ, .notTranspose

        ; set transposition
        inc hl
        ld a, (hl)              ; transposition value
        ld (iy+Sect.transpose), a
        inc hl
        jp .getPartIndex

.notTranspose:
        cp Part.end
        jr NZ, .notEnd

        ; end the music
        xor a
        ld (iy+Sect.isPlaying), a
        ret

.notEnd:
        cp Part.instrument
        jr NC, .setInstrument

        ; set repeat count
        and %00011111
        ld (iy+Sect.repeatCount), a
        inc hl
        jp .getPartIndex

.setInstrument:
        ; never used (?)
        and %00000111
        add (iy+Sect.chOffset)
        ld de, instrOffsets
        add e
        ld e, a
        jr NC, .noCarry
        inc d
.noCarry:
        inc hl                  ; points to the new instrument offset value
        ldi                     ; copy the value to `instrOffsets` table
        jp .getPartIndex

.setScorePart:
        ld (iy+Sect.isPartEnd), 0

        inc hl
        ld (iy+Sect.scoreAddr+0), l
        ld (iy+Sect.scoreAddr+1), h

        ; `a`: score part index
        ld c, a
        ld b, 0
        ld hl, partAddrsLow
        add hl, bc
        ld e, (hl)
        ld hl, partAddrsHigh
        add hl, bc
        ld d, (hl)
        ; `de`: start address of the score part
        ld (iy+Sect.partAddr+0), e
        ld (iy+Sect.partAddr+1), d
        jr .l_11

.getNoteAddr:
        ld e, (iy+Sect.noteAddr+0)
        ld d, (iy+Sect.noteAddr+1)

.l_11:
        ; `de`: note addr
        dec (iy+Sect.duration)
        jr Z, .zeroDuration

        ld a, (de)              ; note or special value
        cp Mark.instrument
        call NC, p_cc5b

        ld (iy+Sect.noteAddr+0), e
        ld (iy+Sect.noteAddr+1), d
        ret

.zeroDuration:
        ld a, (de)              ; note or special value
        cp Mark.instrument
        jr C, .l_13

        call p_cc5b

        ld a, (iy+Sect.isPartEnd)
        and a
        jr Z, .zeroDuration
        jp .partEnd

.l_13:
        cp Mark.pause
        jr Z, .pause

        cp Mark.microtonal
        jr NZ, .note

        ; get microtonal period
        inc de
        ld a, (de)
        ld l, a
        inc de
        ld a, (de)
        ld h, a
        jp .l_15

.note:
        ; `a`: note
        add (iy+Sect.transpose)
        add 12                  ; + octave
        ld (iy+Sect.note), a

        ld hl, noteTable
        add a
        ld c, a
        ld b, 0
        add hl, bc
        ; `hl` : addr in `noteTable`
        ld a, (hl)
        inc hl
        ld h, (hl)
        ld l, a
        ; `hl`: note period

.l_15:
        ; `hl`: period
        ld a, (iy+Sect.i_15)
        or %11000000
        ld (iy+Sect.i_20), a

        inc de
        ld a, (de)              ; duration
        inc de
        ld (iy+Sect.duration), a
        ld c, a

        ; next note addr
        ld (iy+Sect.noteAddr+0), e
        ld (iy+Sect.noteAddr+1), d

        ld e, (iy+Sect.instrAddr+0)
        ld a, (iy+Sect.instrAddr+1)
        ld iyh, a
        ld iyl, e
        ; `iy`: instrument addr
        bit Flag.unused, (ix+Ch.flags)
        ret NZ                  ; never happens

        jp playTone

.pause:
        inc de
        ld a, (de)
        inc de
        ld (iy+Sect.duration), a
        ld (iy+Sect.noteAddr+0), e
        ld (iy+Sect.noteAddr+1), d
        ret


;
;   `de`: note address
p_cc5b:  ; #cc5b
        ld a, (de)              ; note (>= #80)
        cp Mark.smthThresh
        jr NC, .l_0

        ; `a`: #80..#87 - change instrument
        and %00000111
        add (iy+Sect.chOffset)
        ld c, a
        ld b, 0
        ld hl, instrOffsets
        add hl, bc
        ld c, (hl)
        ld hl, instruments
        add hl, bc
        ld (iy+Sect.instrAddr+0), l
        ld (iy+Sect.instrAddr+1), h

        inc de                  ; next note
        ret

.l_0:
        cp Mark.end
        jr NZ, .notEnd
        ld (iy+Sect.isPartEnd), -1
        ret

.notEnd:
        cp Mark.skip
        jr NC, .l_2

        ; `a`: #88..#BF
        and %00001111
        ld (iy+Sect.i_15), a

        inc de                  ; next note
        ret

.l_2:
        inc de                  ; next note
        cp Mark.unused          ; (?)
        ret Z

    .3  inc de                  ; skip 3 more notes (?)
        ret


;
;   `ix`: channel
;   `iy`: section
p_cc95:  ; #cc95
        bit Flag.unused, (ix+Ch.flags)
        ret NZ                  ; never happens

        ld a, (iy+Sect.i_20)
        bit 7, a
        ret Z

        and %00111111
        jr NZ, .l_0

        res 7, (iy+Sect.i_20)
        ret

.l_0:
        ld d, %00000111         ; (const)
        bit 6, (iy+Sect.i_20)
        jr NZ, .l_2

        ; `Sect.i_18` is always 1
        dec (iy+Sect.i_18)
        ret NZ                  ; never happens

        dec (iy+Sect.i_19)
        jp Z, .l_2

        ld l, (iy+Sect.i_16+0)
        ld h, (iy+Sect.i_16+1)
        ; `hl`: previous addr in table
        inc l
        ld (iy+Sect.i_16+0), l
        jp NZ, .l_1
        inc h
        ld (iy+Sect.i_16+1), h
.l_1:
        ; `hl`: next addr in table
        ld a, (hl)
        and d                   ; `a`: 1, always
        ld (iy+Sect.i_18), a
        ld a, (hl)
    .3  rrca
        and %00011111           ; `a`: transposition value
        add (iy+Sect.note)
        jp .setPeriodByNote

.l_2:
        ld hl, p_c55c - (_HIGH %111 _LOW 8)
        ; const `d`= %111 is pre-subtracted from `h`
        ; and (1 * 8) is pre-subtracted from `l`
        ld a, (iy+Sect.i_20)
    .3  add a
        ld e, a                 ; (1..4) * 8
        add hl, de
        ; `hl`: p_c55c + (Sect.i_20 - 1) * 8

        bit 7, (hl)             ; there's always 1 there
        jr NZ, .l_3             ; always jump

        ; unreachable
        bit 6, (iy+Sect.i_20)
        jr NZ, .l_3

        ld (iy+Sect.i_19), 1
        ret

.l_3:
        res 6, (iy+Sect.i_20)
        ld a, (hl)              ; there's always (1<<7 | 1<<3 | 2) there
    .3  rrca
        and d                   ; `a`: 1, always
        ld (iy+Sect.i_18), a

        ld a, (hl)
        and d
        inc a                   ; `a`: 3, always
        ld (iy+Sect.i_19), a
        ; store addr in table
        ld (iy+Sect.i_16+0), l
        ld (iy+Sect.i_16+1), h

        ld a, (iy+Sect.note)

.setPeriodByNote:
        add a
        ld hl, noteTable
        add l
        ld l, a
        jr NC, .noCarry
        inc h
.noCarry:
        ld a, (hl)
        ld (ix+Ch.period+0), a
        inc hl
        ld a, (hl)
        ld (ix+Ch.period+1), a
        ret

    ENDMODULE
