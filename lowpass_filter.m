function dx = lowpass_filter(xm, ts, df, fs, freq)

[A, xm, df1] = fft_mod(xm, ts, df);
A = A/fs;

f_cutoff = 150;
n_cutoff = floor(f_cutoff/df1);
H = zeros(size(freq));
H(1:n_cutoff) = 2 * ones(1, n_cutoff);
H(length(freq)-n_cutoff+1 : length(freq)) = 2 * ones(1, n_cutoff);

Dx = H.*A;
dx = real(ifft(Dx)).*fs;