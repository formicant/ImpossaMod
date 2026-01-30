    MODULE AY


; Ports
registPort  EQU #FFFD
valuePort   EQU #BFFD


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
phaseAddr   word    ; phase procedure addr (onset, decay, sustain, release)
effectAddr  word
flags       byte    ; bit 1: noise, 7: ?
    ENDS

    STRUCT Effect   ; length: 13
envShape    byte
decaySpd    byte    ; < 0
sustainLev  byte
releaseSpd  byte    ; < 0
envPeriod   byte
e_5         byte    ; some time. ch_7
vibrPeriod  byte
vibrSlope   word
flags       byte
period      word
duration    byte

    ENDS

    STRUCT Part     ; length: 21
i_0         byte
i_1         word
i_3         word
i_5         word
effectAddr  word
i_9         byte
i_10        byte
i_11        byte
i_12        byte
i_13        byte
i_14        byte
i_15        byte
i_16        word    ; part length addr?
i_18        byte    ; remaining part length?
i_19        byte    ; remaining notes in part?
i_20        byte
    ENDS


    ENDMODULE
