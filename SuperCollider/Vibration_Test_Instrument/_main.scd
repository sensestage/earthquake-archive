s = Server.default;

~onbela = true;

if (~onbela) {
	s.options.numAnalogInChannels = 8;
	s.options.numAnalogOutChannels = 8;
	s.options.numDigitalChannels = 16;
	s.options.blockSize = 16;
	s.options.numInputBusChannels = 2;
	s.options.numOutputBusChannels = 2;
};

s.waitForBoot({
q = {
	var sig, analogin, impulse, envgen, dur, tickfreq;
	dur = [0.2, 0.4];
	envgen = [0,0];
	sig=[0,0];
	tickfreq = [1, 1];
	analogin = [0,0,0];
	analogin[0] = AnalogInput.ar( DC.ar(0));
	analogin[1] = AnalogInput.ar( DC.ar(1));
	analogin[2] = AnalogInput.ar( DC.ar(2));
	tickfreq[0] = (analogin[1] * 10) + 0.5;
	tickfreq[1] = (analogin[2] * 20) + 0.5;
	impulse = Impulse.ar([tickfreq[0], tickfreq[1]]);
	envgen[0] = EnvGen.ar(Env.perc(0.01, dur[0]), gate: impulse[0]);
	envgen[1] = EnvGen.ar(Env.sine(dur[1]), gate: impulse[1]);

	sig[0] = SinOsc.ar(10 + (analogin[0] * 1000)).range(0, 1.0); // Analog Outputs output signals 0-1
	sig[0] = sig[0] * envgen[0];

	sig[1] = SinOsc.ar(10 + (analogin[0] * 1000)).range(0, 1.0); // Analog Outputs output signals 0-1
	sig[1] = sig[1] * envgen[1];


	AnalogOutput.ar( DC.ar(1), LeakDC.ar(sig[0]) * 0.95); // scale by 0.95 to remove rail distortion
	AnalogOutput.ar( DC.ar(0), LeakDC.ar(sig[1]) * 0.95); // scale by 0.95 to remove rail distortion
}.play(target: s);
});
