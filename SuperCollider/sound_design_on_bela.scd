(
Server.default = s = Server("belaServer", NetAddr("192.168.7.2", 57110));
//s.initTree;
s.options.maxLogins = 5;
s.clientID = 1;
s.startAliveThread;
);


// ~basefilepath = "/home/nescivi/git/projects/earthquakes/earthquake-archive/Python/Test-Data/";

~basefilepathRemote = "/root/Earthquakes/quakedata/";

(
~quakes[0].stationInfo.do{ |stat|
	if ( stat.waves.size > 0 ){
		stat.loadBuffers( s, ~basefilepath, ~basefilepathRemote );
		stat.loadPitchBuffers( s, ~basefilepath, ~basefilepathRemote );
	};
};
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


~stationInfo = ~quakes[0].stationInfo.at( ~quakes[0].stationsSortedByDistance[2] );

~stationInfo.play( s, 7, \waveplayer, \pulseenv );

~stationInfo.waveSynths.do{ |it| it.set( \rate, 10, \t_trig, 1 ) };
~stationInfo.soundSynths.do{ |it| it.set( \ampInMin, 0.01, \ampInMax, 0.2, \ampmax, 10, \ampmin, 0.1, \freqInMax, 4,  \freqOutMin, 100, \freqOutMax, 200 ); };


a = Synth.new( \waveplayer, [\buf, ~stationInfo.buffers[0], \pitchBuf, ~stationInfo.pitchBuffers[0] ] );
a.set( \buf, ~stationInfo.buffers[1], \pitchBuf, ~stationInfo.pitchBuffers[1] );
a.set( \buf, ~stationInfo.buffers[2], \pitchBuf, ~stationInfo.pitchBuffers[2] );

a.set(\rate,10, \t_trig, 1, \loop, 0);

~stationInfo.buffers.size

~ampBus = Bus.control(s,1);
~pitchBus = Bus.control(s,1);
a.set( \ampOut, ~ampBus )
a.set( \pitchOut, ~pitchBus )

b.free;
b = Synth.new( \pulseenv, [ \freq, 100, \out, 7, \amp, ~ampBus.asMap ] );
b.map( \amp, ~ampBus );
b.map( \rate, ~pitchBus );
b.map( \freq, ~pitchBus );
b.set( \out, 7 );
b.set( \ampInMin, 0.01, \ampInMax, 0.2 );
b.set( \ampmax, 10 );
b.set( \ampmin, 0.1 );
b.set( \freqInMax, 4 );
b.set( \freqOutMin, 100 );
b.set( \freqOutMax, 200 );

b.set( \freq, 4 )



b.set( \ratemul, 10 )


s.sendMsg( "/g_dumpTree", 0, 1 );

s.freeAll;