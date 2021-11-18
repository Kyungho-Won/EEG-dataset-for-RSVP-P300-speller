% RSVP feature inspection
%
% Kyungho Won
% data: BCI2000, 32 Biosemi2, 55 subjects
%  * for subject 43 ~ 47, RSVP keyboard disfunction
%  (cannot calculate behavioral score, but can calculate ERP)
%
% target : non-target = 40 : 560
% Origianlly RSVP stream consists of 21 letters, but 3 adject non targets (3-pre, 3-post) were removed
% because their epochs are overlapped with target epochs
%
% [Stage]
%  1. Pre-processing: bandpass filtering, extracting triggers
%   - freq = [1 10]
%   - frame = [-200 1000]
%   - baseline = [-200 0]
%  2. ERP plot
%   - channel: midline Fz, Cz, and Pz
%   - target vs. nontarget
%
%  3. temporal topoplot
%   - target, nontarget, diff(target, nontarget) (optional)
%
% Comments:
% 1Hz high pass filtering is recommended because there EMG around <1Hz
% 10Hz low pass filtering is recommended because there SSVEP response
% around 10 Hz due to 10Hz refresh rate of RSVP

%% Individual ERP
clear; clc;
nbsub = 55;
Params_RSVP = struct('freq', [1 10], 'frame', [0 1000], ...
    'baseline', [-200 0], 'select_ch', 1:32);
electrodes_midline = {'Fz', 'Cz', 'Pz'};
electrodes_eyes = {'FP1', 'FP2', 'AF3', 'AF4'};

ratio_bad_t_nt = zeros(nbsub,2);
for nsb=1
    fname = sprintf('./data/s%02d.mat', nsb);
    EEG = load(fname);
    
    EEG = EEG.RSVP; % use RSVP EEG
    [cur_target, cur_nontarget] = preproc_extractEpoch(EEG, Params_RSVP);
    interest_ch = ismember({EEG.chanlocs.labels}, electrodes_midline);
    
    bad_target = find_badAmplitude(cur_target, 100);
    bad_nontarget = find_badAmplitude(cur_nontarget, 100);
    ratio_bad_t_nt(nsb, 1) = length(bad_target) / size(cur_target, 3);
    ratio_bad_t_nt(nsb, 2) = length(bad_nontarget) / size(cur_nontarget, 3);
    
    t = linspace(Params_RSVP.baseline(1), Params_RSVP.frame(2), size(cur_target, 2));
    avg_target = mean(cur_target, 3)';
    avg_nontarget = mean(cur_nontarget, 3)';
    
    std_target = std(cur_target, [], 3)';
    std_nontarget = std(cur_nontarget, [], 3)';
    
    figure,
    vis_ERP(t, avg_target(:, interest_ch), avg_nontarget(:, interest_ch), ...
        Params_RSVP.baseline, 0:200:1000, std_target(:, interest_ch), std_nontarget(:, interest_ch), 'off');
    
    topo3D = cat(3, avg_target', avg_nontarget', (avg_target-avg_nontarget)');
    clim = [-3 3];
    frames = 0:200:1200;
    figure,
    vis_temporalTopoplot(topo3D, EEG.srate, frames, EEG.chanlocs, clim);
    colormap(redblue);
    
end


%% Grand-averaged ERPs (for subject-averaged)

clear; clc;
nbsub = 55;
Params_RSVP = struct('freq', [1 10], 'frame', [0 1000], ...
    'baseline', [-200 0], 'select_ch', 1:32);
electrodes_midline = {'FZ', 'Cz', 'Pz'};
electrodes_eyes = {'FP1', 'FP2', 'AF3', 'AF4'};


ratio_bad_t_nt = zeros(nbsub,2);
grand_target = [];
grand_nontarget = [];
RSVP_T1 = zeros(nbsub,1);
for nsb=1:nbsub
    fname = sprintf('./data/s%02d.mat', nsb);
    EEG = load(fname);
    fprintf('Loading %s..\n', fname);
    
    EEG = EEG.RSVP; % use RSVP EEG
    [cur_target, cur_nontarget] = preproc_extractEpoch(EEG, Params_RSVP);
    eyes_ch = ismember({EEG.chanlocs.labels}, electrodes_eyes);
    interest_ch = ismember({EEG.chanlocs.labels}, electrodes_midline);
    
    bad_target = find_badAmplitude(cur_target(~eyes_ch, :, :), 100);
    bad_nontarget = find_badAmplitude(cur_nontarget(~eyes_ch, :, :), 100);
    ratio_bad_t_nt(nsb, 1) = length(bad_target) / size(cur_target, 3);
    ratio_bad_t_nt(nsb, 2) = length(bad_nontarget) / size(cur_nontarget, 3);
    
    cur_target(:, :, bad_target) = [];
    cur_nontarget(:, :, bad_nontarget) = [];
    
    % individual peak amplitude and latency
    [ERP_amp(nsb), ERP_lat(nsb)] = max(mean(mean(cur_target(interest_ch, :, :),3),1));
    
    grand_target = cat(3, grand_target, cur_target);
    grand_nontarget = cat(3, grand_nontarget, cur_nontarget);
    RSVP_T1(nsb) = EEG.accuracy_t1;
end
disp('Done');

%% save - current grand averaged settings

RSVP_grand.target = grand_target;
RSVP_grand.nontarget = grand_nontarget;
RSVP_grand.cfg = Params_RSVP;
RSVP_grand.bad_t_nt = ratio_bad_t_nt;
RSVP_grand.comments = 'bad_t_nt: bad ratio of target and nontarget events';
RSVP_grand.comments_badepochs = '100microvolts, exclude FP1 FP2 AF3 AF4';
RSVP_grand.ch = electrodes_midline;
RSVP_grand.RSVPT1 = RSVP_T1;
RSVP_grand.ERP_amp = ERP_amp;
RSVP_grand.ERP_lat = ERP_lat;
RSVP_grand.t = linspace(Params_RSVP.baseline(1), Params_RSVP.frame(2), size(cur_target, 2));

save('RSVP_grand_details2.mat', '-v7.3', '-struct', 'RSVP_grand');
disp('done');
%%

RSVP_grand = load('RSVP_grand_details.mat');

%%
Params_RSVP = struct('freq', [1 10], 'frame', [0 1000], ...
    'baseline', [-200 0], 'select_ch', 1:32, 'srate', 512);

t = linspace(Params_RSVP.baseline(1), Params_RSVP.frame(2), size(RSVP_grand.target, 2));
avg_target = mean(RSVP_grand.target, 3)';
avg_nontarget = mean(RSVP_grand.nontarget, 3)';

std_target = std(RSVP_grand.target, [], 3)';
std_nontarget = std(RSVP_grand.nontarget, [], 3)';

electrodes_midline = {'FZ', 'Cz', 'Pz'};
chanlocs = importdata('biosemi32_locs.mat');
interest_ch = ismember({chanlocs.labels}, electrodes_midline);

grand_Target = mean(avg_target(:, interest_ch), 2);
grand_Nontarget = mean(avg_nontarget(:, interest_ch), 2);

figure,
vis_ERP(t, grand_Target, grand_Nontarget, ...
    Params_RSVP.baseline, 0:200:1000, std_target(:, interest_ch), std_nontarget(:, interest_ch), 'off');
yline(0);
legend({'Target', 'Non-target'});


%% Time-topo plots
%
% To draw scalp topography, one needs EEGLAB toolbox, which is opensource
% Matlab toolbox
% EEGLAB: https://sccn.ucsd.edu/eeglab/index.php

topo3D = cat(3, avg_target', avg_nontarget');
clim = [-3 3];
frames = 0:200:1200;
figure,
vis_temporalTopoplot(topo3D, Params_RSVP.srate, frames, chanlocs, clim);
colormap(redblue);

%% temporary - draw colorbar;

figure,
cb = colorbar('XTick', [-3, 0, 3]);
set(cb,'position',[.5 .5 .05 .22]);
caxis([-3 3]);
colormap(redblue);
set(gca, 'fontsize', 17);


%%
function out = find_badAmplitude(data3D, threshold)
% data3D: ch x time x trial
out = [];
for n_trial = 1:size(data3D, 3)
    cur_trial = data3D(:, :, n_trial);
    if sum(max(abs(cur_trial), [], 2) > threshold)
        out = cat(1, out, n_trial);
    end
end

end
