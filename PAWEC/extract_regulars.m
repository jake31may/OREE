function extract_regulars(inputs)

clearvars
close all 
clc

%% Preliminary information on regular waves

% Input!
sample_frequency = [500,128];   % [Hz] [Qualysis,wave]
start_time = 10;    %[s]
Amplitude = [18,36];    % [mm]


%% Extract data for Cylinder

% Fill me in here...
reg_coarse = [0.4,0.5,0.6,0.8,0.9];
reg_fine1 = [0.65:0.01:0.75,0.67,0.68];
reg_fine2 = [0.65,0.66,0.69,0.7,0.72:0.01:0.75];
frequencies = transpose([reg_coarse,reg_fine1,reg_coarse,reg_fine2]);
sz = length(frequencies);

filepath    = ('Users/jakehollins/Documents/MATLAB/RegularCylinder2/');
folder = 'RegularCylinder2/';

% Leave me alone! Add those pesky end frame anomalies below 
% (Idea: add a peak finder to find that weird peak at the end when the wave
% machine finishes its business for end time and subtract a wave period)
end_coarse = round(50./reg_coarse,0);
end_fine1 = round(150./reg_fine1,0);
end_fine2 = round(150./reg_fine2,0);

end_time = [end_coarse,end_fine1,end_coarse,end_fine2];
start_times = repelem(start_time,sz);

% Anomomolies :(
end_time(27) = 150;
start_times(9) = 172;
start_times(24) = 40;
start_times(25) = 40;

start_frame = transpose(sample_frequency).*start_times;    % [-]
end_frame = transpose(sample_frequency).*end_time;

M = struct();

M = extract_tsv(M,filepath,folder,sample_frequency,start_frame,end_frame,Amplitude,frequencies)
%%
% Resample Motion Data
force = 9.5;
for i = 1:sz
    i
    M(i).Resampled.deHeave = resample(M(i).Motion.deHeave,sample_frequency(2),sample_frequency(1));
    M(i).Resampled.Time = M(i).Wave.Time;
end
%%
for i = 1:sz
    [M(i).MeanPower,M(i).PowerSTD] = RegularPower(force,M(i).Resampled.deHeave,sample_frequency);
end
%%
plotRMSfreqAdapted(M,frequencies)
%% Extract data for Compound

% Fill me in here...
reg_coarse = [0.4,0.5,0.6,0.8,0.9];
reg_fine = 0.65:0.01:0.75;
frequencies = transpose([reg_coarse,reg_fine,reg_coarse,reg_fine]);
sz = length(frequencies);

filepath    = ('Users/jakehollins/Documents/MATLAB/RegCompound/');
folder = 'RegCompound/';

% Leave me alone! Add those pesky end frame anomalies below 
% (Idea: add a peak finder to find that weird peak at the end when the wave
% machine finishes its business for end time and subtract a wave period)
end_coarse = round(50./reg_coarse,0);
end_fine = round(150./reg_fine,0);

end_time = [end_coarse,end_fine,end_coarse,end_fine];
start_times = repelem(start_time,sz);


% Anomomolies :(
end_time(22) = 165;
end_time(32) = 140;

start_frame = transpose(sample_frequency).*start_times;    % [-]
end_frame = transpose(sample_frequency).*end_time;


T = struct();

T = extract_tsv(T,filepath,folder,sample_frequency,start_frame,end_frame,Amplitude,frequencies)

%plotRMSfreq(T,frequencies)

%%
CompoundCrude = AnotherRAO(T,frequencies)
%%
DiamondCrude = AnotherRAO(H,frequencies)
%%
for i = 1:36
    figure()
    plot(M(i).Motion.Time,M(i).Motion.deHeave,'r')
    title(M(i).Name)
    grid on
end

%% Extract data for Diamond

% Fill me in here...
reg_coarse = [0.2,0.25,0.3:0.1:1.1];
reg_fine = [0.30:0.01:0.36,0.38];
frequencies = transpose([reg_coarse,reg_fine,reg_coarse,reg_fine]);
sz = length(frequencies);

filepath    = ('Users/jakehollins/Documents/MATLAB/RegDiamond/');
folder = 'RegDiamond/';

% Leave me alone! Add those pesky end time anomalies below 
end_coarse = round(50./reg_coarse,0);
end_fine = round(150./reg_fine,0);

end_time = [end_coarse,end_fine,end_coarse,end_fine];
start_times = repelem(start_time,sz);
%end_time = end_time-repelem(30,length(end_time));

end_time(34) = 150;
start_times(21) = 70;

start_frame = transpose(sample_frequency).*start_times;    % [-]
end_frame = transpose(sample_frequency).*end_time;

% Anomomolies :(
end_frame(1,1) = end_time(1).*100; % Measured @ 100 Hz instead
end_frame(1,18) = end_time(18).*100;
end_frame(1,19) = end_time(19).*100;


H = struct();
H = extract_tsv(H,filepath,folder,sample_frequency,start_frame,end_frame,Amplitude,frequencies)

plotRMSfreq(H,frequencies)
