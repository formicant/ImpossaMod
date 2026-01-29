    MODULE Basic


start:
        _BASIC_LINE 10, <\
            CLEAR, VAL, '"24063":',\
            LOAD, '""', SCREEN_S, ':',\
            PRINT, AT, VAL, '"18",', SIN, PI, ':',\
            LOAD, '""', CODE, VAL, '"24064":',\
            RANDOMIZE, USR, VAL, '"52261"'>
        _BASIC_LINE 9999, <\
            SAVE, '"Monty"', LINE, SIN, PI, ':',\
            LOAD, '"saver"'>

length  EQU $ - start


    ENDMODULE
