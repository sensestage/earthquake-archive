function SeisSound(inputdata,directory,titleit,starttime,endtime,filt_low,filt_high, ... 
    ff_max,units,dtype,speed_factor,ColorBar_Upper_Limit, ColorBar_Lower_Limit,FramesPerSecond)

%-----------------------------------------
%
% Description of input parameters
%
%    1. inputdata - The name of your data file (must be in SAC format) 
%    2. directory - The name of the folder where your data resides; the images and
%                audio will be stored in this directory as well.
%    3. titleit - Text used for top title 
%    4. starttime - Time in seconds for seismogram start (need not be start time of data)
%    5. endtime - Time in seconds of seismogram end (need not be end time of data)
%    6. filt_low - Lower band limit if data filtering is requested (for low-pass only or no filter use -999)
%    7. filt_high - High band limit if data filtering is requested (for high-pass only or no filter use -999)
%    8. ff_max - Enforced maximum frequency for the spectragram (use -999 to display all available frequencies)
%    9. units - Units for seismograms y-axis label (e.g., cm/s or cm/s/s). 
%	       Use -999 to not specify units.
%    10. dtype - data type (e.g., displacement, velocity or acceleration ) 
%	       Use -999 to default to the data type specified in the SAC file (i.e., hdr.descrip.idep).
%    11. speed_factor - Audio file scale factor
%    12. ColorBar_Upper_Limit - The upper limit of the color bar of the spectrogram.
%    13. ColorBar_Lower_Limit - The lower limit of the color bar of the spectrogram.
%    14. FramesPerSecond - The frame per second rate you plan to use in your final SeisSound movie,
%              this parameter will determine the number of images generated.  Use -999 to let the 
%              program select the rate for you.
%
%  Examples of how to call this function
%
%    SeisSound('BK.PKD.HHT.SAC','../Denali_2002_at_Parkfield','2002 Mw7.8 Denali earthquake triggered tremor at Parkfield, CA; Station: BK.PKD',...
%               300,1800,2,8,25,' ',' ',500,0,-80,-999);
%    SeisSound('BK.PKD.HHT.SAC','../Japan_03112011_PKD','Data from Japan Quake',500,3000,0.5,-inf,25,' ',' ',100);
%    SeisSound('QCN_samp.SAC','../QCN_samp','Data from the QCN network',0,20,0.5,-inf,-999,'','',4);
%    SeisSound('20090324112420.AZ.TRO.HHZ.sac','../SaltonSeaSwarm','Data from the Salton Sea Swarm',1000,15500,.5,10,48,' ');
%    SeisSound('20100404224000.AZ.CPE.HHZ.sac','../Baja_April_2010','Data from the Baja Quake 2010',50,250,10,20,-999,' ',' ',50);
%
% You will also need the following Matlab scripts to be in the same directory as the SeisSound.m program
%    - main_tremor
%    - loaddata.m
%    - fget_sac.m
%    - sac2wav.m
%    - sac.m
%    - linex.m
%    - sachdr.m
%
%  After rendering the audio file and images, use QuickTime pro to create a
%  .mov file. Be sure to set the frames per second of the images to be the
%  same value of variable FramesPerSecond from SeisSound.
%
%  Additional information can be obtained from the SRL article by Kilb et al., titled:
%    Listen, Watch, Learn: SeisSound Video products
%-----------------------------------------

format compact

%-----------------------------------------
%
%  Display input values and define default parameters if needed
%
%-----------------------------------------

   if nargin < 1, inputdata = 'BK.PKD.HHT.SAC'; end
   if nargin < 2, directory = '../Denali_2002_at_Parkfield';end
   if nargin < 3, titleit = ['Data from ',inputdata]; end
   if nargin < 4, starttime = -999; end
   if nargin < 5, endtime = -999; end
   if nargin < 6, filt_low = 0.5; end
   if nargin < 7, filt_high = -inf; end
   if nargin < 8, ff_max = -999; end
   if nargin < 9, units = ''; end
   if nargin < 10, dtype = ''; end
   if nargin < 11, speed_factor = 100; end
   if nargin < 12, ColorBar_Upper_Limit = 0; end
   if nargin < 13, ColorBar_Lower_Limit = -80; end
   if nargin < 14, FramesPerSecond = -999; end
%
    if filt_low == -999, filt_low = 0.5; end
    if filt_high == -999, filt_high = -inf; end
%
   disp('~~~~~~~ INPUT PARAMETERS ~~~~~~~')
   disp(['inputdata: ',inputdata]);
   disp(['directory: ',directory]);
   disp(['titleit: ',titleit]);
   disp(['starttime=',num2str(starttime)]);
   disp(['endtime=',num2str(endtime)])
   disp(['filt_low=',num2str(filt_low)]),
   disp(['filt_high=',num2str(filt_high)]),
   disp(['ff_max=',num2str(ff_max)]),
   disp(['units: ',units]),
   disp(['dtype: ',dtype]),
   disp(['speed_factor=',num2str(speed_factor)])
   disp(['ColorBar_Upper_Limit=',num2str(ColorBar_Upper_Limit)])
   disp(['ColorBar_Lower_Limit=',num2str(ColorBar_Lower_Limit)])
   disp(['FramesPerSecond=',num2str(FramesPerSecond)])
   disp('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~')
  
   audiofile=strcat(directory,'/Audio/',inputdata,'.wav');
   filename = strcat(directory,'/',inputdata);
   
%-----------------------------------------
%
%  Define static parameters
%
%-----------------------------------------
    %scale = 5.0;
    scale = 1.0;
    icount=99;
    nfft = 128;
    %nfft = 128;
    if ff_max > 0
       freq_zoom = 1;
       ff_min = 0;
    else
       freq_zoom = 0;
    end

    FramesPerSec_options = [1 2 6 10 12 15 25 30 50 60];

    Plot1_Length = 0.75;
    Plot1_Height = 0.25;
    Plot1_Xposition = 0.10;
    Plot1_Yposition = 0.65;

    Plot2_Length = 0.75;
    Plot2_Height = 0.25;
    Plot2_Xposition = 0.10;
    Plot2_Yposition = 0.40;

    Plot3_Length = 0.75;
    Plot3_Height = 0.25;
    Plot3_Xposition = 0.10;
    Plot3_Yposition = 0.15;

%---------------------------------------
%
% Create Necessary Folders
%
%---------------------------------------

    fileRenderName = [ directory '/Images/image'];
    if ~exist(filename,'dir')
        string_mkdir = ['mkdir ' directory];
        system([string_mkdir '/Audio']);
        system([string_mkdir '/Images']);
    end

%---------------------------------------------
%
% Read in SAC Data
%
%---------------------------------------------

     [time,data,hdr] = fget_sac(filename);
     delta=hdr.times.delta;
     Nf = 1/(2*delta);
     mag = hdr.event.mag;
     %if mag>0
     %   titleit = [titleit,' magnitude=',num2str(mag)];
     %end
     if endtime==-999, endtime=hdr.times.e; end
     if starttime==-999, starttime = hdr.times.b; end
     if (hdr.times.e < endtime), endtime = hdr.times.e;end
     if (hdr.times.b > starttime), starttime = hdr.times.b;end

%---------------------------------------------
%
%  If title is long split it into two lines
%
%---------------------------------------------

    twolines = 0;
    if length(titleit)>40
       iblank=find(isspace(titleit));
       ipick = ceil(length(iblank)/2);
       ipart = iblank(ipick);
       top = titleit(1:ipart); 
       bot = titleit(ipart+1:length(titleit));
       twolines = 1;
    end

%---------------------------------------------
%
%  Use the IDEP variable to determine the data type if not already specified.
%      1 == IUNKN (Unknown)
%      2 == IDISP (Displacement in nm)
%      3 == IVEL (Velocity in nm/sec)
%      4 == IVOLTS (Velocity in volts)
%      5 == IACC (Acceleration in nm/sec/sec)
%
%  To avoid inconsistencies, if units are not assigned none are displayed.
%
%---------------------------------------------

     if length(dtype)<=1
        if (hdr.descrip.idep == 1)
           dtype='';        
        elseif (hdr.descrip.idep == 2)
           dtype='Displacement';        
        elseif (hdr.descrip.idep == 3)
           dtype='Velocity';        
        elseif (hdr.descrip.idep == 4)
           dtype='Velocity';        
        elseif (hdr.descrip.idep == 5)
           dtype='Acceleration';        
        else
           dtype='';
        end
     end
     ylabelfull = [dtype,' ',units];

%---------------------------------------------
%
%  Filter the data as requested:
%      input: data, time
%      output: databp, timebp
%  Also, to see more detail in the spectrogram we apply a 0.5 hz high-pass filter.
%  This high-pass-filter is used for plotting the spectrogram & creating the audio file
%      input: data, time
%      output: datahp1, timehp1
%
%---------------------------------------------

     if isinf(filt_low)
        disp(['Filtering data: High Pass at ',num2str(filt_high),' Hz']);
     elseif isinf(filt_high)
        disp(['Filtering data: Low Pass at ',num2str(filt_low),' Hz']);
     else
        disp(['Filtering data: ',num2str(filt_low),' to ',num2str(filt_high),' Hz']);
     end
     databp = eqfiltfilt(data,filt_low,filt_high,hdr.times.delta,4);
     timebp = time;

     hp1exists = 1;
     %datahp1=eqfiltfilt(data,0.5,-inf,hdr.times.delta,4);
     datahp1=eqfiltfilt(data,0.01,-inf,hdr.times.delta,4);
     timehp1 = time;

%--------------------------------------------
%
% Generate Audio File
%
%   It is important to normalize the data to be <1 and >-1:
%        data_wave_norm = data_wav/max(abs(data_wav)*1.0001);
%   before calling the MATLAB wavwrite program to avoid warnings 
%   about data clipping of the form ???Warning: Data clipped during
%   write to file???. 
% 
% An alternative way to accomplish this is to use this command
%    sac2wav(filename, audiofile, speed_factor, scale, starttime, endtime);
%
%--------------------------------------------

    max_datahp1 = max(datahp1(time>=starttime & time<=endtime));
    data_wav = datahp1(time>=starttime & time<=endtime)./max_datahp1.*scale;
    nsamp = 1/hdr.times.delta;
    FS = floor(nsamp*speed_factor);
    NBITS = 16;
    data_wave_norm = data_wav/max(abs(data_wav)*1.0001);
    audiowrite(audiofile,data_wave_norm,FS);
    [wave, fs] =audioread(audiofile);
    [M,N]=size(wave);
    soundLength = M/fs;
    if soundLength<1
       disp('ERROR -- soundLength<1. Terminating.')
       keyboard
    end

%--------------------------------------------
%
%  To be in sync with the sound file, define the number of frames to be generated 
%
%--------------------------------------------

    FramesWant = 200;
    if FramesPerSecond < 0
       for k=1:length( FramesPerSec_options )
           ntest(k) = soundLength*FramesPerSec_options(k);
       end
       [a,b] = min(abs(ntest-FramesWant));
       FramesPerSecond=FramesPerSec_options(b);
    end
    disp(['FramesPerSecond = ',num2str(FramesPerSecond)]);
    FramesTotal = soundLength*FramesPerSecond;
   
    if FramesTotal>1000
       disp('CAUTION: The total number of frames requested is > 1000')
    end

    [r,c]=find(time<starttime);
    [RowLength1,ColumnLength1]=size(r);

    RowLength1 = max(1,RowLength1);

    [r,c]=find(time<endtime);
    [RowLength2, ColumnLength2] = size(r);
    Timeinterval=RowLength2-RowLength1;
    interval = Timeinterval/(FramesTotal-1);
    interval=round(interval);

%-----------------------------------------
%
% Generate the spectrogram
%
%-----------------------------------------

    window = nfft;
    noverlap = round(nfft*0.5);
%    noverlap = round(nfft*0.75);
    sample_rate = round(1/hdr.times.delta);
    if hp1exists == 1,
        [B,F,T] = specgram(datahp1(RowLength1:RowLength2),nfft,sample_rate,window,noverlap);
    else
        [B,F,T] = specgram(data(RowLength1:RowLength2),nfft,sample_rate,window,noverlap);
    end;
    Bmax = max(max(B));

%---------------------------------------
%
% Create axis labels
%    -- use strrep to force underscore characters to be visible
%
%---------------------------------------
 
    Plot1_Label2 = strrep(inputdata,'_','\_');

    if (filt_high <0),
          Plot2_Label2 = ['High-Pass ' num2str(filt_low) ' Hz'];
    elseif (filt_low < 0 ),
          Plot2_Label2 = ['Low-Pass ' num2str(filt_high) ' Hz'];
    elseif (filt_low > 0 & filt_high > 0 & filt_low<filt_high),
          Plot2_Label2 = ['Band-Pass ' num2str(filt_low) '-' num2str(filt_high) ' Hz'];
    else
          Plot2_Label2 = ['Band-Stop ' num2str(filt_low) '-' num2str(filt_high) ' Hz'];
    end;

    Plot3_Label2 = 'Spectrogram';

    if (freq_zoom), 
       disp(['Restricting maximum frequency in spectrogram to ',...
              num2str(ff_max),' Hz']);
       Plot3_yaxis_upper_limit = ff_max;
    else,
       Plot3_yaxis_upper_limit = max(F);
       ff_max = max(F);
    end;
    max_data = max(abs(data(time>=starttime & time<=endtime)));
    max_databp = max(abs(databp(time>=starttime & time<=endtime)));
    Spectrogram_yaxis = 'Frequency (Hz)';
    Xaxis = ['Time (s), ' num2str(speed_factor) ' times faster than true speed'];

%--------------------------------------
%
%  Create Images
%
%--------------------------------------

   close all
   figure(1);
   for frame=RowLength1:interval:RowLength2+interval;
        clf;
        icount=icount+1;
        set(gcf,'Position',[400,500,800,500], 'PaperPosition', [0.25 2.5 7.0 5.25]);

        subplot 311 % Plot seismogram
	plot(time(RowLength1:RowLength2),data(RowLength1:RowLength2), 'Color', [.8 .8 .8]);
	hold on
	plot(time(RowLength1:frame),data(RowLength1:frame),'Color', [.2 .2 .2]);
	h = linex(time(frame));
        set(h,'Color','magenta','LineWidth',3);
        hold off
        xlim([starttime, endtime]);
	ylim([-1.1 1.1].*max_data);
        set(gca,'Position',[Plot1_Xposition Plot1_Yposition Plot1_Length Plot1_Height])
        set(gca,'XTickLabel',[])
        if twolines==0
           title(titleit, 'FontSize', 15)
        else
           title({top;bot},'FontSize', 15)
        end
        h=ylabel(ylabelfull);
        xx3 = starttime-(endtime-starttime)*0.08;
        set(h,'Position',[xx3   max_data*(-1.0)    1.0001]);
        xposition =(endtime-(endtime-starttime)*0.05);
        yposition1 = (max_data-(max_data/4.5));
        h=text(xposition, yposition1, Plot1_Label2);
        set(h,'HorizontalAlignment','right');

        subplot 312 % Filtered Seismogram
        plot(timebp(RowLength1:RowLength2),databp(RowLength1:RowLength2), 'Color', [.8 .8 .8]);
        hold on
        plot(timebp(RowLength1:frame),databp(RowLength1:frame),'Color', [.2 .2 .2]);
        h = linex(time(frame));
        set(h,'Color','magenta','LineWidth',3);
        hold off
        xlim([starttime,endtime]);
%       ylabel('Amplitude (cm/s/s)');
        ylim([-1.1 1.1].*max_databp);
        xposition =(endtime-(endtime-starttime)*0.05);
        yposition1 = (max_databp-(max_databp/6.0));
        h=text(xposition, yposition1, Plot2_Label2);
        set(h,'HorizontalAlignment','right');
        set(gca,'Position',[Plot2_Xposition Plot2_Yposition Plot2_Length Plot2_Height],'XTickLabel',[]);

        subplot 313 % Spectrogram
        if hp1exists ==1,
            %imagesc(timehp1(RowLength1:RowLength2),F,log10(abs(B./Bmax)).*(10));
            pcolor(T,F,log10(abs(B./Bmax)).*(10)); shading interp;
        else
            %imagesc(time(RowLength1:RowLength2),F,log10(abs(B./Bmax)).*(10));
            pcolor(T,F,log10(abs(B./Bmax)).*(10));
        end;
        %set(gca,'YScale','log');
        caxis([ColorBar_Lower_Limit, ColorBar_Upper_Limit]);
        axis xy,
        colormap(jet);
        hc = colorbar('Location','EastOutside');     
	hold on
        h=linex(time(frame));
        set(h,'Color','magenta','LineWidth',3);
        hold off;
        xlim([starttime,endtime]);
        ylim([0, Plot3_yaxis_upper_limit])
        set(gca,'Position',[Plot3_Xposition Plot3_Yposition Plot3_Length Plot3_Height]);
        a=ylabel(Spectrogram_yaxis);
        set(a, 'Position', [(starttime-(endtime-starttime)*0.075), (Plot3_yaxis_upper_limit*.5), 1], 'FontSize', 12);
        h = xlabel(Xaxis);
        set(h, 'Position', [(starttime+((endtime-starttime)/2)), (0-(Plot3_yaxis_upper_limit/4)), 1], 'FontSize', 12)
        xposition =(endtime-(endtime-starttime)*0.05);
        yposition1 = (Plot3_yaxis_upper_limit-(Plot3_yaxis_upper_limit/5.5));
        h=text(xposition, yposition1, Plot3_Label2);
        set(h,'HorizontalAlignment','right');
        
	if (freq_zoom), ylim([ff_min ff_max]); end
        eval(['print -djpeg100 ' fileRenderName num2str(icount) '.jpg']);
   end
   disp('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~')
   disp(['A series of ',num2str(floor(FramesTotal)),' image frames have been created.']);
   disp(['When assempling your movie please use: ']);
   disp(['     ',num2str(floor(FramesPerSecond)),' frames per second']);
   disp(['This rate will match the audio file that has a ',...
        ' duration of ',num2str(soundLength),' seconds']);
   disp(['']);
   disp(['Audio file: ',filename,'.wav'])
   disp(['Image files: ',directory,'/Images']);
   disp('Render Finished')	
