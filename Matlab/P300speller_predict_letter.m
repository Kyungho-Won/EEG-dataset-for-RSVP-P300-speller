% P300Speller Letter Classification Training ver1: SWLDA
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
%     - freq = [0.5 10]
%     - frame = [0 600]
%     - baseline = [-200 0]
%
%  2. Apply SWLDA: getting w and w0 from SWLDA
%     - y = w0 + w' * feature
%     - class = sign(y)
%  * In code,
%  predictor = sign(feature(:, INMODEL) * W(INMODEL) + STATS.intercept)
%   INMODEL (selected features)
%   W (selected weights)
%   STATS.intercept: W0
clear; clc;

ch = 1:32; % select channels
% select_ch = find(ismember({biosemi32_locs.labels}, ...
%     {'FZ', 'Cz', 'Pz', 'CP1', 'CP2'}));
spellermatrix = ...
    ['A', 'B', 'C', 'D', 'E', 'F', ...
    'G', 'H', 'I', 'J', 'K', 'L', ...
    'M', 'N', 'O', 'P', 'Q', 'R', ...
    'S', 'T', 'U', 'V', 'W', 'X', ...
    'Y', 'Z', '1', '2', '3', '4', ...
    '5', '6', '7', '8', '9', '_'];
Configs_P3speller = struct('seq_code', 1:12, 'full_repeat', 15, ...
    'spellermatrix', spellermatrix);
Params_P3speller = struct('freq', [0.5 10], 'frame', [0 600], ...
    'baseline', [-200 0], 'select_ch', 1:32);

for nsb=1:55
    fname = sprintf('./data/s%02d.mat', nsb);
    EEG = load(fname);
    eeg_train = EEG.train;
    
    % ------------------------ CALIBRATION EEG ------------------------- %
    feat_train = [];
    label_train = [];
    for nRun = 1:length(eeg_train)
        cur_eeg = eeg_train{nRun};
        data = cur_eeg.data(ch,:);
        cur_eeg.data = data;
        
        [feature_set, label_set] = preproc_P3speller(cur_eeg, Params_P3speller, 'labeled');
        feat_train = cat(1, feat_train, feature_set);
        label_train = cat(1, label_train, label_set);
    end
    
    % train SWLDA
    rd = shuffle([feat_train label_train]);
    feat_train = rd(:, 1:end-1);
    label_train = rd(:, end);
    mdl_SWLDA = trainSWLDA(feat_train, label_train, 0.08, 60);
    
    predictor = predictSWLDA(mdl_SWLDA, feat_train, 'label');
    acc_binary_epoch = sum(predictor==label_train) / length(label_train);
    fprintf('P300 speller train epoch classification accuracy is %.2f%%\n', 100*acc_binary_epoch);
    
    % ----------------------------- TEST EEG --------------------------- %
    eeg_test = EEG.test;
    % load classifier weight and display results
    for nRun = 1:length(eeg_test)
        cur_eeg = eeg_test{nRun};
        word_len = cur_eeg.nbTrials / (length(Configs_P3speller.seq_code)*Configs_P3speller.full_repeat);
  
        data = cur_eeg.data(ch,:); % remove extra channels for analysis
        cur_eeg.data = data;
        [feat_test, label_train] = preproc_P3speller(cur_eeg, Params_P3speller, 'labeled');
        
        rd = shuffle([feat_test label_train]);
        feat_test = rd(:, 1:end-1);
        label_train = rd(:, end);
        
        predictor = predictSWLDA(mdl_SWLDA, feat_test, 'label');
        acc_binary_epoch = sum(predictor==label_train) / length(label_train);
        %         fprintf('P300 speller epoch (binary) classification accuracy is %.2f%%\n', 100*acc_swlda);
        
        % ------------ letter detection accuracy
        markers_seq = cur_eeg.markers_seq;
        letter_idx = find(ismember(cur_eeg.markers_seq, Configs_P3speller.seq_code)); % seq len x # of repetition x # of words
        feat_unknown = preproc_P3speller(cur_eeg, Params_P3speller, 'unknown');
        
%         own classifier - predicted label for feat_unknwon
%         (predicted_labels) target: positive, non-target: negative
%         ans_letters_custom = detect_letter_P3speller_custom(predicted_labels, world_len, ...
%             cur_eeg.text_to_spell, letter_idx, markers_seq, Configs_P3speller);       
        ans_letters = detect_letter_P3speller(mdl_SWLDA, word_len, feat_unknown, ...
            cur_eeg.text_to_spell, letter_idx, markers_seq, Configs_P3speller);
        
        acc_on_repetition(nsb, nRun, :) = ans_letters.acc_on_repetition; % [nbsub, nbrun, nbrepetition(1~15)]
        correct_on_repetition(nsb, nRun, :) = ans_letters.correct_on_repetition; % [nbsub, nbrun, nbrepetition(1~15)]

        fprintf('User answer: %s (%d/%d), accuracy: %.2f\n', ...
            ans_letters.text_result, correct_on_repetition(nsb, nRun, 15), word_len, acc_on_repetition(nsb, nRun, 15));
    end
    fprintf('\nOverall: %d/%d, accuracy: %.2f\n\n', sum(correct_on_repetition(nsb, :, Configs_P3speller.full_repeat), 2), ...
        word_len*nRun, sum(correct_on_repetition(nsb, :, Configs_P3speller.full_repeat), 2)/(word_len*nRun));
    
end


save('Total_performance.mat', 'acc_on_repetition', 'correct_on_repetition');
%%

load('Total_performance.mat');

disp(size(correct_on_repetition));
total_corrected_repeat = squeeze(sum(correct_on_repetition, 2));
total_acc_repeat = total_corrected_repeat / 28;

avgd_acc = mean(total_acc_repeat, 1);

figure, 
h=boxchart(total_acc_repeat);
pbaspect([2 1 1]);
set(gca, 'fontsize', 13);
xlabel('The nubmer of repetitions');
ylabel('Letter detection accuracy');
hold on;
box on;
plot(avgd_acc, '-o');

% ylim([0 1.2]);
% % text(0.5, 1.1, num2str(round(avgd_acc(1), 2)));


%% bar plot
sky_boxchart = [0 0.4470 0.7410];
figure,
bar(total_acc_repeat(:, end), ...
    'FaceColor', sky_boxchart, 'FaceAlpha', 0.2, ...
    'EdgeColor', sky_boxchart, 'Linewidth', 1.2); 
set(gca, 'fontsize', 13);
xlabel('Subjects');
ylabel('Offline letter detection accuracy');
ylim([0.4 1]);
xlim([0 56]);
pbaspect([2 1 1]);











