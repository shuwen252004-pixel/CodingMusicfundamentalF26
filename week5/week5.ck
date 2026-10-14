// EXPERIMENTAL PIECE

// SOUND CHAIN

TriOsc osc => Gain mainGain => Pan2 mainPan => dac;

SndBuf sample => Gain sampleGain => Pan2 samplePan => dac;

CNoise pink("pink") => Gain pinkGain => Pan2 pinkPan => dac;

0 => pinkGain.gain;


// DRUMS

Gain drumMaster => dac;

SndBuf cKick => drumMaster;
SndBuf cSnare => drumMaster;
SndBuf cHihat => drumMaster;

.35 => drumMaster.gain;


// GLOBAL VARIABLES

// main melody
[60, 62, 65, 63, 64, 58, 57] @=> int melody[];

// second melody
[57, 60, 62, 65, 63, 60, 55] @=> int melody2[];

// sample melody
[60, 62, 65, 63, 60, 57, 58, 55] @=> int sampleMelody[];

// drum patterns
[1,0,0,1,0,0,1,0] @=> int kickPattern[];

[0,0,1,0,0,1,0,1] @=> int snarePattern[];

[1,1,0,1,1,0,1,0] @=> int hihatPattern[];


// snare samples

string snareSamples[3];

me.dir() + "/audio/snare_01.wav" => snareSamples[0];
me.dir() + "/audio/snare_02.wav" => snareSamples[1];
me.dir() + "/audio/snare_03.wav" => snareSamples[2];


// load 

me.dir() + "/audio/stereo_fx_01.wav" => sample.read;

me.dir() + "/audio/kick_01.wav" => cKick.read;
me.dir() + "/audio/snare_01.wav" => cSnare.read;
me.dir() + "/audio/hihat_01.wav" => cHihat.read;


// don't play sample immediately

sample.samples() => sample.pos;

cKick.samples() => cKick.pos;
cSnare.samples() => cSnare.pos;
cHihat.samples() => cHihat.pos;


// RANDOM

Math.randomize();


// FUNCTION 1
// VOLUME SWELL

fun void swell(float begin, float end, float grain)
{
    if(begin < end)
    {
        for(begin => float j; j < end; j + grain => j)
        {
            j => mainGain.gain;
            .01::second => now;
        }
    }
    else
    {
        for(begin => float j; j > end; j + grain => j)
        {
            j => mainGain.gain;
            .01::second => now;
        }
    }
}


// FUNCTION 2
// PLAY ONE NOTE

fun void playNote(int note, float volume)
{
    Std.mtof(note) => osc.freq;
    
    Math.random2f(-.7,.7) => mainPan.pan;
    
    swell(.01, volume, .01);
    
    swell(volume, .01, -.01);
    
    30::ms => now;
}


// FUNCTION 3
// PLAY MELODY

fun void playMelody(int notes[], float volume)
{
    for(0 => int i; i < notes.cap(); i++)
    {
        playNote(notes[i], volume);
    }
}


// FUNCTION 4
// RANDOM MELODY

fun void randomMelody(int notes[], int repetitions, float volume)
{
    for(0 => int i; i < repetitions; i++)
    {
        if(Math.random2(0,100) > 25)
        {
            notes[Math.random2(0,notes.cap()-1)] => int note;
            
            Math.random2(-12,12) +=> note;
            
            Std.mtof(note) => osc.freq;
            
            Math.random2f(.02,volume) => mainGain.gain;
            
            Math.random2f(-1.0,1.0) => mainPan.pan;
        }
        
        else
        {
            0 => mainGain.gain;
        }
        
        Math.random2(50,180)::ms => now;
        
        0 => mainGain.gain;
    }
}


// FUNCTION 5
// PLAY DRUM STEP

fun void drumStep(int beat)
{
    // kick
    
    if(kickPattern[beat] == 1)
    {
        0 => cKick.pos;
        
        Math.random2f(.4,.7) => cKick.gain;
    }
    
    
    // snare
    
    if(snarePattern[beat] == 1)
    {
        Math.random2(
        0,
        snareSamples.cap() - 1
        ) => int which;
        
        snareSamples[which] => cSnare.read;
        
        0 => cSnare.pos;
        
        Math.random2f(.3,.6) => cSnare.gain;
    }
    
    
    // hi-hat
    
    if(hihatPattern[beat] == 1)
    {
        if(Math.random2(0,100) > 20)
        {
            0 => cHihat.pos;
            
            Math.random2f(.5,1.5) => cHihat.rate;
            
            Math.random2f(.05,.15) => cHihat.gain;
        }
    }
}


// FUNCTION 6
// GRANULARIZE SAMPLE

fun void granularize(int repetitions)
{
    0 => int i;
    
    while(i < repetitions)
    {
        // random grain size
        
        Math.random2(10,50) => int steps;
        
        sample.samples() / steps => int grain;
        
        
        // random sample position
        
        Math.random2(
        0,
        sample.samples() - grain
        ) => sample.pos;
        
        
        // random sample speed
        
        Math.random2f(.5,2.0) => sample.rate;
        
        
        // random sample pan
        
        Math.random2f(-1.0,1.0) => samplePan.pan;
        
        
        // random sample volume
        
        Math.random2f(.08,.25) => sampleGain.gain;
        
        
        // sometimes reverse
        
        if(Math.random2(0,100) > 75)
        {
            -1.0 => sample.rate;
        }
        
        
        // MUSICAL LAYER
        
        sampleMelody[i % sampleMelody.cap()] => int note;
        
        Std.mtof(note) => osc.freq;
        
        .06 => mainGain.gain;
        
        Math.random2f(-.5,.5) => mainPan.pan;
        
        
        // sometimes no musical note
        
        if(Math.random2(0,100) < 20)
        {
            0 => mainGain.gain;
        }
        
        
        // DRUMS
        
        i % 8 => int beat;
        
        drumStep(beat);
        
        
        // sample + TriOsc + drums
        
        grain::samp => now;
        
        
        // stop
        
        0 => sampleGain.gain;
        0 => mainGain.gain;
        
        0 => cKick.gain;
        0 => cSnare.gain;
        0 => cHihat.gain;
        
        i++;
    }
}


// FUNCTION 7
// RECURSION

fun void ending(int n)
{
    if(n > 0)
    {
        Std.mtof(50 + n * 2) => osc.freq;
        
        .12 => mainGain.gain;
        
        Math.random2f(-1.0,1.0) => mainPan.pan;
        
        n * 30::ms => now;
        
        0 => mainGain.gain;
        
        ending(n-1);
    }
}


// MAIN PROGRAM

// A
// original melody + pink noise

.01 => pinkGain.gain;

Math.random2f(-.3,.3) => pinkPan.pan;

playMelody(melody,.18);

0 => pinkGain.gain;


// B
// random / unstable version

randomMelody(melody,30,.12);


// GRANULAR SECTION
// sample + small TriOsc + drums

granularize(150);


// A'
// original melody comes back

playMelody(melody,.12);

playMelody(melody2,.08);


// RANDOM INTERRUPTION

randomMelody(melody2,20,.12);


// ENDING
// recursion

ending(12);


// STOP EVERYTHING

0 => mainGain.gain;
0 => sampleGain.gain;
0 => pinkGain.gain;

0 => cKick.gain;
0 => cSnare.gain;
0 => cHihat.gain;

1::second => now;