Nov 15, 2016

Hi Sissel and Jonathan,

I prepared a script for you which you can use to make 'section' plots and to download and convert waveform data to sound. Along with the script there is also included some examples for the last 20 events with magnitude bigger than 2. (see attached file fdsn2wavplot)

The script is quite auto-explicative. It only requires Python and ObsPy 1.0. Take a look at the first part, where you can configure some options (it is important to put your user email for the data portal). Later in the script, you can also change the options to select the earthquakes and the plotting options (size, color, etc.).

Regarding the sound, I convert it to sound using the ObsPy function to write in .WAV. You can play with the samplerate to make it longer or shorter. The result (.wav files) should be edited with an Audio Editor (i.e.: Audacity) in order to amply the signal, if not it is too low. I suggest playing with the editor to get want you want.

In addition, I attached another file (sound_old) with the things we provided to you last time we met (there are some links, examples, and videos).

I hope this will be useful! Good luck with the final preparation of the exposition!

Cheers,
Jordi
