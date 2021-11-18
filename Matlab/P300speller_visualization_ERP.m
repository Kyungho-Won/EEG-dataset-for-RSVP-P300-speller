% P300Speller Visualization ver1
%
% Kyungho Won
%
% [ reference ]
% data: BCI2000, 32 Biosemi2, 55 subjects
% target text: BRAIN, POWER / SUBJECT, NEURONS, IMAGINE, QUALITY
% target : standard = 30 : 150
%
% [ Stage ]
%  1. Pre-processing: bandpass filtering, extracting triggers
%     - freq = [0.5 40]
%     - frame = [0 1000]
%     - baseline = [-200 0]

clear; clc;
ch = 1:32; % select channels

Params_P3speller = struct('freq', [1 10], 'frame', [0 1000], ...
    'baseline', [-200 0], 'select_ch', 1:32);
electrodes_midline = {'FZ', 'Cz', 'Pz'};
electrodes_eyes = {'FP1', 'FP2', 'AF3', 'AF4'};

for nsb=1
    fname_train = sprintf('./data/s%02d.mat', nsb);
    EEG = load(fname_train);
    eeg_test = EEG.test;
    
    % ------------------------ CALIBRATION EEG ------------------------- %
    eeg_target = [];
    eeg_nontarget = [];
    for nRun = 1:length(eeg_test)
        cur_eeg = eeg_test{nRun};
        interest_ch = ismember({cur_eeg.chanlocs.labels}, electrodes_midline);
        [cur_target, cur_nontarget] = preproc_extractEpoch(cur_eeg, Params_P3speller);
        
        eeg_target = cat(3, eeg_target, cur_target);
        eeg_nontarget = cat(3, eeg_nontarget, cur_nontarget);
    end
    
    figure,
    t = linspace(Params_P3speller.baseline(1), Params_P3speller.frame(2), size(cur_target, 2));
    avg_target = mean(eeg_target, 3)';
    avg_nontarget = mean(eeg_nontarget, 3)';
    
    std_target = std(cur_target, [], 3)';
    std_nontarget = std(cur_nontarget, [], 3)';
    vis_ERP(t, avg_target(:, interest_ch), avg_nontarget(:, interest_ch), ...
        Params_P3speller.baseline, 0:200:1000, std_target(:, interest_ch), std_nontarget(:, interest_ch), 'off');
    
    topo3D = cat(3, avg_target', avg_nontarget', (avg_target-avg_nontarget)');
    clim = [-3 3];
    frames = 0:200:1200;
    figure,
    vis_temporalTopoplot(topo3D, cur_eeg.srate, frames, cur_eeg.chanlocs, clim);
    colormap(redblue);
end


%% grand-averaged

clear; clc;
ch = 1:32; % select channels
nbsub = 55;
Params_P3speller = struct('freq', [1 10], 'frame', [0 1000], ...
    'baseline', [-200 0], 'select_ch', 1:32);
electrodes_midline = {'FZ', 'Cz', 'Pz'};

grand_target = [];
grand_nontarget =[];

for nsb=1:nbsub
    fname = sprintf('./data/s%02d.mat', nsb);
    EEG = load(fname);
    fprintf('Loading %s..\n', fname);
    eeg_test = EEG.test;
    
    % ------------------------ CALIBRATION EEG ------------------------- %
    eeg_target = [];
    eeg_nontarget = [];
    for nRun = 1:length(eeg_test)
        cur_eeg = eeg_test{nRun};
        interest_ch = ismember({cur_eeg.chanlocs.labels}, electrodes_midline);
        [cur_target, cur_nontarget] = preproc_extractEpoch(cur_eeg, Params_P3speller);
        
        eeg_target = cat(3, eeg_target, cur_target);
        eeg_nontarget = cat(3, eeg_nontarget, cur_nontarget);
    end
    
    % individual peak amplitude and latency
    [ERP_amp(nsb), ERP_lat(nsb)] = max(mean(mean(eeg_target(interest_ch, :, :), 3), 1));
    
    grand_target = cat(3, grand_target, mean(eeg_target,3));
    grand_nontarget = cat(3, grand_nontarget, mean(eeg_nontarget,3));
end
disp('done');

%% save - current grand average settings

SpellerERP_grand.target = grand_target;
SpellerERP_grand.nontarget = grand_nontarget;
SpellerERP_grand.cfg = Params_P3speller;
SpellerERP_grand.ch = electrodes_midline;
SpellerERP_grand.ERP_amp = ERP_amp;
SpellerERP_grand.ERP_lat = ERP_lat;
SpellerERP_grand.t = linspace(Params_P3speller.baseline(1), Params_P3speller.frame(2), size(cur_target, 2));

save('SpellerERP_grand.mat', '-v7.3', '-struct', 'SpellerERP_grand');
disp('done');

%% load

SpellerERP_grand = load('SpellerERP_grand.mat');

%% ERP
Params_P3speller = struct('freq', [1 10], 'frame', [0 1000], ...
    'baseline', [-200 0], 'select_ch', 1:32, 'srate', 512);
electrodes_midline = {'FZ', 'Cz', 'Pz'};
chanlocs = importdata('biosemi32_locs.mat');
interest_ch = ismember({chanlocs.labels}, electrodes_midline);

figure,
t = linspace(Params_P3speller.baseline(1), Params_P3speller.frame(2), size(SpellerERP_grand.target, 2));
avg_target = mean(SpellerERP_grand.target, 3)';
avg_nontarget = mean(SpellerERP_grand.nontarget, 3)';

std_target = std(SpellerERP_grand.target, [], 3)';
std_nontarget = std(SpellerERP_grand.nontarget, [], 3)';

grand_Target = mean(avg_target(:, interest_ch),2);
grand_Nontarget = mean(avg_nontarget(:, interest_ch),2);
vis_ERP(t, grand_Target, grand_Nontarget, ...
    Params_P3speller.baseline, 0:200:1000, std_target(:, interest_ch), std_nontarget(:, interest_ch), 'off');
yline(0);
legend({'Target', 'Non-target'});

%% Time topo

topo3D = cat(3, avg_target', avg_nontarget');
clim = [-1 1];
frames = 0:200:1200;
figure,
vis_temporalTopoplot(topo3D, Params_P3speller.srate, frames, chanlocs, clim);
colormap(redblue);


