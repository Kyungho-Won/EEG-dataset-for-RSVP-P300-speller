import mat73
import matplotlib.pyplot as plt
import numpy as np
import matplotlib
matplotlib.use('Qt5Agg')
from functions.func_filters import butter_bandpass_filter
from functions import func_preproc as preproc

# pre-defined parameters
baseline = [-200, 0] # in ms
frame = [-200, 1000] # in ms

# One need to specify data directory
data_dir = "/Volumes/T5_2TB/Matlab_workspace/P3BCI2017_current/Won2021/data/"

nsub = 1
EEG = mat73.loadmat(data_dir+'s{:02d}.mat'.format(int(nsub)))

# pre-processing for test data
for n_calib in range(len(EEG['test'])):
  cur_EEG = EEG['test'][n_calib]
  data = np.asarray(cur_EEG['data'])
  srate = cur_EEG['srate']
  data = butter_bandpass_filter(data, 1, 10, srate, 4)
  markers = cur_EEG['markers_target']

  targetID = np.where(markers==1)[0]
  nontargetID = np.where(markers==2)[0]

  tmp_targetEEG = preproc.extractEpoch3D(data, targetID, srate, baseline, frame, True)
  tmp_nontargetEEG = preproc.extractEpoch3D(data, nontargetID, srate, baseline, frame, True)
  if n_calib == 0:
    targetEEG = tmp_targetEEG
    nontargetEEG = tmp_nontargetEEG
  else:
    targetEEG = np.dstack((targetEEG, tmp_targetEEG))
    nontargetEEG = np.dstack((nontargetEEG, tmp_nontargetEEG))

avg_target = np.mean(targetEEG, axis=2) # trial average
avg_nontarget = np.mean(nontargetEEG, axis=2) # trial average

# Channel selection for drawing ERPs
elec_midline = [31-1, 32-1, 13-1] # Fz, Cz, and Pz, respectively, -1 for indexing
ch_avg_target = np.mean(avg_target[elec_midline, :], axis=0)
ch_avg_nontarget = np.mean(avg_nontarget[elec_midline, :], axis=0)

# Single subject averaged target & nontarget ERPs - visualization
t = np.linspace(-200, 1000, avg_target.shape[1])
plt.plot(t, ch_avg_target.transpose(), color=[1, 0.5, 0])
plt.plot(t, ch_avg_nontarget.transpose(), color=[0, 0, 0])
plt.xlabel('ms')
plt.ylabel(r'$\mu V$')
plt.gca().yaxis.grid(True)
plt.rcParams.update({'font.size': 13})
plt.xlim([-200, 1000])

# plot ratio
ratio = .6
x_left, x_right = plt.gca().get_xlim()
y_low, y_high = plt.gca().get_ylim()

plt.gca().set_aspect(abs((x_right-x_left)/(y_low-y_high))*ratio)
plt.show()