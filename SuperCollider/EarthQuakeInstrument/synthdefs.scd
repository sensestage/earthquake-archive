(
SynthDef( \modeSelector, { |out,inbus, nodeid, outbus|
	var toggle;
	var mode = DigitalIn.kr( 0 ); // on bela
	// var mode = In.kr( inbus );
	toggle = ToggleFF.kr( mode );
	Pause.kr( toggle, nodeid );
	SendReply.kr( Changed.kr( mode ), '/changeMode', mode ); // useful for testing
	SendReply.kr( Changed.kr( mode ), '/toggleMode', toggle ); // use for earthquake playing
	Out.kr( outbus, Delay1.kr( Changed.kr( toggle ) ) );
}).send(s);
);

(
SynthDef( \testSignal,{ arg freq=100, rate=10, stepRate=0.5, dur=0.1, amp=0.5, doneAction = 1, resetbus=0;
	var stepTrigger = Impulse.kr( stepRate );
	var endCount = PulseCount.kr( stepTrigger );
	var trigger = Impulse.kr(rate);
	var signal = SinOsc.ar( freq, 0, amp*EnvGen.kr( Env.perc, trigger, timeScale: dur ) );
	var outputStepper = Stepper.kr( stepTrigger, In.kr( resetbus ), 2, 7 ); // loops
	var gate = BinaryOpUGen( '<', endCount, 30 );
	var env = EnvGen.kr( Env.cutoff, gate, doneAction: doneAction );
	Out.ar( outputStepper, signal*env );
}).send(s);
);

(
SynthDef( \quakeSelector, { |out,inbus|
	var quake = DigitalIn.kr( [2, 3, 4, 5], [1,2,4,8] ).sum.poll(1); // on bela
	SendReply.kr( Changed.kr( quake ), '/changeQuake', quake );
}).send(s);
);

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

(
SynthDef( \pulseenv,{ arg out=0, freq=100, rate=10, dur=0.1, amp=0.4, ampmin=0.01, ampmax=10, ampInMin=0.01, ampInMax=1, ratemin=0.5, ratemax=20, freqInMax=8,  freqOutMin=50, freqOutMax=200, freqRatio = 1;
	var amplitude = LinExp.kr( amp.poll(1), ampInMin, ampInMax, ampmin, ampmax );
	var impulseRate = LinExp.kr( rate.poll(1), 0.2, 8, ratemin, ratemax );
	var frequency = LinExp.kr( freq, 0.2, freqInMax, freqOutMin, freqOutMax );
	var duration = 1 / impulseRate;
	Out.ar( out, SinOsc.ar( frequency * freqRatio, 0, amplitude*EnvGen.kr( Env.perc, Impulse.kr(impulseRate), timeScale: duration ) ).tanh *0.95 );
}).send(s);
);

