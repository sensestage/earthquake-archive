// This file replicates the functionality of _main.scd for controlling the Bela SC server remotely.

( // remote belaserver
Server.default = s = Server("belaServer", NetAddr("192.168.7.2", 57110));
//s.initTree;
s.options.maxLogins = 5;
s.clientID = 1;
s.startAliveThread;
);


/*
Channels
2 - belly left
3 - belly right
4 - neck
5 - collar left
6 - collar right
7 - sternum


*/

SynthDef('sin', {arg st_hz=50, end_hz=1000, dur=1, outch=2, amp=1.0;
	var sig, env;
	sig = SinOsc.ar(Line.ar(st_hz, end_hz, dur));
	env = EnvGen.ar(Env.perc(0.01, 1), timeScale: dur, doneAction: 2);
	Out.ar(outch, sig * env * amp);
}).send(s);

(
~gest = [
	['delta', 0.1, 'st_hz', 100, 'end_hz', 80, 'dur', 0.4, 'outch', 2],
	['delta', 0.1, 'st_hz', 100, 'end_hz', 80, 'dur', 0.4, 'outch', 3],
	['delta', 0.1, 'st_hz', 60, 'end_hz', 90, 'dur', 1.3, 'outch', 4],
	['delta', 0.1, 'st_hz', 60, 'end_hz', 90, 'dur', 0.5, 'outch', 5],
	['delta', 0.1, 'st_hz', 60, 'end_hz', 80, 'dur', 0.5, 'outch', 6],
	['delta', 0.1, 'st_hz', 60, 'end_hz', 100, 'dur', 0.6, 'outch', 7],
	['delta', 0.1, 'st_hz', 60, 'end_hz', 90, 'dur', 0.5, 'outch', 5],
	['delta', 0.01, 'st_hz', 60, 'end_hz', 80, 'dur', 0.5, 'outch', 6],
	['delta', 0.1, 'st_hz', 60, 'end_hz', 90, 'dur', 1.5, 'outch', 5],
	['delta', 0.01, 'st_hz', 60, 'end_hz', 80, 'dur', 1.5, 'outch', 6],
];

~sin = {
	var step;
	~gest.do {arg vals, i;
		Synth('sin', vals);
		vals[1].yield;
	};
}.fork;
);




// Using a more flexible frequency & amplitude modulated sinewave
SynthDef('sinmod', {arg atk=0.01, rel=1.0, lfo_hz_st=1, lfo_hz_end=10, mod_hz_st=50, mod_hz_end=1000, low_hz=50, hi_hz=1000,
	dur=1, outch=2, amp=1.0;
	var sig, env, fmod, lfo;
	fmod = SinOsc.ar(Line.ar(mod_hz_st, mod_hz_end, dur)).range(low_hz, hi_hz);
	lfo = SinOsc.ar(Line.ar(lfo_hz_st, lfo_hz_end, dur));
	sig = SinOsc.ar(fmod) * lfo;
	env = EnvGen.ar(Env.linen(atk, 1, rel, curve: -4), timeScale: dur, doneAction: 2);
	Out.ar(outch, sig * env * amp);
}).send(s);


(
~gest = [
	['delta', 0.1, 'lfo_hz_st', 100, 'lfo_hz_end', 2, 'atk', 0.1, 'mod_hz_st', 1, 'mod_hz_end', 20, 'low_hz', 60,'hi_hz', 100,'dur', 1.4, 'outch', 2],
	['delta', 0.1, 'atk', 0.2, 'rel', 2.0, 'mod_hz_st', 10, 'mod_hz_end', 4, 'low_hz', 50,'hi_hz', 100,'dur', 2.4, 'outch', 3],
	['delta', 0.1, 'mod_hz_st', 2, 'mod_hz_end', 38, 'low_hz', 50,'hi_hz', 90,'dur', 0.5, 'outch', 5],
	['delta', 0.1, 'mod_hz_st', 10, 'mod_hz_end', 3, 'low_hz', 50,'hi_hz', 100,'dur', 0.5, 'outch', 7],
	['delta', 0.1, 'mod_hz_st', 1, 'mod_hz_end', 8, 'low_hz', 50,'hi_hz', 80,'dur', 0.5, 'outch', 6],
	['delta', 0.1, 'lfo_hz_st', 0.3, 'rel', 0.1, 'mod_hz_st', 1, 'mod_hz_end', 20, 'low_hz', 30,'hi_hz', 100,'dur', 4.4, 'outch', 4],
];


~sin = {
	var step;
	~gest.do {arg vals, i;
		Synth('sinmod', vals);
		vals[1].yield;
	};
}.fork;
);





(
~pat = [
	['delta', 0.1, 'atk', 0.1, 'mod_hz_st', 10, 'mod_hz_end', 8, 'low_hz', 50,'hi_hz', 100,'dur', 1.4, 'outch', 2],
	['delta', 0.1, 'atk', 0.2, 'rel', 2.0, 'mod_hz_st', 10, 'mod_hz_end', 8, 'low_hz', 50,'hi_hz', 100,'dur', 2.4, 'outch', 3],
	['delta', 0.1, 'mod_hz_st', 3, 'mod_hz_end', 8, 'low_hz', 50,'hi_hz', 90,'dur', 0.5, 'outch', 5],
	['delta', 0.1, 'mod_hz_st', 1, 'mod_hz_end', 8, 'low_hz', 50,'hi_hz', 100,'dur', 0.5, 'outch', 7],
	['delta', 0.1, 'mod_hz_st', 1, 'mod_hz_end', 8, 'low_hz', 50,'hi_hz', 80,'dur', 0.5, 'outch', 6],
	['delta', 0.1, 'rel', 0.1, 'mod_hz_st', 10, 'mod_hz_end', 2, 'low_hz', 50,'hi_hz', 100,'dur', 2.4, 'outch', 4],
];


~sin = {
	var step;
	~pat.do {arg vals, i;
		Synth('sinmod', vals);
		vals[1].yield;
	};
}.fork;
);












// load other files from _main.scd

// Make sure to set these appropriately so that both the Bela & the local machine can load the test data
~basefilepath = "../../Python/Test-Data/".resolveRelative;
~basefilepathRemote = "/root/earthquakes/Python/Test-Data/";

// This creates all the buffers and synths needed to play back the channels. And deals with the problem when
// there are not 6 stations for a given earthquake (in which case, multiple channels per stations are used)
~quakePlayers = IdentityDictionary.new;
(// prepare channel players
Task({
	~quakes.do{ |jt,j|
		var nStations = jt.stationInfo.size;
		~quakePlayers.put( j, List.new );
		jt.stationsSortedByDistance.do{ |it,i|
			var sortedAmp = jt.stationInfo.at( it ).waveAmplitudes.order({arg a, b; a[1] <= b[1] });

			if ( nStations == 4 ){
				if ( i<2 ){
					// first two of sortedAmp
					sortedAmp.at([0,1]).do{ |k|
						// k.postln;
						jt.stationInfo.at( it ).createChannelPlayer( k );
						jt.stationInfo.at( it ).prepChannelPlayer( k, s, ~basefilepath, ~basefilepathRemote ); // basepath, remotepath
						~quakePlayers.at( j ).add(
							jt.stationInfo.at( it ).channelPlayers.at( k );
						);
						0.1.wait;
					};
				}{
					jt.stationInfo.at( it ).createChannelPlayer( sortedAmp.first );
					jt.stationInfo.at( it ).prepChannelPlayer( sortedAmp.first, s,  ~basefilepath, ~basefilepathRemote ); // basepath, remotepath
					~quakePlayers.at( j ).add(
						jt.stationInfo.at( it ).channelPlayers.at( sortedAmp.first );
					);
					0.1.wait;
				};
			};
			if ( nStations == 5 ) {
				if ( i==0 ){
					// first two of sortedAmp
					sortedAmp.at([0,1]).do{ |k|
						// k.postln;
						jt.stationInfo.at( it ).createChannelPlayer( k );
						jt.stationInfo.at( it ).prepChannelPlayer( k, s,  ~basefilepath, ~basefilepathRemote ); // basepath, remotepath
						~quakePlayers.at( j ).add(
							jt.stationInfo.at( it ).channelPlayers.at( k );
						);
						0.1.wait;
					};
				}{
					jt.stationInfo.at( it ).createChannelPlayer( sortedAmp.first );
					jt.stationInfo.at( it ).prepChannelPlayer( sortedAmp.first, s,  ~basefilepath, ~basefilepathRemote ); // basepath, remotepath
					~quakePlayers.at( j ).add(
						jt.stationInfo.at( it ).channelPlayers.at( sortedAmp.first );
					);
					0.1.wait;
				};
			};
			if ( nStations == 6 ){
				jt.stationInfo.at( it ).createChannelPlayer( sortedAmp.first );
				jt.stationInfo.at( it ).prepChannelPlayer( sortedAmp.first, s,  ~basefilepath, ~basefilepathRemote ); // basepath, remotepath
				~quakePlayers.at( j ).add(
					jt.stationInfo.at( it ).channelPlayers.at( sortedAmp.first );
				);
				0.1.wait;
			};
		};
		~quakePlayers[j].postln;
	};
}).play;
);

// function to play an earthquake
(
~playQuake = { |qid|
	~quakePlayers.at( qid ).do{ |it,i| it.play( s,~spOrder[i], \waveplayer, \pulseenv ) };
};
);

(
~stopQuake = { |qid|
	~quakePlayers.at( qid ).do{ |it| it.stop };
}
);

(
~lastQuake = -1;
~switchQuake = { |v|
	"quake switch to ".post; v.postln;
	if ( ~lastQuake > -1 ){
		~stopQuake.value( ~lastQuake );
	};
	if ( v > 0 ){
		~playQuake.value( v-1 );
	};
	~lastQuake = v-1;
};
);