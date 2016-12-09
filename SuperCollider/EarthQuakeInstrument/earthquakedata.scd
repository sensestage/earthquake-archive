(
// ~basefilepath = ~mypath +/+ "../../Python/Test-Data";
~basefilepath = "/home/nescivi/git/projects/earthquakes/earthquake-archive/Python/Test-Data/";
// ~basefilepath = "/root/earthquakes/Python/Test-Data/";
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

	// it.analyzeAmplitudes;  // processing
	it.readAmplitudes;

	// it.stationsSortedByDistance.postln;
};
);
