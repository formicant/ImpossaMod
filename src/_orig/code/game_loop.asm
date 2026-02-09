    MODULE Code


gameStart:  ; #cc5a
        call gameMenu
        call clearGameState
.l_2:
        call levelSelectionMenu
        call clearScreenPixels
        ld a, Colour.white      ; bright white ink, black paper
        call fillScreenAttrs
        call clearScene
        call removeObjects      ; not needed (?)
        call initLevel
        ; continue

.gameLoop:
        ld a, (State.s_57)      ; ?
        or a
        jr Z, .l_5

        ld ix, scene.obj1
        ld de, Obj
        ld b, 7
.l_4:
        bit 0, (ix+Obj.flags)
        jr NZ, .l_5

        add ix, de
        djnz .l_4

        ld bc, 5000
        call delay              ; 5 s delay
        jp .l_2

.l_5:
        call performSmartIfSmartKeyPressed ; TODO: replace
        call cleanUpScene             ; TODO: can be inlined
        call c_f553             ; TODO: can be inlined
        call c_ecee             ; TODO: can be inlined (time: long)
        call c_e56f             ; TODO: can be inlined (time: medium)
        call putNextObjectsToScene  ; (time: medium)
        call boss_logic         ; TODO: can be inlined
        call c_e60a             ; TODO: can be inlined
        call decBlinkTime       ; TODO: can be inlined
        call c_e6e1             ; TODO: can be inlined (time: medium)
        call c_d308             ; TODO: can be inlined
        call c_d709             ; TODO: can be inlined (time: long)
        call enterShop          ; TODO: can be inlined
        call shopLogic          ; TODO: can be inlined
        call c_df85             ; TODO: can be inlined (time: medium)
        call updateConveyors    ; TODO: can be inlined
        call rollConveyorTiles  ; TODO: can be inlined
        call drawObjectsChecked ; (time: extreme)

        ld c, 3
        call waitFrames

        call updateScreenTiles  ; (time: extreme)

        ld a, (State.s_05)
        or a
        jr Z, .l_6

        xor a
        ld (State.s_05), a
        ld ix, scene.hero
        set 0, (ix+Obj.flags)   ; set that hero exists (why not?)

        call advanceInMap       ; TODO: can be inlined
        call putNextObjectsToScene
.l_6:
        call pauseGameIfPauseKeyPressed ; TODO: replace
        call checkQuitKey       ; TODO: remove
        jp Z, gameStart

        ld a, (State.isDead)
        or a
        jr Z, .l_8
        xor a
        ld (State.isDead), a
        ld a, (State.hasDiary)
        or a
        jr Z, .l_7
        xor a
        ld (State.hasDiary), a
        ld a, #32
        call addEnergy
        jr .l_8
.l_7:
        call showGameOver       ; TODO: can be inlined
        jp gameStart
.l_8:
        jp .gameLoop


    ENDMODULE
