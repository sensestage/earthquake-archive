~switchQuake.value(0);

~switchQuake.value(1);
~quakePlayers[0].do{ |it| it.waveSynth.set( \rate, 10 ) };
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