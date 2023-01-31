% Read audio files
clc;
clear;
[y,fs] = audioread('fly.mp3');
y =y(:,1) + y(:,2);
% Plot signal in time domain
 N = size(y,1);
t = (0:N-1)/fs;
figure(1);
subplot(3,1,1);
plot(t,y);
title(" modulating signal in time domain");
xlabel('Time(s)');
ylabel('Amplitude ');

%% 
%  Frequency domain
% Plot signal in frequency domain
freq_y= fft(y);
dfs=fs/length(y);
fre_range=-fs/2:dfs:fs/2-dfs;
magnitude1=abs(fftshift(freq_y));
phase1=unwrap(angle(freq_y));
subplot(3,1,2);
plot(fre_range,magnitude1);
title(" magnitude");
ylabel('magnitude ');
subplot(3,1,3);
plot(fre_range,phase1);
title(" phase");
ylabel('phase');

%%
%carrier and modulation

bw=bandwidth(y)./(2.*pi);
fc=(fs/2)-bw;
wc=fc*2*pi;

% Ac = max(abs(y));
Ac = abs(min(y));
carrier= cos(wc*t).';

% Plot in time domain
modulated = (y+Ac).*carrier;
figure(2);
subplot(3,1,1);
plot(t,modulated);
title(" modulated signal in time domain");
ylabel('Amplitude');

freq_y2=fft(modulated);


magnitude2=abs(fftshift(freq_y2));
phase2=unwrap(angle(freq_y2));
subplot(3,1,2);

% plot(f1,magnitude1(1:N/2),magnitude1(N/2+1:N));
plot(fre_range,magnitude2);

title(" magnitude");
ylabel('magnitude ');
subplot(3,1,3);
plot(fre_range,phase2);
title(" phase");
ylabel('phase');

% demodulation
%%
demodulated_signal =  modulated.*carrier;

LPF = lowpass(demodulated_signal,10000,fs);
% ('Fp,Fst,Ap,Ast',0.1,0.8,1,80);
% d = fdesign.lowpass('Fp,Fst,Ap,Ast',0.1,0.2,0.07,1e-7,'linear');
% designmethods(d);
% Hd = design(d, 'equiripple');
% LPF = filter(Hd,demodulated_signal);
LPF=LPF*2;
LPF = LPF -Ac;

figure(3);
subplot(3,1,1);
plot(t,LPF);
title(" demodulated signal in time domain");
ylabel('Amplitude');

freq_y3=fft(LPF );
magnitude3=abs(fftshift(freq_y3));
phase3=unwrap(angle(freq_y3));
subplot(3,1,2);
plot(fre_range,magnitude3);
title(" magnitude");
ylabel('magnitude ');
subplot(3,1,3);
plot(fre_range,phase3);
title(" phase");

ylabel('phase');

sound(LPF,fs);