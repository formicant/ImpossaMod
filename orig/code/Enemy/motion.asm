    MODULE Enemy

; For every object in the scene, process its motion
performMotionOfAllObjs:  ; #ecee
        ld ix, Scene.obj2
        ld b, 6                 ; object count
.object:
        push bc
        push ix
        call checkStillEnemyActivation
        call performObjectMotion
        pop ix
        ld bc, Obj              ; object size
        add ix, bc
        pop bc
        djnz .object
        ret


; Check object motion type and do appropriate actions
;   arg `ix`: object
performObjectMotion:  ; #ed08
        bit Flag.exists, (ix+Obj.flags)
        ret Z

        call emitEnemyBullet

        ld a, (ix+Obj.mo.type)
        cp Motion.bullet
        jp Z, bulletMotion

        bit Flag.waiting, (ix+Obj.flags)
        ret NZ

        ld a, (ix+Obj.objType)
        cp ObjType.pressPlatf
        jp Z, pressPlatformMotion

        call checkDynamiteExplosion

        ld a, (ix+Obj.mo.type)
        cp Motion.trajOrFall
        jr NZ, .skip
        call trajectoryMotion
        jp fallingMotion
.skip:
        cp Motion.trajectory
        call Z, trajectoryMotion

        ld a, (ix+Obj.mo.type)
        or a
        jp Z, .noMotion

        cp Motion.general
        jp Z, generalMotion
        cp Motion.trajectory
        jp Z, generalMotion     ; does nothing (?)

        cp Motion.selfGuided
        jp Z, selfGuidedMotion

        cp Motion.coinJump
        jp Z, coinJumpMotion

        ret

.noMotion:
        set Flag.fixedX, (ix+Obj.flags)
        set Flag.fixedY, (ix+Obj.flags)
        ret

    ENDMODULE
