(
Server.default = s = Server("belaServer", NetAddr("192.168.7.2", 57110));
//s.initTree;
s.options.maxLogins = 5;
s.clientID =1;
s.startAliveThread;
);


~basefilepath = "/home/nescivi/Documents/Projects/Earthquakes/fdsn2wavplot/data/";

~quakes = (~basefilepath +/+ "*" ).pathMatch;

~basefilepathRemote = "/root/Earthquakes/data/";

~quakes[0].replace( ~basefilepath, ~basefilepathRemote )

~quakewaves = (~quakes[0] +/+ "wav_eqsize/*.wav").pathMatch;

~quakewavesRemote = ~quakewaves.collect{ |it| it.replace( ~basefilepath, ~basefilepathRemote ) };

~quakebuffers = ~quakewavesRemote.collect{ |fn| Buffer.read( s, fn ) };


(
SynthDef( \waveplayer6, { |out=0, buf=0, amp=1, id=0, loop=0, t_trig=1, pos=0|
	var signal, amptrack;
	signal = PlayBuf.ar( 1, buf, BufRateScale.kr(buf), t_trig, loop: loop );
	Out.ar( out, PanAz.ar( 6, signal*amp, pos ) );
}).send(s);
);

~quakebuffers.do{ |it,i| Synth.new( \waveplayer6, [ \out, 0, \buf, it, \loop, 1, \pos, i*2/(~quakebuffers.size) - 1 ] ); };

s.freeAll;