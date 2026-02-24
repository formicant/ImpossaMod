    MODULE Flag

; bits in `Obj.flags`
exists      EQU 0   ; 0: object is absent, 1: object is present
isBig       EQU 1   ; 0: small sprite (16×16), 1: big sprite (24×21)
fixedX      EQU 2   ; cannot move horizontally
fixedY      EQU 3   ; cannot move vertically
blink       EQU 4   ; blinking phase when the sprite is not drawn
waiting     EQU 5   ; object is not active (invisible yet or in still phase)
mirror      EQU 6   ; draw sprite mirrored
cleanUp     EQU 7   ; object should be removed

; bits in `Obj.auxFlags`
riding      EQU 0   ; object is rideable (or the hero is riding)
standsStill EQU 1   ; randomly stands still
unknown     EQU 2   ; (used in data but ignored in code)
nonEnemy    EQU 3   ; can't be destroyed by smart
givesCoin   EQU 4   ; a coin appears after defeat
changesDir  EQU 5   ; randomly changes direction
falling     EQU 7   ; walking enemy is falling down

    ENDMODULE
