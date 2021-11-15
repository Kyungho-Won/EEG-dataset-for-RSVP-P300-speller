# A Benchmark EEG Dataset for P300 Speller Brain-Computer Interfaces
 
 #### This includes Matlab and Python code to extract features from RSVP and P300 speller EEG, and evaluate letter detection accuracy in P300 speller with the open EEG dataset that will be published (in submission).
 ![image](https://user-images.githubusercontent.com/34480950/141660475-b262803d-b867-4ff1-ad82-59f5a63b0c69.png)

 
 ## 1. Dataset
 #### This code aims to analyize EEG data collected during RSVP and P300 speller sessions. For more information, please refer to the data note (in submission)
 
 ## 2. Preprocessing and Feature extraction
 #### From RSVP and P300 speller EEG, users are able to extract event-related potentials (ERPs) during target events while non-target events show non-noticiable changes.
 #### For preprocessing, we used only the minimum required processing, hence users can use their preprocessing methods.
 
 ## 3. External dependancy
 #### For Matlab code, users can extract features and evaluate P300 speller performance, but users can draw more intuitive plots, such as multi-channel EEG plot and  scalp topography with EEGLAB toolbox (https://sccn.ucsd.edu/eeglab/index.php).
 #### For Python code, users need to install the follwing moduels: matplotlib, scipy, h5py, mat73, sklearn, 
 ```
 >> pip install [module name]
 ```
 
 ## 4. Get started
 #### At first, download EEG and make directory named "data" in ./Matlab or ./Python. Otherwise you can specify your filepath in the scripts
 ```
 ./Matlab/data/s01.mat
 ...
 
 or
 
 ./Python/data/s01.mat
 ...
 ```
 ### Matlab
 #### 1) RSVP
 #### 2) P300 speller
 
 ### Python
 #### 1) RSVP
 #### 2) P300 speller
