// This file replicates the functionality of _main.scd for controlling the Bela SC server remotely.

( // remote belaserver
Server.default = s = Server("belaServer", NetAddr("192.168.7.2", 57110));
//s.initTree;
s.options.maxLogins = 5;
s.clientID = 1;
s.startAliveThread;
);

// load other files from _main.scd
// use the below instead of earthquake_waves.scd

// Make sure to set these appropriately so that both the Bela & the local machine can load the test data
~basefilepath = "/home/nescivi/git/projects/earthquakes/earthquake-archive/Python/Test-Data/";
~basefilepathRemote = "/root/earthquakes/Python/Test-Data/";


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