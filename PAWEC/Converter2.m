function [FSomega,Mat2] = Converter2(frequencies,Mat,ScaleFactor)


FSomega = 2*pi*sqrt(1/ScaleFactor)*frequencies;

FSAveragePower = (ScaleFactor^3.5)*Mat(:,2);
FSRAO = Mat(:,1);
FSkCw = Mat(:,4);

Mat2 = [FSRAO,FSAveragePower,FSkCw];

end

%%
% [fSCy2, SAvPowerCy2,SRAOCy2,SkCwCy2] = Converter2(fSCy,SGCy,49.39)
% [fSCo2, SAvPowerCo2,SRAOCo2,SkCwCo2] = Converter2(fSCo,SGCo,49.39)
% [fSDi2, SAvPowerDi2,SRAODi2,SkCwDi2] = Converter2(fSDi,SGDi,49.39)

% [fBCy2, BAvPowerCy2,BRAOCy2,BkCwCy2] = Converter2(fBCy,BGCy,49.39)
% [fBCo2, BAvPowerCo2,BRAOCo2,BkCwCo2] = Converter2(fBCo,BGCo,49.39)
% [fBDi2, BAvPowerDi2,BRAODi2,BkCwDi2] = Converter2(fBDi,BGDi,49.39)