function CrudeRAO = AnotherRAO(H,frequencies)
%%
sz = length(frequencies)

n = 20;                      % number of waves
MaxWave = zeros(sz,1);
MinWave = zeros(sz,1);
for i = 1:sz
    [W_peak,] = findpeaks(H(i).Wave.deAmplitude,'NPeaks',n,'SortStr','descend','MinPeakProminence',0.001);
    [W_trough,] = findpeaks(-H(i).Wave.deAmplitude,'NPeaks',n,'SortStr','descend','MinPeakProminence',0.001);
    MaxWave(i) = mean(W_peak(5:n));
    MinWave(i) = mean(W_trough(5:n));
end
WaveAmplitude = ((MaxWave+MinWave)/2);


n = 40;                      % number of waves
MaxHeave = zeros(sz,1);
MinHeave = zeros(sz,1);
for i = 1:sz
    [H_peak,] = findpeaks(H(i).Motion.deHeave,'NPeaks',n,'SortStr','descend','MinPeakProminence',0.001);
    [H_trough,] = findpeaks(-H(i).Motion.deHeave,'NPeaks',n,'SortStr','descend','MinPeakProminence',0.001);
    MaxHeave(i) = mean(H_peak(5:n));
    MinHeave(i) = mean(H_trough(5:n));
end
HeaveAmplitude = ((MaxHeave+MinHeave)/2);

CrudeRAO = HeaveAmplitude./(WaveAmplitude*1000);

F = frequencies(1:sz/2);


CrudeRAO1 = CrudeRAO(1:sz/2);
CrudeRAO2 = CrudeRAO((1+sz/2):end);
F = frequencies(1:sz/2);
[Fsorted,Index] = sort(F);
CrudeRAO2 = CrudeRAO2(Index);
CrudeRAO1 = CrudeRAO1(Index);

figure(1)
plot(Fsorted,CrudeRAO1,'ro')
hold on
plot(Fsorted,CrudeRAO2,'bo')
grid on
hold off
legend('Amplitude = 18 mm','Amplitude = 36mm')
xlabel('Frequency [Hz]')
ylabel('RAO')
title(['Regular wave frequency and response amplitude operator for ',H(1).WEC, ' using amplitude of waves and response.'])

%%
yy1 = smooth(Fsorted,CrudeRAO1,0.4,'loess');
yy2 = smooth(Fsorted,CrudeRAO2,0.4,'loess');

figure(2)
plot(Fsorted,CrudeRAO1,'r.',Fsorted,yy1,'r-',LineWidth=2)
hold on
plot(Fsorted,CrudeRAO2,'b.',Fsorted,yy2,'b-',LineWidth=2)
grid on
hold off
legend('','Amplitude = 18 mm','','Amplitude = 36mm')
xlabel('Frequency [Hz]')
ylabel('RAO')
title(['Regular wave frequency and response amplitude operator for ',H(1).WEC], 'using amplitude of response.')

%%
end