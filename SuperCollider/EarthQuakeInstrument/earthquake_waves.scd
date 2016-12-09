~quakePlayers = IdentityDictionary.new;
(// prepare channel players
Task({ // load buffers slowly
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
						jt.stationInfo.at( it ).prepChannelPlayer( k, s ); // basepath, remotepath
						~quakePlayers.at( j ).add(
							jt.stationInfo.at( it ).channelPlayers.at( k );
						);
						0.1.wait;
					}
				}{
					jt.stationInfo.at( it ).createChannelPlayer( sortedAmp.first );
					jt.stationInfo.at( it ).prepChannelPlayer( sortedAmp.first, s ); // basepath, remotepath
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
						jt.stationInfo.at( it ).prepChannelPlayer( k, s ); // basepath, remotepath
						~quakePlayers.at( j ).add(
							jt.stationInfo.at( it ).channelPlayers.at( k );
						);
						0.1.wait;
					};
				}{
					jt.stationInfo.at( it ).createChannelPlayer( sortedAmp.first );
					jt.stationInfo.at( it ).prepChannelPlayer( sortedAmp.first, s ); // basepath, remotepath
					~quakePlayers.at( j ).add(
						jt.stationInfo.at( it ).channelPlayers.at( sortedAmp.first );
					);
					0.1.wait;
				};
			};
			if ( nStations == 6 ){
				jt.stationInfo.at( it ).createChannelPlayer( sortedAmp.first );
				jt.stationInfo.at( it ).prepChannelPlayer( sortedAmp.first, s ); // basepath, remotepath
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
	~quakePlayers.at( qid ).do{ |it,i| it.play( s,~spOrder[i], \waveplayer, \pulseenv, [\rate, 5, \attack, 0.05, \release, 0.2], [  \ampmin, 0.1, \ampmax, 1, \ampInMin, 0.00025, \ampInMax, 0.2, \freqOutMin, 75, \freqOutMax, 200, \ratemin, 1, \ratemax, 40 ] ) };
};
);

(
~stopQuake = { |qid|
	~quakePlayers.at( qid ).do{ |it| it.stop };
}
);

~lastQuake = -1;
~switchQuake = { |v|
	// TODO: quake has to be different than previous one
	"quake switch to ".post; v.postln;
	if ( ~lastQuake > -1 ){
		~stopQuake.value( ~lastQuake );
	};
	if ( v > 0 ){
		~playQuake.value( v-1 );
	};
	~lastQuake = v-1;
};
