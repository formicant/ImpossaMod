    MODULE AY

; Score parts
scorePart0:
        db Mark.instrument | 4
        db Mark.something | 0
        db octave*4 + Note.C,  3*whole/4
        db Mark.pause,           whole/4
        db octave*4 + Note.C,  3*whole/4
        db Mark.pause,           whole/4
        
        db Mark.something | 1
        db octave*4 + Note.C,  3*whole/4
        db Mark.pause,           whole/4
        db octave*4 + Note.C,  3*whole/4
        db Mark.pause,           whole/4
        
        db Mark.something | 2
        db octave*4 + Note.C,  3*whole/4
        db Mark.pause,           whole/4
        db octave*4 + Note.C,  3*whole/4
        db Mark.pause,           whole/4
        
        db Mark.something | 3
        db octave*4 + Note.C,  3*whole/4
        db Mark.pause,           whole/4
        db octave*4 + Note.C,  3*whole/4
        db Mark.pause,           whole/4
        
        db Mark.something | 4
        db octave*4 + Note.C,  3*whole/4
        db Mark.pause,           whole/4
        db octave*4 + Note.C,  3*whole/4
        db Mark.pause,           whole/4
        
        db Mark.something | 5
        db octave*4 + Note.C,  3*whole/4
        db Mark.pause,           whole/4
        db octave*4 + Note.C,  3*whole/4
        db Mark.pause,           whole/4
        
        db Mark.end

scorePart1:
        db Mark.pause,           whole/2
        db Mark.end

scorePart2:
        db Mark.instrument | 0
        db Mark.something | 1
        db octave*4 + Note.D,    whole/2
        db Mark.something | 2
        db octave*4 + Note.Fs,   whole/2
        db octave*4 + Note.F,    whole/2
        db octave*4 + Note.Gs,   whole/2
        db octave*4 + Note.Fs,   whole/2
        db Mark.something | 3
        db octave*4 + Note.A,    whole/2
        db octave*4 + Note.Gs,   whole/2
        db Mark.something | 4
        db octave*5 + Note.Cs,   whole/2
        db Mark.something | 0
        db Mark.end

scorePart3:
        db Mark.instrument | 1
        db octave*1 + Note.B,    whole/4
        db octave*1 + Note.B,    whole/4
        db Mark.end

scorePart4:
        db Mark.instrument | 1
        db octave*1 + Note.B,    whole/4
        db octave*1 + Note.B,    whole/4
        db octave*1 + Note.B,    whole/4
        db octave*1 + Note.B,    whole/4
        db octave*1 + Note.B,    whole/4
        db octave*1 + Note.B,    whole/4
        db octave*1 + Note.B,    whole/8
        db octave*1 + Note.B,    whole/8
        db octave*1 + Note.B,    whole/8
        db octave*1 + Note.B,    whole/8
        db octave*1 + Note.B,    whole/4
        db octave*1 + Note.B,    whole/4
        db octave*1 + Note.B,    whole/4
        db octave*1 + Note.B,    whole/4
        db octave*1 + Note.B,    whole/4
        db octave*1 + Note.B,    whole/4
        db octave*1 + Note.B,    whole/8
        db octave*1 + Note.B,    whole/8
        db octave*1 + Note.B,    whole/8
        db octave*1 + Note.B,    whole/8
        db Mark.end

scorePart5:
        db Mark.instrument | 2
        db octave*3 + Note.E,    whole/16
        db octave*6 + Note.E,    whole/16
        db octave*4 + Note.E,    whole/16
        db octave*5 + Note.E,    whole/16
        db octave*3 + Note.E,    whole/16
        db octave*6 + Note.E,    whole/16
        db octave*4 + Note.E,    whole/16
        db octave*5 + Note.E,    whole/16
        db octave*3 + Note.E,    whole/16
        db octave*6 + Note.E,    whole/16
        db octave*4 + Note.E,    whole/16
        db octave*5 + Note.E,    whole/16
        db octave*3 + Note.E,    whole/16
        db octave*6 + Note.E,    whole/16
        db octave*4 + Note.E,    whole/16
        db octave*5 + Note.E,    whole/16
        db octave*3 + Note.E,    whole/16
        db octave*6 + Note.E,    whole/16
        db octave*4 + Note.E,    whole/16
        db octave*5 + Note.E,    whole/16
        db octave*3 + Note.E,    whole/16
        db octave*6 + Note.E,    whole/16
        db octave*4 + Note.E,    whole/16
        db octave*5 + Note.E,    whole/16
        db octave*3 + Note.E,    whole/16
        db octave*6 + Note.E,    whole/16
        db octave*4 + Note.E,    whole/16
        db octave*5 + Note.E,    whole/16
        db octave*3 + Note.E,    whole/16
        db octave*6 + Note.E,    whole/16
        db octave*4 + Note.E,    whole/16
        db octave*5 + Note.E,    whole/16
        db octave*3 + Note.E,    whole/16
        db octave*6 + Note.E,    whole/16
        db octave*4 + Note.E,    whole/16
        db octave*5 + Note.E,    whole/16
        db octave*3 + Note.E,    whole/16
        db octave*6 + Note.E,    whole/16
        db octave*4 + Note.E,    whole/16
        db octave*5 + Note.E,    whole/16
        db octave*3 + Note.E,    whole/16
        db octave*6 + Note.E,    whole/16
        db octave*4 + Note.E,    whole/16
        db octave*5 + Note.E,    whole/16
        db octave*3 + Note.E,    whole/16
        db octave*6 + Note.E,    whole/16
        db octave*4 + Note.E,    whole/16
        db octave*5 + Note.E,    whole/16
        db octave*3 + Note.E,    whole/16
        db octave*6 + Note.E,    whole/16
        db octave*4 + Note.E,    whole/16
        db octave*5 + Note.E,    whole/16
        db octave*3 + Note.E,    whole/16
        db octave*6 + Note.E,    whole/16
        db octave*4 + Note.E,    whole/16
        db octave*3 + Note.E,    whole/16
        db octave*3 + Note.E,    whole/16
        db octave*3 + Note.E,    whole/16
        db octave*3 + Note.E,    whole/8
        db octave*3 + Note.E,    whole/8
        db octave*3 + Note.E,    whole/16
        db octave*3 + Note.E,    whole/16
        db Mark.end

scorePart6:
        db Mark.instrument | 1
        db Mark.something | 1
        db octave*4 + Note.A,  3*whole/16
        db octave*4 + Note.A,  3*whole/16
        db octave*4 + Note.A,  3*whole/16
        db Mark.something | 2
        db octave*5 + Note.Cs, 3*whole/16
        db octave*5 + Note.Cs,   whole/8
        db octave*5 + Note.Cs,   whole/8
        db octave*5 + Note.Ds, 3*whole/16
        db octave*5 + Note.Ds, 3*whole/16
        db octave*5 + Note.Ds, 3*whole/16
        db octave*4 + Note.Gs, 3*whole/16
        db octave*4 + Note.Gs,   whole/8
        db octave*4 + Note.Gs,   whole/8
        db Mark.something | 0
        db Mark.end

scorePart7:
        db Mark.instrument | 1
        db octave*2 + Note.B,    whole/16
        db octave*2 + Note.B,    whole/16
        db octave*2 + Note.B,    whole/8
        db octave*2 + Note.B,    whole/8
        db octave*2 + Note.B,    whole/16
        db octave*2 + Note.B,    whole/8
        db octave*2 + Note.B,    whole/8
        db octave*2 + Note.B,    whole/16
        db octave*2 + Note.Fs,   whole/8
        db octave*2 + Note.A,    whole/8
        db Mark.end

scorePart8:
        db Mark.instrument | 1
        db octave*3 + Note.D,    whole/16
        db octave*3 + Note.D,    whole/16
        db octave*3 + Note.D,    whole/8
        db octave*3 + Note.D,    whole/8
        db octave*3 + Note.D,    whole/16
        db octave*3 + Note.D,    whole/16
        db octave*2 + Note.A,    whole/16
        db octave*2 + Note.A,    whole/16
        db octave*2 + Note.A,    whole/8
        db octave*2 + Note.A,    whole/8
        db octave*2 + Note.A,    whole/16
        db octave*2 + Note.A,    whole/16
        db Mark.end

scorePart9:
        db Mark.instrument | 1
        db octave*2 + Note.B,    whole/16
        db octave*3 + Note.B,    whole/8
        db octave*2 + Note.B,    whole/16
        db octave*3 + Note.B,    whole/8
        db octave*2 + Note.B,    whole/16
        db octave*3 + Note.B,    whole/8
        db octave*2 + Note.B,    whole/16
        db octave*3 + Note.B,    whole/8
        db octave*2 + Note.A,    whole/8
        db octave*2 + Note.Fs,   whole/8
        db Mark.end

scorePart10:
        db Mark.instrument | 1
        db octave*2 + Note.B,    whole/16
        db octave*2 + Note.B,    whole/16
        db octave*2 + Note.B,    whole/8
        db octave*2 + Note.B,  3*whole/16
        db octave*2 + Note.B,    whole/8
        db octave*2 + Note.B,    whole/16
        db octave*2 + Note.B,    whole/8
        db octave*2 + Note.B,    whole/8
        db octave*3 + Note.B,    whole/16
        db octave*3 + Note.B,    whole/16
        db Mark.end

scorePart11:
        db Mark.instrument | 1
        db octave*3 + Note.D,    whole/16
        db octave*3 + Note.D,    whole/16
        db octave*3 + Note.D,    whole/8
        db octave*3 + Note.D,    whole/8
        db octave*3 + Note.D,    whole/16
        db octave*3 + Note.D,    whole/16
        db octave*2 + Note.A,    whole/16
        db octave*2 + Note.A,    whole/16
        db octave*2 + Note.A,    whole/8
        db octave*2 + Note.A,    whole/8
        db octave*2 + Note.A,    whole/16
        db octave*2 + Note.A,    whole/16
        db Mark.end

scorePart12:
        db Mark.instrument | 1
        db octave*2 + Note.B,    whole/16
        db octave*2 + Note.B,    whole/16
        db octave*3 + Note.B,    whole/8
        db octave*2 + Note.B,    whole/8
        db octave*3 + Note.B,    whole/16
        db octave*2 + Note.B,    whole/8
        db octave*2 + Note.B,    whole/16
        db octave*3 + Note.B,    whole/8
        db octave*2 + Note.B,    whole/8
        db octave*3 + Note.B,    whole/8
        db octave*2 + Note.G,    whole/16
        db octave*2 + Note.G,    whole/16
        db octave*3 + Note.G,    whole/8
        db octave*2 + Note.G,    whole/8
        db octave*3 + Note.G,    whole/16
        db octave*2 + Note.A,    whole/8
        db octave*2 + Note.A,    whole/16
        db octave*3 + Note.A,    whole/8
        db octave*2 + Note.A,    whole/8
        db octave*3 + Note.A,    whole/8
        db octave*2 + Note.B,    whole/16
        db octave*2 + Note.B,    whole/16
        db octave*3 + Note.B,    whole/8
        db octave*2 + Note.B,    whole/8
        db octave*3 + Note.B,    whole/16
        db octave*2 + Note.B,    whole/8
        db octave*2 + Note.B,    whole/16
        db octave*3 + Note.B,    whole/8
        db octave*2 + Note.B,    whole/8
        db octave*3 + Note.B,    whole/8
        db octave*3 + Note.D,    whole/16
        db octave*3 + Note.D,    whole/16
        db octave*4 + Note.D,    whole/8
        db octave*3 + Note.D,    whole/8
        db octave*4 + Note.D,    whole/16
        db octave*2 + Note.A,    whole/8
        db octave*2 + Note.A,    whole/16
        db octave*3 + Note.A,    whole/8
        db octave*2 + Note.A,    whole/8
        db octave*3 + Note.A,    whole/8
        db Mark.end

scorePart13:
        db Mark.instrument | 1
        db octave*2 + Note.B,    whole/16
        db octave*2 + Note.B,    whole/8
        db octave*2 + Note.B,    whole/16
        db octave*2 + Note.B,    whole/8
        db octave*2 + Note.B,    whole/16
        db octave*2 + Note.B,  3*whole/16
        db octave*2 + Note.A,    whole/8
        db octave*3 + Note.D,    whole/8
        db octave*2 + Note.A,    whole/8
        db octave*2 + Note.G,    whole/16
        db octave*2 + Note.G,    whole/8
        db octave*2 + Note.G,    whole/8
        db octave*2 + Note.G,    whole/8
        db octave*2 + Note.G,    whole/16
        db octave*2 + Note.A,    whole/8
        db octave*2 + Note.Fs,   whole/8
        db octave*2 + Note.A,    whole/8
        db octave*2 + Note.B,    whole/8
        db Mark.end

scorePart14:
        db Mark.instrument | 3
        db octave*5 + Note.E,    whole/8
        db octave*5 + Note.E,    whole/8
        db octave*4 + Note.E,    whole/8
        db octave*5 + Note.E,    whole/8
        db octave*5 + Note.E,    whole/16
        db octave*5 + Note.E,    whole/8
        db octave*5 + Note.E,    whole/16
        db octave*4 + Note.E,    whole/8
        db octave*4 + Note.E,    whole/8
        db octave*5 + Note.E,    whole/8
        db octave*5 + Note.E,    whole/8
        db octave*4 + Note.E,  3*whole/16
        db octave*5 + Note.E,    whole/8
        db octave*5 + Note.E,    whole/16
        db octave*5 + Note.E,    whole/16
        db octave*5 + Note.E,    whole/16
        db octave*4 + Note.E,    whole/16
        db octave*3 + Note.E,    whole/16
        db octave*2 + Note.E,    whole/16
        db octave*2 + Note.E,    whole/16
        db octave*2 + Note.E,    whole/8
        db octave*2 + Note.E,    whole/8
        db octave*5 + Note.E,    whole/8
        db octave*4 + Note.E,    whole/8
        db octave*4 + Note.E,    whole/8
        db octave*5 + Note.E,    whole/8
        db octave*4 + Note.E,    whole/8
        db octave*5 + Note.E,    whole/8
        db octave*4 + Note.E,    whole/8
        db octave*4 + Note.E,    whole/8
        db octave*5 + Note.E,    whole/8
        db octave*5 + Note.E,    whole/16
        db octave*5 + Note.E,    whole/16
        db octave*5 + Note.E,    whole/16
        db octave*6 + Note.E,    whole/16
        db octave*6 + Note.E,    whole/16
        db octave*5 + Note.E,    whole/16
        db octave*4 + Note.E,    whole/16
        db octave*3 + Note.E,    whole/16
        db octave*2 + Note.E,    whole/16
        db octave*2 + Note.E,    whole/16
        db Mark.end

scorePart15:
        db Mark.instrument | 4
        db octave*3 + Note.B,    whole/8
        db octave*4 + Note.Fs,   whole/16
        db octave*4 + Note.Fs,   whole/16
        db octave*4 + Note.F,    whole/8
        db octave*4 + Note.Fs,   whole/8
        db octave*4 + Note.B,    whole/8
        db octave*4 + Note.As,   whole/8
        db octave*4 + Note.B,    whole/8
        db octave*5 + Note.Cs,   whole/8
        db octave*3 + Note.B,    whole/8
        db octave*4 + Note.G,    whole/16
        db octave*4 + Note.G,    whole/16
        db octave*4 + Note.Fs,   whole/8
        db octave*4 + Note.G,    whole/8
        db octave*4 + Note.A,    whole/8
        db octave*4 + Note.G,    whole/8
        db octave*4 + Note.Fs,   whole/8
        db octave*4 + Note.D,    whole/8
        db octave*3 + Note.B,    whole/8
        db octave*4 + Note.Fs,   whole/16
        db octave*4 + Note.Fs,   whole/16
        db octave*4 + Note.F,    whole/8
        db octave*4 + Note.Fs,   whole/8
        db octave*4 + Note.B,    whole/8
        db octave*4 + Note.As,   whole/8
        db octave*4 + Note.B,    whole/8
        db octave*5 + Note.Cs,   whole/8
        db octave*5 + Note.D,    whole/8
        db octave*5 + Note.E,    whole/16
        db octave*5 + Note.Fs,   whole/16
        db octave*5 + Note.G,    whole/8
        db octave*5 + Note.Fs,   whole/16
        db octave*5 + Note.E,    whole/16
        db octave*5 + Note.Fs,   whole/8
        db octave*5 + Note.E,    whole/8
        db octave*5 + Note.D,    whole/8
        db octave*5 + Note.Cs,   whole/8
        db Mark.end

scorePart16:
        db Mark.instrument | 4
        db octave*4 + Note.B,    whole/8
        db octave*4 + Note.Fs,   whole/8
        db octave*4 + Note.B,    whole/8
        db octave*5 + Note.Fs,   whole/8
        db octave*5 + Note.D,    whole/4
        db octave*5 + Note.Cs,   whole/4
        db octave*4 + Note.B,    whole/8
        db octave*4 + Note.Fs,   whole/8
        db octave*4 + Note.B,    whole/8
        db octave*5 + Note.Fs,   whole/8
        db octave*5 + Note.D,    whole/8
        db octave*5 + Note.Cs,   whole/8
        db octave*4 + Note.B,    whole/8
        db octave*4 + Note.A,    whole/8
        db octave*4 + Note.B,    whole/8
        db octave*4 + Note.Fs,   whole/8
        db octave*4 + Note.B,    whole/8
        db octave*5 + Note.Fs,   whole/8
        db octave*5 + Note.D,    whole/4
        db octave*5 + Note.Cs,   whole/8
        db octave*4 + Note.A,    whole/8
        db octave*4 + Note.G,    whole/2
        db octave*4 + Note.Fs,   whole/2
        db Mark.end

scorePart17:
        db Mark.instrument | 4
        db octave*4 + Note.B,  5*whole/4
        db octave*5 + Note.D,    whole/16
        db octave*5 + Note.Cs,   whole/16
        db octave*5 + Note.D,    whole/16
        db octave*5 + Note.Cs,   whole/16
        db octave*5 + Note.D,    whole/8
        db octave*5 + Note.E,    whole/8
        db octave*5 + Note.D,    whole/8
        db octave*4 + Note.A,    whole/8
        db octave*4 + Note.B,  5*whole/4
        db octave*5 + Note.D,    whole/16
        db octave*5 + Note.Cs,   whole/16
        db octave*5 + Note.D,    whole/16
        db octave*5 + Note.Cs,   whole/16
        db octave*5 + Note.D,    whole/8
        db octave*5 + Note.E,    whole/8
        db octave*5 + Note.D,    whole/8
        db octave*5 + Note.Ds,   whole/8
        db Mark.end

scorePart18:
        db Mark.instrument | 0
        db octave*5 + Note.E,  5*whole/4
        db octave*5 + Note.G,    whole/16
        db octave*5 + Note.Fs,   whole/16
        db octave*5 + Note.G,    whole/16
        db octave*5 + Note.Fs,   whole/16
        db octave*5 + Note.G,    whole/8
        db octave*5 + Note.A,    whole/8
        db octave*5 + Note.G,    whole/8
        db octave*5 + Note.D,    whole/8
        db octave*5 + Note.E,    whole
        db Mark.instrument | 5
        db octave*5 + Note.E,    whole
        db Mark.end

scorePart19:
        db Mark.instrument | 4
        db octave*3 + Note.Fs,   whole/8
        db octave*3 + Note.A,    whole/8
        db octave*3 + Note.Gs,   whole/8
        db octave*3 + Note.A,    whole/8
        db octave*3 + Note.Fs,   whole/8
        db octave*4 + Note.A,    whole/8
        db octave*4 + Note.Gs,   whole/8
        db octave*4 + Note.Fs,   whole/8
        db octave*4 + Note.Cs,   whole/8
        db octave*4 + Note.E,    whole/8
        db octave*4 + Note.Ds,   whole/8
        db octave*4 + Note.E,    whole/8
        db octave*4 + Note.Cs,   whole/8
        db octave*5 + Note.E,    whole/8
        db octave*5 + Note.Ds,   whole/8
        db octave*5 + Note.Cs,   whole/8
        db octave*4 + Note.E,    whole/8
        db octave*4 + Note.G,    whole/8
        db octave*4 + Note.Fs,   whole/8
        db octave*4 + Note.G,    whole/8
        db octave*4 + Note.E,    whole/8
        db octave*5 + Note.G,    whole/8
        db octave*5 + Note.Fs,   whole/8
        db octave*5 + Note.E,    whole/8
        db octave*6 + Note.D,    whole/8
        db octave*6 + Note.Cs,   whole/8
        db octave*5 + Note.B,    whole/8
        db octave*5 + Note.D,    whole/8
        db octave*5 + Note.Cs,   whole/8
        db octave*4 + Note.B,    whole/8
        db octave*4 + Note.D,    whole/8
        db octave*4 + Note.Cs,   whole/8
        db Mark.end

scorePart20:
        db Mark.instrument | 4
        db octave*3 + Note.Fs,   whole/8
        db octave*3 + Note.A,    whole/8
        db octave*3 + Note.Gs,   whole/8
        db octave*3 + Note.A,    whole/8
        db octave*3 + Note.Fs,   whole/8
        db octave*4 + Note.A,    whole/8
        db octave*4 + Note.Gs,   whole/8
        db octave*4 + Note.Fs,   whole/8
        db octave*4 + Note.Cs,   whole/8
        db octave*4 + Note.E,    whole/8
        db octave*4 + Note.Ds,   whole/8
        db octave*4 + Note.E,    whole/8
        db octave*4 + Note.Cs,   whole/8
        db octave*5 + Note.E,    whole/8
        db octave*5 + Note.Ds,   whole/8
        db octave*5 + Note.Cs,   whole/8
        db octave*4 + Note.E,    whole/8
        db octave*4 + Note.G,    whole/8
        db octave*4 + Note.Fs,   whole/8
        db octave*4 + Note.G,    whole/8
        db octave*4 + Note.E,    whole/8
        db octave*5 + Note.G,    whole/8
        db octave*5 + Note.Fs,   whole/8
        db octave*5 + Note.E,    whole/8
        db octave*4 + Note.Gs,   whole/8
        db octave*4 + Note.B,    whole/8
        db octave*4 + Note.As,   whole/8
        db octave*4 + Note.B,    whole/8
        db octave*4 + Note.Gs,   whole/8
        db octave*4 + Note.B,    whole/8
        db octave*5 + Note.D,    whole/8
        db octave*5 + Note.F,    whole/8
        db Mark.end

scorePart21:
        db Mark.instrument | 4
        db Mark.something | 4
        db octave*5 + Note.Fs,   whole/8
        db octave*5 + Note.Fs,   whole/4
        db octave*5 + Note.G,    whole/4
        db octave*5 + Note.Fs,   whole/4
        db octave*5 + Note.E,    whole/8
        db octave*5 + Note.Fs,   whole
        db Mark.something | 0
        db Mark.instrument | 6
        db octave*1 + Note.B,    whole/32
        db Mark.end

scorePart22:
        db Mark.pause,           whole
        db Mark.pause,           whole
        db Mark.pause,           whole
        db Mark.pause,           whole
        db Mark.end

scorePart23:
        db Mark.instrument | 4
        db octave*3 + Note.A,    whole
        db Mark.instrument | 5
        db octave*3 + Note.A,    whole
        db Mark.pause,           whole
        db Mark.pause,           whole
        db Mark.end

scorePart24:
scorePart25:
        db Mark.instrument | 2
        db octave*3 + Note.E,    whole
        db octave*3 + Note.E,    whole
        db octave*3 + Note.E,    whole
        db octave*3 + Note.E,    whole/16
        db octave*3 + Note.E,    whole/16
        db octave*3 + Note.E,    whole/16
        db octave*3 + Note.E,    whole/16
        db octave*3 + Note.E,    whole/16
        db octave*3 + Note.E,    whole/16
        db octave*3 + Note.E,    whole/16
        db octave*3 + Note.E,    whole/16
        db octave*3 + Note.E,    whole/16
        db octave*3 + Note.E,    whole/16
        db octave*3 + Note.E,    whole/16
        db octave*3 + Note.E,    whole/16
        db octave*3 + Note.E,    whole/16
        db octave*3 + Note.E,    whole/16
        db octave*3 + Note.E,    whole/16
        db octave*3 + Note.E,    whole/16
        db Mark.end

scorePart26:
        db Mark.instrument | 1
        db octave*2 + Note.B,    whole/8
        db octave*2 + Note.B,    whole/8
        db octave*2 + Note.B,    whole/8
        db octave*2 + Note.B,    whole/8
        db octave*2 + Note.B,    whole/8
        db octave*2 + Note.B,    whole/8
        db octave*2 + Note.B,    whole/8
        db octave*2 + Note.B,    whole/8
        db octave*2 + Note.B,    whole/8
        db octave*2 + Note.B,    whole/8
        db octave*2 + Note.B,    whole/8
        db octave*2 + Note.B,    whole/8
        db octave*2 + Note.B,    whole/8
        db octave*2 + Note.B,    whole/16
        db octave*2 + Note.B,    whole/16
        db octave*2 + Note.B,    whole/8
        db octave*2 + Note.B,    whole/16
        db octave*2 + Note.B,    whole/16
        db octave*2 + Note.B,    whole/8
        db octave*2 + Note.B,    whole/8
        db octave*2 + Note.B,    whole/8
        db octave*2 + Note.B,    whole/8
        db octave*2 + Note.B,    whole/8
        db octave*2 + Note.B,    whole/8
        db octave*2 + Note.B,    whole/8
        db octave*2 + Note.B,    whole/8
        db octave*2 + Note.B,    whole/16
        db octave*2 + Note.B,    whole/16
        db octave*2 + Note.B,    whole/8
        db octave*2 + Note.B,    whole/8
        db octave*2 + Note.B,    whole/16
        db octave*2 + Note.B,    whole/8
        db octave*2 + Note.B,    whole/16
        db octave*2 + Note.B,    whole/16
        db octave*2 + Note.B,    whole/16
        db octave*2 + Note.B,    whole/8
        db octave*2 + Note.B,    whole/16
        db octave*2 + Note.B,    whole/16
        db Mark.end

scorePart27:
        db Mark.instrument | 1
        db octave*3 + Note.Fs,   whole/16
        db octave*3 + Note.Fs,   whole/16
        db octave*3 + Note.Fs,   whole/8
        db octave*3 + Note.Fs, 3*whole/16
        db octave*3 + Note.Fs,   whole/8
        db octave*3 + Note.Fs,   whole/16
        db octave*3 + Note.Fs,   whole/8
        db octave*3 + Note.Fs,   whole/8
        db octave*3 + Note.Fs,   whole/16
        db octave*3 + Note.Fs,   whole/16
        db octave*3 + Note.Cs,   whole/16
        db octave*3 + Note.Cs,   whole/16
        db octave*3 + Note.Cs,   whole/8
        db octave*3 + Note.Cs,   whole/8
        db octave*3 + Note.Cs,   whole/16
        db octave*3 + Note.Cs,   whole/8
        db octave*3 + Note.Cs,   whole/8
        db octave*3 + Note.Cs,   whole/16
        db octave*3 + Note.Cs,   whole/8
        db octave*3 + Note.Cs,   whole/16
        db octave*3 + Note.Cs,   whole/16
        db octave*3 + Note.E,    whole/16
        db octave*3 + Note.E,    whole/16
        db octave*3 + Note.E,    whole/8
        db octave*3 + Note.E,  3*whole/16
        db octave*3 + Note.E,    whole/8
        db octave*3 + Note.E,    whole/16
        db octave*3 + Note.E,    whole/8
        db octave*3 + Note.E,    whole/8
        db octave*3 + Note.E,    whole/16
        db octave*3 + Note.E,    whole/16
        db octave*2 + Note.B,    whole/16
        db octave*2 + Note.B,    whole/16
        db octave*2 + Note.B,    whole/8
        db octave*2 + Note.B,  3*whole/16
        db octave*2 + Note.B,    whole/8
        db octave*2 + Note.B,    whole/16
        db octave*2 + Note.B,    whole/8
        db octave*2 + Note.B,    whole/8
        db octave*2 + Note.B,    whole/16
        db octave*2 + Note.B,    whole/16
        db Mark.end

scorePart28:
        db Mark.instrument | 1
        db octave*3 + Note.Fs,   whole/16
        db octave*3 + Note.Fs,   whole/16
        db octave*3 + Note.Fs,   whole/8
        db octave*3 + Note.Fs, 3*whole/16
        db octave*3 + Note.Fs,   whole/8
        db octave*3 + Note.Fs,   whole/16
        db octave*3 + Note.Fs,   whole/8
        db octave*3 + Note.Fs,   whole/8
        db octave*3 + Note.Fs,   whole/16
        db octave*3 + Note.Fs,   whole/16
        db octave*3 + Note.Cs,   whole/16
        db octave*3 + Note.Cs,   whole/16
        db octave*3 + Note.Cs,   whole/8
        db octave*3 + Note.Cs,   whole/8
        db octave*3 + Note.Cs,   whole/16
        db octave*3 + Note.Cs,   whole/8
        db octave*3 + Note.Cs,   whole/8
        db octave*3 + Note.Cs,   whole/16
        db octave*3 + Note.Cs,   whole/8
        db octave*3 + Note.Cs,   whole/16
        db octave*3 + Note.Cs,   whole/16
        db octave*3 + Note.E,    whole/16
        db octave*3 + Note.E,    whole/16
        db octave*3 + Note.E,    whole/8
        db octave*3 + Note.E,  3*whole/16
        db octave*3 + Note.E,    whole/8
        db octave*3 + Note.E,    whole/16
        db octave*3 + Note.E,    whole/8
        db octave*3 + Note.E,    whole/8
        db octave*3 + Note.E,    whole/16
        db octave*3 + Note.E,    whole/16
        db octave*3 + Note.Gs,   whole/16
        db octave*2 + Note.Gs,   whole/16
        db octave*2 + Note.Gs,   whole/8
        db octave*2 + Note.Gs, 3*whole/16
        db octave*2 + Note.Gs,   whole/8
        db octave*2 + Note.Gs,   whole/16
        db octave*2 + Note.Gs,   whole/8
        db octave*2 + Note.Gs,   whole/8
        db octave*2 + Note.Gs,   whole/16
        db octave*2 + Note.Gs,   whole/16
        db Mark.end

scorePart29:
        db Mark.instrument | 1
        db octave*2 + Note.Fs,   whole/8
        db octave*2 + Note.Fs,   whole/4
        db octave*2 + Note.G,    whole/4
        db octave*2 + Note.Fs,   whole/4
        db octave*2 + Note.E,    whole/8
        db octave*2 + Note.Fs,   whole
        db Mark.end


; Score addresses for channels
scoreInitAddrs: ; #C4CB
.start: dw scoreEnd, scoreEnd, scoreC
.stop:  dw scoreEnd, scoreEnd, scoreEnd

; Scores
scoreA:
        db Part.repeat | 8, 3
        db 4, 26
        db Part.repeat | 3, 7
        db 8, 9
        db Part.transpose, -7
        db 9
        db Part.transpose, 0
        db 9
        db Part.transpose, -7
        db 9
        db Part.transpose, 0
        db Part.repeat | 3, 10
        db 11, 12
        db Part.repeat | 2, 13
        db 12
        db Part.repeat | 3, 10
        db 11, 12
        db Part.repeat | 2, 13
        db 12, 12
        db Part.transpose, 5
        db 12
        db Part.transpose, 0
        db 27, 28, 29
        db Part.end

scoreB:
        db 0, 2
        db Part.transpose, 5
        db 2
        db Part.repeat | 14, 5
        db Part.end

scoreC:
        db 0
        db Part.end

scoreEnd:
        db 1
        db Part.end


; Score part address table
partAddrsLow:
        db low(scorePart0),   low(scorePart1),   low(scorePart2)
        db low(scorePart3),   low(scorePart4),   low(scorePart5)
        db low(scorePart6),   low(scorePart7),   low(scorePart8)
        db low(scorePart9),   low(scorePart10),  low(scorePart11)
        db low(scorePart12),  low(scorePart13),  low(scorePart14)
        db low(scorePart15),  low(scorePart16),  low(scorePart17)
        db low(scorePart18),  low(scorePart19),  low(scorePart20)
        db low(scorePart21),  low(scorePart22),  low(scorePart23)
        db low(scorePart24),  low(scorePart25),  low(scorePart26)
        db low(scorePart27),  low(scorePart28),  low(scorePart29)
partAddrsHigh:
        db high(scorePart0),  high(scorePart1),  high(scorePart2)
        db high(scorePart3),  high(scorePart4),  high(scorePart5)
        db high(scorePart6),  high(scorePart7),  high(scorePart8)
        db high(scorePart9),  high(scorePart10), high(scorePart11)
        db high(scorePart12), high(scorePart13), high(scorePart14)
        db high(scorePart15), high(scorePart16), high(scorePart17)
        db high(scorePart18), high(scorePart19), high(scorePart20)
        db high(scorePart21), high(scorePart22), high(scorePart23)
        db high(scorePart24), high(scorePart25), high(scorePart26)
        db high(scorePart27), high(scorePart28), high(scorePart29)


; (?)
; 5 × 8 bytes
p_c55c: ; #C55C   time  len trsp time trsp time
        db 1<<7 | 1<<3 | 2, 4<<3 | 1, 9<<3 | 1, 0, 0, 0, 0, 0   ; 1
        db 1<<7 | 1<<3 | 2, 3<<3 | 1, 8<<3 | 1, 0, 0, 0, 0, 0   ; 2
        db 1<<7 | 1<<3 | 2, 5<<3 | 1, 9<<3 | 1, 0, 0, 0, 0, 0   ; 3
        db 1<<7 | 1<<3 | 2, 4<<3 | 1, 7<<3 | 1, 0, 0, 0, 0, 0   ; 4
        db 1<<7 | 4<<3 | 1, 6<<3 | 1,        0, 0, 0, 0, 0, 0   ; (unused)


; Instruments used in the music (8 × 10 bytes)
instruments: ; #C584
        ;     env  dec sus rel eP viD viP viS    flag
.i0:    Instr #60, -1, 48, -1, 48, 16, 6,  1, 1<<Flag.tone
.i1:    Instr #7F, -3,  0, -2, 55,  0, 0,  0, 1<<Flag.tone
.i2:    Instr #7F, -6,  0, -1, 40,  0, 1, 24, 1<<Flag.noise
.i3:    Instr #7F, -4,  0, -1, 40,  0, 1, 24, 1<<Flag.noise
.i4:    Instr #7F, -2, 50, -1, 62, 32, 3,  2, 1<<Flag.tone
.i5:    Instr #7F, -1, 50, -1, 64,  0, 0,  1, 1<<Flag.tone
.i6:    Instr #7F, -2,  0, -1,  0, 32, 3,  2, 1<<Flag.tone
.i7:    Instr #60, -1,  0, -1, 48, 16, 6,  1, 1<<Flag.tone     ; (unused)


toneWithEnv  EQU 1<<Flag.env | 1<<Flag.tone

; Game sound effects (15 × 13 bytes)
aySounds:  ; #c5d4
        ;        env  dec sus  rel envP  ?  viP  viS      flag        period dur
        Effect { #7F, -23, 1,  -1, #7F, #00, 0,  163, 1<<Flag.tone  }, 1498,  1  ; (unused)
        Effect { #1B,  -1, 1,  -1, #50, #00, 0,    1, 1<<Flag.tone  },   47,  1  ; (unused)
        Effect { #7F, -23, 1,  -1, #7F, #00, 0, -215, 1<<Flag.tone  },  846,  1  ; (unused)
        Effect { #08, -14, 1,  -7, #6B, #FF, 0,    0, toneWithEnv   }, 3900,  2  ; damageEnemy
        Effect { #0E, -14, 1,  -7, #29, #FF, 0,    0, 1<<Flag.noise },   88,  1  ; kickOrThrow
        Effect { #7F,  -4, 1,  -1, #44, #00, 0,  -20, 1<<Flag.tone  }, 2154,  1  ; jump
        Effect { #7F,  -3, 1,  -1, #60, #00, 0, -256, 1<<Flag.noise },  240,  1  ; killEnemy
        Effect { #0C,   0, 0,   0, #71, #00, 0,  156, toneWithEnv   }, 4027, 15  ; (unused)
        Effect { #0A,  -6, 1, -10, #00, #00, 0,   -1, toneWithEnv   },   35, 28  ; laserGun
        Effect { #14, -20, 1,  -1, #7F, #01, 0,    0, 1<<Flag.noise },  124, 10  ; (unused)
        Effect { #7F,  -3, 1,  -1, #7F, #04, 0,  -32, 1<<Flag.tone  }, 2413,  1  ; powerGun
        Effect { #7F,  -6, 1,  -1, #7F, #00, 0,  -14, 1<<Flag.tone  },  637,  1  ; pickItem
        Effect { #7F, -10, 1,  -1, #7F, #00, 0,    0, 1<<Flag.tone  }, 3460,  1  ; energyLoss
        Effect { #7F,  -7, 1,  -1, #7F, #00, 0,    0, 1<<Flag.tone  },  200,  1  ; pickWeapon
        Effect { #7F,  -3, 8, -35, #7E, #00, 0, -803, 1<<Flag.tone  }, 1010,  1  ; (unused)


; Period value for each note
noteTable:  ; #c697
.o0_As: dw 3822
.o0_B:  dw 3608
.o1_C:  dw 3405
.o1_Cs: dw 3214
.o1_D:  dw 3034
.o1_Ds: dw 2863
.o1_E:  dw 2703
.o1_F:  dw 2551
.o1_Fs: dw 2408
.o1_G:  dw 2273
.o1_Gs: dw 2145
.o1_A:  dw 2025
.o1_As: dw 1911
.o1_B:  dw 1804 ; (lowest used)
.o2_C:  dw 1703
.o2_Cs: dw 1607
.o2_D:  dw 1517
.o2_Ds: dw 1432
.o2_E:  dw 1351
.o2_F:  dw 1276
.o2_Fs: dw 1236 ; (mistake, should be 1204)
.o2_G:  dw 1136
.o2_Gs: dw 1073
.o2_A:  dw 1012
.o2_As: dw  988 ; (mistake, should be 956)
.o2_B:  dw  902
.o3_C:  dw  851
.o3_Cs: dw  804
.o3_D:  dw  758
.o3_Ds: dw  716
.o3_E:  dw  676
.o3_F:  dw  638
.o3_Fs: dw  602
.o3_G:  dw  568
.o3_Gs: dw  536
.o3_A:  dw  506
.o3_As: dw  478
.o3_B:  dw  451
.o4_C:  dw  426
.o4_Cs: dw  402
.o4_D:  dw  379
.o4_Ds: dw  358
.o4_E:  dw  338
.o4_F:  dw  319
.o4_Fs: dw  301
.o4_G:  dw  284
.o4_Gs: dw  268
.o4_A:  dw  253
.o4_As: dw  239
.o4_B:  dw  225
.o5_C:  dw  213
.o5_Cs: dw  201
.o5_D:  dw  190
.o5_Ds: dw  179
.o5_E:  dw  169
.o5_F:  dw  159
.o5_Fs: dw  150
.o5_G:  dw  142
.o5_Gs: dw  134
.o5_A:  dw  127
.o5_As: dw  119
.o5_B:  dw  113
.o6_C:  dw  106
.o6_Cs: dw  100
.o6_D:  dw   95
.o6_Ds: dw   89
.o6_E:  dw   84 ; (highest used)
.o6_F:  dw   80
.o6_Fs: dw   75
.o6_G:  dw   71
.o6_Gs: dw   67
.o6_A:  dw   63
.o6_As: dw   60
.o6_B:  dw   56
.o7_C:  dw   53
.o7_Cs: dw   50
.o7_D:  dw   47
.o7_Ds: dw   45
.o7_E:  dw   42
.o7_F:  dw   40
.o7_Fs: dw   38
.o7_G:  dw   36
.o7_Gs: dw   34
.o7_A:  dw   32
.o7_As: dw   24 ; (mistake, should be 30)

    ENDMODULE
