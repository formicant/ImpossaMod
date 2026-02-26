    MODULE Hero

heroWalkPhases:  ; #e401
        dw cS.heroWalks1
        dw cS.heroWalks2
        dw cS.heroStands
        dw cS.heroWalks3
        dw cS.heroWalks4
        dw cS.heroStands
.armed:
        dw cS.armedHeroWalks1
        dw cS.armedHeroWalks2
        dw cS.armedHeroStands
        dw cS.armedHeroWalks3
        dw cS.armedHeroWalks4
        dw cS.armedHeroStands


; (Some game logic with weapons?)
setWalkPhase:  ; #e419
        ld a, (State.pressTime)
        or a
        jr Z, .noPress

        ; hero is pressed
        dec a
        ld (State.pressTime), a

        ; set small sprite
        ld de, cS.heroSmallWalks
        ld a, (State.stepPeriod)
        or a
        jr Z, .l_0
        inc (ix+Obj.walkPhase)
        ld a, (ix+Obj.walkPhase)
        and %00000010
        jr NZ, .l_0
        ld de, cS.heroSmallStands
.l_0:
        ld (ix+Obj.sprite+0), e
        ld (ix+Obj.sprite+1), d
        ret

.noPress:
        ld a, (State.stepPeriod)
        or a
        ret Z

        ld hl, State.stepTime
        inc (hl)
        ld a, (State.stepPeriod)
        cp (hl)
        ret NZ

        ld (hl), 0

        inc (ix+Obj.walkPhase)
        ld a, (ix+Obj.walkPhase)
        cp 6                    ; walk phase count
        jr C, .l_2
        xor a
        ld (ix+Obj.walkPhase), a      ; reset walk phase

.l_2:
        add a
        ld l, a
        ld h, 0
        ld de, heroWalkPhases
        ld a, (State.weapon)
        cp ObjType.powerGun
        jr C, .noGun
        ld de, heroWalkPhases.armed
.noGun:
        add hl, de
        ld e, (hl)
        inc hl
        ld d, (hl)
        ld (ix+Obj.sprite+0), e
        ld (ix+Obj.sprite+1), d
        ret

    ENDMODULE
