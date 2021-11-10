function [feature_out, label_out] = preproc_P3speller(eeg, params, opt)
%
% [feature_out, label_out] = preproc_P3speller(eeg, params, opt)
% - This function extracts features from P300 speller
% opt: 'unknown', 'labeled'

% bandpassfilter
wn = params.freq / (eeg.srate/2);
[b, a] = butter(4, wn, 'bandpass');
% demean the data before filtering
meandat = mean(eeg.data, 2);
eeg.data = bsxfun(@minus, eeg.data, meandat);
filtered = filtfilt(b, a, eeg.data')';

if strcmpi(opt, 'unknown')
    tmp_letters = sign(eeg.markers_seq);
    rmbase_unknown = segment_with_rmbase(filtered, tmp_letters, params.frame, params.baseline, eeg.srate, '2D');
    
    % channel select
    rmbase_unknown = rmbase_unknown(params.select_ch, :);
    % output dim: [ch x (time x trials)]
    
    % decimation for smoothing
    % -- replacing each sequence of 24 samples with their average
    % (Krusienski et al., 2006)
    unknwon_data = decimation_by_average(rmbase_unknown, 24, eeg.nbTrials);
    
    % reshaping to [trial x (chxconcatenated)]
    feature_out = reshape(unknwon_data, length(params.select_ch) * ...
        length(unknwon_data)/eeg.nbTrials, eeg.nbTrials)';
    label_out = [];
else
    tmp_target = eeg.markers_target;
    tmp_target(tmp_target==2) = 0; % remove non-target markers
    % tmp_target: 1 for target o/w 0
     
    tmp_nontarget = eeg.markers_target;
    tmp_nontarget(tmp_nontarget==1) = 0; % remove target merkers
    tmp_nontarget = sign(tmp_nontarget);
    % tmp_nontarget: 1 for non-target o/w 0
    
    % segment windows with baseline correction
    rmbase_target = segment_with_rmbase(filtered, tmp_target, params.frame, params.baseline, eeg.srate, '2D');
    rmbase_nontarget = segment_with_rmbase(filtered, tmp_nontarget, params.frame, params.baseline, eeg.srate, '2D');
    
    % channel select
    rmbase_target = rmbase_target(params.select_ch, :);
    rmbase_nontarget = rmbase_nontarget(params.select_ch, :);
    % output dim: [ch x (time x trials)]
    
    % decimation for smoothing
    % -- replacing each sequence of 24 samples with their average
    % (Krusienski et al., 2006)
    target_data = decimation_by_average(rmbase_target, 24, eeg.nbTrials_target);
    nontarget_data = decimation_by_average(rmbase_nontarget, 24, eeg.nbTrials_nontarget);
    
    % reshaping to [trial x (chxconcatenated)]
    feat_target = reshape(target_data, length(params.select_ch) * ...
        length(target_data)/eeg.nbTrials_target, eeg.nbTrials_target)';
    feat_nontarget = reshape(nontarget_data, length(params.select_ch) * ...
        length(nontarget_data)/eeg.nbTrials_nontarget, eeg.nbTrials_nontarget)';
    
    label_target = ones(size(feat_target, 1), 1);
    label_nontarget = -ones(size(feat_nontarget, 1), 1);
    
    feature_out = [feat_target;feat_nontarget];
    label_out = [label_target;label_nontarget];
end

end