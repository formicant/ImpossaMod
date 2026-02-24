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
mixOff      EQU %111111


; Structures used in orig code

    STRUCT Ch       ; length: 18
mixTone     byte    ; negative bit mask in `regMixer` for channel tone
mixNoise    byte    ; negative bit mask in `regMixer` for channel noise
mixMask     byte    ; positive bit mask in `regMixer` for tone and noise
period      word
volume      byte
duration    byte    ; also, vibrato half-period
ch_7        byte    ; some time. e_5
vibrCounter byte
vibrValue   word
vibrSlope   word
phaseAddr   word    ; phase procedure addr (attack, decay, sustain, release)
instrAddr   word
flags       byte    ; bit 1: noise, 7: ?
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
i_0         byte    ; = chan index * 8 (const?)
i_1         word    ; musicInitAddrs
scoreAddr   word
noteAddr    word
instrAddr   word
i_9         byte    ; init with 1, 5 bits when #80 <= v <#C0
transpose   byte    ; init with 0, marked by #FE
i_11        byte    ; init with -1
duration    byte    ; init with 1
isPlaying   byte    ; init with -1
note        byte
i_15        byte    ; init with 0
i_16        word    ; addr in p_c55c?
i_18        byte    ; bits 3..5 of p_c55c value?
i_19        byte    ; length in p_c55c?
i_20        byte    ; bit 7: ?, 6: ?, 5..0: ?
    ENDS

    ENDMODULE
