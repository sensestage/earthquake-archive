~testSignal2 = Synth.new( \testSignal2, [ \out,1 ] );

(
~switchQuake = { |v|
	var rate = ((v-6) > 0).binaryValue * 5 + 5;
	var speaker = if ( v  == 0 ){ 0 }{ ~spOrder.at( (v-1)%6 ) };
	~testSignal2.set( \out, speaker, \rate, rate );
};
);

// ~switchQuake.value(12)