    MODULE Basic


start:
        _BASIC_LINE 1, <\
            BORDER, NOT, PI, ':',\
            PAPER, NOT, PI, ':',\
            INK, NOT, PI, ':',\
            CLEAR, VAL, '"25088":',\
            PRINT, '#', NOT, PI, ';',\
                AT, NOT, PI, ',', NOT, PI, ';',\
                INK, NOT, PI, ',,,,:',\
            POKE, VAL, '"23739",', CODE, '"o":',\
            LOAD, '""', SCREEN_S, ':',\
            LOAD, '""', CODE, ':',\
            RUN, USR, VAL, '"33281"'>

length  EQU $ - start


    ENDMODULE
