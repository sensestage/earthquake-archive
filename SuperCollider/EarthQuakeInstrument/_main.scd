s = Server.default;

s.options.numAnalogInChannels = 8;
s.options.numAnalogOutChannels = 8;
s.options.numDigitalChannels = 16;

s.options.blockSize = 16;
s.options.numInputBusChannels = 2;
s.options.numOutputBusChannels = 10;
s.options.dacLevel = 0;

s.options.maxLogins = 5; // multiple logins ensures that you can connect to/from your host computer without problem multiple times.

// s.options.postln;

~mypath = "".resolveRelative;

(~mypath +/+ "earthquakedata.scd").load;

// s.boot;

s.waitForBoot({

	(~mypath +/+ "synthdefs.scd").load;
	(~mypath +/+ "oscdefs.scd").load;
	s.sync;
	(~mypath +/+ "plumbing.scd").load;




});