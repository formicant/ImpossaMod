    MODULE Code

; Add energy
;   `a`: energy points to add
; Used by c_cc25, c_cd5c, c_e6e1 and c_e9b1.
addEnergy:  ; #d09a
        exa
        ld a, (State.maxEnergy)
        ld b, a
        exa
        ld c, a
        ld a, (State.energy)
        add c
        cp b
        jr C, .skip
        ld a, b
.skip:
        ld (State.energy), a
        jp Panel.printEnergy


; Decrement energy by one point
;   `ix`: Scene.hero
; Used by c_d709 and c_e6e1.
decEnergy:  ; #d0af
        ld a, (ix+Obj.blinkTime)
        or a
        ret NZ                  ; don't decrement if still blinking

        ld a, (State.energy)
        sub 1
        jr NC, .skip
        ld a, #FF
        ld (State.isDead), a
        xor a
.skip:
        ld (State.energy), a
        ld (ix+Obj.blinkTime), 7
        ld a, Sound.energyLoss
        call Sound.playSound
        jp Panel.printEnergy


; Decrement blinking time for all scene objects
; Used by c_cc25.
decBlinkTime:  ; #d0d0
        ld ix, Scene.objects
        ld b, 8                 ; object count
        ld de, Obj              ; object size
.object:
        ld a, (ix+Obj.blinkTime)
        or a
        jr Z, .skip

        dec a
        ld (ix+Obj.blinkTime), a
        and 1                   ; even/odd
        jr NZ, .skip
        set Flag.blink, (ix+Obj.flags)
.skip:
        add ix, de
        djnz .object
        ret

    ENDMODULE
