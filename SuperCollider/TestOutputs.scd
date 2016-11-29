(
Server.default = s = Server("belaServer", NetAddr("192.168.7.2", 57110));
//s.initTree;
s.options.maxLogins = 5;
s.clientID =1;
s.startAliveThread;
);


(
SynthDef("AOut",{ arg out=0, freq=100, rate=10, dur=0.1, amp=0.4;
	Out.ar( out, SinOsc.ar( freq, 0, amp*EnvGen.kr( Env.perc, Impulse.kr(rate), timeScale: dur ) ) );
}).send(s);
);

s.sync;
a = Synth.new("AOut", [\out,4], target: s).postln;

a.set( \rate, 20, \amp, 1, \out, 7) // sternum
a.set( \rate, 20, \amp, 1, \out, 4) // top back
a.set( \rate, 20, \amp, 1, \out, 6) // left shoulder
a.set( \rate, 20, \amp, 1, \out, 5) // right shoulder
a.set( \rate, 20, \amp, 1, \out, 2) // left hip
a.set( \rate, 20, \amp, 1, \out, 3) // right hip

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