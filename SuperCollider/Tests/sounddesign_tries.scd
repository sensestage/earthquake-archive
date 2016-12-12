s.boot;

// ~quakes[0].stationInfo.at( ~quakes[0].stationsSortedByDistance[0] ).loadBuffers;

~stationInfo = ~quakes[0].stationInfo.at( ~quakes[0].stationsSortedByDistance[2] );
(
if ( ~stationInfo.waves.size > 0 ){
	~stationInfo.loadBuffers;
	~stationInfo.loadPitchBuffers;
};
);

~stationInfo.waves

~stationInfo.buffers;
~stationInfo.pitchBuffers;

// ~stationInfo.freeBuffers;

s.scope(1);

(
SynthDef( \waveplayer, { |out=0, ampOut=0, pitchOut=0, buf=0, amp=1, id=0, loop=0, t_trig=1, rate=1, pitchBuf=0|
	var signal, amptrack, track;
	var pitchSignal;
	pitchSignal = PlayBuf.ar( 1, pitchBuf, BufRateScale.kr(pitchBuf)*rate, t_trig, loop: loop );
	signal = PlayBuf.ar( 1, buf, BufRateScale.kr(buf)*rate, t_trig, loop: loop );
	track = 1 - Done.kr( signal );
	amptrack = Amplitude.kr( signal );
	amptrack = Gate.kr( amptrack * track, track );
	Out.kr( ampOut, amptrack );
	Out.kr( pitchOut, pitchSignal );
}).send(s);
);

a.free;
a = Synth.new( \waveplayer, [\buf, ~stationInfo.buffers[0], \pitchBuf, ~stationInfo.pitchBuffers[0] ] );


~stationInfo.buffers[0].plot
~stationInfo.pitchBuffers[0].plot
~stationInfo.pitchTraceWaveFiles
~stationInfo.pitchTraces[0].rawTrace
~quakes[0].pitchWaveFiles
(~quakes[0].basePath +/+ "wav_pitchtrace/*.wav.pitch").pathMatch;

(
SynthDef("pulseenv",{ arg out=0, freq=100, rate=10, dur=0.1, amp=0.4, ampmul=10, ratemul=1;
	Out.ar( out, SinOsc.ar( freq, 0, amp*ampmul*EnvGen.kr( Env.perc, Impulse.kr(rate.poll*ratemul), timeScale: dur ) ) );
}).send(s);
);

b = Synth.new( \pulseenv, [ \freq, 100, \rate, 10, \amp, 0.1 ] );

b.free;

c = Bus.control(s,1);
d = Bus.control(s,1);
a.set( \ampOut, c )
a.set( \pitchOut, d )

a.set(\rate,10, \t_trig, 1);

b.map( \amp, c );
b.map( \rate, d );

b.set( \ratemul, 10 )
b.set( \ampmul, 5 )


(
SynthDef("ModSine",{ arg out=0, freq=100, dfreq=5, rate=10, dur=0.1, amp=0, t_trig=1;
	var ampShaped = [0.01, 1, -10].asSpec.map( amp );
	var freqs = Array.fill( 10, TRand.kr( 0, dfreq, t_trig ) );
	Out.ar( out, SinOsc.ar( freq + freqs, 0, ampShaped/10 ).sum );
}).send(s);
);

(
SynthDef( \modSines4,{ arg out=0, freq=100, dfreq=5, rate=10, dur=0.1, t_trig=1;
	var ampShaped = [0.01, 1, -10].asSpec.map( \amps.kr( [0,0,0,0] ) );
	var freqs = Array.fill( 4, TRand.kr( 0, dfreq, t_trig ) );
	Out.ar( out, SinOsc.ar( freq + freqs, 0, ampShaped/4 ).sum );
}).send(s);
);

(
SynthDef( \modPulses4,{ arg out=0, freq=100, dfreq=5, t_trig=1;
	var ampShaped = [0.01, 1, -10].asSpec.map( \amps.kr( [0,0,0,0] ) );
	var freqs = Array.fill( 4, TRand.kr( 0, dfreq, t_trig ) );
	Out.ar( out,
		LPF.ar(
			Pulse.ar( freq + freqs, 0.5, ampShaped/4 ).sum,
			\lfreq.kr(200)
		)
	);
}).send(s);
);

b = Synth.new( \modSines4 );
b.free
b = Synth.new( \modPulses4, [\dfreq, 20] );

c = Bus.control(s,4);

a.free;
b.free;

a = ~stationInfo.buffers.collect{ |it,i| Synth.new( \waveplayer, [\buf, it, \outcontrol, c.index + i, \id, i, \rate, 2 ] ) };

a.do{ |it| it.set( \out, 3) };

a.do{ |it| it.free; };

OSCdef( \pitch, { |msg| if ( msg[2] == 0 ){ ~sig.addValue( msg[3] ) } }, '/pitchAmp' );

OSCdef( \pitch, { |msg| if ( msg[2] == 0 ){ ~sig.addValue( msg[3] ); b.set( \freq, msg[3]*20 ); } }, '/pitchAmp' );

~signals
~sig = SignalCharacteristics.new( 500 );
~sigGui = SignalCharacteristicsGui.new( ~sig );


SynthDef( \sine, { Out.ar( 1, SinOsc.ar( \freq.kr(300), 0, \amp.kr(0.1) ) ) }).add;

b = Synth.new( \sine );
b.set( \freq, 500 );
b.free


OSCdef( \pitch, { |msg| if ( msg[2] == 0 ){ ~sig.addValue( msg[3] ) } }, '/pitchAmp' );




a.do{ |it| it.set( \t_trig, 1, \rate, 1 ); };

b.map( \amps, c );
b.set( \t_trig, 1 );

s.freqscope



Synth.new( \waveplayer, [\buf, ~quakes[0].stationInfo.at( ~quakes[0].stationsSortedByDistance[0] ).buffers[0] ] );


s.boot;

~quakes[0].stationInfo.at( ~quakes[0].stationsSortedByDistance[0] ).pitchTraces[0].func = { |val| val.postln; };
~quakes[0].stationInfo.at( ~quakes[0].stationsSortedByDistance[0] ).pitchTraces[0].createPlayer;

~quakes[0].stationInfo.at( ~quakes[0].stationsSortedByDistance[0] ).pitchTraces[0].func.value( 0.1 )

~quakes[0].stationInfo.at( ~quakes[0].stationsSortedByDistance[0] ).pitchTraces[0].play;
~quakes[0].stationInfo.at( ~quakes[0].stationsSortedByDistance[0] ).pitchTraces[0].stop;

	~quakes[0].stationInfo.at( ~quakes[0].stationsSortedByDistance[0] ).pitchTraces[0].func = { |val| val.postln; };

(
SynthDef("pulseenv",{ arg out=0, freq=100, rate=10, dur=0.1, amp=0.4;
	Out.ar( out, SinOsc.ar( freq, 0, amp*EnvGen.kr( Env.perc, Impulse.kr(rate), timeScale: dur ) ) );
}).send(s);
);

a = Synth.new( \pulseenv, [ \freq, 100, \rate, 10, \amp, 0.1 ] );

~quakes[0].stationInfo.at( ~quakes[0].stationsSortedByDistance[0] ).pitchTraces[0].func = { |val| val.postln; a.set( \rate, val*10, \freq, val*200 ) };
