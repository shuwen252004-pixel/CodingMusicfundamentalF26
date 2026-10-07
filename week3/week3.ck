// sound chain
TriOsc s => dac;

//loop
for( 0 => int i ; i <= 127; i++)
{
    Std.mtof(i) => float Hz; //MIDI to hertz
    <<< i, Hz >>>; //print out i and Hz
    Hz => s. freq; //update frequency
    200::ms => now;
}

// absolute value example

//negative int
-10 => int negative_int;
// negative float
-1.2234 => float nagetive_float;

// Std commands for absolute values
Std.abs(negative_int) => int abs_int;
Std.fabs