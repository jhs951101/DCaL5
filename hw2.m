clear all;
close all;

echo on
df = 0.2
ts = 1/4000;
fs = 1/ts;
fc = 400;
kp = 5;  % kp: 위상 변조를 위해 메시지 신호에 곱할 값

T1 = 0; T2 = 0.15;
m = [ones(1,T2/(3*ts)),-2*ones(1,T2/(3*ts)),zeros(1,T2/(3*ts)+1)];

m_min = min(m); m_max = max(m);

t = [T1:ts:T2];
N = length(t);

echo on ;
[M,m,df1] = fft_mod(m,ts,df);
M = M/fs;
f = [0:df1:df1*(length(m)-1)]-fs/2;
s_m = cos(2*pi*(fc*t + kp * m(1:length(t)) ));  % 메시지 신호를 PM 변조 해줌
[S_m,s_m,df1] = fft_mod(s_m,ts,df);
S_m = S_m/fs;

subplot(2,1,1);
plot(t,m(1:length(t)));
axis([T1 T2 m_min-0.1 m_max+0.1]);
xlabel('Time');
title('Message signal');
subplot(2,1,2);
plot(t,s_m(1:length(t)));
xlabel('Time');
title('Modulated signal');
pause

subplot(2,1,1);
plot(f,abs(fftshift(M))) ;
xlabel('Frequency');
title('Magnitude spectrum of the message signal');
subplot(2,1,2);
plot(f,abs(fftshift(S_m)))
title('Magnitude spectrum of the modulated signal');
xlabel('Frequency');
pause

snr_dB = 30; % SNR in dB
snr = 10^(snr_dB/10); % linear SNR
signal_power = (norm(s_m(1:N))^2)/N; % modulated signal power
noise_power = signal_power/snr; % noise power
noise_std = sqrt(noise_power); % noise standard deviation
noise = noise_std*randn(1,N); % Generate noise
r = s_m(1:N); % When there is no noise
r = r+noise;

% 동기 복조
z = complex_env(r,ts,T1,T2,fc); % Find phase of the received signal
phase = angle(z);
theta = unwrap(phase); % Restore original phase
t1 = t(1:length(t)-1);
demod = (1/(2*pi*kp))*(diff(theta)/ts); %Differentiate and scale phase

% PM 신호를 FM 복조기에 통과시킨 후 적분함
integ_demod(1) = 0;
for ii = 1:length(t1) - 1
    integ_demod(ii+1) = integ_demod(ii) + demod(ii)*ts;
end

integ_demod = lowpass_filter(integ_demod, ts, df, fs, f);

figure;
subplot(2,1,1)
plot(t,m(1:length(t)));
axis([T1 T2 m_min-1 m_max+1]);
xlabel('Time')
title('Message signal')
subplot(2,1,2)
plot(t1,integ_demod(1:length(t1)));
axis([T1 T2 m_min-1 m_max+1]);
xlabel('Time');
title('Demodulated signal');

% 비동기 복조
dr_dt = diff(r);
z = hilbert(dr_dt); % Get analytic signal
envelope = abs(z); % Find the envelope
demod1 = envelope;

% PM 신호를 FM 복조기에 통과시킨 후 적분함
integ_demod1(1) = 0;
for ii = 1:length(t1) - 1
    integ_demod1(ii+1) = integ_demod1(ii) + demod1(ii)*ts;
end
    
pause

figure;
subplot(2,1,1)
plot(t,m(1:length(t)));
axis([T1 T2 m_min-1 m_max+1]);
xlabel('Time')
title('Message signal')
subplot(2,1,2)
plot(t1,integ_demod1(1:length(t1)));
xlabel('Time');
title('Demodulated signal');