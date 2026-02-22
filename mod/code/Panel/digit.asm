    MODULE Panel

; Print digit or space in case of a leading zero
;   arg `a`: digit (0..9)
;       `a'`: 0 if there were only leading zeros before
;   ret `a'`: 0 if leading zero
;   spoils `af`, `bc`
printDigitWithoutLeadingZeros:
        exa
        or a
        jr NZ, .significant
        exa
        or a
        jp NZ, .firstSignificant

        dec a                   ; space
        jp Utils.printChar

.firstSignificant:
        exa
        dec a                   ; not a leading zero
.significant:
        exa
        jp Utils.printChar

    ENDMODULE
