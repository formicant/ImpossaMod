    MODULE Code


gameStart:  ; #cc5a
        call gameMenu
        call clearGameState

.levelStart:
        call levelSelectionMenu
        call clearScreenPixels
        ld a, Colour.white      ; bright white ink, black paper
        call fillScreenAttrs
        call clearScene
        call removeObjects      ; not needed (?)
        call initLevel

.gameLoop:
        ; check if boss is killed
        ld a, (State.bossKilled)
        or a
        jr Z, .normal
        ; wait until all clouds disappear
        ld ix, scene.obj1
        ld de, Obj              ; object size
        ld b, 7                 ; object count
.bossPart:
        bit 0, (ix+Obj.flags)   ; exists
        jr NZ, .normal
        add ix, de
        djnz .bossPart
        ; level complete
        ld bc, 5000
        call delay              ; 5 s delay
        jp .levelStart

.normal:
        call performSmartIfPressed  ; TODO: replace
        call cleanUpScene           ; TODO: can be inlined
        call enemyBulletTimer       ; TODO: can be inlined
        call processObjsBehaviour   ; (time: long)
        call moveObjects            ; TODO: can be inlined (time: medium)
        call putNextObjsToScene     ; (time: medium)
        call bossLogic              ; TODO: can be inlined
        call checkTransitEnter      ; TODO: can be inlined
        call decBlinkTime           ; TODO: can be inlined
        call processHeroCollisions  ; TODO: can be inlined (time: medium)
        call c_d308                 ; TODO: can be inlined
        call c_d709                 ; TODO: can be inlined (time: long)
        call enterShop              ; TODO: can be inlined
        call shopLogic              ; TODO: can be inlined
        call processFire            ; TODO: can be inlined (time: medium)
        call updateConveyors        ; TODO: can be inlined
        call rollConveyorTiles      ; TODO: can be inlined
        call drawObjectsChecked     ; (time: extreme)

        _DEBUG_BORDER Colour.black
        ld c, 3
        call waitFrames
        _DEBUG_BORDER Colour.blue

        call updateScreenTiles  ; (time: extreme)

        ld a, (State.s_05)
        or a
        jr Z, .l_6

        xor a
        ld (State.s_05), a
        ld ix, scene.hero
        set 0, (ix+Obj.flags)   ; set that hero exists (why not?)

        call advanceInMap       ; TODO: can be inlined
        call putNextObjsToScene

.l_6:
        call pauseGameIfPressed ; TODO: replace
        call checkQuitKey       ; TODO: remove
        jp Z, gameStart

        ld a, (State.isDead)
        or a
        jr Z, .alive
        xor a
        ld (State.isDead), a
        ld a, (State.hasDiary)
        or a
        jr Z, .noDiary
        xor a
        ld (State.hasDiary), a
        ld a, 50
        call addEnergy
        jr .alive

.noDiary:
        call showGameOver       ; TODO: can be inlined
        jp gameStart

.alive:
        jp .gameLoop


    ENDMODULE
