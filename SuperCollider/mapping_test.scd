(
SynthDef( \checkMap,{ arg
	out=0, freq=100, rate=10, amp=0.4, dur=1,
	ampmin=0.01, ampmax=10, ampInMin=0.01, ampInMax=1,
	rateInMin=0.2, rateInMax=8, ratemin=0.5, ratemax=20,
	freqInMin=0.2, freqInMax=8, freqOutMin=50, freqOutMax=200, freqRatio = 1,
	endGate=1, spAmp=1;
	var inAmp = LFSaw.kr( \rampRate.kr(1) ).range( ampInMin, ampInMax );
	var amplitude = LinExp.kr( inAmp, ampInMin, ampInMax, ampmin, ampmax );
	SendReply.kr( Impulse.kr( 20 ), '/amps', [inAmp, amplitude] );
	Out.ar( out, SinOsc.ar( 500 )*amplitude );
}).send(s);
);

a = Synth.new( \checkMap )

OSCdef( \ampWatch, { |msg| msg.postln; }, '/amps' );

a.set( \rampRate, 0.5, \ampmin, 0.01, \ampmax, 1, \ampInMin, 0.1, \ampInMax, 1 );

a.free;

// use Shaper.kr to shape the mapping
