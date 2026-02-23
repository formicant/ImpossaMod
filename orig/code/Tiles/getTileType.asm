    MODULE Tiles

; Get tile type
;   arg `a`: tile index
;   ret `a`: tile type without fg/bg bit
; Used by c_d709, c_d7f6, c_d94c, c_da95, c_db4e, c_dbfc, c_de37,
; c_deb1, c_df85, c_f1d7, c_f2e7 and c_f618.
getTileType:  ; #eaee
        push hl
        ld h, high(Level.tileTypes)
        ld l, a
        ld a, (hl)
        and TileType.typeMask   ; remove fg/bg bit
        pop hl
        ret

    ENDMODULE
