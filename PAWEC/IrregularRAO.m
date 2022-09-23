function [RAO] = IrregularRAO(heave,wave,sample_frequency,band_lo,band_hi,Name)

 z = heave;
 w = wave;

 %% Perform fft analysis on heave and wave data
n = length(z);
duration = n./sample_frequency;

if mod(n,2) == 1
    n = n+1;
end

zhat = fft(z,n,1);
zhat = [abs(zhat(1:1+n/2))]';

what = fft(w,n,1);
what = [abs(what(1:1+n/2))]';

df = sample_frequency/n;
f = 0:df:(sample_frequency/2 - df);

f_lo = find(f >= band_lo,1,'first');
f_hi = find(f >= band_hi,1,'first');


f_interval = f(f_lo:f_hi);

z_interval = zhat(f_lo:f_hi);
w_interval = what(f_lo:f_hi);

PSDz = (z_interval.*conj(z_interval))./duration;
PSDz(2:end-1) = 2*PSDz(2:end-1);
PSDw = (w_interval.*conj(w_interval))./duration;
PSDw(2:end-1) = 2*PSDw(2:end-1);
%% Filter
 windices = PSDw > 100000;
 zindices = PSDz > 100000;


zPSDclean = PSDz.*zindices;
wPSDclean = PSDw.*windices;


%% plot
RAO = sqrt(zPSDclean./wPSDclean);
figure()
subplot(2,1,1)
plot(f_interval,wPSDclean,'b-',f_interval,zPSDclean,'r-')
ylabel('Power Spectral Density [s]')
xlabel('Frequency [Hz]')
title(['PSD for motion and wave signals for ',Name])
legend('Wave','Heave Motion')

subplot(2,1,2)
plot(f_interval,RAO)
ylabel('RAO')
xlabel('Frequency [Hz]')
title(['Response amplitude operator of compound across different frequencies for file: ',Name])