clear all;
close all;

df = 0.2 % df: desired frequency resolution [Hz]
ts = 1/4000; % ts: sampling interval [sec]
fs = 1/ts; % fs: sampling frequency
fc = 300; % fc: carrier frequency

kf = 150 ; % kf: frequency sensitivity [Hz/volt] 50 10 100 150

T1 = 0; T2 = 0.15; % observation time interval (from T1 to T2 sec)
t = [T1:ts:T2]; % t: observation time vector
m = [ones(1,T2/(3*ts)),-2*ones(1,T2/(3*ts)),zeros(1,T2/(3*ts)+1)];  % m: message signal

integ_m(1) = 0;
for i = 1:length(t)-1 % integral of m
integ_m(i+1) = integ_m(i)+m(i)*ts;
echo off ;
end
echo on ;

[M,m,df1] = fft_mod(m,ts,df);  % M: Fourier transform of message signal
M = M/fs;
f = [0:df1:df1*(length(m)-1)]-fs/2; % f: frequency vector
s_m = cos(2*pi*(fc*t + kf*integ_m)); % s_m: modulated signal
[S_m,s_m,df1] = fft_mod(s_m,ts,df); % S_m: Fourier transform of modulated signal
S_m = S_m/fs;

subplot(2,1,1)
plot(t,m(1:length(t)))
axis([T1 T2 -2.1 2.1])
xlabel('Time')
title('Message signal')
subplot(2,1,2)
plot(t,s_m(1:length(t)))
axis([T1 T2 -2.1 2.1])
xlabel('Time')
title('Modulated signal')
pause

subplot(2,1,1)
plot(f,abs(fftshift(M)))
xlabel('Frequency')
title('Magnitude spectrum of the message signal')

subplot(2,1,2)
plot(f,abs(fftshift(S_m)))
title('Magnitude spectrum of the modulated signal')
xlabel('Frequency')
pause

T1 = -0.1; T2 = 0.1; % observation time interval (from T1 to T2 sec)
t = [T1:ts:T2]; % t: observation time vector
tau = 0.1; % tau: Pulse width [sec]
m = 2*triangle(tau, T1, T2, fs, df);  % m: message signal

integ_m(1) = 0;
for i = 1:length(t)-1 % integral of m
integ_m(i+1) = integ_m(i)+m(i)*ts;
echo off ;
end
echo on ;

[M,m,df1] = fft_mod(m,ts,df); % M: Fourier transform of message signal
M = M/fs;
f = [0:df1:df1*(length(m)-1)]-fs/2; % f: frequency vector
s_m = cos(2*pi*(fc*t + kf*integ_m)); % s_m: modulated signal
[S_m,s_m,df1] = fft_mod(s_m,ts,df); % S_m: Fourier transform of modulated signal
S_m = S_m/fs;

figure;
subplot(2,1,1)
plot(t,m(1:length(t)))
axis([T1 T2 -2.1 2.1])
xlabel('Time')
title('Message signal')
subplot(2,1,2)
plot(t,s_m(1:length(t)))
axis([T1 T2 -2.1 2.1])
xlabel('Time')
title('Modulated signal')
pause

subplot(2,1,1)
plot(f,abs(fftshift(M)))
xlabel('Frequency')
title('Magnitude spectrum of the message signal')
subplot(2,1,2)
plot(f,abs(fftshift(S_m)))
title('Magnitude spectrum of the modulated signal')
xlabel('Frequency')