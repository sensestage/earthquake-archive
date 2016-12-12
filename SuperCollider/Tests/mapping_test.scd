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

s.boot;

b = Buffer.alloc(s, 512, 1, { |buf| buf.chebyMsg([1,0,1,1,0,1])});

(
{
    Shaper.ar(
        b,
        SinOsc.ar(300, 0, Line.kr(0,1,6)),
        0.5
    )
}.scope;
)

b.free;


b = Buffer.alloc(s, 512, 1 );

//size must be power of two plus 1
t = Signal.hanningWindow(512);
a = t.copyRange(1,256);
a.collect{ |it| it**(-2) }.plot
a.plot;

// linear function
t.plot

(
a = Signal.newClear(256);
a.waveFill({ arg x, old, i; sin(x)}, 0, 3pi);
a.waveFill({ arg x, old, i; old * sin(11 * x + 0.3) }, 0, 3pi);
a.waveFill({ arg x, old, i; old * (x % 4) }, 0, 3pi);

a.plot;
)

// t.asWavetableNoWrap will convert it to the official Wavetable format at next power of two size
b.sendCollection(t.asWavetableNoWrap);  // may also use loadCollection here

b.plot
(
SynthDef( \shaperMap,{ arg
	out=0,
	ampmin=0.01, ampmax=10, ampInMin=0, ampInMax=1;
	var inAmp = LFSaw.kr( \rampRate.kr(1) ).range( ampInMin, ampInMax );
	var amplitude = Shaper.kr( \shaperBuf.kr(0), inAmp );
	SendReply.kr( Impulse.kr( 20 ), '/amps', [inAmp, amplitude] );
	Out.ar( out, SinOsc.ar( 500 )*amplitude );
}).send(s);
);
