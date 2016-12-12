t = SemiColonFileReader.readInterpret( "/home/nescivi/git/projects/earthquakes/earthquake-archive/Python/Test-Data/2003-10-24-3.0/wav_norm/pitchtrace.txt" );

t = FileReader.readInterpret( "/home/nescivi/git/projects/earthquakes/earthquake-archive/Python/Test-Data/2003-10-24-3.0/wav_norm/pitchtrace-2003-10-24_01-50-53_NL_WDB4_HHZ.txt", delimiter: $  )

t.flop[1].maxItem.postcs

t.flop[1].collect{ |it| if ( it > 200.0 ){ 0 }{ it } }.plot;

t.flop[1].copyRange( 250, 480 ).plot;

("aubiopitch -i" + inputFile + "-H 64 -B 1024 -p yin > pitchtrace-"++inputFile++".pitch" ).unixCmd;

2003-10-24_01-50-53_NL_WDB4_HHZ.wav  > pitchtrace-2003-10-24_01-50-53_NL_WDB4_HHZ.txt
