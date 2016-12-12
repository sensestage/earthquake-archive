(
SynthDef( \modeSelector, { |out,inbus, nodeid, outbus|
	var toggle;
	var mode = DigitalIn.kr( 0 ); // on bela
	// var mode = In.kr( inbus );
	toggle = ToggleFF.kr( mode );
	Pause.kr( toggle, nodeid );
	SendReply.kr( Changed.kr( mode ), '/changeMode', mode ); // useful for testing
	SendReply.kr( Changed.kr( toggle ), '/toggleMode', toggle ); // use for earthquake playing
	Out.kr( outbus, Delay1.kr( Changed.kr( toggle ) ) );
}).send(s);
);

(
SynthDef( \testSignal,{ arg freq=100, rate=10, stepRate=0.5, dur=0.1, amp=0.5, doneAction = 1, resetbus=0;
	var stepTrigger = Impulse.kr( stepRate );
	//var endCount = PulseCount.kr( stepTrigger );
	var trigger = Impulse.kr(rate);
	var signal = SinOsc.ar( freq, 0, amp*EnvGen.kr( Env.perc, trigger, timeScale: dur ) );
	var outputStepper = Stepper.kr( stepTrigger, In.kr( resetbus ), 2, 7 ); // loops
	//var gate = BinaryOpUGen( '<', endCount, 30 );
	//var env = EnvGen.kr( Env.cutoff, gate, doneAction: doneAction );
	Out.ar( outputStepper, signal );
}).send(s);
);

(
SynthDef( \testSignal2,{ arg freq=100, rate=5, out=2, dur=0.1, amp=0.5, doneAction = 1, resetbus=0;
	// var stepTrigger = Impulse.kr( stepRate );
	//var endCount = PulseCount.kr( stepTrigger );
	var trigger = Impulse.kr(rate);
	var signal = SinOsc.ar( freq, 0, amp*EnvGen.kr( Env.perc, trigger, timeScale: dur ) );
	Out.ar( out, signal );
}).send(s);
);

/*
(
SynthDef( \quakeSelector, { |out|
	var quake = DigitalIn.kr( [2, 3, 4, 5], [1,2,4,8] ).sum; // on bela
	SendReply.kr( Changed.kr( quake ), '/changeQuake', quake );
}).send(s);
);
*/

(
SynthDef( \quakeSelector, { |maxTime=5|
	// var quake = DigitalIn.kr( [2, 3, 4, 5], [1,2,4,8] ).sum.poll(1); // on bela
	var quake = DigitalIn.kr( [2, 3, 4, 5], [1,2,4,8] ).sum; // on bela
	var timeSinceChange = Sweep.kr( Changed.kr( quake ), 1 );
	var trigSelect = BinaryOpUGen( '>', timeSinceChange, maxTime );
	SendReply.kr( trigSelect, '/changeQuake', quake );
}).send(s);
);

(
SynthDef( \waveplayer, { |ampOut=0, buf=0, pitchOut=0, pitchBuf=0, loop=0, t_trig=1, rate=1, doneOut=0 |
	var signal, amptrack, track;
	var pitchSignal, pitchTrack, done;
	pitchSignal = PlayBuf.ar( 1, pitchBuf, BufRateScale.kr(pitchBuf)*rate, t_trig, loop: loop );
	signal = PlayBuf.ar( 1, buf, BufRateScale.kr(buf)*rate, t_trig, loop: loop );
	done = Done.kr( signal );
	track = 1 - done;
	amptrack = Amplitude.kr( signal, \attack.kr(0.01), \release.kr(0.01) );
	// amptrack = Gate.kr( amptrack * track, track );
	// pitchTrack = Gate.kr( pitchSignal, track );
	FreeSelf.kr( DelayN.kr( done, 3, 3 ) );
	Out.kr( doneOut, track );
	Out.kr( ampOut, amptrack );
	Out.kr( pitchOut, pitchSignal );
}).send(s);
);

(
SynthDef( \waveplayerAmp, { |
	ampOut=0, buf=0, pitchOut=0, pitchBuf=0, ampBuf=0,
	loop=0, t_trig=1, rate=1, doneOut=0,
	srcAmpLo=0.05, srcAmpHi=1, dstRateLo=1, dstRateHi=10,
	ampRate=0 |
	var ampSignal, amptrack, track;
	var pitchSignal, pitchTrack, done;
	var ampRateMap = LinExp.kr( (1- ampRate).max(0), srcAmpLo, srcAmpHi, dstRateLo, dstRateHi );

	var phasor1 = Phasor.ar( 0, BufRateScale.kr(ampBuf) * ampRateMap * rate, 0, BufFrames.kr( ampBuf ) );
	// var phasor2 = Phasor.ar( 0, BufRateScale.kr(pitchBuf) * ampRateMap * rate, 0, BufFrames.kr( pitchBuf ) ).poll(5);
	var frameRatio = BufFrames.ir( pitchBuf ) / BufFrames.ir( ampBuf );
	pitchSignal = BufRd.ar( 1, pitchBuf, phasor1 * frameRatio, loop );
	ampSignal = BufRd.ar( 1, ampBuf, phasor1, loop ) / 2; // there was factor 4 instead of 2 in the analysis...
	done = BinaryOpUGen( '>', phasor1, BufFrames.kr( ampBuf ) - 1000);
	FreeSelf.kr( DelayN.kr( done, 3, 3 ) );
	Out.kr( doneOut, 1-done );
	Out.kr( ampOut, ampSignal );
	Out.kr( pitchOut, pitchSignal );
}).send(s);
);

(
SynthDef( \pulseenv,{ arg
	out=0, amp=0.4, pitch=1, dur=1, endGate=1, spAmp=1,
	ampmin=0.01, ampmax=10, ampInMin=0.01, ampInMax=1,
	rateInMin=0.2, rateInMax=8, ratemin=0.5, ratemax=20,
	freqInMin=0.2, freqInMax=8, freqOutMin=50, freqOutMax=200, freqRatio = 1;

	var amplitude = LinExp.kr( amp, ampInMin, ampInMax, ampmin, ampmax );
	var impulseRate = LinExp.kr( pitch, rateInMin, rateInMax, ratemin, ratemax );
	var frequency = LinExp.kr( pitch, freqInMin, freqInMax, freqOutMin, freqOutMax );
	var duration = dur / impulseRate;
	Out.ar( out,
		(
			SinOsc.ar( frequency * freqRatio) *
			amplitude * EnvGen.kr( Env.perc, Impulse.kr(impulseRate), timeScale: duration )
			* spAmp
		).tanh * 0.95 * EnvGen.kr( Env.cutoff(1), endGate, doneAction: 2 )
	);
}).send(s);
);

(
SynthDef( \pulseenv2,{ arg
	out=0, amp=0.4, dur=1, pitch=10,
	ampmin=0.01, ampmax=10, ampInMin=0.01, ampInMax=1,
	rateInMin=0.2, rateInMax=8, ratemin=0.5, ratemax=20,
	freqInMin=0.2, freqInMax=8, freqOutMin=50, freqOutMax=200, freqRatio = 1,
	endGate=1, spAmp=1;
	var amplitude = LinExp.kr( amp, ampInMin, ampInMax, ampmin, ampmax );
	var impulseRate = LinExp.kr( pitch, rateInMin, rateInMax, ratemin, ratemax );
	var frequency = LinExp.kr( pitch, freqInMin, freqInMax, freqOutMin, freqOutMax );
	var duration = dur / impulseRate;
	Out.ar( out,
		(
			SinOsc.ar( frequency * freqRatio) *
			amplitude * EnvGen.kr( Env.perc, Impulse.kr(impulseRate), timeScale: duration )
			* spAmp
		).tanh * 0.95 * EnvGen.kr( Env.cutoff(1), endGate, doneAction: 2 )
	);
}).send(s);
);

(
// Using a more flexible frequency & amplitude modulated sinewave
SynthDef('sinmod', {arg out=2,
	atk=0.01, rel=1.0,
	lfo_hz_st=1, lfo_hz_end=10, mod_hz_st=50, mod_hz_end=1000, low_hz=50, hi_hz=1000,
	dur=1, amp=1.0, pitch=1,
	ampOutMin=0.001, ampOutMax=1, ampInMin=0.01, ampInMax=1,
	pitchInMin=0.2, pitchInMax=8,
	endGate=1, spAmp=1;

	var sig, fmod, lfo;

	var amplitude = LinExp.kr( amp, ampInMin, ampInMax, ampOutMin, ampOutMax );
	var pitchF = LinLin.kr( pitch, pitchInMin, pitchInMax, 0, 1 );

	fmod = SinOsc.ar( pitchF.range( mod_hz_st, mod_hz_end ) ).range(low_hz, hi_hz);  // Line.ar(mod_hz_st, mod_hz_end, dur)
	lfo = SinOsc.ar( pitchF.range( lfo_hz_st, lfo_hz_end) ); // Line.ar(lfo_hz_st, lfo_hz_end, dur));
	sig = SinOsc.ar(fmod) * lfo;
	// env = EnvGen.ar(Env.linen(atk, 1, rel, curve: -4), timeScale: dur, doneAction: 2);
	FreeSelf.kr( 1 - endGate );
	Out.ar(out, sig * amplitude * amp * spAmp * 0.95 * EnvGen.kr( Env.cutoff(1), endGate.poll(5), doneAction: 2 ) );
}).send(s);
);