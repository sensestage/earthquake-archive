~basefilepath = "/home/nescivi/git/projects/earthquakes/earthquake-archive/Python/Test-Data/";

// 2003

~files = (~basefilepath +/+ "2003-10-24-3.0/wav_norm/split/*HHE.wav").pathMatch.sort;
~files.do{ |it| it.postln; }

(
~data = ~files.collect{ |it|
	var sndfile, data;
	sndfile = SoundFile.new;
	sndfile.openRead( it );
	~sampleRate = sndfile.sampleRate;
	data = FloatArray.fill( sndfile.numFrames, 0 );
	sndfile.readData( data );
	sndfile.close;
	data;
};
);

~concatdata = FloatArray.new;
~data.do{ |it| ~concatdata = ~concatdata ++ it };
~concatdata.plot;

(
~sndfile = SoundFile.new().headerFormat_( "WAV" ).sampleFormat_( "float" ).numChannels_(1).sampleRate_( ~sampleRate ) ;
~sndfile.openWrite(  ~basefilepath +/+ "2003-10-24-3.0/wav_norm/" ++ PathName( ~files[0] ).fileName  );
~sndfile.writeData(~concatdata);
~sndfile.close;
);

///---

~files = (~basefilepath +/+ "2003-10-24-3.0/wav_norm/split/*HHN.wav").pathMatch.sort;
~files.do{ |it| it.postln; }

(
~data = ~files.collect{ |it|
	var sndfile, data;
	sndfile = SoundFile.new;
	sndfile.openRead( it );
	~sampleRate = sndfile.sampleRate;
	data = FloatArray.fill( sndfile.numFrames, 0 );
	sndfile.readData( data );
	sndfile.close;
	data;
};
);

(
~concatdata = FloatArray.new;
~data.do{ |it| ~concatdata = ~concatdata ++ it };
~concatdata.plot;
);

(
~sndfile = SoundFile.new().headerFormat_( "WAV" ).sampleFormat_( "float" ).numChannels_(1).sampleRate_( ~sampleRate ) ;
~sndfile.openWrite(  ~basefilepath +/+ "2003-10-24-3.0/wav_norm/" ++ PathName( ~files[0] ).fileName  );
~sndfile.writeData(~concatdata);
~sndfile.close;
);

///--- 2008

~files = (~basefilepath +/+ "2008-10-30-3.2/wav_norm/split/*HHZ.wav").pathMatch.sort;
~files.do{ |it| it.postln; }

(
~data = ~files.collect{ |it|
	var sndfile, data;
	sndfile = SoundFile.new;
	sndfile.openRead( it );
	~sampleRate = sndfile.sampleRate;
	data = FloatArray.fill( sndfile.numFrames, 0 );
	sndfile.readData( data );
	sndfile.close;
	data;
};
);

(
~concatdata = FloatArray.new;
~data.do{ |it| ~concatdata = ~concatdata ++ it };
~concatdata.plot;
);

(
~sndfile = SoundFile.new().headerFormat_( "WAV" ).sampleFormat_( "float" ).numChannels_(1).sampleRate_( ~sampleRate ) ;
~sndfile.openWrite(  ~basefilepath +/+ "2008-10-30-3.2/wav_norm/" ++ PathName( ~files[0] ).fileName  );
~sndfile.writeData(~concatdata);
~sndfile.close;
);


~files = (~basefilepath +/+ "2008-10-30-3.2/wav_norm/split/*HHN.wav").pathMatch.sort;
~files.do{ |it| it.postln; }

(
~data = ~files.collect{ |it|
	var sndfile, data;
	sndfile = SoundFile.new;
	sndfile.openRead( it );
	~sampleRate = sndfile.sampleRate;
	data = FloatArray.fill( sndfile.numFrames, 0 );
	sndfile.readData( data );
	sndfile.close;
	data;
};
);

(
~concatdata = FloatArray.new;
~data.do{ |it| ~concatdata = ~concatdata ++ it };
~concatdata.plot;
);

(
~sndfile = SoundFile.new().headerFormat_( "WAV" ).sampleFormat_( "float" ).numChannels_(1).sampleRate_( ~sampleRate ) ;
~sndfile.openWrite(  ~basefilepath +/+ "2008-10-30-3.2/wav_norm/" ++ PathName( ~files[0] ).fileName  );
~sndfile.writeData(~concatdata);
~sndfile.close;
);


~files = (~basefilepath +/+ "2008-10-30-3.2/wav_norm/split/*HHE.wav").pathMatch.sort;
~files.do{ |it| it.postln; }

(
~data = ~files.collect{ |it|
	var sndfile, data;
	sndfile = SoundFile.new;
	sndfile.openRead( it );
	~sampleRate = sndfile.sampleRate;
	data = FloatArray.fill( sndfile.numFrames, 0 );
	sndfile.readData( data );
	sndfile.close;
	data;
};
);

(
~concatdata = FloatArray.new;
~data.do{ |it| ~concatdata = ~concatdata ++ it };
~concatdata.plot;
);

(
~sndfile = SoundFile.new().headerFormat_( "WAV" ).sampleFormat_( "float" ).numChannels_(1).sampleRate_( ~sampleRate ) ;
~sndfile.openWrite(  ~basefilepath +/+ "2008-10-30-3.2/wav_norm/" ++ PathName( ~files[0] ).fileName  );
~sndfile.writeData(~concatdata);
~sndfile.close;
);



// 2015-09-30-3.1

~files = (~basefilepath +/+ "2015-09-30-3.1/wav_norm/split/*HHE.wav").pathMatch.sort;
~files.do{ |it| it.postln; }

(
~data = ~files.collect{ |it|
	var sndfile, data;
	sndfile = SoundFile.new;
	sndfile.openRead( it );
	~sampleRate = sndfile.sampleRate;
	data = FloatArray.fill( sndfile.numFrames, 0 );
	sndfile.readData( data );
	sndfile.close;
	data;
};
);

(
~concatdata = FloatArray.new;
~data.do{ |it| ~concatdata = ~concatdata ++ it };
~concatdata.plot;
);

(
~sndfile = SoundFile.new().headerFormat_( "WAV" ).sampleFormat_( "float" ).numChannels_(1).sampleRate_( ~sampleRate ) ;
~sndfile.openWrite(  ~basefilepath +/+ "2015-09-30-3.1/wav_norm/" ++ PathName( ~files[0] ).fileName  );
~sndfile.writeData(~concatdata);
~sndfile.close;
);


~files = (~basefilepath +/+ "2015-09-30-3.1/wav_norm/split/*HHN.wav").pathMatch.sort;
~files.do{ |it| it.postln; }

(
~data = ~files.collect{ |it|
	var sndfile, data;
	sndfile = SoundFile.new;
	sndfile.openRead( it );
	~sampleRate = sndfile.sampleRate;
	data = FloatArray.fill( sndfile.numFrames, 0 );
	sndfile.readData( data );
	sndfile.close;
	data;
};
);

(
~concatdata = FloatArray.new;
~data.do{ |it| ~concatdata = ~concatdata ++ it };
~concatdata.plot;
);

(
~sndfile = SoundFile.new().headerFormat_( "WAV" ).sampleFormat_( "float" ).numChannels_(1).sampleRate_( ~sampleRate ) ;
~sndfile.openWrite(  ~basefilepath +/+ "2015-09-30-3.1/wav_norm/" ++ PathName( ~files[0] ).fileName  );
~sndfile.writeData(~concatdata);
~sndfile.close;
);


~files = (~basefilepath +/+ "2015-09-30-3.1/wav_norm/split/*HHZ.wav").pathMatch.sort;
~files.do{ |it| it.postln; }

(
~data = ~files.collect{ |it|
	var sndfile, data;
	sndfile = SoundFile.new;
	sndfile.openRead( it );
	~sampleRate = sndfile.sampleRate;
	data = FloatArray.fill( sndfile.numFrames, 0 );
	sndfile.readData( data );
	sndfile.close;
	data;
};
);

(
~concatdata = FloatArray.new;
~data.do{ |it| ~concatdata = ~concatdata ++ it };
~concatdata.plot;
);

(
~sndfile = SoundFile.new().headerFormat_( "WAV" ).sampleFormat_( "float" ).numChannels_(1).sampleRate_( ~sampleRate ) ;
~sndfile.openWrite(  ~basefilepath +/+ "2015-09-30-3.1/wav_norm/" ++ PathName( ~files[0] ).fileName  );
~sndfile.writeData(~concatdata);
~sndfile.close;
);


