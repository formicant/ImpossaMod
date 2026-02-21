    MODULE Lev3Iceland


; #B373
trajVelTable:
        dw trajectories.vel0    ; #B981
        dw trajectories.vel1    ; #B983
        dw trajectories.vel2    ; #B985
        dw trajectories.vel3    ; #B9A1
        dw trajectories.vel4    ; #BA20
        dw trajectories.vel5    ; #BAAB
        dw trajectories.vel6    ; #BB2B
        dw trajectories.vel7    ; #BB74
        dw trajectories.vel8    ; #BBA9
        dw trajectories.vel9    ; #BBEE
        block 14, #FF           ; padding

; #B395
trajDirTable:
        dw trajectories.dir0    ; #B982
        dw trajectories.dir1    ; #B984
        dw trajectories.dir2    ; #B993
        dw trajectories.dir3    ; #B9E1
        dw trajectories.dir4    ; #BA66
        dw trajectories.dir5    ; #BAEB
        dw trajectories.dir6    ; #BB50
        dw trajectories.dir7    ; #BB8F
        dw trajectories.dir8    ; #BBCC
        dw trajectories.dir9    ; #BC1F
        block 14, #FF           ; padding


    ENDMODULE
