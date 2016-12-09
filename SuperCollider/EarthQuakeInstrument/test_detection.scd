~testSignal2 = Synth.new( \testSignal2, [ \out,1 ] );

(
~switchQuake = { |v|
	var rate = ((v-6) > 0).binaryValue * 5 + 5;
	~testSignal2.set( \out, ~spOrder.at( v%6 ), \rate, rate );
};
);

// ~switchQuake.value(12)