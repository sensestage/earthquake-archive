(
Server.default = s = Server("belaServer", NetAddr("192.168.7.2", 57110));
//s.initTree;
s.options.maxLogins = 5;
s.clientID =1;
s.startAliveThread;
);


(
SynthDef("AOut",{ arg out=0;
	Out.ar( out, SinOsc.ar( 500, 0, 0.4*EnvGen.kr( Env.perc, Impulse.kr(10), timeScale: 0.1 ) ) );
}).send(s);
);

s.sync;
a = Synth.new("AOut", [\out,4], target: s).postln;
a.free;
b = Synth.new("AOut", [\out,7], target: s).postln;
b.free;

c = Synth.new("AOut", [\out,2], target: s).postln;
c.free;
d = Synth.new("AOut", [\out,3], target: s).postln;
d.free;

e = Synth.new("AOut", [\out,5], target: s).postln;
e.free;
f = Synth.new("AOut", [\out,6], target: s).postln;
f.free;



s.freeAll