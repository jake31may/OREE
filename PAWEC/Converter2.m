function [FSomega,Mat2] = Converter2(frequencies,Mat,ScaleFactor)


FSomega = 2*pi*sqrt(1/ScaleFactor)*frequencies;

FSAveragePower = (ScaleFactor^3.5)*Mat(:,2);
FSRAO = Mat(:,1);
FSkCw = Mat(:,4);

Mat2 = [FSRAO,FSAveragePower,FSkCw];

end
