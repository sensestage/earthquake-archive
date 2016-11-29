function sac2wav(sacfile,speed_factor,scale,t1,t2)
% function sac2wav(sacfile,wavfile,speed_factor,scale,t1,t2)
% matlab function to convert the SAC data into
% sound waves using matlab's wavewrite program
% need fget_sac program, which can be downloaded from
% the MatSAC package by zpeng at http://geophysics.eas.gatech.edu/people/zpeng/Teaching/MatSAC.tar.gz
% written by Zhigang Peng at GT (zpeng@gatech.edu)
% modifed from the code sent by Debi Kilb at UCSD (dkilb@epicenter.ucsd.edu)
% last updated by zpeng, Sun Feb 20 22:44:30 EST 2011

if nargin < 5, t2 = 2000; end
if nargin < 4, t1 = 0; end
if nargin < 3, scale = 1.2; end
if nargin < 2, speed_factor = 500; end
if nargin < 1, sacfile = 'BP.GHIB.DP1.SAC'; end

wavfile = [sacfile,'.wav'];

[time,data,SAChdr] = fget_sac(sacfile);

delta = SAChdr.times.delta; 
% sampling rate
nsamp = 1/delta;

% remean
data = data - mean(data);
% normalize by the maximum amplitude
% cut the data
data = data(time>=t1 & time <=t2);

max_data = max(abs(data));
data = data./max_data.*scale;
FS = floor(nsamp*speed_factor);
NBITS = 16;
% some default values
wavwrite(data,FS,NBITS,wavfile);
% test wavread
% [Y,FS,NBITS]=wavread(wavefile);
