// for all quakes

(
~spOrder = [7,4,6,5,2,3];

~basefilepath = "/home/nescivi/git/projects/earthquakes/earthquake-archive/Python/Test-Data/";
~basefilepathRemote = "/root/earthquakes/Python/Test-Data/";

~quakePaths = (~basefilepath +/+ "*").pathMatch;

~quakes = ~quakePaths.collect{ |it| EarthQuake.new( it ) };
);
(
~quakes.do{ |it|
	it.readInfo;
	it.parseStations;

	it.waveFiles;
	// it.normalizeWaves;     // processing
	it.normalizedWaveFiles;
	// it.analyzePitchWaves;  // processing

	// it.matchWavesWithStations;
	// it.readAllPitchTraces; // only needed for processing
	// it.writePitchTraces;   // processing

	it.matchWavesWithStations;
	it.filterStations; // take out stations for which there are no waveforms

	it.writeAmplitudeTracesAndCut;

	// it.analyzeAmplitudes;  // processing
	it.readAmplitudes;

	it.stationsSortedByDistance.postln;
};
);


// s.options.numOutputBusChannels = 8;
// s.boot;

ServerOptions

s.bufferAllocator.debug

// ~quakes.do{ |it| it.readAllBuffers(s, ~basefilepath, ~basefilepathRemote ) }; // optional arguments: basepath, remotepath

(// read buffers:
~quakes.do{ |jt,j|
	jt.stationsSortedByDistance.do{ |it,i|
		var indexOfAmp = jt.stationInfo.at( it ).waveAmplitudes.collect{ |it| it[1] }.maxIndex;
		[ j, i ].postln;
		jt.stationInfo.at( it ).loadBuffer( s, indexOfAmp, ~basefilepath, ~basefilepathRemote );
		jt.stationInfo.at( it ).loadPitchBuffer( s, indexOfAmp, ~basefilepath, ~basefilepathRemote );
	};
}
);

(
// free buffers
~quakes.do{ |jt,j|
	jt.stationInfo.do{ |st| st.freeBuffer; st.freePitchBuffer };
};
);


// function to play an earthquake
(
~playQuake = { |qid|
	~quakes[ qid ].stationsSortedByDistance.do{ |it,i|
		~quakes[ qid ].stationInfo.at( it ).playOne( s, ~spOrder[i], \waveplayer, \pulseenv );
	}
};
);

s.sendMsg( "/g_dumpTree", 0, 1 );


(
~stopQuake = { |qid|
	~quakes[ qid ].stationInfo.do{ |it| it.stopOne };
}
);

~playQuake.value( 0 );
~stopQuake.value( 0 );

~playQuake.value( 1 );
~stopQuake.value( 1 );

~playQuake.value( 2 );
~stopQuake.value( 2 );

~playQuake.value( 3 );
~stopQuake.value( 3 );

~playQuake.value( 4 );
~stopQuake.value( 4 );

~playQuake.value( 5 );
~stopQuake.value( 5 );

~playQuake.value( 6 );
~stopQuake.value( 6 );

~playQuake.value( 7 );
~stopQuake.value( 7 );

~playQuake.value( 8 );
~stopQuake.value( 8 );

~playQuake.value( 9 );
~stopQuake.value( 9 );

~playQuake.value( 10 );
~stopQuake.value( 10 );

~playQuake.value( 11 );
~stopQuake.value( 11 );

~playQuake.value( 12 );
~stopQuake.value( 12 );


~index = ~quakes[0].stationInfo.[ 'NL_HWF4_HH' ].waveAmplitudes.collect{ |it| it[1] }.maxIndex

~quakes[0].stationInfo[ 'NL_HWF4_HH' ].playOne( s, 0, ~index, \waveplayer, \pulseenv );
~quakes[0].stationInfo[ 'NL_HWF4_HH' ].stopOne;

~quakes[0].quakeInfo.dump
wavefilenames

~quakes[0].stationInfo[ 'NL_WDB4_HH' ].waveAmplitudes
~quakes[0].stationInfo[ 'NL_WDB4_HH' ].waves
.waves.do{ |it| ~sndfile = SoundFile.new; ~sndfile.openRead( it ); ~sndfile.channelPeaks.postln; ~sndfile.close; }

~quakes[0].stationInfo.collect{ |st| st.waves.collect{ |it| ~sndfile = SoundFile.new; ~sndfile.openRead( it ); ~peaks = ~sndfile.channelPeaks; ~sndfile.close; ~peaks } }.do{ |jt| jt.size.postln; }

~quakes[0].stationInfo[ 'NL_WDB4_HH' ].waves[0] < ~quakes[0].stationInfo[ 'NL_WDB4_HH' ].waves[1]
~quakes[0].stationInfo[ 'NL_WDB4_HH' ].waves[1] < ~quakes[0].stationInfo[ 'NL_WDB4_HH' ].waves[2]
~quakes[0].stationInfo[ 'NL_WDB4_HH' ].waves[2]

~quakes[0].stationInfo.do{ |it| it.waves.collect{ |jt| jt.contains( "HHN" ) }.postln }

~quakes.do{ |it| it.stationsSortedByDistance.postln; };

// 4 tot 6 stations:
// mapping:
// 4: stern + upper back, left shoulder, right shoulder, left + right hip
// 5: stern + upper back, left shoulder, right shoulder, left, right hip
// 6: stern, upper back, left shoulder, right shoulder, left, right hip

~selectedStations = ~quakes[0].stationInfo.select{ |it| it.waves.size > 0 };
~selectedStations.keys

// ~quakes[0].stationInfo.at( ~quakes[0].stationsSortedByDistance[0] ).waves.size.postln;
// ~quakes[0].stationInfo.at( ~quakes[0].stationsSortedByDistance[0] ).readPitchTraces

~quakes[0].stationInfo.at( ~quakes[0].stationsSortedByDistance[0] ).pitchTraces[0].trace

~quakes[0].stationInfo.at( ~quakes[0].stationsSortedByDistance[0] ).pitchTraces[0].func = { |val| val.postln; };
~quakes[0].stationInfo.at( ~quakes[0].stationsSortedByDistance[0] ).pitchTraces[0].createPlayer;

~quakes[0].stationInfo.at( ~quakes[0].stationsSortedByDistance[0] ).pitchTraces[0].func.value( 0.1 )

~quakes[0].stationInfo.at( ~quakes[0].stationsSortedByDistance[0] ).pitchTraces[0].play;

~quakes[0].stationInfo.at( ~quakes[0].stationsSortedByDistance[0] ).pitchTraces[0].player.reset;

~quakes[0].stationInfo.at( ~quakes[0].stationsSortedByDistance[0] ).pitchTraces[0].stop;


~traces = ~quakes[0].stationInfo.at( ~quakes[0].stationsSortedByDistance[0] ).pitchTraces.collect{ |it| it.rawTrace.flop[1] }.collect{ |it| it.collect{ |jt| if ( jt > 200 ){ 0.0 }{ jt } } }.plot;

~pval = 0.0;
~quakes[0].stationInfo.at( ~quakes[0].stationsSortedByDistance[0] ).pitchTraces.collect{ |it| it.rawTrace }[0].collect{ |jt| if ( (jt[1] > 0.0) and: ( jt[1] < 150.0 ) ){ ~pval = jt[1]; jt[1] }{ ~pval } }.plot;

(
~quakes[9].stationInfo.do{ |stat|
	var traces = stat.pitchTraces.collect{ |it| it.rawTrace.flop[1] }.collect{ |it| it.collect{ |jt| if ( jt > 150 ){ 0.0 }{ jt } } };
	if ( traces.size > 0 ){ traces.plot }
};
);


// for one quake:

~basefilepath = "/home/nescivi/git/projects/earthquakes/earthquake-archive/Python/Test-Data/2003-10-24-3.0/";

~quake = EarthQuake.new( ~basefilepath );
~quake.readInfo;
~quake.parseStations;

~quake.waveFiles;
~quake.normalizeWaves;
~quake.normalizedWaveFiles;

~quake.matchWavesWithStations;
~quake.stationsSortedByDistance;

// ~quake.quakeInfo.dump
// ~quake.stationInfo.do{ |it| it.dump };