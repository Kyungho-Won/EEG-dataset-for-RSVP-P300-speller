# EEG Dataset for RSVP and P300 Speller Brain-Computer Interfaces
 
 #### This includes Matlab and Python code to extract features from RSVP and P300 speller EEG, and evaluate letter detection accuracy in P300 speller with the open EEG dataset.
 
 #### EEG Dataset for RSVP and P300 Speller Brain-Computer Interfaces, https://doi.org/10.1038/s41597-022-01509-w
 
 ## 1. Dataset
 #### This code aims to analyize EEG data collected during RSVP and P300 speller sessions. For more information, please refer to the data note.
 
 ## 2. Preprocessing and Feature extraction
 #### From RSVP and P300 speller EEG, users are able to extract event-related potentials (ERPs) during target events while non-target events show non-notable changes.
 #### For preprocessing, we used only the minimum required processing, hence users can use their preprocessing methods.
 
 ## 3. External dependancy
 #### For Matlab code, users can extract features and evaluate P300 speller performance, but users can draw more intuitive plots, such as multi-channel EEG plot and  scalp topography with EEGLAB toolbox (https://sccn.ucsd.edu/eeglab/index.php).
 #### For Python code, users need to install the follwing moduels: matplotlib, scipy, h5py, mat73, sklearn, statsmodels
 ```
 >> pip install [module name]
 ```
 #### We note that our results in the data note were produced with Matlab. One can use Python script to extract feature and evaluate P300 speller performance, but the results maybe different. Temporal scalp tography is only shown in Matlab with EEGLAB toolbox.
 
 ## 4. Get started
 #### At first, download EEG and make directory named "data" in ./Matlab or ./Python. Otherwise you can specify your filepath in the scripts.
 #### Second, add paths for ./functions for ./Matlab or ./Python
 ```
 ./Matlab/data/s01.mat
 ...
 
 or
 
 ./Python/data/s01.mat
 ...
 ```
 ### Matlab
 #### 1) RSVP </br> Run each block (separted by '%%') in the script using the keyboard shortcut (ctrl + Enter for Windows, cmd + Enter for Mac)
 ```
 ./Matlab/
 - RSVP_visualization_ERP.m # to extract RSVP ERP
 ```
 #### 2) P300 speller </br> Run each block in the script using the keyboard shortcut (ctrl + Enter for Windows, cmd + Enter for Mac)
 ```
 ./Matlab/
 - P300speller_visualization_ERP.m # to extract P300 speller ERP
 - P300speller_predict_letter.m # to evaluate P300 speller performance
 ```
 ### Python (Under modification)
 #### One can use Google Colab or Jupyter notebook (*.ipynb).
 ```
 ./Python/
 - Load_Won2021dataset.ipynb
 ```
 #### 1) RSVP
  ```
 ./Python/
 - RSVP_visualization_ERP.py # to extract RSVP ERP
 ```
 #### 2) P300 speller
  ```
 ./Python/
 - P300speller_visualization_ERP.py # to extract P300 speller ERP
 - P300speller_predict_letter.py # to evaluate P300 speller performance
 ```
