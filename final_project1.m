% First stage 'Transmitter':
[y,fs]=audioread('song.MP3');               %read the audio file
N_sec=8;                                    %number of seconds played
y=y(1:N_sec*fs);                            %trimming the specified part of song
clear sound;sound(y,fs);                    %play the song

%Plot the sound file in time domain 
t=linspace(0,N_sec,N_sec*fs);
figure;
subplot(2,1,1);
plot(t,y);
title('Signal in time domain');

%Plot the sound file in frequency domain
N=length(y);                                %Number of samples
Y=abs(fftshift(fft(y)));                    %transfer to frequency domain
fvec=linspace(-fs/2,fs/2,N);                %frequency range
subplot(2,1,2);
plot(fvec,Y);
title('Signal in frequency domain');

% Second Stage 'Channel':
channel=[];
channel= [channel menu('choose your signal','delta','ExpOne','ExpTwo','chimpresp')];    %channel menu
t_conv=linspace(0,1,fs);                      %Time range of impulse function
t_channel=linspace(0,N_sec+1,(N_sec+1)*fs-1); %Time range of the result
switch channel
    case 1
        delta=[1 zeros(1,fs-1)];              %delta function
        y_channel=conv(y,delta);              %Convultion with input
        figure;plot(t_channel,y_channel);title('Channel 1');
        clear sound;sound(y_channel,fs);
    case 2
        ExpOne=exp(-2*pi*5000*t_conv);        %first exponential function
        y_channel=conv(y,ExpOne);             %Convultion with input
        figure;plot(t_channel,y_channel);title('Channel 2');
        clear sound;sound(y_channel,fs);
    case 3
        ExpTwo=exp(-2*pi*1000*t_conv);         %second exponential function 
        y_channel=conv(y,ExpTwo);              %Convultion with input
        figure;plot(t_channel,y_channel);title('Channel 3');
        clear sound;sound(y_channel,fs);
    case 4
        chimpresp=[2 zeros(1,1*fs-2) 0.5];      %Required Impulse function
        y_channel=conv(chimpresp,y);            %Convultion with input
        figure;plot(t_channel,y_channel);title('Channel 4');
        clear sound;sound(y_channel,fs);
end

% Third Stage 'Noise':
Sigma=input('Enter the standard deviation (noise level)*Preferred <0.1: ');
Z=Sigma*randn(1,length(y_channel));           %standard deviation
y_noise=y_channel+Z;                          %adding noise

%Play the sound after adding noise
clear sound;sound(y_noise,fs);
%Plot the sound file in time domain 
figure;
subplot(2,1,1);
plot(t_channel,y_noise);
title('Signal with noise in time domain');
%Plot the sound file in frequency domain
N2=length(y_noise);                           %number of samples
fvec=linspace(-fs/2,fs/2,N2);                 %frequency range
y_freq2=fftshift(fft(y_noise));               %transfer to frequency domain
y_fpolt=abs(y_freq2);                         %taking absolute to plot the magnitude of signal 
subplot(2,1,2);
plot(fvec,y_fpolt);
title('Signal with noise in frequency domain');

% Fourth Stage 'Reciever':
spH=length(y_freq2)/fs;                       %samples_per_Hz
frequency = input('Cut off frequency of filter(default=3400Hz): '); %input from user
%construct an ideal low pass filter which has a cut off of 3.4 KHz
f_cut=uint32(((fs/2)-frequency)*spH);         %specifing range of frequency to cut
y_freq2([1:f_cut end-f_cut+1:end])=0;         %trimming specified number of samples
figure;
subplot(2,1,2);
y_fplot2=abs(y_freq2);                        %taking absolute to plot the magnitude of signal 
plot(fvec,y_fplot2);
title('Signal in frequency domain after filteration');
y_filter=real(ifft(ifftshift(y_freq2)));      %Transfer back to time domain (after filtering)
subplot(2,1,1);
plot(t_channel,y_filter);ylim([-1 1]);
title('Signal in time domain after filteration');
clear sound;sound(y_filter,fs);