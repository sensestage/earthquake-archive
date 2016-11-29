/*

* earthquakes with different epicentres of magnitude
* measurement data is at each time at different locations

** useful information: coordinates of measurement locations
** files have an offset - should be centered -> fixed
** files have to be normalized -> fixed
** files are not equal length -> fixed


* earthquakes could start at different places on the body, based on the epicentre?

* or should we always follow a centre to outer body approach

*/

s.boot;

~basefilepath = "/home/nescivi/Documents/Projects/Earthquakes/fdsn2wavplot/data/";

~quakes = (~basefilepath +/+ "*" ).pathMatch;

~quakewaves = (~quakes[0] +/+ "wav_eqsize/*.wav").pathMatch;


~quakebuffers.do{ |it| it.free };

~quakebuffers = ~quakewaves.collect{ |fn| Buffer.read( s, fn ) };

(
SynthDef( \waveplayer, { |out=0, buf=0, amp=1, id=0, loop=0, t_trig=1|
	var signal, amptrack;
	signal = PlayBuf.ar( 1, buf, BufRateScale.kr(buf), t_trig, loop: loop );
	// signal = LeakDC.ar( signal );
	// amptrack = Amplitude.kr( signal );
	// SendReply.kr( Impulse.kr(20), '/quake/amplitude', amptrack, id);
	Out.ar( out, signal*amp );
}).add;
);

OSCdef( \amptrack, { |msg| msg.postln; }, '/quake/amplitude' );

OSCdef( \amptrack ).free;

s.freeAll;

(
Tdef( \playQuake, {
	a = Synth.new( \waveplayer, [ \out, 0, \buf, ~quakebuffers[0] ] );
	~quakebuffers.do{ |it|
		it.path.postln;
		a.set( \buf, it, \t_trig, 1 );
		5.0.wait;
	};
	a.free;
}).play;
);


a.free;


s.scope


~quakebuffers.do{ |it,i| Synth.new( \waveplayer, [ \out, i, \buf, it, \loop, 1 ] ); };

s.freeAll;

~quakebuffers.do{ |it,i| Synth.new( \waveplayer2, [ \out, 0, \buf, it, \loop, 1, \pos, i*2/(~quakebuffers.size-1) - 1 ] ); };

~quakebuffers.collect{ |it| it.numFrames }


~quakes.collect{ |it| ( it +/+ "wav_norm/*.wav").pathMatch.size }

~quakes.collect{ |it| ( it +/+ "wav_norm/*.wav").pathMatch.size }
~quakewaves = (~quakes[0] +/+ "wav_norm/*.wav").pathMatch;

(
SynthDef( \waveplayer2, { |out=0, buf=0, amp=1, id=0, loop=0, t_trig=1, pos=0, rate=1|
	var signal, amptrack;
	signal = PlayBuf.ar( 1, buf, BufRateScale.kr(buf) * rate, t_trig, loop: loop );
	Out.ar( out, Pan2.ar( signal*amp, pos ) );
}).add;
)

(
SynthDef( \waveplayer6, { |out=0, buf=0, amp=1, id=0, loop=0, t_trig=1|
	var signal, amptrack;
	signal = PlayBuf.ar( 1, buf, BufRateScale.kr(buf), t_trig, loop: loop );
	Out.ar( out, PanAz.ar( 6, signal*amp, pos ) );
}).add;
)