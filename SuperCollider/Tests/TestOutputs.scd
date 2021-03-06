(
Server.default = s = Server("belaServer", NetAddr("192.168.7.2", 57110));
//s.initTree;
s.options.maxLogins = 5;
s.clientID =1;
s.startAliveThread;
);

m =  NetAddr("192.168.7.2", 57110);
m.sendMsg( "/g_dumpTree", 0, 1 );
m.sendMsg( "n_free", 1002 );

n =  NetAddr("192.168.7.2", 57120);
n.sendMsg( '/changeQuake', 1002, -1, 0 );
n.sendMsg( '/changeQuake', 1002, -1, 1 );
n.sendMsg( '/changeQuake', 1002, -1, 2 );
n.sendMsg( '/changeQuake', 1002, -1, 3 );
n.sendMsg( '/changeQuake', 1002, -1, 4 );
n.sendMsg( '/changeQuake', 1002, -1, 5 );
n.sendMsg( '/changeQuake', 1002, -1, 6 );
n.sendMsg( '/changeQuake', 1002, -1, 7 );
n.sendMsg( '/changeQuake', 1002, -1, 8 );
n.sendMsg( '/changeQuake', 1002, -1, 9 );
n.sendMsg( '/changeQuake', 1002, -1, 10 );
n.sendMsg( '/changeQuake', 1002, -1, 11 );
n.sendMsg( '/changeQuake', 1002, -1, 12 );
n.sendMsg( '/changeQuake', 1002, -1, 13 );


(
SynthDef("AOut",{ arg out=0, freq=100, rate=10, dur=0.1, amp=0.4;
	Out.ar( out, SinOsc.ar( freq, 0, amp*EnvGen.kr( Env.perc, Impulse.kr(rate), timeScale: dur ) ) );
}).send(s);
);

s.sync;
a = Synth.new("AOut", [\out,4], target: s).postln;

[7,4,6,5,2,3]

a.set( \rate, 10, \amp, 1, \out, 7) // sternum
a.set( \rate, 10, \amp, 1, \out, 4) // top back
a.set( \rate, 10, \amp, 1, \out, 6) // left shoulder -> right shoulder (2)
a.set( \rate, 10, \amp, 1, \out, 5) // right shoulder -> left shoulder (2)
a.set( \rate, 10, \amp, 1, \out, 2) // left hip
a.set( \rate, 10, \amp, 1, \out, 3) // right hip

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