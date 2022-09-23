function [start_frame,end_frame] = AnalysisWindow(signal,wave_frequency,diffThreshold,waves)

% Apply a moving average on the peaks of signal.
l_signal = length(signal);
prominence = max(signal(round(0.4*l_signal,0):round(0.6*l_signal,0)))*0.5;
   
[sigPeak,sigElement] = findpeaks(signal,"MinPeakProminence",prominence);

nPeaks = round(length(sigPeak)/10,0);             % Number of peaks considered in moving average
movAverage = movmean(sigPeak,nPeaks);


%%
grad = gradient(movAverage,1/wave_frequency);
grad = abs(gradient(grad,1/wave_frequency));

half_grad = round(length(grad)/2,0);
half2 = grad(half_grad:end);

%%
if max(half2) > diffThreshold
    Remove_end = find(half2>diffThreshold,1,"first")+1;
else
    Remove_end = half_grad;
end 

half1 = flipud(grad(1:half_grad));

if max(half1) > diffThreshold
    Remove_start = -find(half1>diffThreshold,1,"first")+half_grad;
else
    Remove_start = 1;
end

if waves > 60
    Remove_start = half_grad;
end

start_frame = sigElement(Remove_start+1);
end_frame = sigElement(half_grad+Remove_end-1);

end
