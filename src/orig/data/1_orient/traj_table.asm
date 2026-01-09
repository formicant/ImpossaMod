    MODULE Lev1Orient


; #B373
trajVelTable:
        dw trajectories.vel0    ; #B935
        dw trajectories.vel1    ; #B933
        dw trajectories.vel2    ; #B937
        dw trajectories.vel3    ; #B980
        dw trajectories.vel4    ; #B9BB
        dw trajectories.vel5    ; #B9BB
        dw trajectories.vel6    ; #B9F2
        dw trajectories.vel7    ; #BA0B
        dw trajectories.vel8    ; #BA3E
        block 16, #FF           ; padding

; #B395
trajDirTable:
        dw trajectories.dir0    ; #B936
        dw trajectories.dir1    ; #B934
        dw trajectories.dir2    ; #B95C
        dw trajectories.dir3    ; #B99E
        dw trajectories.dir4    ; #B9CE
        dw trajectories.dir5    ; #B9E0
        dw trajectories.dir6    ; #B9FF
        dw trajectories.dir7    ; #BA25
        dw trajectories.dir8    ; #BA4B
        block 16, #FF           ; padding


    ENDMODULE
