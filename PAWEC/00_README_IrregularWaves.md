This code has been developed to extract and analyse data for the outward-protruding point-absorber wave energy converter as part of a Masters thesis in 2022. This code was developed in MATLAB and processes the bulk of the data in structs. Unfortunately, a quirk of this language does not allow multiple functions to be declared within a single script, so these are in separate .m files.

Prerequisites:

This code was performed on MATLAB version R2022a. Backwards compatibility has not been checked.

Input files:
	•	.tsv files from motion capture.
	•	.txt files from wave gauge data.
(This analysis only considered heave motion, however the code could easily be modified to extract other degrees of freedom.)

Workflow for irregular waves:

Place all the .tsv and .txt files into a folder, and specify the file path and folder in the script, ‘Irregular.m’. You will also need to specify the sample frequencies, bandwidth (band_lo, band_hi), number of files (sz), PTO force and start and end times. ‘extract_irregulars.m’ to extract the data from the .tsv and .txt files into a struct, Q. 
Q = extract_irregulars(Q,filepath,folder,sample_frequency,start_time,end_time)

The RAO is calculated using ‘IrregularRAO.m’, which utilises fast Fourier transform. The signal is filtered  in lines 37-38, and only frequencies within the bandwidth are considered. The output of the this function is the RAO at each frequency interval. (The name input is the file name, which allows the user to identify each irregular wave test.)
[RAO] = IrregularRAO(heave,wave,sample_frequency,band_lo,band_hi,Name)

The power is calculated using the function ‘RegularPower.m’, using a static force - see 00_README_RegularWaves.md for more information.
[Mean_Power] = RegularPower(force,heave,sample_frequency)
