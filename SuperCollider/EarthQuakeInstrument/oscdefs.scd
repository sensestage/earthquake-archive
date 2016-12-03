(
OSCdef( \playQuakeSignal, { |msg|
	msg.postln;
}, '/toggleMode' );
);

(
OSCdef( \changeModeButton, { |msg|
	msg.postln;
}, '/changeMode' );
);

(
~currentQuake = 0;
OSCdef( \changeQuake, { |msg|
	msg.postln;
	if ( msg[3] != ~currentQuake ){
		~switchQuake.value( msg[3] );
		~currentQuake = msg[3];
	};
}, '/changeQuake' );
);

~switchQuake = { |v| "quake switch to ".post; v.postln; };
