// BUBBLE

// dreamcore + experimental


// SOUND CHAIN

TriOsc bubble => Gain bubbleGain => Pan2 bubblePan => dac;

SndBuf sample => Gain sampleGain => Pan2 samplePan => dac;

SndBuf kick => Gain kickGain => Pan2 kickPan => dac;

SndBuf snare => Gain snareGain => Pan2 snarePan => dac;

SndBuf hihat => Gain hihatGain => Pan2 hihatPan => dac;

CNoise pink("pink") => Gain pinkGain => Pan2 pinkPan => dac;

TriOsc harmony => Gain harmonyGain => Pan2 harmonyPan => dac;


// INITIAL VOLUMES

0 => bubbleGain.gain;
0 => sampleGain.gain;
0 => kickGain.gain;
0 => snareGain.gain;
0 => hihatGain.gain;
0 => pinkGain.gain;
0 => harmonyGain.gain;


// BUBBLE MELODIES

[84,88,91,96,93,91,88,86,
84,91,96,93,91,88,86,84] @=> int bubbleMelody[];

[79,83,86,91,88,86,83,81,
79,86,91,88,86,83,81,79] @=> int bubbleMelody2[];


// SAMPLE MELODY

[60,62,65,63,60,57,58,55] @=> int sampleMelody[];


// DRUM PATTERNS

[1,0,0,0,0,1,0,0] @=> int kickPattern[];

[0,0,1,0,0,0,1,0] @=> int snarePattern[];

[1,1,0,1,0,1,1,0] @=> int hihatPattern[];


// C SECTION MELODIES

[72,75,79,77,74,76,81,79,
72,75,80,78,74,77,76,71] @=> int cMelody1[];

[72,75,79,77,74,76,81,79,
72,75,80,78,73,77,76,72] @=> int cMelody2[];

[79,83,86,84,81,85,88,86,
79,82,87,85,81,84,83,78] @=> int cMelody3[];

[69,72,75,74,71,73,77,75,
69,72,76,74,70,73,72,67] @=> int cMelody4[];

[84,87,91,89,86,88,93,91,
84,87,92,90,86,89,88,83] @=> int cMelody5[];

[79,82,86,84,81,85,88,86,
79,82,87,85,80,84,83,78] @=> int cMelody6[];

[72,76,79,78,75,77,82,80,
72,76,81,79,74,78,77,71] @=> int cMelody7[];

[67,71,74,76,73,75,79,77,
67,70,75,73,69,72,71,67] @=> int cMelody8[];


// C HARMONY

[60,63,67,65,62,64,69,67,
60,63,68,66,62,65,64,59] @=> int cHarmony1[];

[55,59,62,61,57,60,64,62,
55,58,63,61,57,60,59,54] @=> int cHarmony2[];

[64,67,71,69,65,69,72,70,
64,67,72,70,65,68,67,63] @=> int cHarmony3[];


// C DRUMS

[1,0,0,1,0,0,1,0] @=> int cKick[];

[0,0,1,0,0,1,0,1] @=> int cSnare[];


// LOAD SAMPLES

me.dir() + "/audio/stereo_fx_01.wav" => sample.read;

me.dir() + "/audio/kick_01.wav" => kick.read;

me.dir() + "/audio/snare_03.wav" => snare.read;

me.dir() + "/audio/hihat_01.wav" => hihat.read;


// PUT PLAYHEADS AT THE END

sample.samples() => sample.pos;

kick.samples() => kick.pos;

snare.samples() => snare.pos;

hihat.samples() => hihat.pos;


// RANDOM

Math.randomize();


// FUNCTION 1
// PLAY ONE BUBBLE NOTE

fun void bubbleNote(int note, float volume)
{
    Std.mtof(note) => bubble.freq;

    volume => bubbleGain.gain;

    Math.random2f(-.7,.7) => bubblePan.pan;

    180::ms => now;


    Std.mtof(note + 12) => bubble.freq;

    volume * .35 => bubbleGain.gain;

    50::ms => now;


    0 => bubbleGain.gain;

    80::ms => now;
}


// FUNCTION 2
// PLAY BUBBLE MELODY

fun void playBubble(int notes[], float volume)
{
    for(0 => int i; i < notes.cap(); i++)
    {
        bubbleNote(notes[i],volume);
    }
}


// FUNCTION 3
// GRANULAR SAMPLE

fun void granularSection(int repetitions, int level)
{
    0 => int i;
    0 => int pieces;
    0 => int grain;

    while(i < repetitions)
    {
        if(level == 0)
        {
            Math.random2(30,70) => pieces;
        }
        else
        {
            Math.random2(45,90) => pieces;
        }


        sample.samples() / pieces => grain;


        Math.random2(
            0,
            sample.samples() - grain
        ) => sample.pos;


        if(level == 0)
        {
            Math.random2f(0.5,2.0) => sample.rate;

            Math.random2f(.14,.23) => sampleGain.gain;
        }
        else
        {
            Math.random2f(0.5,2.4) => sample.rate;

            Math.random2f(.18,.30) => sampleGain.gain;
        }


        Math.random2f(-.8,.8) => samplePan.pan;


        if(i % 4 == 0)
        {
            sampleMelody[i % sampleMelody.cap()] => int note;

            Std.mtof(note) => bubble.freq;

            .025 => bubbleGain.gain;

            Math.random2f(-.6,.6) => bubblePan.pan;
        }


        if(level == 1)
        {
            if(kickPattern[i % kickPattern.cap()] == 1)
            {
                0 => kick.pos;

                Math.random2f(.8,1.2) => kick.rate;

                .06 => kickGain.gain;

                Math.random2f(-.5,.5) => kickPan.pan;
            }


            if(snarePattern[i % snarePattern.cap()] == 1)
            {
                0 => snare.pos;

                Math.random2f(.8,1.3) => snare.rate;

                .045 => snareGain.gain;

                Math.random2f(-.5,.5) => snarePan.pan;
            }


            if(hihatPattern[i % hihatPattern.cap()] == 1)
            {
                0 => hihat.pos;

                Math.random2f(.8,1.4) => hihat.rate;

                .035 => hihatGain.gain;

                Math.random2f(-.8,.8) => hihatPan.pan;
            }
        }


        if(level == 0)
        {
            .002 => pinkGain.gain;
        }
        else
        {
            .004 => pinkGain.gain;
        }


        Math.random2f(-.5,.5) => pinkPan.pan;


        Math.random2(25,60)::ms => now;


        0 => sampleGain.gain;
        0 => bubbleGain.gain;
        0 => kickGain.gain;
        0 => snareGain.gain;
        0 => hihatGain.gain;


        i++;
    }
}


// FUNCTION 4
// B SECTION CLIMAX

fun void climax()
{
    0 => int i;
    0 => int pieces;
    0 => int grain;
    0 => int note;

    while(i < 90)
    {
        45 + i => pieces;

        sample.samples() / pieces => grain;


        1.2 + (i * .016) => sample.rate;


        .18 + (i * .0028) => sampleGain.gain;


        Math.random2(
            0,
            sample.samples() - grain
        ) => sample.pos;


        Math.random2f(-1.0,1.0) => samplePan.pan;


        if(i % 2 == 0)
        {
            bubbleMelody[i % bubbleMelody.cap()] => note;

            12 +=> note;

            Std.mtof(note) => bubble.freq;

            .035 + (i * .0008) => bubbleGain.gain;

            Math.random2f(-1.0,1.0) => bubblePan.pan;
        }


        if(i % 2 == 0)
        {
            0 => kick.pos;

            .08 + (i * .0007) => kickGain.gain;

            Math.random2f(-.7,.7) => kickPan.pan;
        }


        if(i % 4 == 2)
        {
            0 => snare.pos;

            .07 + (i * .0006) => snareGain.gain;

            Math.random2f(-.7,.7) => snarePan.pan;
        }


        if(i % 2 == 1)
        {
            0 => hihat.pos;

            Math.random2f(.8,1.6) => hihat.rate;

            .035 + (i * .0004) => hihatGain.gain;

            Math.random2f(-1.0,1.0) => hihatPan.pan;
        }


        .002 + (i * .00012) => pinkGain.gain;


        Math.random2(20,45)::ms => now;


        0 => sampleGain.gain;
        0 => bubbleGain.gain;
        0 => kickGain.gain;
        0 => snareGain.gain;
        0 => hihatGain.gain;


        i++;
    }


    0 => sample.pos;

    0.5 => sample.rate;

    .45 => sampleGain.gain;


    Std.mtof(108) => bubble.freq;

    .13 => bubbleGain.gain;

    0 => bubblePan.pan;


    Std.mtof(96) => harmony.freq;

    .06 => harmonyGain.gain;

    0 => harmonyPan.pan;


    0 => kick.pos;

    .14 => kickGain.gain;


    0 => snare.pos;

    .12 => snareGain.gain;


    0 => hihat.pos;

    .08 => hihatGain.gain;


    .012 => pinkGain.gain;


    350::ms => now;


    0 => sampleGain.gain;
    0 => bubbleGain.gain;
    0 => harmonyGain.gain;
    0 => kickGain.gain;
    0 => snareGain.gain;
    0 => hihatGain.gain;
    0 => pinkGain.gain;
}


// FUNCTION 5
// C SECTION

fun void playCSection(int version)
{
    0 => int i;
    0 => int note;
    0 => int harmonyNote;

    while(i < 16)
    {
        if(version == 0)
        {
            cMelody1[i] => note;
            cHarmony1[i] => harmonyNote;
        }
        else if(version == 1)
        {
            cMelody2[i] => note;
            cHarmony1[i] => harmonyNote;
        }
        else if(version == 2)
        {
            cMelody3[i] => note;
            cHarmony3[i] => harmonyNote;
        }
        else if(version == 3)
        {
            cMelody4[i] => note;
            cHarmony2[i] => harmonyNote;
        }
        else if(version == 4)
        {
            cMelody5[i] => note;
            cHarmony3[i] => harmonyNote;
        }
        else if(version == 5)
        {
            cMelody6[i] => note;
            cHarmony1[i] => harmonyNote;
        }
        else if(version == 6)
        {
            cMelody7[i] => note;
            cHarmony2[i] => harmonyNote;
        }
        else
        {
            cMelody8[i] => note;
            cHarmony1[i] => harmonyNote;
        }


        if(version == 4)
        {
            12 +=> note;
        }


        if(version == 5)
        {
            12 +=> note;
        }


        Std.mtof(note) => bubble.freq;


        if(version == 0)
        {
            .065 => bubbleGain.gain;
        }
        else if(version == 1)
        {
            .075 => bubbleGain.gain;
        }
        else if(version == 2)
        {
            .08 => bubbleGain.gain;
        }
        else if(version == 3)
        {
            .045 => bubbleGain.gain;
        }
        else if(version == 4)
        {
            .085 => bubbleGain.gain;
        }
        else if(version == 5)
        {
            .095 => bubbleGain.gain;
        }
        else if(version == 6)
        {
            .055 => bubbleGain.gain;
        }
        else
        {
            .07 => bubbleGain.gain;
        }


        Math.random2f(-.45,.45) => bubblePan.pan;


        Std.mtof(harmonyNote) => harmony.freq;


        if(version == 3)
        {
            .015 => harmonyGain.gain;
        }
        else if(version == 5)
        {
            .045 => harmonyGain.gain;
        }
        else
        {
            .028 => harmonyGain.gain;
        }


        Math.random2f(-.25,.25) => harmonyPan.pan;


        if(version == 0)
        {
            if(i % 4 == 0)
            {
                0 => kick.pos;

                .035 => kickGain.gain;
            }
        }


        if(version == 1)
        {
            if(cKick[i % cKick.cap()] == 1)
            {
                0 => kick.pos;

                .055 => kickGain.gain;
            }

            if(cSnare[i % cSnare.cap()] == 1)
            {
                0 => snare.pos;

                .04 => snareGain.gain;
            }
        }


        if(version == 2)
        {
            if(cKick[i % cKick.cap()] == 1)
            {
                0 => kick.pos;

                .06 => kickGain.gain;
            }

            if(cSnare[i % cSnare.cap()] == 1)
            {
                0 => snare.pos;

                .045 => snareGain.gain;
            }
        }


        if(version == 3)
        {
            if(i % 4 == 0)
            {
                0 => kick.pos;

                .03 => kickGain.gain;
            }
        }


        if(version == 4)
        {
            if(cKick[i % cKick.cap()] == 1)
            {
                0 => kick.pos;

                .075 => kickGain.gain;
            }

            if(cSnare[i % cSnare.cap()] == 1)
            {
                0 => snare.pos;

                .055 => snareGain.gain;
            }

            .095 => bubbleGain.gain;

            .04 => harmonyGain.gain;
        }


        if(version == 5)
        {
            if(i % 2 == 0)
            {
                0 => kick.pos;

                .085 => kickGain.gain;
            }

            if(i % 4 == 2)
            {
                0 => snare.pos;

                .065 => snareGain.gain;
            }

            .10 => bubbleGain.gain;

            .045 => harmonyGain.gain;
        }


        if(version == 6)
        {
            if(i % 4 == 0)
            {
                0 => kick.pos;

                .04 => kickGain.gain;
            }

            .06 => bubbleGain.gain;

            .022 => harmonyGain.gain;
        }


        if(version == 7)
        {
            if(i % 4 == 0)
            {
                0 => kick.pos;

                .05 => kickGain.gain;
            }

            if(i % 4 == 2)
            {
                0 => snare.pos;

                .04 => snareGain.gain;
            }

            .07 => bubbleGain.gain;

            .03 => harmonyGain.gain;
        }


        if(i == 5)
        {
            0 => bubbleGain.gain;
        }


        if(i == 13)
        {
            0 => bubbleGain.gain;
        }


        if(version == 0)
        {
            330::ms => now;
        }
        else if(version == 1)
        {
            310::ms => now;
        }
        else if(version == 2)
        {
            290::ms => now;
        }
        else if(version == 3)
        {
            390::ms => now;
        }
        else if(version == 4)
        {
            270::ms => now;
        }
        else if(version == 5)
        {
            240::ms => now;
        }
        else if(version == 6)
        {
            340::ms => now;
        }
        else
        {
            370::ms => now;
        }


        0 => bubbleGain.gain;
        0 => harmonyGain.gain;
        0 => kickGain.gain;
        0 => snareGain.gain;


        i++;
    }
}


// MAIN PROGRAM


// A

.008 => pinkGain.gain;

0 => pinkPan.pan;

playBubble(bubbleMelody,.08);

playBubble(bubbleMelody2,.065);


// PAUSE

0 => pinkGain.gain;

800::ms => now;


// B FLOATING

.004 => pinkGain.gain;

granularSection(50,0);


// B BUILD UP

.006 => pinkGain.gain;

granularSection(70,1);


// B CLIMAX

climax();


// SUDDEN SILENCE

0 => bubbleGain.gain;
0 => sampleGain.gain;
0 => pinkGain.gain;
0 => kickGain.gain;
0 => snareGain.gain;
0 => hihatGain.gain;
0 => harmonyGain.gain;

1.5::second => now;


// A'

.006 => pinkGain.gain;

playBubble(bubbleMelody,.055);

playBubble(bubbleMelody2,.045);


// C1

.02 => pinkGain.gain;

playCSection(0);


// C2

.03 => pinkGain.gain;

playCSection(1);


// C3

.04 => pinkGain.gain;

playCSection(2);


// C4

.01 => pinkGain.gain;

playCSection(3);


// C5

.04 => pinkGain.gain;

playCSection(4);


// C6

.06 => pinkGain.gain;

playCSection(5);


// C7

.02 => pinkGain.gain;

playCSection(6);


// C8

.03 => pinkGain.gain;

playCSection(7);


// FINAL SILENCE

0 => bubbleGain.gain;
0 => harmonyGain.gain;
0 => kickGain.gain;
0 => snareGain.gain;
0 => hihatGain.gain;
0 => pinkGain.gain;
0 => sampleGain.gain;

1::second => now;


// BUBBLE FART ENDING
// same idea as before, but directly in the main program

0 => int endI;
0 => int endPieces;
0 => int endGrain;


while(endI < 10)
{
    Math.random2(45,80) => endPieces;

    sample.samples() / endPieces => endGrain;


    Math.random2(
        0,
        sample.samples() - endGrain
    ) => sample.pos;


    Math.random2f(.55,1.15) => sample.rate;

    Math.random2f(.18,.30) => sampleGain.gain;

    Math.random2f(-.8,.8) => samplePan.pan;


    Math.random2(30,700)::ms => now;


    0 => sampleGain.gain;


    Math.random2(35,900)::ms => now;


    endI++;
}


0 => endI;


while(endI < 7)
{
    Math.random2(60,100) => endPieces;

    sample.samples() / endPieces => endGrain;


    Math.random2(
        0,
        sample.samples() - endGrain
    ) => sample.pos;


    Math.random2f(.8,1.5) => sample.rate;

    Math.random2f(.16,.28) => sampleGain.gain;

    Math.random2f(-.8,.8) => samplePan.pan;


    Math.random2(20,50)::ms => now;


    0 => sampleGain.gain;


    Math.random2(20,60)::ms => now;


    endI++;
}


// FINAL BIG PUFF

Math.random2(25,40) => endPieces;

sample.samples() / endPieces => endGrain;


Math.random2(
    0,
    sample.samples() - endGrain
) => sample.pos;


.55 => sample.rate;

.40 => sampleGain.gain;

0 => samplePan.pan;


120::ms => now;


0 => sampleGain.gain;

100::ms => now;


// TINY AFTER-BUBBLE

Math.random2(
    0,
    sample.samples() - 1
) => sample.pos;


0.8 => sample.rate;

1 => sampleGain.gain;

.6 => samplePan.pan;


60::ms => now;


0 => sampleGain.gain;


// FINAL SILENCE

1::second => now;


// STOP EVERYTHING

0 => bubbleGain.gain;
0 => harmonyGain.gain;
0 => sampleGain.gain;
0 => kickGain.gain;
0 => snareGain.gain;
0 => hihatGain.gain;
0 => pinkGain.gain;

1::second => now;