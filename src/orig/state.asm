    MODULE State

; Game state variables
start:

s_01:   dw -0
s_03:   dw -0
s_05:   db -0
s_06:   db -0
s_07:   db -0
s_08:   db -0   ; never read, but written (?)
s_09:   db -0   ; never read, but written (?)
s_0A:   db -0
s_0B:   db -0
s_0C:   db -0
s_0D:   block 17
s_1E:   db -0
s_1F:   db -0

s_20:   db -0
s_21:   db -0
s_22:   block 5
s_27:   db -0
s_28:   db -0
s_29:   db -0
s_2A:   db -0
s_2B:   db -0
s_2C:   db -0
s_2D:   db -0
s_2E:   db -0
s_2F:   db -0

s_30:   db -0
s_31:   db -0
s_32:   db -0
s_33:   db -0
s_34:   db -0
s_35:   db -0
s_36:   db -0
s_37:   db -0
s_38:   db -0
s_39:   db -0
s_3A:   dw -0
s_3C:   db -0
s_3D:   db -0
s_3E:   db -0
s_3F:   db -0

s_40:   db -0
s_41:   db -0
s_42:   db -0
s_43:   db -0
s_44:   db -0
s_45:   db -0
s_46:   db -0
s_47:   db -0
s_48:   db -0
s_49:   db -0
s_4A:   db -0
s_4B:   db -0
s_4C:   db -0
s_4D:   db -0
s_4E:   db -0
s_4F:   db -0

s_50:   db -0
s_51:   db -0
s_52:   dw -0
s_54:   db -0
s_55:   db -0
s_56:   db -0
s_57:   db -0
s_58:   db -0
s_59:   db -0
s_5A:   block 48

length  EQU $ - start

loadedLevel:   db -0


    ENDMODULE
