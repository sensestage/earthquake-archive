// mode change - start / stop test signal
~resetBus = Bus.control(s,1);
~testSignal = Synth.newPaused( \testSignal, [ \resetbus, ~resetBus ] );
~modeSelector = Synth.new( \modeSelector, [\nodeid, ~testSignal.nodeID, \outbus, ~resetBus] );

// quake selection

~quakeSelector = Synth.new( \quakeSelector );

