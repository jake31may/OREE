This code has been developed to extract and analyse data for the outward-protruding point-absorber wave energy converter as part of a Masters thesis in 2022. This code was developed in MATLAB and processes the bulk of the data in structs. Unfortunately, a quirk of this language does not allow multiple functions to be declared within a single script, so these are in separate  .m files.

Prerequisites: \\
This code was performed on MATLAB version R2022a. Backwards compatibility has not been checked. 

Input files: 
* .tsv files from motion capture.
* .txt files from wave gauge data. 

(This analysis only considered heave motion, however the code could easily be modified to extract other degrees of freedom.) 

Workflow for regular wave testing:
Three models were tested: cylinder, compound and diamond. For regular waves, each model had its own script as different waves tests (Cylinder2.m, Compound2.m, and Diamond.m). If using, download one of these and adapt as necessary. 

Place all the .tsv and .txt files into a folder, and specify the file path and folder in the script. You will also need to specify the frequency , wave amplitude and sample frequency for each test run as a vector in alphabetical order. The start and end frame of the data also need to specified - this allows the removal of unwanted data earlier, but the window of analysis is determined later. 

Data is extracted using ‘extract_tsv.m’, and output as a struct, Q:

Q = extract_tsv(Q,filepath,folder,sample_frequency,start_frame,end_frame,Amplitude,frequencies)

(If wishing to extract degrees of freedom other than heave, adjust/copy line 59-60 to extract columns other than 5.)

An analysis window is considered using a differentiation of peaks using the function ‘AnalysisWindow.m’.  This removes transient motion behaviour at the beginning and end of the motion signal. The ‘diffThreshold’ input allows to the user to tune the sensitivity of this transient behaviour. The ‘waves’ input allows to differentiate test runs if using a different number of waves for frequencies close to the natural frequency. In the present code, for cases where more than 50 waves were assessed, only the second half of the signal is considered. This of course can be adjusted or removed (by changing waves = 1) as necessary. 

[start_frame,end_frame] = AnalysisWindow(signal,wave_frequency,diffThreshold,waves)

If the motion and wave data is of a different sample frequency, after extraction, this resampled to the motion frequency. This allowed the FFT analysis to perform more consistently. 

The RAO and average power were calculated in this analysis with functions ‘FFT_RAO.m’ and ‘RegularPower.m’ respectively (‘AnotherRAO.m’ is also included as an alternative for calculating the RAO from amplitude peaks of motion and waves for comparison). 

The RAO is calculated using an FFT of the motion, z, and wave signal, w, and dividing the amplitude of the peak frequency (do check that the peak frequency is the same for both signals by removing ‘;’ on lines 30-31).  

RAO = FFT_RAO(z,w,sample_frequency)

Power is calculated as the product of velocity of the oscillating body and static force of the PTO. Velocity  is calculated as the derivative of the FFT motion signal, using ‘derviFFT.m’.  Mean power is taken as the integral of the instantaneous power and divided by the signal level.

[Mean_Power] = RegularPower(force,heave,sample_frequency)

Capture width, capture width ratios and wave power is calculated using the ‘CaptureWidth.m’ function. 

[cw,k_cw,cw_r,Cw_max,WavePower] = CaptureWidth(WECpower,WaveAmplitude,WaveFrequency,WECRadius)


Plots:
It may be necessary to plot different wave amplitudes. The data collected in the struct therefore needs to split into the separate amplitudes, which is done using ‘split.m’.  At present this is for a single split for two amplitudes, but can easily be adapted for multiple. For line graphs, each split can be organised into frequency order using the function ‘sortie.m’. ‘input1’ Needs to be the wave frequencies as a column vector, and ‘input2’ can be a matrix with multiple variables. 

[output1,output2]= sortit(input1,input2)

Additional code allows the creation of various figures.
