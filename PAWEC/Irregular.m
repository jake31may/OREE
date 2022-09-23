%% Irregular Extraction!

sample_frequencies = [500,128]; %[Motion,Wave]
start_time = 10;           % [s]
end_time = 440;            % [s]
force = 9.5;               % [N]

sz = 8;
band_lo = repelem(0.3,sz);
band_hi = repelem(1.0,sz);

%% Cylinder


filepath    = ('Users/jakehollins/Documents/MATLAB/CylinderIrr/');
folder = 'CylinderIrr/';

CylinderIrregular = struct();

CylinderIrregular = extract_irregulars(CylinderIrregular,filepath,folder,sample_frequencies,start_time,end_time)
%%

for i = 1:sz
    z = CylinderIrregular(i).Motion.deHeave;
    t = CylinderIrregular(i).Motion.Time;
    
    CylinderIrregular(i).Heave = resample(z,sample_frequencies(2),sample_frequencies(1));

    CylinderIrregular(i).WaveAmp = CylinderIrregular(i).Wave.deAmplitude*1000;

    z = CylinderIrregular(i).Heave;
    w = CylinderIrregular(i).WaveAmp;

    RAO(i,:) = WhiteNoiseRAO(z,w,sample_frequencies(2),band_lo(i),band_hi(i));
    CylinderIrregular(i).RAO = RAO(i,:);

    AvPower(i) = RegularPower(9.5,z,[500,128]);
    CylinderIrregular(i).AvPower = AvPower(i);
end