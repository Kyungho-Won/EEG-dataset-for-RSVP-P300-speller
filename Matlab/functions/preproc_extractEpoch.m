function [eeg_class1, eeg_class2] = preproc_extractEpoch(eeg, params)

% bandpassfilter
wn = params.freq / (eeg.srate/2);
[b, a] = butter(4, wn, 'bandpass');
% demean the data before filtering
meandat = mean(eeg.data, 2);
eeg.data = bsxfun(@minus, eeg.data, meandat);
filtered = filtfilt(b, a, eeg.data')';

tmp_target = eeg.markers_target;
tmp_target(tmp_target==2) = 0; % remove non-target markers
% tmp_target: 1 for target o/w 0

tmp_nontarget = eeg.markers_target;
tmp_nontarget(tmp_nontarget==1) = 0; % remove target merkers
tmp_nontarget = sign(tmp_nontarget);
% tmp_nontarget: 1 for non-target o/w 0

% segment windows with baseline correction
params.frame(1) = min(params.baseline(1), params.frame(1)); % for displaying baseline and epoch
rmbase_target = segment_with_rmbase(filtered, tmp_target, params.frame, params.baseline, eeg.srate, '3D');
rmbase_nontarget = segment_with_rmbase(filtered, tmp_nontarget, params.frame, params.baseline, eeg.srate, '3D');

% channel select
eeg_class1 = rmbase_target(params.select_ch, :, :);
eeg_class2 = rmbase_nontarget(params.select_ch, :, :);
end