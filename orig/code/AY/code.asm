    MODULE AY

mixerValue:  ; #c741
        db mixOff

; #c742    mxT  mxN  mxM  period vol  susT   ?  vCnt vValue vSlope phAddr inAddr flag
ayChA:  Ch #FE, #F7, #09, #6F6D, #6E, #74, #79, #0D, #090A, #646C, #6320, #282C, #69
ayChB:  Ch #FD, #EF, #12, #7470, #78, #73, #69, #7A, #2965, #0A0D, #6C09, #2064, #62
ayChC:  Ch #FB, #DF, #24, #090A, #61, #64, #64, #20, #6C68, #622C, #0963, #6D3B, #6F

noisePeriod:  ; #c778
        db 0


; Play tone
;   `ix`: channel addr
;   `iy`: instrument addr
;   `hl`: period
;   `c`: duration
; disables interrupts
playTone:  ; #c779
        di
        ld a, iyl
        ld (ix+Ch.instrAddr+0), a
        ld a, iyh
        ld (ix+Ch.instrAddr+1), a

        ld (ix+Ch.period+0), l
        ld (ix+Ch.period+1), h
        ld (ix+Ch.duration), c

        ld a, (iy+Instr.e_5)
        ld (ix+Ch.ch_7), a

        ; set vibrato
        ld a, (iy+Instr.vibrPeriod)
        and %01111111
        srl a
        jr NZ, .l_0
        ld a, 1
.l_0:
        ld (ix+Ch.vibrCounter), a   ; `vibrPeriod` / 2

        ld a, (iy+Instr.vibrSlope+0)
        ld (ix+Ch.vibrSlope+0), a
        ld a, (iy+Instr.vibrSlope+1)
        ld (ix+Ch.vibrSlope+1), a

        xor a
        ld (ix+Ch.vibrValue+0), a
        ld (ix+Ch.vibrValue+1), a

        ; set mixer
        ld a, (mixerValue)
        or (ix+Ch.mixMask)
        ld c, (iy+Instr.flags)
        ld (ix+Ch.flags), c
        bit Flag.tone, c
        jr Z, .noTone
        and (ix+Ch.mixTone)     ; tone on
.noTone:
        bit Flag.noise, c
        jr Z, .noNoise
        and (ix+Ch.mixNoise)    ; noise on
.noNoise:
        ld (mixerValue), a

        bit Flag.envelope, c
        jr NZ, .envelope

        ; set ADSR stage
        ld hl, attackStage
        ld (ix+Ch.adsrAddr+0), l
        ld (ix+Ch.adsrAddr+1), h
        ret

.envelope:
        ; set envelope
        call beginRegUpdate

        ld a, (iy+Instr.attackSpd)  ; here, envelope shape
        ld c, regEnvShape
        call setAyReg

        ld a, (iy+Instr.attackLev)  ; here, envelope period
        ld c, regEnvPer         ; (low)
        call setAyReg
        inc c                   ; (high)
        xor a
        call setAyReg

        ld (ix+Ch.volume), #FF

        jp endRegUpdate


; Initialise AY registers and some struct fields
initAy:  ; #c7fe
        call beginRegUpdate

        ld c, regMixer
        ld a, (mixerValue)
        or mixOff
        ld (mixerValue), a
        call setAyReg
        xor a
        inc c                   ; regVolumeA
        call setAyReg
        inc c                   ; regVolumeB
        call setAyReg
        inc c                   ; regVolumeC
        call setAyReg
        ld a, 1
        inc c                   ; regEnvPer (low)
        call setAyReg
        inc c                   ; regEnvPer (high)
        xor a
        call setAyReg
        inc c                   ; regEnvShape
        call setAyReg

        ld (ayChA.flags), a
        ld (ayChB.flags), a
        ld (ayChC.flags), a
        ld (ayChA.volume), a
        ld (ayChB.volume), a
        ld (ayChC.volume), a

        jp endRegUpdate


; Write values to AY registers
setAyValues:  ; #c83f
        ld a, (mixerValue)
        and mixOff
        cp mixOff
        ret Z

        ld ix, ayChA
        call applyEffect
        ld ix, ayChB
        call applyEffect
        ld ix, ayChC
        call applyEffect

        call beginRegUpdate
        ld ix, ayChA

        ; regMixer
        ld c, regMixer
        ld a, (mixerValue)
        call setAyReg

        ; regPeriodA
        ld c, regPeriodA
        ld a, (ayChA.period+0)
        add (ix+Ch.vibrValue+0)
        bit Flag.noise, (ix+Ch.flags)
        jp Z, .l_0
        ld (noisePeriod), a
.l_0:
        call setAyReg
        inc c
        ld a, (ayChA.period+1)
        adc a, (ix+Ch.vibrValue+1)
        call setAyReg

        ; regPeriodB
        inc c
        ld a, (ayChB.period+0)
        add (ix+Ch+Ch.vibrValue+0)
        bit Flag.noise, (ix+Ch+Ch.flags)
        jp Z, .l_1
        ld (noisePeriod), a
.l_1:
        call setAyReg
        inc c
        ld a, (ayChB.period+1)
        adc a, (ix+Ch+Ch.vibrValue+1)
        call setAyReg

        ; regPeriodC
        inc c
        ld a, (ayChC.period+0)
        add (ix+2*Ch+Ch.vibrValue+0)
        bit Flag.noise, (ix+2*Ch+Ch.flags)
        jp Z, .l_2
        ld (noisePeriod), a
.l_2:
        call setAyReg
        inc c
        ld a, (ayChC.period+1)
        adc a, (ix+2*Ch+Ch.vibrValue+1)
        call setAyReg

        ; regNoisePer
        inc c
        ld a, (noisePeriod)
    .3  rrca
        call setAyReg

        ; regVolumeA
        ld c, regVolumeA
        ld a, (ayChA.volume)
    .3  srl a
        call setAyReg

        ; regVolumeB
        inc c
        ld a, (ayChB.volume)
    .3  srl a
        call setAyReg

        ; regVolumeC
        inc c
        ld a, (ayChC.volume)
    .3  srl a
        call setAyReg

        jp endRegUpdate


applyEffect:  ; #c8fb
        ld a, (mixerValue)
        and (ix+Ch.mixMask)
        cp (ix+Ch.mixMask)
        ret Z

        ld a, (ix+Ch.instrAddr+0)
        ld iyl, a
        ld a, (ix+Ch.instrAddr+1)
        ld iyh, a
        ; `iy`: instrument

        ld a, (ix+Ch.duration)
        and a
        jr Z, .noDuration
        cp -1
        jr Z, .noDuration
        dec (ix+Ch.duration)
.noDuration:
        call doVibrato

        bit Flag.envelope, (iy+Instr.flags)
        jp NZ, switchOffIfEnded

        ; jump to the current ADSR stage
        ld l, (ix+Ch.adsrAddr+0)
        ld h, (ix+Ch.adsrAddr+1)
        jp hl
        ; possible jumps:
        ; `attackStage`, `decayStage`, `sustainStage`, `releaseStage`


; Attack - the initial ADSR stage
; Raise the volume until it reaches the peak level
;   `ix`: channel
;   `iy`: instrument
attackStage:  ; #c92d
        ld a, (ix+Ch.volume)
        add (iy+Instr.attackSpd)
        cp (iy+Instr.attackLev)
        jr NC, .end
        ld (ix+Ch.volume), a
        ret
.end:
        ld a, (iy+Instr.attackLev)
        ld (ix+Ch.volume), a

        ; set the next stage
        ld hl, decayStage
        ld (ix+Ch.adsrAddr+0), l
        ld (ix+Ch.adsrAddr+1), h
        ret


; Decay - the second ADSR stage
; Drop the volume until it reaches the sustain level
;   `ix`: channel
;   `iy`: instrument
decayStage:  ; #c94c
        ld a, (ix+Ch.volume)
        add (iy+Instr.decaySpd)
        jp M, .end
        cp (iy+Instr.sustainLev)
        jr C, .end
        ld (ix+Ch.volume), a
        ret
.end:
        ld a, (iy+Instr.sustainLev)
        ld (ix+Ch.volume), a

        ; set the next stage
        ld hl, sustainStage
        ld (ix+Ch.adsrAddr+0), l
        ld (ix+Ch.adsrAddr+1), h
        ret


; Sustain - the third ADSR stage
; Keep the volume during the duration of the note
;   `ix`: channel
sustainStage:  ; #c96e
        ld a, (ix+Ch.duration)
        and a
        ret NZ

        ; set the next stage
        ld hl, releaseStage
        ld (ix+Ch.adsrAddr+0), l
        ld (ix+Ch.adsrAddr+1), h
        ret


; Release - the final ADSR stage
; Drop the volume to zero
;   `ix`: channel
;   `iy`: instrument
releaseStage: ; #c967d
        ld a, (ix+Ch.volume)
        add (iy+Instr.releaseSpd)
        jp M, switchOff

        ld (ix+Ch.volume), a
        ret


; Switch off a channel
;   `ix`: channel
switchOff:
        ld (ix+Ch.volume), 0
        ld a, (mixerValue)
        or (ix+Ch.mixMask)
        ld (mixerValue), a
        res Flag.f_7, (ix+Ch.flags)
        ret


; Switch off a channel if the note has ended
;   `ix`: channel
switchOffIfEnded:  ; #c99c
        ld a, (ix+Ch.duration)
        and a
        ret NZ
        jr switchOff


doVibrato:  ; # c9a3
        ld a, (ix+Ch.ch_7)
        and a
        jr Z, .zero
        cp -1
        ret Z

        dec (ix+Ch.ch_7)
        ret NZ

.zero:
        ; update vibrato value
        ld l, (ix+Ch.vibrValue+0)
        ld h, (ix+Ch.vibrValue+1)
        ld c, (ix+Ch.vibrSlope+0)
        ld b, (ix+Ch.vibrSlope+1)
        add hl, bc
        ld (ix+Ch.vibrValue+0), l
        ld (ix+Ch.vibrValue+1), h

        dec (ix+Ch.vibrCounter)
        ret NZ

        ld a, (iy+Instr.vibrPeriod)
        and a
        ret Z

        jp P, .positive         ; always true?

        ld (ix+Ch.ch_7), -1     ; never happens?
        ret

.positive:
        ; reset vibrato counter with duration
        ld (ix+Ch.vibrCounter), a

        ; negate vibrato slope
        ld a, c
        cpl
        ld c, a
        ld a, b
        cpl
        ld b, a
        inc bc

        ld (ix+Ch.vibrSlope+0), c
        ld (ix+Ch.vibrSlope+1), b
        ret


; Do nothing
; Called before updating AY register values
; Apparently, contained some debug or abandoned code
beginRegUpdate:  ; #c9e5
        ret

; Do nothing
; Called after updating AY register values
; Apparently, contained some debug or abandoned code
endRegUpdate:  ; #c9e6
        ret


; Write a value to an AY register
;   `c`: AY register index
;   `a`: value to write
; spoils: `e`
setAyReg:  ; #c9e7
        push bc
        ld e, c
        ld bc, Port.ayRegister
        out (c), e
        ld b, high(Port.ayValue)
        out (c), a
        pop bc
        ret


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
        set 7, (ix+Ch.flags)
        ei
        ret


; #ca2d
;              0      1      3      5      7    9   10   11   12   13   14   15     16   18   19   20
sectA:  Sect 0*8, #646F, #0D65, #090A, #646C, #20, #28, #69, #78, #2B, #73, #70, #6374, #6F, #6C, #29
sectB:  Sect 1*8, #3137, #0909, #733B, #7465, #20, #63, #6F, #6C, #6F, #75, #72, #7420, #6F, #20, #77
sectC:  Sect 2*8, #7469, #0D65, #090A, #6572, #74, #0D, #0A, #0D, #0A, #3B, #2D, #2D2D, #2D, #2D, #2D


; Table containing offsets in the `instruments` table pointing to instruments
; 3 × 8 bytes. Initialised at runtime as instruments 0 to 7
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
        bit Flag.f_7, (ix+Ch.flags)
        ret NZ

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
        cp Mark.nothing         ; (?)
        ret Z

    .3  inc de                  ; skip 3 more notes (?)
        ret


;
;   `ix`: channel
;   `iy`: section
p_cc95:  ; #cc95
        bit Flag.f_7, (ix+Ch.flags)
        ret NZ

        ld a, (iy+Sect.i_20)
        bit 7, a
        ret Z

        and %00111111
        jr NZ, .l_0

        res 7, (iy+Sect.i_20)
        ret

.l_0:
        ld d, %00000111
        bit 6, (iy+Sect.i_20)
        jr NZ, .l_2

        dec (iy+Sect.i_18)
        ret NZ

        dec (iy+Sect.i_19)
        jp Z, .l_2

        ld l, (iy+Sect.i_16+0)
        ld h, (iy+Sect.i_16+1)
        inc l
        ld (iy+Sect.i_16+0), l
        jp NZ, .l_1
        inc h
        ld (iy+Sect.i_16+1), h
.l_1:
        ld a, (hl)
        and d
        ld (iy+Sect.i_18), a
        ld a, (hl)
    .3  rrca
        and %00011111
        add (iy+Sect.note)
        jp .setPeriodByNote

.l_2:
        ld hl, p_c55c - #0708   ; `d`= 7 is added to `h`, `a`&%00011111: 1..5
        ld a, (iy+Sect.i_20)
    .3  add a
        ld e, a
        add hl, de              ; `hl`: #p_c55c + 8 * (Sect.i_20 - 1)

        bit 7, (hl)
        jr NZ, .l_3

        bit 6, (iy+Sect.i_20)
        jr NZ, .l_3

        ld (iy+Sect.i_19), 1
        ret

.l_3:
        res 6, (iy+Sect.i_20)
        ld a, (hl)
    .3  rrca
        and d
        ld (iy+Sect.i_18), a

        ld a, (hl)
        and d
        inc a
        ld (iy+Sect.i_19), a
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


; Initialises an AY sound effect
;   `a`: sound index (0..14)
playAySound:  ; #cd25
        push hl, de, bc, ix, iy

        ld e, a                 ; why?

        ; calculate sound effect addr
        ld l, a
        ld h, 0
    .2  add hl, hl
        ld c, l
        ld b, h
        add hl, hl
        add hl, bc
        ld c, a
        ld b, 0
        add hl, bc
        ; `hl`: `a` * 13
        ld bc, aySounds
        add hl, bc
        push hl : pop iy
        ; `iy`: sound effect addr

        ; choose next channel
        ld a, (lastUsedChannel)
        inc a
        cp 3
        jp C, .selectChannel
        xor a

.selectChannel:
        ld (lastUsedChannel), a
        ld ix, ayChA
        and a
        jp Z, .playTone
        ld ix, ayChB
        cp 1
        jp Z, .playTone
        ld ix, ayChC
        ; `ix`: channel struct addr

.playTone:
        ld l, (iy+Effect.period+0)
        ld h, (iy+Effect.period+1)
        ld c, (iy+Effect.duration)
        call playTone

        pop iy, ix, bc, de, hl
        ret


; Channel used for playing the last sound effect (0..2)
lastUsedChannel:  ; #cd77
        db 0

    ENDMODULE
