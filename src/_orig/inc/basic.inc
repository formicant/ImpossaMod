    MODULE Basic


; Control characters
C_COMMA     EQU #06
C_LEFT      EQU #08
C_RIGHT     EQU #09
C_ENTER     EQU #0D
C_NUMBER    EQU #0E
C_INK       EQU #10
C_PAPER     EQU #11
C_FLASH     EQU #12
C_BRIGHT    EQU #13
C_INVERSE   EQU #14
C_OVER      EQU #15
C_AT        EQU #16
C_TAB       EQU #17

; Symbols
S_LT        EQU #3C ; <
S_GT        EQU #3E ; >
S_POUND     EQU #60 ; £
S_COPYRIGHT EQU #7F ; ©

; Pseudographics
G_00_00     EQU #80 ; |  |
G_01_00     EQU #81 ; | ▀|
G_10_00     EQU #82 ; |▀ |
G_11_00     EQU #83 ; |▀▀|
G_00_01     EQU #84 ; | ▄|
G_01_01     EQU #85 ; | █|
G_10_01     EQU #86 ; |▀▄|
G_11_01     EQU #87 ; |▀█|
G_00_10     EQU #88 ; |▄ |
G_01_10     EQU #89 ; |▄▀|
G_10_10     EQU #8A ; |█ |
G_11_10     EQU #8B ; |█▀|
G_00_11     EQU #8C ; |▄▄|
G_01_11     EQU #8D ; |▄█|
G_10_11     EQU #8E ; |█▄|
G_11_11     EQU #8F ; |██|

; UDG
G_A         EQU #90
G_B         EQU #91
G_C         EQU #92
G_D         EQU #93
G_E         EQU #94
G_F         EQU #95
G_G         EQU #96
G_H         EQU #97
G_I         EQU #98
G_J         EQU #99
G_K         EQU #9A
G_L         EQU #9B
G_M         EQU #9C
G_N         EQU #9D
G_O         EQU #9E
G_P         EQU #9F
G_Q         EQU #A0
G_R         EQU #A1
G_S         EQU #A2
G_T         EQU #A3 ; 48K Basic only
G_U         EQU #A4 ; 48K Basic only

; Basic keywords
SPECTRUM    EQU #A3 ; 128K Basic only
PLAY        EQU #A4 ; 128K Basic only
RND         EQU #A5
INKEY_S     EQU #A6 ; INKEY$
PI          EQU #A7
FN          EQU #A8
POINT       EQU #A9
SCREEN_S    EQU #AA ; SCREEN$
ATTR        EQU #AB
AT          EQU #AC
TAB         EQU #AD
VAL_S       EQU #AE ; VAL$
CODE        EQU #AF
VAL         EQU #B0
LEN         EQU #B1
SIN         EQU #B2
COS         EQU #B3
TAN         EQU #B4
ASN         EQU #B5
ACS         EQU #B6
ATN         EQU #B7
LN          EQU #B8
EXP         EQU #B9
INT         EQU #BA
SQR         EQU #BB
SGN         EQU #BC
ABS         EQU #BD
PEEK        EQU #BE
IN          EQU #BF
USR         EQU #C0
STR_S       EQU #C1 ; STR$
CHR_S       EQU #C2 ; CHR$
NOT         EQU #C3
BIN         EQU #C4
OR          EQU #C5
AND         EQU #C6

S_LE        EQU #C7 ; <=
S_GE        EQU #C8 ; >=
S_NE        EQU #C9 ; <>

LINE        EQU #CA
THEN        EQU #CB
TO          EQU #CC
STEP        EQU #CD
DEF_FN      EQU #CE
CAT         EQU #CF
FORMAT      EQU #D0
MOVE        EQU #D1
ERASE       EQU #D2
OPEN_H      EQU #D3 ; OPEN #
CLOSE_H     EQU #D4 ; CLOSE #
MERGE       EQU #D5
VERIFY      EQU #D6
BEEP        EQU #D7
CIRCLE      EQU #D8
INK         EQU #D9
PAPER       EQU #DA
FLASH       EQU #DB
BRIGHT      EQU #DC
INVERSE     EQU #DD
OVER        EQU #DE
OUT         EQU #DF
LPRINT      EQU #E0
LLIST       EQU #E1
STOP        EQU #E2
READ        EQU #E3
DATA        EQU #E4
RESTORE     EQU #E5
NEW         EQU #E6
BORDER      EQU #E7
CONTINUE    EQU #E8
DIM         EQU #E9
REM         EQU #EA
FOR         EQU #EB
GO_TO       EQU #EC
GO_SUB      EQU #ED
INPUT       EQU #EE
LOAD        EQU #EF
LIST        EQU #F0
LET         EQU #F1
PAUSE       EQU #F2
NEXT        EQU #F3
POKE        EQU #F4
PRINT       EQU #F5
PLOT        EQU #F6
RUN         EQU #F7
SAVE        EQU #F8
RANDOMIZE   EQU #F9
IF          EQU #FA
CLS         EQU #FB
DRAW        EQU #FC
CLEAR       EQU #FD
RETURN      EQU #FE
COPY        EQU #FF


; Add a Basic program line
    MACRO _BASIC_LINE lineNumber?, text?
        byte high(lineNumber?), low(lineNumber?)
        word .end - .start
.start:
        byte text?
        byte C_ENTER
.end:
    ENDM


    ENDMODULE
