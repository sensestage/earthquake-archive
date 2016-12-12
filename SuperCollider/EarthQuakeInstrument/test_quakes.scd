// better mapping of the amplitude
// basic amplitude mapping per speaker
// come up with a way to change rate of playback based on amplitude
//+ epicenter in a different place for each earthquake
//+ don't restart quake when it was already playing
//+ tweak DAC parameter - not possible, already at max


~switchQuake.value(0);


~quakes[0].basePath
~quakePlayers[0][0].waveBuffer

~switchQuake.value(1);
~quakePlayers[0].do{ |it| it.waveSynth.set( \rate, 5, \attack, 0.05, \release, 0.2 ) };
~quakePlayers[0].do{ |it| it.soundSynth.set( \ampmin, 0.1, \ampmax, 1, \ampInMin, 0.00025, \ampInMax, 0.2, \freqOutMin, 75, \freqOutMax, 200, \ratemin, 1, \ratemax, 40 ) };

~switchQuake.value(2);
~quakePlayers[1].do{ |it| it.waveSynth.set( \rate, 5, \attack, 0.05, \release, 0.2 ) };
~quakePlayers[1].do{ |it| it.soundSynth.set( \ampmin, 0.1, \ampmax, 1, \ampInMin, 0.00025, \ampInMax, 0.2, \freqOutMin, 75, \freqOutMax, 200, \ratemin, 1, \ratemax, 40 ) };

~switchQuake.value(3);
~quakePlayers[2].do{ |it| it.waveSynth.set( \rate, 5, \attack, 0.05, \release, 0.2 ) };
~quakePlayers[2].do{ |it| it.soundSynth.set( \ampmin, 0.1, \ampmax, 1, \ampInMin, 0.00025, \ampInMax, 0.2, \freqOutMin, 75, \freqOutMax, 200, \ratemin, 1, \ratemax, 40 ) };

~switchQuake.value(4);
~quakePlayers[3].do{ |it| it.waveSynth.set( \rate, 5, \attack, 0.05, \release, 0.2 ) };
~quakePlayers[3].do{ |it| it.soundSynth.set( \ampmin, 0.1, \ampmax, 1, \ampInMin, 0.00025, \ampInMax, 0.2, \freqOutMin, 75, \freqOutMax, 200, \ratemin, 1, \ratemax, 40 ) };

~switchQuake.value(5);
~quakePlayers[4].do{ |it| it.waveSynth.set( \rate, 5, \attack, 0.05, \release, 0.2 ) };
~quakePlayers[4].do{ |it| it.soundSynth.set( \ampmin, 0.1, \ampmax, 1, \ampInMin, 0.00025, \ampInMax, 0.2, \freqOutMin, 75, \freqOutMax, 200, \ratemin, 1, \ratemax, 40 ) };

~switchQuake.value(6);
~quakePlayers[5].do{ |it| it.waveSynth.set( \rate, 5, \attack, 0.05, \release, 0.2 ) };
~quakePlayers[5].do{ |it| it.soundSynth.set( \ampmin, 0.1, \ampmax, 1, \ampInMin, 0.00025, \ampInMax, 0.2, \freqOutMin, 75, \freqOutMax, 200, \ratemin, 1, \ratemax, 40 ) };

~switchQuake.value(7);
~quakePlayers[6].do{ |it| it.waveSynth.set( \rate, 5, \attack, 0.05, \release, 0.2 ) };
~quakePlayers[6].do{ |it| it.soundSynth.set( \ampmin, 0.1, \ampmax, 1, \ampInMin, 0.00025, \ampInMax, 0.2, \freqOutMin, 75, \freqOutMax, 200, \ratemin, 1, \ratemax, 40 ) };



~switchQuake.value(8);
~quakePlayers[7].do{ |it| it.waveSynth.set( \rate, 5, \attack, 0.05, \release, 0.2 ) };
~quakePlayers[7].do{ |it| it.soundSynth.set( \ampmin, 0.1, \ampmax, 1, \ampInMin, 0.00025, \ampInMax, 0.2, \freqOutMin, 75, \freqOutMax, 200, \ratemin, 1, \ratemax, 40 ) };


~switchQuake.value(9);
~quakePlayers[8].do{ |it| it.waveSynth.set( \rate, 5, \attack, 0.05, \release, 0.2 ) };
~quakePlayers[8].do{ |it| it.soundSynth.set( \ampmin, 0.1, \ampmax, 1, \ampInMin, 0.00025, \ampInMax, 0.2, \freqOutMin, 75, \freqOutMax, 200, \ratemin, 1, \ratemax, 40 ) };


~switchQuake.value(10);
~quakePlayers[9].do{ |it| it.waveSynth.set( \rate, 5, \attack, 0.05, \release, 0.2 ) };
~quakePlayers[9].do{ |it| it.soundSynth.set( \ampmin, 0.1, \ampmax, 1, \ampInMin, 0.00025, \ampInMax, 0.2, \freqOutMin, 75, \freqOutMax, 200, \ratemin, 1, \ratemax, 40 ) };

~switchQuake.value(11);
~quakePlayers[10].do{ |it| it.waveSynth.set( \rate, 5, \attack, 0.05, \release, 0.2 ) };
~quakePlayers[10].do{ |it| it.soundSynth.set( \ampmin, 0.1, \ampmax, 1, \ampInMin, 0.00025, \ampInMax, 0.2, \freqOutMin, 75, \freqOutMax, 200, \ratemin, 1, \ratemax, 40 ) };

~switchQuake.value(12);
~quakePlayers[11].do{ |it| it.waveSynth.set( \rate, 5, \attack, 0.05, \release, 0.2 ) };
~quakePlayers[11].do{ |it| it.soundSynth.set( \ampmin, 0.1, \ampmax, 1, \ampInMin, 0.00025, \ampInMax, 0.2, \freqOutMin, 75, \freqOutMax, 200, \ratemin, 1, \ratemax, 40 ) };

~switchQuake.value(13);
~quakePlayers[12].do{ |it| it.waveSynth.set( \rate, 5, \attack, 0.05, \release, 0.2 ) };
~quakePlayers[12].do{ |it| it.soundSynth.set( \ampmin, 0.1, \ampmax, 1, \ampInMin, 0.00025, \ampInMax, 0.2, \freqOutMin, 75, \freqOutMax, 200, \ratemin, 1, \ratemax, 40 ) };


	out=0, freq=100, rate=10, amp=0.4, dur=0.1,
	ampmin=0.01, ampmax=10, ampInMin=0.01, ampInMax=1,
	rateInMin=0.2, rateInMax=8, ratemin=0.5, ratemax=20,
	freqInMin=0.2, freqInMax=8, freqOutMin=50, freqOutMax=200, freqRatio = 1,

s.sendMsg( "/g_dumpTree", 0, 1 );

Tdef( \countTime ).reset.play;

~switchQuake.value(2);
~quakes[ 1 ].stationInfo.do{ |it| it.waveSynth.set( \rate, 10 ) }; Tdef( \countTime ).reset.play;

~switchQuake.value(3);
~quakes[ 2 ].stationInfo.do{ |it| it.waveSynth.set( \rate, 10 ) }; Tdef( \countTime ).reset.play;

~switchQuake.value(4);
~quakes[ 3 ].stationInfo.do{ |it| it.waveSynth.set( \rate, 10 ) }; Tdef( \countTime ).reset.play;

~switchQuake.value(5);
~quakes[ 4 ].stationInfo.do{ |it| it.waveSynth.set( \rate, 10 ) }; Tdef( \countTime ).reset.play;

~switchQuake.value(6);
~quakes[ 5 ].stationInfo.do{ |it| it.waveSynth.set( \rate, 10 ) }; Tdef( \countTime ).reset.play;

~switchQuake.value(7);
~quakes[ 6 ].stationInfo.do{ |it| it.waveSynth.set( \rate, 10 ) }; Tdef( \countTime ).reset.play;

~switchQuake.value(8);
~quakes[ 7 ].stationInfo.do{ |it| it.waveSynth.set( \rate, 10 ) }; Tdef( \countTime ).reset.play;

~switchQuake.value(9);
~quakes[ 8 ].stationInfo.do{ |it| it.waveSynth.set( \rate, 10 ) }; Tdef( \countTime ).reset.play;

~switchQuake.value(10);
~quakes[ 9 ].stationInfo.do{ |it| it.waveSynth.set( \rate, 10 ) }; Tdef( \countTime ).reset.play;

~switchQuake.value(11);
~quakes[ 10 ].stationInfo.do{ |it| it.waveSynth.set( \rate, 10 ) }; Tdef( \countTime ).reset.play;


~switchQuake.value(12);
~quakes[ 11 ].stationInfo.do{ |it| it.waveSynth.set( \rate, 10 ) }; Tdef( \countTime ).reset.play;

~switchQuake.value(13);
~quakes[ 12 ].stationInfo.do{ |it| it.waveSynth.set( \rate, 10 ) }; Tdef( \countTime ).reset.play;



Tdef( \countTime, { inf.do{ |i| i.postln; 1.wait; } } );
Tdef( \countTime ).play;

Tdef( \countTime ).stop;

~quakes[ 0 ].stationInfo.do{ |it| it.waveSynth.postln; };

~quakes.do{ |it,i| [ i , PathName( it.basePath ).folderName ].postln; }