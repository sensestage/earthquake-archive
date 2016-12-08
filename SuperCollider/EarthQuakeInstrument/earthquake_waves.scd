(// read buffers:
~quakes.do{ |jt,j|
	jt.stationsSortedByDistance.do{ |it,i|
		var indexOfAmp = jt.stationInfo.at( it ).waveAmplitudes.collect{ |it| it[1] }.maxIndex;
		// [ j, i ].postln;
		jt.stationInfo.at( it ).loadBuffer( s, indexOfAmp );
		jt.stationInfo.at( it ).loadPitchBuffer( s, indexOfAmp );
	};
}
);

~quakes[0].dump;

// function to play an earthquake
(
~playQuake = { |qid|
	~quakes[ qid ].stationsSortedByDistance.do{ |it,i|
		~quakes[ qid ].stationInfo.at( it ).playOne( s, ~spOrder[i], \waveplayer, \pulseenv );
	}
};
);

(
~stopQuake = { |qid|
	~quakes[ qid ].stationInfo.do{ |it| it.stopOne };
}
);

~lastQuake = 0;
~switchQuake = { |v|
	"quake switch to ".post; v.postln;
	~stopQuake.value( ~lastQuake );
	~playQuake.value( v );
	~lastQuake = v;
};
