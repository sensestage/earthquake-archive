(
Server.default = s = Server("belaServer", NetAddr("192.168.7.2", 57110));
//s.initTree;
s.options.maxLogins = 5;
s.clientID = 1;
s.startAliveThread;
);


~basefilepath = "/home/nescivi/Documents/Projects/Earthquakes/fdsn2wavplot/data/";

~quakes = (~basefilepath +/+ "*" ).pathMatch;

~basefilepathRemote = "/root/Earthquakes/data/";

~quakes[0].replace( ~basefilepath, ~basefilepathRemote )

~quakewaves = (~quakes[0] +/+ "wav_eqsize/*.wav").pathMatch;

~quakewavesRemote = ~quakewaves.collect{ |it| it.replace( ~basefilepath, ~basefilepathRemote ) };

~quakebuffers = ~quakewavesRemote.collect{ |fn| Buffer.read( s, fn ) };

~quakebuffers.size;

~quakePeaks[0]

(
SynthDef( \waveplayer, { |out=0, outcontrol=0, buf=0, amp=1, id=0, loop=0, t_trig=1, rate=1|
	var signal, amptrack;
	signal = PlayBuf.ar( 1, buf, BufRateScale.kr(buf)*rate, t_trig, loop: loop );
	amptrack = Amplitude.kr( signal );
	Out.kr( outcontrol, amptrack );
	// SendReply.kr( Impulse.kr(20), '/quake/amplitude', amptrack, id);
	Out.ar( out, signal*amp );
}).send(s);
);

~quakeSynths = ~quakebuffers.collect{ |it,i| Synth.new( \waveplayer, [ \out, 2, \buf, it, \loop, 1 ] ); };
~quakeSynths.do{ |it,i| it.set( \outcontrol, i ); };

~quakeSynths[0].set( \out, 7 ); // max

~quakeSynths[1].set( \out, 5 ); // 4th
~quakeSynths[2].set( \out, 4 ); // 2nd
~quakeSynths[3].set( \out, 6 ); // 3rd

~quakeSynths[4].set( \out, 2 ); // 5th
~quakeSynths[5].set( \out, 3 ); // 6th


~ampSpec = [0.01, 1, -10].asSpec;

~ampSpec.map( [ 1, 0.055505599826574, 0.25060629844666, 0.16046759486198, 0.055096868425608, 0.039428867399693, 0.035859286785126 ] ).plot



(
SynthDef("ModSine",{ arg out=0, freq=100, dfreq=5, rate=10, dur=0.1, amp=0, t_trig=1;
	var ampShaped = [0.01, 1, -10].asSpec.map( amp );
	var freqs = Array.fill( 10, TRand.kr( 0, dfreq, t_trig ) );
	Out.ar( out, SinOsc.ar( freq + freqs, 0, ampShaped/10 ).sum );
}).send(s);
);

~modSines = [7,4,6,5,2,3].collect{ |it,i| Synth.new( \ModSine, [ \out, it ] ) };

~modSines.do{ |it,i| it.free; };

~modSines.do{ |it,i| it.map( \amp, i ) };

~modSines.do{ |it,i| it.set( \freq, 5 ) };
~modSines.do{ |it,i| it.set( \dfreq, 3, \t_trig,1 ) };

~quakeSynths.do{ |it,i| it.set( \rate, 0.5 ); };

~quakeSynths.do{ |it,i| it.set( \amp, 0 ); };


s.sendMsg( "/g_dumpTree", 0, 1 );




~quakePeaks[0]

~quakeSynths.do{ |it| it.set( \rate, 0.5 ); };


~quakeSynths.do{ |it| it.free; };


~quakePeaks.do{ |it| it.postln; };


(
SynthDef( \waveplayer6, { |out=0, buf=0, amp=1, id=0, loop=0, t_trig=1, pos=0, rate=1,startPos=0|
	var signal, amptrack;
	signal = PlayBuf.ar( 1, buf, BufRateScale.kr(buf)*rate, t_trig, startPos, loop );
	signal = PanAz.ar( 6, signal*amp, pos );
	\outchannels.kr( [7,4,6,5,2,3] );
	6.do{ |i|
		Out.ar( \outchannels.kr.at( i ), signal.at( i ) );
	};
}).send(s);
);

~quakeSynths = ~quakebuffers.collect{ |it,i| Synth.new( \waveplayer6, [ \out, 2, \buf, it, \loop, 1, \pos, i*2/(~quakebuffers.size) - 1 ] ); };
~quakeSynths2 = ~quakebuffers.collect{ |it,i| Synth.new( \waveplayer6, [ \out, 2, \buf, it, \loop, 1, \pos, i*2/(~quakebuffers.size) - 1 ] ); };

~quakebuffers

~quakeSynths2.do{ |it| it.set( \amp, 2, \rate, 0.5, \out, 2 ); }
~quakeSynths.do{ |it| it.set( \amp, 2, \rate, 0.5, \out, 2 ); }
s.freeAll;

~quakeSynths.do{ |it,i| it.set( \pos, (i+3*2/(~quakebuffers.size) - 1).wrap(-1,1) ); }

s.sendMsg( "/g_dumpTree", 0, 1 );

s.freeAll;