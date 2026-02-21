    MODULE Code


gameStart:  ; #cc5a
        call gameMenu
        call clearGameState

.levelStart:
        call levelSelectionMenu
        call clearScreenPixels
        ld a, Colour.brWhite    ; bright white ink, black paper
        call fillScreenAttrs
        call clearScene
        call removeObjects      ; not needed (?)
        call initLevel

.gameLoop:
        ; check if boss is killed
        ld a, (State.bossKilled)
        or a
        jr Z, .normal
        ; wait until all explosion clouds disappear
        ld ix, Scene.obj1
        ld de, Obj              ; object size
        ld b, 7                 ; object count
.bossPart:
        bit Flag.exists, (ix+Obj.flags)
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
        _DEBUG_BORDER Colour.red
        call performMotionOfAllObjs   ; (time: long)
        _DEBUG_BORDER Colour.black
        call moveObjects            ; TODO: can be inlined (time: medium)
        _DEBUG_BORDER Colour.magenta
        call putNextObjsToScene     ; (time: medium)
        _DEBUG_BORDER Colour.black
        call bossLogic              ; TODO: can be inlined
        call checkTransitEnter      ; TODO: can be inlined
        call decBlinkTime           ; TODO: can be inlined
        _DEBUG_BORDER Colour.green
        call processHeroCollisions  ; TODO: can be inlined (time: medium)
        _DEBUG_BORDER Colour.black
        call heroRiding             ; TODO: can be inlined
        _DEBUG_BORDER Colour.cyan
        call processHero            ; TODO: can be inlined (time: long)
        _DEBUG_BORDER Colour.black
        call enterShop              ; TODO: can be inlined
        call shopLogic              ; TODO: can be inlined
        _DEBUG_BORDER Colour.yellow
        call processFire            ; TODO: can be inlined (time: medium)
        _DEBUG_BORDER Colour.black
        call updateConveyors        ; TODO: can be inlined
        call rollConveyorTiles      ; TODO: can be inlined
        _DEBUG_BORDER Colour.white
        call Drawing.drawObjectsChecked     ; (time: extreme)
        _DEBUG_BORDER Colour.black

    IFDEF _MOD
        ld c, 2
    ELSE
        ld c, 3
    ENDIF
        call Interrupt.waitFrames
        _DEBUG_BORDER Colour.blue

        call Drawing.updateScreenTiles  ; (time: extreme)
        _DEBUG_BORDER Colour.black

        ld a, (State.advance)
        or a
        jr Z, .skipAdvance

        xor a
        ld (State.advance), a
        ld ix, Scene.hero
        set Flag.exists, (ix+Obj.flags) ; why?

        call advanceInMap       ; TODO: can be inlined
        _DEBUG_BORDER Colour.white
        call putNextObjsToScene
        _DEBUG_BORDER Colour.black

.skipAdvance:
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
