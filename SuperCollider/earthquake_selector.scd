/*
Possible setups:

* All earthquakes are playing, but some are muted. The selector turns an earthquake on. Is more intensive in terms of processing needed
* One earthquake set is playing, selector switches the buffer. This may need one overlap for nice crossfading.
* As above, but some of the logic happening on the language side. Needs OSC communication back/forth

*/

// sizes:
[ 7, 11, 1, 5, 3, 1, 4, 11, 3, 11, 8, 2, 4, 9, 9, 11, 10, 12, 16, 19 ]
//~quakes.size
[ 7, 11, 5, 4, 11, 3, 11, 8, 4, 9, 9, 11, 10, 12, 16, 19 ].size


(
SynthDef( \quakeSelector, { |out,inbus|
	// var quake = DigitalIn.kr( [2, 3, 4, 5], [1,2,4,8] ).sum; // on bela
	var quake = (In.kr( inbus, 4 ) * [1,2,4,8]).sum;
	var bufferCounts = \bufferCountIn.kr( [ 1,2,3,4,  5,6,7,8,  9,10,11,12,  13,14,15,16 ] ); // how many buffers each set has
	Select.kr( quake, bufferCounts ).poll;
}).send(s);
);

// testing
b = Bus.control( s, 4 );

a = Synth.new( \quakeSelector, [\inbus, b ] );
b.setn( [0,0,0,1] );
b.setn( [1,1,1,1] );
b.setn( [0,1,0,1] );

a.free;
