    MODULE Lev2Amazon


; #B373
trajVelTable:
        dw trajectories.vel0    ; #B863
        dw trajectories.vel1    ; #B865
        dw trajectories.vel2    ; #B867
        dw trajectories.vel3    ; #B91C
        dw trajectories.vel4    ; #B981
        dw trajectories.vel5    ; #B9D2
        dw trajectories.vel6    ; #B9E7
        dw trajectories.vel7    ; #BA03
        block 18, #FF           ; padding

; #B395
trajDirTable:
        dw trajectories.dir0    ; #B864
        dw trajectories.dir1    ; #B866
        dw trajectories.dir2    ; #B8C2
        dw trajectories.dir3    ; #B94F
        dw trajectories.dir4    ; #B9AA
        dw trajectories.dir5    ; #B9DD
        dw trajectories.dir6    ; #B9F5
        dw trajectories.dir7    ; #BA18
        block 18, #FF           ; padding


    ENDMODULE
