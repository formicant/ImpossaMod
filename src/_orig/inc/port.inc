    MODULE Port


; Multi-purpose input-output port (border, tape, beeper)
general     EQU #FE

tapeIn      EQU 6       ; (bit, input)
tapeOut     EQU 3       ; (bit, output)
beeper      EQU 4       ; (bit, output)

; Keyboard half-rows (input)
keys_VCXZc  EQU #FEFE
keys_GFDSA  EQU #FDFE
keys_TREWQ  EQU #FBFE
keys_54321  EQU #F7FE
keys_67890  EQU #EFFE
keys_YUIOP  EQU #DFFE
keys_HJKLe  EQU #BFFE
keys_BNMss  EQU #7FFE

; Keyboard key bits
key1        EQU 0
key2        EQU 1
key3        EQU 2
key4        EQU 3
key5        EQU 4
key6        EQU 4
key7        EQU 3
key8        EQU 2
key9        EQU 1
key0        EQU 0
keyQ        EQU 0
keyW        EQU 1
keyE        EQU 2
keyR        EQU 3
keyT        EQU 4
keyY        EQU 4
keyU        EQU 3
keyI        EQU 2
keyO        EQU 1
keyP        EQU 0
keyA        EQU 0
keyS        EQU 1
keyD        EQU 2
keyF        EQU 3
keyG        EQU 4
keyH        EQU 4
keyJ        EQU 3
keyK        EQU 2
keyL        EQU 1
keyEnter    EQU 0
keyCaps     EQU 0
keyZ        EQU 1
keyX        EQU 2
keyC        EQU 3
keyV        EQU 4
keyB        EQU 4
keyN        EQU 3
keyM        EQU 2
keySymbol   EQU 1
keySpace    EQU 0

; Bit mask for all keys
keyMask     EQU %00011111


; Kempston joystick port
kempston    EQU #1F     ; (input)
.right      EQU 0       ; (bit)
.left       EQU 1       ; (bit)
.down       EQU 2       ; (bit)
.up         EQU 3       ; (bit)
.fire       EQU 4       ; (bit)
.buttonC    EQU 5       ; (bit)
.buttonA    EQU 6       ; (bit)
.start      EQU 7       ; (bit)

; Bit mask for standard Kempston
.mask       EQU %00011111


; ZX Spectrum 128K memory configuration port
memory      EQU #7FFD   ; (output)
.rom48      EQU 4       ; (bit)


; ZX Spectrum 128K AY-3-8910 sound generator ports
ayRegister  EQU #FFFD   ; (output)
ayValue     EQU #BFFD   ; (in-out)



    ENDMODULE
