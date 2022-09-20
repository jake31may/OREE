function [Mag,f] = Spectrum_FFT(time_series,sample_frequency)

n = length(time_series);
duration = n/sample_frequency;

dim = 1;
df = sample_frequency/n;

f = transpose(0:df:(sample_frequency/2 - df));
f_length = length(f);

FFT = fft(time_series,n,dim);
Mag = (FFT(1:f_length).*conj(FFT(1:f_length))./duration);

end