
// sample-based sequencer

Gain contrastMaster => dac;

SndBuf cKick => contrastMaster;
SndBuf cSnare => contrastMaster;
SndBuf cHihat => contrastMaster;


.45 => contrastMaster.gain;


me.dir() + "/audio/kick_01.wav" => cKick.read;
me.dir() + "/audio/snare_01.wav" => cSnare.read;
me.dir() + "/audio/hihat_01.wav" => cHihat.read;


cKick.samples() => cKick.pos;
cSnare.samples() => cSnare.pos;
cHihat.samples() => cHihat.pos;


string snareSamples[3];

me.dir() + "/audio/snare_01.wav" => snareSamples[0];
me.dir() + "/audio/snare_02.wav" => snareSamples[1];
me.dir() + "/audio/snare_03.wav" => snareSamples[2];


// counter
0 => int cCounter;


while(cCounter < 32)
{
    cCounter % 8 => int beat;
    
    
    // kick on 0 and 4
    if(beat == 0 || beat == 4)
    {
        0 => cKick.pos;
    }
    
    
    // snare on 2 and 6
    if(beat == 2 || beat == 6)
    {
        // randomly choose a snare sample
        Math.random2(0, snareSamples.cap() - 1) => int which;
        
        snareSamples[which] => cSnare.read;
        0 => cSnare.pos;
    }
    
    
    // hi-hat on every step
    0 => cHihat.pos;
    
    // random hi-hat speed
    Math.random2f(.5, 1.5) => cHihat.rate;
    
    // random hi-hat volume
    Math.random2f(.08, .18) => cHihat.gain;
    
    
    cCounter++;
    
    250::ms => now;
}