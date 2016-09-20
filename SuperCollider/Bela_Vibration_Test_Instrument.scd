
/**********************************
Vibration Instrument

3 input potentiometers.

Two audio outputs.

Todo: Put this on the Bela for Sissel to play with...

********************************/


/*
ABOUT THE STARTUP FLAGS: The -u flag tells it which UDP port to listen on, and with the -z flag we choose scsynth's internal blocksize. We need to do this because scsynth's default internal buffer size (64) is bigger than the hardware buffer size (16), so dividing hardware by internal returned 0 buffers per callback. To make it run, you need to add the command-line argument "-z 16" (or presumably make the hardware buffer size bigger).

The startup flag -J defines how many analog input channels will be enabled, the startup flag -K how many analog output channels will be enabled, the startup flag -G how many digital channels will be enabled; by default all are set to 0.

> scsynth -u 57110 -z 16 -J 2 -K 2 -G 0 -i 0 -o 2
*/
// See ServerOptions.asOptionsString for constructing options strings
~args = "-u 57110 -z 16 -J 8 -K 8 -G 0 -i 2 -o 2";
~scriptdir = "/Volumes/Store/Box/DEV/Bela/Bela/scripts";
~startcmd = ~scriptdir +/+ "scsynth.sh start -c" + ~args; // Using Guilio's startup script
~startcmd;
~startcmd.unixCmd({}, true);

s = Server("belaServer", NetAddr("192.168.7.2", 57110));

// These commands are necessary to connect the running sclang to the server
// These are not done when you boot scsynth directly from the command line
s.initTree;
s.startAliveThread;
s.dumpOSC; // tell the server to dump its OSC communications to the term

"ssh root@192.168.7.2 cat /proc/xenomai/stat".unixCmd; // Get the status of the Bela


(
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


	AnalogOutput.ar( DC.ar(1), sig[0] * 0.95); // scale by 0.95 to remove rail distortion
	AnalogOutput.ar( DC.ar(0), sig[1] * 0.95); // scale by 0.95 to remove rail distortion
}.play(target: s);
);

q.free;






