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
OSCdef( \changeQuake, { |msg|
	msg.postln;
}, '/changeQuake' );
);

