    MODULE State


; Game state variables
start:

screenX:    dw -0       ; x coord of the left screen edge in the map
s_03:       dw -0
s_05:       db -0
coins:      db -0       ; 0, 25, …, 250
coinDigits: block 3     ; 3 decimal digits in ascii
soupCans:   db -0       ; 1..3
energy:     db -0       ; 0..34
maxEnergy:  db -0       ; 18, 22, 26, 30, 34
energyText: block 17    ; characters representing energy indicator bars
level:      db -0       ; 0..4
s_1F:       db -0
s_20:       db -0
hasSmart:   db -0       ; 0|1
levelsDone: block 5     ; 0|1 for each level
s_27:       db -0
s_28:       db -0       ; (0..4, index of call table #D6E7 ?)
s_29:       db -0
s_2A:       db -0
s_2B:       db -0
s_2C:       db -0
s_2D:       db -0
s_2E:       db -0
s_2F:       db -0
s_30:       db -0
s_31:       db -0
s_32:       db -0
s_33:       db -0
s_34:       db -0
s_35:       db -0
s_36:       db -0
s_37:       db -0
s_38:       db -0
s_39:       db -0
s_3A:       dw -0
weapon:     db -0       ; 0..4
s_3D:       db -0
s_3E:       db -0
s_3F:       db -0
s_40:       db -0
s_41:       db -0
s_42:       db -0
s_43:       db -0
s_44:       db -0
s_45:       db -0
s_46:       db -0
shopItem:   db -0       ; active item in the shop
shopPrice:  db -0       ; active item price in the shop
s_49:       db -0
s_4A:       db -0
s_4B:       db -0
s_4C:       db -0
s_4D:       db -0
s_4E:       db -0
s_4F:       db -0
s_50:       db -0
s_51:       db -0       ; (60..1, some counter?)
s_52:       dw -0       ; (pointer in the level object table?)
s_54:       db -0
s_55:       db -0
s_56:       db -0
s_57:       db -0
s_58:       db -0
s_59:       db -0
s_5A:       block 48    ; 16 × 3

length  EQU $ - start

loadedLevel:   db -0


    ENDMODULE
