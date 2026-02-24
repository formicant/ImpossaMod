    MODULE Hero

; Used by c_cc25.
performSmartIfPressed:  ; #d4e5
        call Control.checkSmartKey
        ret NZ
        ld a, (State.hasSmart)
        or a
        ret Z
        ld a, (State.bossFight)
        or a
        ret NZ

        ; perform smart
        ld iy, Scene.obj2
        ld b, 6                 ; object count
.object:
        push bc
        bit Flag.nonEnemy, (iy+Obj.auxFlags)
        jr NZ, .next

        ; check if object is visible
        ld l, (iy+Obj.x+0)
        ld h, (iy+Obj.x+1)
        ld de, 288
        xor a
        sbc hl, de
        jr NC, .next

        call Enemy.damageEnemy.kill

.next:
        ld de, Obj              ; object size
        add iy, de
        pop bc
        djnz .object

    IFNDEF _MOD ; TODO: Remove!
        xor a
        ld (State.hasSmart), a
    ENDIF

    IFDEF _MOD
        jp Panel.printSmart
    ELSE
        ret
    ENDIF

    ENDMODULE
