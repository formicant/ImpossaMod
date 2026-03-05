    MODULE AY

; AY registers
regPeriodA  EQU #0
regPeriodB  EQU #2
regPeriodC  EQU #4
regNoisePer EQU #6
regMixer    EQU #7
regVolumeA  EQU #8
regVolumeB  EQU #9
regVolumeC  EQU #A
regEnvPer   EQU #B
regEnvShape EQU #D


; Values
mixOff      EQU %00111111

tempo       EQU 3

; Octave offsets for notes

octave1     EQU -10
octave2     EQU   2
octave3     EQU  14
octave4     EQU  26
octave5     EQU  38
octave6     EQU  50


    MODULE Part

repeat      EQU #80
instrument  EQU #C0
transpose   EQU #FE
end         EQU #FF

    ENDMODULE


; notes inside an octave
    MODULE Note

C   EQU   0
Cs  EQU   1
D   EQU   2
Ds  EQU   3
E   EQU   4
F   EQU   5
Fs  EQU   6
G   EQU   7
Gs  EQU   8
A   EQU   9
As  EQU  10
B   EQU  11

    ENDMODULE


    MODULE Mark

microtonal  EQU #7E
pause       EQU #7F
instrument  EQU #80
smthThresh  EQU #88
something   EQU #90
skip        EQU #C0
nothing     EQU #C2
end         EQU #FF

    ENDMODULE


    MODULE Flag ; bits of `Ch.flags` and `Instr.flags`

tone        EQU 0
noise       EQU 1
envelope    EQU 2
f_7         EQU 7

    ENDMODULE


; Structures used in orig code

    STRUCT Ch       ; length: 18

mixTone     byte    ; (const) negative bit mask in `regMixer` for channel tone
mixNoise    byte    ; (const) negative bit mask in `regMixer` for channel noise
mixMask     byte    ; (const) positive bit mask in `regMixer` for tone and noise
period      word
volume      byte
duration    byte    ; also, vibrato half-period
ch_7        byte    ; some time. e_5
vibrCounter byte
vibrValue   word
vibrSlope   word
adsrAddr    word    ; addr of the current ADSR stage procedure (attack, decay, sustain, release)
instrAddr   word    ; instrument address
flags       byte    ; bit 0: tone, 1: noise, 2: envelope, 7: ?

    ENDS


    STRUCT Instr    ; length: 10

attackSpd   byte    ; also, envelope shape
decaySpd    byte    ; < 0
sustainLev  byte
releaseSpd  byte    ; < 0
attackLev   byte    ; also, envelope period
e_5         byte    ; some time. ch_7
vibrPeriod  byte
vibrSlope   word
flags       byte

    ENDS


    STRUCT Effect   ; length: 13

instrument  Instr
period      word
duration    byte

    ENDS


    STRUCT Sect     ; length: 21

chOffset    byte    ; (const) channel_index * 8
scoreAddr   word    ; address in the score index
partAddr    word    ; start address of the current score part
noteAddr    word    ; address of the current note in the score part
instrAddr   word    ; instrument address
repeatCount byte    ; init with 1, times to repeat the score part
transpose   byte    ; init with 0, marked by #FE
isPartEnd   byte    ; init with -1. -1: part has ended, 0: part continues
duration    byte    ; init with 1
isPlaying   byte    ; init with -1
note        byte
i_15        byte    ; init with 0. Set to 0..15 when note marker is #9x
i_16        word    ; addr in p_c55c?
i_18        byte    ; bits 3..5 of p_c55c value?
i_19        byte    ; length in p_c55c?
i_20        byte    ; bit 7: ?, 6: ?, 5..0: ?

    ENDS

    ENDMODULE
