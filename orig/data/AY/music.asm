    MODULE AY

; Score parts
scorePart0:
        db Mark.instrument | 0
        db octave*5 + Note.Fs,   whole/2
        db octave*5 + Note.G,    whole/2
        db octave*5 + Note.Fs,   whole/2
        db octave*5 + Note.B,    whole/2
        db octave*5 + Note.Fs,   whole/2
        db octave*5 + Note.G,    whole/2
        db octave*5 + Note.Fs,   whole/2
        db octave*4 + Note.B,    whole/2
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
.start: dw scoreA, scoreB, scoreC
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
        db 22, 22, 25, 23
        db Part.repeat | 2, 6
        db 14, 15, 16, 22, 14, 15, 16, 16, 17, 18, 19, 20, 21
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

    ENDMODULE
