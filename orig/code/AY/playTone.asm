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

        ld a, (iy+Instr.vibrDelay)
        ld (ix+Ch.vibrDelay), a

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

        bit Flag.env, c
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

        bit Flag.env, (iy+Instr.flags)
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
        res Flag.unused, (ix+Ch.flags)
        ret


; Switch off a channel if the note has ended
;   `ix`: channel
switchOffIfEnded:  ; #c99c
        ld a, (ix+Ch.duration)
        and a
        ret NZ
        jr switchOff


doVibrato:  ; # c9a3
        ld a, (ix+Ch.vibrDelay)
        and a
        jr Z, .zero
        cp -1
        ret Z

        dec (ix+Ch.vibrDelay)
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

        ld (ix+Ch.vibrDelay), -1     ; never happens?
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

    ENDMODULE
