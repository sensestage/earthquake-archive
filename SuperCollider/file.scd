(
SynthDef("AOut",{ arg out=0, freq=100, rate=10, dur=0.1, amp=0.4;
	Out.ar( out, SinOsc.ar( freq, 0, amp*EnvGen.kr( Env.perc, Impulse.kr(rate), timeScale: dur ) ) );
}).send(s);
)


0.000000 0.
120/64
64/120
/0.533333
0.246160
