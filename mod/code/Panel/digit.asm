    MODULE Panel

; Print digit or space in case of a leading zero
;   `a`: digit (0..9)
;   `a'`: 0 if there were only leading zeros before
; returns:
;   `a'`: 0 if leading zero
; spoils: `af`, `bc`
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
