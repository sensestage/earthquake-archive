// for all quakes

(
~basefilepath = "/home/nescivi/git/projects/earthquakes/earthquake-archive/Python/Test-Data/";

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

	it.matchWavesWithStations;
	// it.readAllPitchTraces; // only needed for processing
	// it.writePitchTraces;   // processing
	it.matchWavesWithStations;
	it.filterStations; // take out stations for which there are no waveforms

	it.stationsSortedByDistance.postln;
};
);

~quakes[0].stationInfo.keys

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