s = Server.default;

s.options.numAnalogInChannels = 8;
s.options.numAnalogOutChannels = 8;
s.options.numDigitalChannels = 16;
s.options.dacLevel = 0;
s.options.blockSize = 16;

s.options.numInputBusChannels = 2;
s.options.numOutputBusChannels = 10;

s.options.maxLogins = 5; // multiple logins ensures that you can connect to/from your host computer without problem multiple times.

// s.options.postln;

~mypath = "".resolveRelative;

~spOrder = [7,4,6,5,2,3];

(~mypath +/+ "earthquakedata.scd").load;

// s.boot;

s.waitForBoot({

	(~mypath +/+ "synthdefs.scd").load;
	s.sync;
	(~mypath +/+ "plumbing.scd").load;
	s.sync;
	(~mypath +/+ "earthquake_waves.scd").load; // the actual earthquake waves
	// (~mypath +/+ "test_detection.scd").load; // to test the detection of signals

	(~mypath +/+ "oscdefs.scd").load;

});