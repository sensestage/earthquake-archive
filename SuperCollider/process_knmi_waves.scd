~basefilepath = "/home/nescivi/Documents/Projects/Earthquakes/fdsn2wavplot/data/";

~quakes = (~basefilepath +/+ "*" ).pathMatch;

// make directories for results:
~quakes.do{ |it| File.mkdir( it +/+ "wav_offset" ) };
~quakes.do{ |it| File.mkdir( it +/+ "wav_norm" ) };
~quakes.do{ |it| File.mkdir( it +/+ "wav_eqsize" ) };

// read in soundfiles and remove the DC offset
(
~quakes.do{ |it|
	~waves = ( it +/+ "WAV/*.wav").pathMatch;
	~waves.do{ |jt|
		~soundfile = SoundFile.new( jt );
		~soundfile.openRead( jt );
		jt.postln;
		~soundfile.numFrames.postln;
		~snddata = FloatArray.fill( ~soundfile.numFrames, 0 );
		~soundfile.readData( ~snddata );
		~snddata2 = (~snddata - ~snddata[0]).as( FloatArray ); // remove offset
		~soundfile2 = SoundFile.new.headerFormat_( "WAV" ).sampleFormat_( ~soundfile.sampleFormat ).numChannels_( ~soundfile.numChannels ).sampleRate_( ~soundfile.sampleRate );
		~soundfile2.openWrite( (it +/+ "wav_offset" +/+ PathName( jt ).fileName ) );
		~soundfile2.writeData( ~snddata2 );
		~soundfile2.close;
		~soundfile.close;
	};
};
);

// normalize per earthquake
(
~quakes.do{ |it|
	~waves = ( it +/+ "wav_offset/*.wav").pathMatch;
	~waves.postln;
	SoundFile.groupNormalize( ~waves, ( it +/+ "wav_norm" ), "WAV", "float", 1 );
};
);

// adjust numFrames per quake - so all wave files for each quake are equally long
(
~quakes.do{ |it|
	~waves = ( it +/+ "wav_norm/*.wav").pathMatch;
	~soundfiles = ~waves.collect{ |it| SoundFile.new( it ) };
	~soundfiles.do{ |it| it.openRead };
	~lengths = ~soundfiles.collect{ |it| it.numFrames };
	~maxLength = ~lengths.maxItem.postln;

	~soundfiles.do{ |jt|
		~snddata = FloatArray.fill( ~maxLength, 0 );
		~snddata2 = FloatArray.fill( ~maxLength, 0 );
		jt.readData( ~snddata );
		// ~snddata.size.postln;
		~snddata2 = (~snddata2 + ~snddata).as( FloatArray );
		// ~snddata2.size.postln;
		~soundfile2 = SoundFile.new.headerFormat_( "WAV" ).sampleFormat_( jt.sampleFormat ).numChannels_( jt.numChannels ).sampleRate_( jt.sampleRate );
		~soundfile2.openWrite( (it +/+ "wav_eqsize" +/+ PathName( jt.path ).fileName ) );
		~soundfile2.writeData( ~snddata2 );
		~soundfile2.close;
	};

	~soundfiles.do{ |it| it.close };
};
);


(
// find peaks
~quakePeaks = ~quakes.collect{ |it|
	~waves = ( it +/+ "wav_eqsize/*.wav").pathMatch;
	~soundfiles = ~waves.collect{ |it| SoundFile.new( it ) };
	~soundfiles.do{ |it| it.openRead };

	~soundPeaks = ~soundfiles.collect{ |jt| jt.channelPeaks.unbubble};

	~soundfiles.do{ |it| it.close };
	~soundPeaks;
};
);

~quakePeaks[1].plot
