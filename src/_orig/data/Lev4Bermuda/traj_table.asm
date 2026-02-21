    MODULE Lev4Bermuda


; #B373
trajVelTable:
        dw trajectories.vel0    ; #B99B
        dw trajectories.vel1    ; #B99D
        dw trajectories.vel2    ; #B99F
        dw trajectories.vel3    ; #B9CC
        dw trajectories.vel4    ; #BA01
        dw trajectories.vel5    ; #BA62
        dw trajectories.vel6    ; #BAAB
        dw trajectories.vel7    ; #BB2F
        dw trajectories.vel8    ; #BB88
        dw trajectories.vel9    ; #BC4A
        dw trajectories.vel10   ; #BC63
        block 12, #FF           ; padding

; #B395
trajDirTable:
        dw trajectories.dir0    ; #B99C
        dw trajectories.dir1    ; #B99E
        dw trajectories.dir2    ; #B9B6
        dw trajectories.dir3    ; #B9E7
        dw trajectories.dir4    ; #BA32
        dw trajectories.dir5    ; #BA87
        dw trajectories.dir6    ; #BAEB
        dw trajectories.dir7    ; #BB5C
        dw trajectories.dir8    ; #BBE9
        dw trajectories.dir9    ; #BC57
        dw trajectories.dir10   ; #BCDC
        block 12, #FF           ; padding


    ENDMODULE
