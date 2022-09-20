function [RAO] = WhiteNoiseRAO(heave,wave,sample_frequency,band_lo,band_hi,Name)
%%
% heave = CylinderIrregular(4).Heave;
% wave = CylinderIrregular(4).WaveAmp;
% sample_frequency = 128;
% band_lo = 0.3; band_hi = 1.0;


%% Calculate the RAO from White Noise Spectra


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
%%
 windices = PSDw > 100000;
 zindices = PSDz > 100000;

% zinter = zhat.*zindices;
% what = what.* windices;


zPSDclean = PSDz.*zindices;
wPSDclean = PSDw.*windices;

% zPSDclean = PSDz;
% wPSDclean = PSDw;


%%
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
%figure()
%plot(f_interval,smooth(RAO))
%%


%RAO_values = transpose(z_interval)./transpose(w_interval);
%%
% Fs = sample_frequency;
% smoothNum = 20;
% 
% [S,f] = Spectrum_FFT(w,Fs);
% S_smooth = smooth(S,smoothNum);
% [S_pxx,f] = pwelch(w,[],[],f,Fs); % Use the default values 
% S_pxx = S_pxx*2;
% 
% mo(1) = trapz(f,S); % Calculates zeroth moment of spectrum using trapezium function.
% mo(2) = trapz(f,S_smooth); % Calculates zeroth moment of spectrum using trapezium function.
% mo(3) = trapz(f,S_pxx); % Calculates zeroth moment of spectrum using trapezium function.
% 
% figure(41)
% %subplot(2,1,1)
% 
% plot(f,S_smooth)
% a1 = max(S_smooth);
% xlabel('frequency (Hz)')
% ylabel('Wave Spectrum')
% axis([0.3 1.0 0 1.1*max(a1)])
% grid on
% 
% 
% 
% [S_Z,f] = Spectrum_FFT(z,Fs);
% S_smoothZ = smooth(S_Z,smoothNum);
% [S_pxxZ,f] = pwelch(S2,[],[],f,Fs); % Use the default values 
% S_pxxZ = S_pxxZ*2;
% 
% % figure % Plots the results using the FFT spectrum
% % plot(f,S_Z)
% % hold on
% % plot(f,S_smoothZ)
% % plot(f,S_pxxZ)
% % xlabel('frequency (Hz)')
% % ylabel('psd m^2s')
% % axis([0 2 0 1.1*max(S_pxxZ)])
% 
% figure(41)
% %subplot(2,1,2)
% hold on
% plot(f,S_smoothZ)
% xlabel('frequency (Hz)')
% ylabel('Heave Spectrum')
% a3 = max(S_smoothZ);
% axis([0.3 1.0 0 1.1*max(a3)])
% grid on
% %%
% 
% 
% RAO_Z = sqrt(S_Z./S);
% RAO_Zsmooth = sqrt(S_smoothZ./S_smooth);
% RAO_Zxx = sqrt(S_pxxZ./S_pxx);
% 
% RAO_Z = S_Z./S;
% RAO_Zsmooth = S_smoothZ./S_smooth;
% RAO_Zxx = S_pxxZ./S_pxx;
% 
% 
% figure(42)
% subplot(3,1,1)
% plot(f,RAO_Z)
% xlabel('frequency (Hz)')
% ylabel('Z')
% a3 = max(RAO_Z);
% axis([0.3 1.2 0 1.1*max(a3)])
% grid on
% 
% subplot(3,1,2)
% plot(f,RAO_Zsmooth)
% xlabel('frequency (Hz)')
% ylabel('Z')
% a3 = max(RAO_Zsmooth);
% axis([0.3 1.2 0 1.1*max(a3)])
% grid on
% 
% subplot(3,1,3)
% plot(f,RAO_Zxx)
% xlabel('frequency (Hz)')
% ylabel('Z')
% a3 = max(RAO_Zxx);
% axis([0.3 1.2 0 1.1*max(a3)])
% grid on
% 
% %% Plot Results
% 
% figure()
% scatter(f(f_lo:f_hi),RAO_values,'b.')
% xlabel('Frequency [Hz]')
% ylabel('RAO')
% 
% figure()
% obw([z,w],sample_frequency)
% %%
% figure()
% plot(f(f_lo:f_hi),z_interval); hold on
% plot(f(f_lo:f_hi),w_interval); hold off
% xlabel('Frequency [Hz]')
% ylabel('|FFT|')
% 
% %%
% pwelch([z,w])