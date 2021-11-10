import mat73
import matplotlib.pyplot as plt
import numpy as np
from sklearn import linear_model
import statsmodels.api as sm

from functions.func_filters import butter_bandpass_filter
from sklearn.linear_model import LinearRegression
from functions import func_preproc as preproc
from functions import func_classifier as classifier

from scipy.signal import butter, filtfilt
data_dir = "F:\Main\matlab_workspace\P3BCI2017_current\Won2021\data\\"

nsub = 1
EEG = mat73.loadmat(data_dir+'s{:02d}.mat'.format(int(nsub)))

# pre-defined parameters
baseline = [-200, 0] # in ms
frame = [0, 600] # in ms

# pre-processing for training data
for n_calib in range(len(EEG['train'])):
    data = np.asarray(EEG['train'][n_calib]['data'])
    srate = EEG['train'][n_calib]['srate']
    data = butter_bandpass_filter(data, 0.5, 10, srate, 4)
    markers = EEG['train'][n_calib]['markers_target']

    """"
    targetID = np.where(markers==1)[0]
    nontargetID = np.where(markers==2)[0]

    tmp_targetEEG = preproc.extractEpoch3D(data, targetID, srate, baseline, frame, False)
    tmp_nontargetEEG = preproc.extractEpoch3D(data, nontargetID, srate, baseline, frame, False)
    if n_calib == 0:
        targetEEG = tmp_targetEEG
        nontargetEEG = tmp_nontargetEEG
    else:
        targetEEG = np.dstack((targetEEG, tmp_targetEEG))
        nontargetEEG = np.dstack((nontargetEEG, tmp_nontargetEEG))
    """
#print(targetEEG.shape) # ch x time x trial
#print(nontargetEEG.shape) # ch x time x trial
#np.save('sam.npy', data)



print(data)





