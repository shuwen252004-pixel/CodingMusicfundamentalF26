//program name
<<< "bubble" >>>;

TriOsc i => dac;
SqrOsc p => dac;


40 => p.freq;
0.006 => p.gain;

130 => i.freq; 
0.08 => i.gain;  
500::ms => now;

164 => i.freq;
0.1 => i.gain;
500::ms => now;
 
247 => i.freq;
0.1 => i.gain;  
500::ms => now;

196 => i.freq;
0.08 => i.gain;  
500::ms => now;

164 => i.freq;
0.08 => i.gain;  
500::ms => now;

130 => i.freq; 
0.08 => i.gain; 
450::ms => now;
 
0 => i.gain;
50::ms => now;
 

130 => i.freq; 
0.08 => i.gain; 
500::ms => now;

164 => i.freq;
0.1 => i.gain;
500::ms => now;
 
247 => i.freq;
0.1 => i.gain;  

500::ms => now;

196 => i.freq;
0.08 => i.gain;  
500::ms => now;

164 => i.freq;
0.08 => i.gain;  
500::ms => now;

130 => i.freq; 
0.08 => i.gain; 

500::ms => now;

147 => i.freq; 
0.06 => i.gain; 
500::ms => now;

175 => i.freq;
0.1 => i.gain;
500::ms => now;

220 => i.freq;
0.1 => i.gain;  
500::ms => now;

175 => i.freq;
0.1 => i.gain;
500::ms => now;

147 => i.freq; 
0.06 => i.gain; 
500::ms => now;
 
123 => i.freq;
0.04 => i.gain;
500::ms => now;

147 => i.freq; 
0.06 => i.gain; 
500::ms => now;

175 => i.freq;
0.1 => i.gain;
500::ms => now;

220 => i.freq;
0.1 => i.gain;  
500::ms => now;

175 => i.freq;
0.1 => i.gain;
500::ms => now;

0 => i.gain;
500::ms =>now;

220 => i.freq; 
0.1 => i.gain;  
250::ms => now;

260 => i.freq;
0.12 => i.gain;
250::ms => now; 


SinOsc in => dac;

20 => int f;

// going up
while( f < 400)
{
    f => in.freq;
    <<< "f" >>>;
    0.01::second => now;
    f++;
}

//going down
while( f > 20)
{
    f => in.freq;
    0.01::second => now;
    f--;
}

SinOsc foo => dac;

//infinite time loop

while( true )
{
    
    Math.random2f(600, 1000) => foo.freq;
    250::ms => now;
}





