// sound
TriOsc s => dac;
Noise n => Pan2 p => dac;
SinOsc sweep => dac;

0.08 => s.gain;
0.006 => n.gain;
0.02 => sweep.gain;


// Melody A
[48, 52, 59, 55, 52, 48] @=> int pitchA[];
[.5, .5, .5, .5, .5, .5] @=> float rhythmA[];


// repeat Melody A twice
for(0 => int r; r < 2; r++)
{
    for(0 => int i; i < pitchA.cap(); i++)
    {
        Std.mtof(pitchA[i]) => s.freq;
        
        for(0 => int x; x < rhythmA[i] * 100; x++)
        {
            // noise moves left and right
            Math.sin(now/1::second*2*pi) => p.pan;
            
            // frequency moves low -> high -> low
            (Math.sin(now/1::second*pi) + 1) * 340 + 120 => sweep.freq;
            
            10::ms => now;
        }
    }
}


// Melody B
[50, 53, 57, 53, 50, 47] @=> int pitchB[];
[.5, .5, .5, .5, .5, .5] @=> float rhythmB[];


// play Melody B twice
for(0 => int r; r < 2; r++)
{
    for(0 => int i; i < pitchB.cap(); i++)
    {
        Std.mtof(pitchB[i]) => s.freq;
        
        for(0 => int x; x < rhythmB[i] * 100; x++)
        {
            // noise moves left and right
            Math.sin(now/1::second*2*pi) => p.pan;
            
            // frequency moves low -> high -> low
            (Math.sin(now/1::second*pi) + 1) * 340 + 120 => sweep.freq;
            
            10::ms => now;
        }
    }
}