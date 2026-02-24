    MODULE Main


gameStart:  ; #cc5a
        call Menu.gameMenu
        call Hero.clearGameState

.levelStart:
        call Menu.levelSelectionMenu
        call Utils.clearScreenPixels
        ld a, Colour.brWhite    ; bright white ink, black paper
        call Utils.fillScreenAttrs
        call Scene.clearScene
        call Scene.removeObjects      ; not needed (?)
        call Hero.initLevel

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
        call Utils.delay        ; 5 s delay
        jp .levelStart

.normal:

        call Hero.performSmartIfPressed  ; TODO: replace
        call Scene.cleanUpScene           ; TODO: can be inlined

        call Enemy.enemyBulletTimer       ; TODO: can be inlined
        _DEBUG_BORDER Colour.red
        call Enemy.performMotionOfAllObjs   ; (time: long)
        _DEBUG_BORDER Colour.black
        call Scene.moveObjects            ; TODO: can be inlined (time: medium)
        _DEBUG_BORDER Colour.magenta
        call Scene.putNextObjsToScene     ; (time: medium)
        _DEBUG_BORDER Colour.black
        call Boss.switch              ; TODO: can be inlined
        call Location.checkTransitEnter      ; TODO: can be inlined
        call Scene.decBlinkTime           ; TODO: can be inlined
        _DEBUG_BORDER Colour.green
        call Hero.processHeroCollisions  ; TODO: can be inlined (time: medium)
        _DEBUG_BORDER Colour.black
        call Hero.heroRiding             ; TODO: can be inlined
        _DEBUG_BORDER Colour.cyan
        call Hero.processHero            ; TODO: can be inlined (time: long)
        _DEBUG_BORDER Colour.black
        call Location.enterShop              ; TODO: can be inlined
        call Location.shopLogic              ; TODO: can be inlined
        _DEBUG_BORDER Colour.yellow
        call Hero.processFire            ; TODO: can be inlined (time: medium)
        _DEBUG_BORDER Colour.black
        call Tiles.updateConveyors        ; TODO: can be inlined
        call Tiles.rollConveyorTiles      ; TODO: can be inlined
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

        call Location.advanceInMap       ; TODO: can be inlined
        _DEBUG_BORDER Colour.white
        call Scene.putNextObjsToScene
        _DEBUG_BORDER Colour.black

.skipAdvance:
        call Menu.pauseGameIfPressed ; TODO: replace
        call Control.checkQuitKey   ; TODO: remove
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
        call Hero.addEnergy
        jr .alive

.noDiary:
        call Menu.showGameOver       ; TODO: can be inlined
        jp gameStart

.alive:
        jp .gameLoop


    ENDMODULE
