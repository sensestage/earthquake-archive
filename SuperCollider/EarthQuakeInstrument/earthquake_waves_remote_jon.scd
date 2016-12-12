// This file replicates the functionality of _main.scd for controlling the Bela SC server remotely.

( // remote belaserver
Server.default = s = Server("belaServer", NetAddr("192.168.7.2", 57110));
//s.initTree;
s.options.maxLogins = 5;
s.clientID = 1;
s.startAliveThread;
);


SynthDef('sin', {arg st_hz=50, end_hz=1000, dur=1, outch=2, amp=1.0;
	var sig;
	sig = SinOsc.ar(EnvGen.ar(Env.linen(0.01, 1, 2, curve: -4), timeScale: dur, doneAction: 2).range(st_hz, end_hz));
	Out.ar(outch, sig * amp);
}).send(s);

(
{
	Synth('sin', ['st_hz', 40, 'end_hz', 80, 'dur', 1.1, 'outch', 2]); // belly left
	0.5.yield;
	Synth('sin', ['st_hz', 40, 'end_hz', 30, 'dur', 2.1, 'outch', 3]); // belly right
	0.5.yield;
	Synth('sin', ['st_hz', 40, 'end_hz', 70, 'dur', 0.1, 'outch', 4]); // neck
	0.5.yield;
	Synth('sin', ['st_hz', 40, 'end_hz', 60, 'dur', 0.1, 'outch', 5]); // collar left
	0.5.yield;
	Synth('sin', ['st_hz', 40, 'end_hz', 50, 'dur', 0.1, 'outch', 6]); // collar right
	0.5.yield;
	Synth('sin', ['st_hz', 40, 'end_hz', 40, 'dur', 0.1, 'outch', 7]); // sternum
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