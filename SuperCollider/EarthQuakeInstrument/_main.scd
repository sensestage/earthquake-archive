s = Server.default;

// Configuring the Bela to enable these channels as analog ins and outs.
s.options.numAnalogInChannels = 8;
s.options.numAnalogOutChannels = 8;
s.options.numDigitalChannels = 16;
s.options.dacLevel = 0;
s.options.blockSize = 16;

// Configuring SuperCollider to detect INs and OUTs
s.options.numInputBusChannels = 2;
s.options.numOutputBusChannels = 10;

s.options.maxLogins = 5; // multiple logins ensures that you can connect to/from your host computer without problem multiple times.

// s.options.postln;

~mypath = "".resolveRelative;

// ~spOrder = [7,4, 6,5, 2,3];

~spAmps = [ 1,1, 1,1, 1,1 ]; // adjust here for different amplitudes

(
~spOrders = [
	[7,4, 6,5, 2,3],
	[4,7, 5,6, 2,3],
	[6,5, 4,7, 2,3],
	[5,6, 7,4, 2,3],

	[2,3, 6,5, 7,4],
	[3,2, 5,6, 7,4],
	[2,3, 4,7, 6,5],
	[3,2, 7,4, 6,5],

	[6,7, 5,4, 2,3],
	[5,7, 6,4, 2,3],
	[6,2, 5,7, 4,3],
	[5,3, 7,6, 4,2]
];
);

(~mypath +/+ "earthquakedata.scd").load;

// s.boot;

s.waitForBoot({

	(~mypath +/+ "synthdefs.scd").load;
	s.sync;
	(~mypath +/+ "plumbing.scd").load;
	s.sync;
	(~mypath +/+ "earthquake_waves.scd").load; // the actual earthquake waves
	// (~mypath +/+ "test_detection.scd").load; // to test the detection of signals
	5.0.wait;
	(~mypath +/+ "oscdefs.scd").load;

});