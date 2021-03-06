EarthQuake{

	var <basePath;

	var <distanceInfo, <quakeInfo, <stationInfo;

	var <wavesByStation;

	*new{ |basepath|
		^super.new.init( basepath );
	}

	init{ |basepath|
		basePath = basepath;
		wavesByStation = IdentityDictionary.new;
	}

	readInfo{
		quakeInfo = EarthQuakeInfo.new.read( basePath );

		distanceInfo = SemiColonFileReader.read( basePath +/+ "distance_info.csv", true );
	}

	parseStations{
		var stInfo;
		stationInfo = IdentityDictionary.new;
		distanceInfo.do{ |it|
			stInfo = EarthQuakeStationInfo.new.readLine( it );
			stationInfo.put( stInfo.fileName.asSymbol, stInfo );
		}
	}

	waveFiles{
		^( basePath +/+ "wavefiles/*.wav").pathMatch;
	}

	normalizedWaveFiles{
		^( basePath +/+ "wav_norm/*.wav").pathMatch;
	}

	ampWaveFiles{
		^( basePath +/+ "wav_amp/*.wav").pathMatch;
	}

	cutWaveFiles{
		^( basePath +/+ "wav_amp/*.wav").pathMatch;
	}

	pitchFiles{
		^( basePath +/+ "wav_pitch/*.pitch").pathMatch;
	}

	pitchWaveFiles{
		^( basePath +/+ "wav_pitchtrace/*.wav.pitch").pathMatch;
	}

	normalizeWaves{
		var waves;
		if ( File.exists( basePath +/+ "wav_norm" ) ){
			("Folder for normalized waves already exists!" + basePath +/+ "wav_norm" ).warn;
		}{
			File.mkdir( basePath +/+ "wav_norm" );
			waves = this.waveFiles;
			SoundFile.groupNormalize( waves, ( basePath +/+ "wav_norm" ), "WAV", "float", 1 );
		};
	}

	writeAmplitudeTracesAndCut{ |threshold=0.00001|
		var waves;
		if ( File.exists( basePath +/+ "wav_amp" ) or: File.exists( basePath +/+ "wav_cut" ) ){
			("Folder for amplitude waves already exists!" + basePath +/+ "wav_amp" ).warn;
			("Folder for cut waves already exists!" + basePath +/+ "wav_cut" ).warn;
		}{
			File.mkdir( basePath +/+ "wav_cut" );
			File.mkdir( basePath +/+ "wav_amp" );
			waves = this.normalizedWaveFiles;
			waves.do{ |it|
				this.processWaveFileAmpCut( it, basePath, threshold );
			}
		};
	}

	processWaveFileAmpCut{ |path, basePath, threshold|
		var inSndfile = SoundFile.new;
		var outSndfile1 = SoundFile.new;
		var outSndfile2 = SoundFile.new;
		var srate, indata;
		var ampval, ampdata, cutdata;
		var ampFile = path.replace( basePath +/+ "wav_norm", basePath +/+ "wav_amp" );
		var cutFile = path.replace( basePath +/+ "wav_norm", basePath +/+ "wav_cut" );

		// read in data:
		inSndfile.openRead( path );
		srate = inSndfile.sampleRate;
		indata = FloatArray.fill( inSndfile.numFrames, 0 );
		inSndfile.readData( indata );
		inSndfile.close;

		// do amplitude check, and cut out the data
		cutdata = [];
		ampval = 0;
		ampdata = indata.collect{ |it|
			ampval = (ampval*0.995)+(it.pow(2)*0.005);
			if ( ampval > threshold ){
				cutdata = cutdata ++ it;
			};
			ampval;
		}.collect{ |it| it.sqrt * 4 };

		outSndfile1 = SoundFile.new().headerFormat_( "WAV" ).sampleFormat_( "float" ).numChannels_(1).sampleRate_( srate ) ;
		outSndfile1.openWrite( ampFile );
		outSndfile1.writeData( ampdata.as(FloatArray));
		outSndfile1.close;

		outSndfile2 = SoundFile.new().headerFormat_( "WAV" ).sampleFormat_( "float" ).numChannels_(1).sampleRate_( srate ) ;
		outSndfile2.openWrite( cutFile );
		outSndfile2.writeData( cutdata.as(FloatArray));
		outSndfile2.close;
	}

	analyzePitchWaves{
		var wavepath, waves;
		if ( File.exists( basePath +/+ "wav_pitch" ) ){
			("Folder for pitch traces of waves already exists!" + basePath +/+ "wav_pitch" ).warn;
		}{
			File.mkdir( basePath +/+ "wav_pitch" );
			waves = this.normalizedWaveFiles;
			waves.do{ |it|
				wavepath = it.replace( basePath +/+ "wav_norm", basePath +/+ "wav_pitch" );
				("aubiopitch -i" + it + "-H 64 -B 1024 -p yin >" + wavepath ++".pitch" ).unixCmd;
			};
		}
	}

	analyzeAmplitudes{
		stationInfo.do{ |it| it.analyzeAmplitudes( basePath ) };
	}

	readAmplitudes{
		stationInfo.do{ |it| it.readAmplitudes( basePath ) };
	}

	writePitchTraces{ |filterMax=150|
		/*if ( File.exists( basePath +/+ "wav_pitchtrace" ) ){
			("Folder for wave files of pitch traces already exists!" + basePath +/+ "wav_pitchtrace" ).warn;
		}{*/
			File.mkdir( basePath +/+ "wav_pitchtrace" );
			stationInfo.do{ |it| it.writePitchTraceWaves( basePath, filterMax ) };
	// }
	}

	matchWavesWithStations{
		stationInfo.do{ |it|
			it.findMatchingWaves( this.normalizedWaveFiles );
			it.findMatchingPitches( this.pitchFiles );
			it.findMatchingPitchWaves( this.pitchWaveFiles );
			it.findMatchingAmpWaves( this.ampWaveFiles );
			it.findMatchingCutWaves( this.cutWaveFiles );
		};
	}

	readAllPitchTraces{
		stationInfo.do{ |it| it.readPitchTraces; };
	}

	filterStations{
		stationInfo = stationInfo.select{ |it| it.waves.size > 0 };
	}

	stationsSortedByDistance{
		^stationInfo.asArray.sort( { |a,b| a.distance < b.distance } ).collect{ |it| it.fileName.asSymbol };
	}

	readAllBuffers{ |server, basepath, remotepath|
		stationInfo.do{ |stat|
			if ( stat.waves.size > 0 ){
				stat.loadBuffers( server, basepath, remotepath );
				stat.loadPitchBuffers( server, basepath, remotepath );
				// stat.loadAmpBuffers( server, basepath, remotepath );
				// stat.loadCutBuffers( server, basepath, remotepath );
			};
		};
	}

}

EarthQuakeInfo{
	var <longitude, <latitude;
	var <magnitude;
	var <date;

	*new{
		^super.new;
	}

	read{ |path|
		var fileinfo = SemiColonFileReader.read( path +/+ "quake_info.csv" , true );
		date = fileinfo[0][0];
		latitude = fileinfo[0][1].asFloat;
		longitude = fileinfo[0][2].asFloat;
		magnitude = fileinfo[0][3].asFloat;
	}

}

EarthQuakeStationInfo{
	var <name;
	var <fileName;

	var <longitude, <latitude;
	var <distance;

	var <waves;
	var <ampWaves, <cutWaves;
	var <waveAmplitudes;
	var <pitchTraceFiles, <pitchTraces;
	var <pitchTraceWaveFiles;

	var <channelPlayers;

	// // playing one
	// var <buffer, <pitchBuffer;
	// var <waveSynth, <soundSynth;
	// var <pitchBus, <ampBus, <doneBus;

	// // playing all
	// var <buffers;
	// var <pitchBuffers;
	// var <waveSynths, <soundSynths;
	// var <pitchBuses, <ampBuses;

	*new{
		^super.new.init;
	}

	init{
		channelPlayers = IdentityDictionary.new;
	}

	createChannelPlayer{ |id|
		channelPlayers.put( id, EarthQuakeChannelPlayer.new );
	}

	prepChannelPlayer{ |id, server, basePath, replacePath|
		var wavefilename = waves[ id ];
		if ( wavefilename.isNil ){
			("waveFile with index"+id+"does not exist: ").postln;
			waves.postln;
		}{
			if ( replacePath.notNil and: basePath.notNil ){
				wavefilename = wavefilename.replace( basePath, replacePath );
			};
			channelPlayers.at( id ).loadBuffer( server, wavefilename );
		};

		wavefilename = pitchTraceWaveFiles[ id ];
		if ( wavefilename.isNil ){
			("pitchTraceWaveFile with index"+id+"does not exist").postln;
			pitchTraceWaveFiles.postln;
		}{
			if ( replacePath.notNil and: basePath.notNil ){
				wavefilename = wavefilename.replace( basePath, replacePath );
			};
			channelPlayers.at( id ).loadPitchBuffer( server, wavefilename );
		};

		wavefilename = ampWaves[ id ];
		if ( wavefilename.isNil ){
			("ampWave with index"+id+"does not exist").postln;
			ampWaves.postln;
		}{
			if ( replacePath.notNil and: basePath.notNil ){
				wavefilename = wavefilename.replace( basePath, replacePath );
			};
			channelPlayers.at( id ).loadAmpBuffer( server, wavefilename );
		};

		wavefilename = ampWaves[ id ];
		if ( wavefilename.isNil ){
			("cutWave with index"+id+"does not exist").postln;
			cutWaves.postln;
		}{
			if ( replacePath.notNil and: basePath.notNil ){
				wavefilename = wavefilename.replace( basePath, replacePath );
			};
			channelPlayers.at( id ).loadCutBuffer( server, wavefilename );
		};


		channelPlayers.at( id ).allocBuses( server )
	}

	playChannelPlayer{ |id, server, output, waveDef, soundDef, waveArgs, soundArgs|
		channelPlayers.at( id ).play( server, output, waveDef, soundDef, waveArgs, soundArgs );
	}

	stopChannelPlayer{ |id|
		channelPlayers.at( id ).stop;
	}

	readLine{ |line|
		name = line[0];
		fileName = name.replace( " -- ", "_" ).replace( " ", "_" ).replace("*","" );
		latitude = line[1].asFloat;
		longitude = line[2].asFloat;
		distance = line[3].asFloat;
	}

	findMatchingWaves{ |waveFiles|
		waves = waveFiles.select{ |it| it.contains( fileName ) };
		waves = waves.sort;
	}

	findMatchingAmpWaves{ |waveFiles|
		ampWaves = waveFiles.select{ |it| it.contains( fileName ) };
		ampWaves = ampWaves.sort;
	}

	findMatchingCutWaves{ |waveFiles|
		cutWaves = waveFiles.select{ |it| it.contains( fileName ) };
		cutWaves = cutWaves.sort;
	}

	analyzeAmplitudes{ |basepath|
		var sndfile, peaks;
		var amplitudes = waves.collect{ |it| sndfile = SoundFile.new; sndfile.openRead( it ); peaks = sndfile.channelPeaks; sndfile.close; [ PathName( it ).fileNameWithoutExtension, peaks.unbubble ] };
		var filewriter = SemiColonFileWriter.new( basepath +/+ fileName ++ "_waveamplitudes.csv" );
		amplitudes.do{ |it|
			filewriter.writeLine( it );
		};
		filewriter.close;
	}

	readAmplitudes{ |basepath|
		waveAmplitudes = SemiColonFileReader.read( basepath +/+ fileName ++ "_waveamplitudes.csv" );
		waveAmplitudes = waveAmplitudes.collect{ |it| [ it[0], it[1].asFloat ] };
	}

	// loadBuffers{ |server, basePath, replacePath|
	// 	var wavefilenames = waves;
	// 	if ( buffers.notNil ){ this.freeBuffers };
	// 	if ( replacePath.notNil and: basePath.notNil ){
	// 		wavefilenames = waves.collect{ |it| it.replace( basePath, replacePath ); };
	// 	};
	// 	buffers = wavefilenames.collect{ |it| Buffer.read( server, it ); };
	// }
	//
	// freeBuffers {
	// 	buffers.do{ |it| it.free; };
	// }

	findMatchingPitches{ |wavePitches|
		pitchTraceFiles = wavePitches.select{ |it| it.contains( fileName ) };
		pitchTraceFiles = pitchTraceFiles.sort;
	}

	findMatchingPitchWaves{ |wavePitches|
		pitchTraceWaveFiles = wavePitches.select{ |it| it.contains( fileName ) };
		pitchTraceWaveFiles = pitchTraceWaveFiles.sort;
	}

	readPitchTraces{ |filterMax=150|
		pitchTraces = pitchTraceFiles.collect{ |it| EarthQuakePitchTrace.new.read( it ).filter(filterMax); };
	}

	writePitchTraceWaves{ |basePath, filterMax=150|
		var sndfile, sr, wavepath;
		pitchTraces.do{ |it,i|
			// read corresponding wave file for samplerate
			sndfile = SoundFile.new;
			sndfile.openRead( waves[i] );
			sr = sndfile.sampleRate;
			sndfile.close;
			wavepath = pitchTraceFiles[i].replace( basePath +/+ "wav_pitch", basePath +/+ "wav_pitchtrace" );
			it.writeWave( wavepath, sr, filterMax );
		}
	}

	// loadPitchBuffers{ |server, basePath, replacePath|
	// 	var wavefilenames = pitchTraceWaveFiles;
	// 	if ( pitchBuffers.notNil ){ this.freePitchBuffers };
	// 	if ( replacePath.notNil and: basePath.notNil ){
	// 		wavefilenames = pitchTraceWaveFiles.collect{ |it| it.replace( basePath, replacePath ); };
	// 	};
	// 	pitchBuffers = wavefilenames.collect{ |it| Buffer.read( server, it ); };
	// }
	//
	// freePitchBuffers {
	// 	pitchBuffers.do{ |it| it.free; };
	// }


	// // play all wave forms
	// play{ |server, output, waveDef, soundDef|
	// 	var count = buffers.size;
	// 	pitchBuses = Bus.control( server, count );
	// 	ampBuses = Bus.control( server, count );
	// 	waveSynths = buffers.collect{ |buf,i| Synth.new( waveDef, [ \buf, buf, \pitchBuf, pitchBuffers[i], \ampOut, ampBuses.index + i, \pitchOut, pitchBuses.index + i ] ) };
	// 	soundSynths = count.collect{ |i| Synth.new( soundDef, [ \out, output, \amp, ampBuses.subBus(i).asMap, \rate, pitchBuses.subBus(i).asMap, \freq, pitchBuses.subBus(i).asMap ] ) };
	// }
	//
	// stop{
	// 	pitchBuses.do{ |it| it.free };
	// 	ampBuses.do{ |it| it.free };
	// 	waveSynths.do{ |it| it.free };
	// 	soundSynths.do{ |it| it.free };
	// }

}

EarthQuakeChannelPlayer {
	var <waveBuffer, <ampBuffer, <cutBuffer, <pitchBuffer;
	var <waveSynth, <soundSynth;
	var <pitchBus, <ampBus, <doneBus;

	var <>maxAmp = 1.0;

	*new{
		^super.new;
	}

	loadBuffer{ |server, path|
		if ( waveBuffer.notNil ){ this.freeBuffer };
		waveBuffer = Buffer.read( server, path );
	}

	freeBuffer{
		waveBuffer.free;
	}


	loadAmpBuffer{ |server, path|
		if ( ampBuffer.notNil ){ this.freeAmpBuffer };
		ampBuffer = Buffer.read( server, path );
	}

	freeAmpBuffer{
		ampBuffer.free;
	}

	loadCutBuffer{ |server, path|
		if ( cutBuffer.notNil ){ this.freeCutBuffer };
		cutBuffer = Buffer.read( server, path );
	}

	freeCutBuffer{
		cutBuffer.free;
	}


	loadPitchBuffer{ |server, path|
		if ( pitchBuffer.notNil ){ this.freePitchBuffer };
		pitchBuffer = Buffer.read( server, path );
	}

	freePitchBuffer{
		pitchBuffer.free;
	}

	allocBuses{ |server|
		pitchBus = Bus.control( server, 1 );
		ampBus = Bus.control( server, 1 );
		doneBus = Bus.control( server, 1 );
	}

	freeBuses{
		pitchBus.free;
		ampBus.free;
		doneBus.free;
	}

	play{ |server, output, waveDef, soundDef, waveArgs, soundArgs|
		waveSynth = Synth.new( waveDef,
			[ \buf, waveBuffer, \cutBuf, cutBuffer, \ampBuf, ampBuffer, \pitchBuf, pitchBuffer,
				\ampOut, ampBus, \pitchOut, pitchBus, \doneOut, doneBus
		] ++ waveArgs );
		soundSynth = Synth.new( soundDef, [
			\out, output,
			\amp, ampBus.asMap, \pitch, pitchBus.asMap,
			\endGate, doneBus.asMap, \cutBuf, cutBuffer
		] ++ soundArgs )
	}

	stop{
		waveSynth.free;
		soundSynth.free;
	}

	release{ |releaseTime|
		waveSynth.release( releaseTime );
		soundSynth.release( releaseTime );
	}
}



EarthQuakePitchTrace {

	var <rawTrace;
	var <sparseTrace;
	var <trace;
	var <waveFile;

	var <player;
	var <>rate = 1;
	var <>func;

	*new{
		^super.new;
	}

	read{ |path|
		rawTrace = FileReader.readInterpret( path, delimiter: $  );
	}

	filter{ |max=150|
		// filters the values that are above 0 and below 150
		sparseTrace = rawTrace.select{ |it| ( it[1] > 0.0 and: ( it[1] < max ) ) };
	}

	writeWave{ |path, sr=120, filterMax=150|
		// sr of the original wave file; our pitchwave is 1/64 of that sr
		// this will write a wave file based on the pitch trace
		var sndfile;
		var prevVal = 0;
		trace = rawTrace.collect{ |jt| if ( (jt[1] > 0.0) and: ( jt[1] < filterMax ) ){ prevVal = jt[1]; jt[1] }{ prevVal } };
		sndfile = SoundFile.new.headerFormat_("WAV").sampleFormat_("float").sampleRate_( sr/64.0 ).numChannels_(1);
		sndfile.openWrite( path );
		sndfile.writeData( trace.as( FloatArray ) );
		sndfile.close;
		waveFile = path;
	}

	createPlayer{
		player = Task.new( {
			var lastTime = 0;
			sparseTrace.do{ |it|
				// it.postln;
				( it[0] - lastTime / rate ).wait;
				this.func.value( it[1] ); // do something with the data
				lastTime = it[0]; // calculate new time interval
			};
		});
	}

	play{
		if ( player.isNil or: func.isNil ){
			"No pitch trace player or function defined yet, not playing".warn;
			^this;
		};
		player.reset.play;
	}

	stop{
		player.stop;
	}

}