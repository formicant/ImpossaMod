    MODULE Code


; Play sound (beeper or AY)
playSound:
        ret
        ; ld c, a
        ; ld a, (useBeeper)
        ; or a
        ; ld a, c
        ; jp NZ, playBeeperSound
        ; TODO:
        ; jp playAySound


callPlayMenuMusic:
        ; TODO !
        ret

callAySoundFrame:
        ; TODO !
        ret


; (get something from memory page 1)
hasMusicEnded:  ; #bdfa
        ; TODO !
        ret


useBeeper:
        db 1

; #FF if Spectrum 48K, #00 if Spectrum 128K
is48k:  db -0


    ENDMODULE
