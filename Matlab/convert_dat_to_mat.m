% P3BCI2017 Letter Classification Training ver1: SWLDA
%
% Kyungho Won
%
% [ reference ]
% alumni code - bcicls.m
% data: BCI2000, 32 Biosemi2, 55 subjects
% target text: BRAIN, POWER / SUBJECT, NEURONS, IMAGINE, QUALITY
% target : standard = 30 : 180
%
% [ Stage ]
%  1. Pre-processing: bandpass filtering, extracting triggers
%     - frame = [0 800]
%     - baseline = [-200 0]
%
%  2. Apply SWLDA: getting w and w0 from SWLDA
%     - y = w0 + w' * feature
%     - class = sign(y)
clear; clc;
load('biosemi32_locs.mat');

for nsb=1:55
    
    eeg = cell(0);
    for run=1:2
        filename = sprintf('../data/S%02d/spell_trainS001R%02d.dat', nsb, run);
        cur_eeg = load_P3BCI2000(filename);
        cur_eeg.chanlocs = biosemi32_locs;
        eeg{run} = cur_eeg;
    end
    save(sprintf('./dat/s%02d/P300speller_train.mat', nsb), 'eeg');
    
    eeg = cell(0);
    for run=1:4
        filename = sprintf('../data/S%02d/spell_testS001R%02d.dat', nsb, run);
        cur_eeg = load_P3BCI2000(filename);
        cur_eeg.chanlocs = biosemi32_locs;
        eeg{run} = cur_eeg;
    end
    save(sprintf('./dat/s%02d/P300speller_test.mat', nsb), 'eeg');
    
end

%% Resting state

clear; clc;

fname_prefix = {'REST_OPENS001', 'REST_CLOSES001'};
% REST_OPENS001R01

for nsb=1
    eeg = cell(0);
    
    for eyes=1
        for run=1
            filename = sprintf('../data/S%02d/%sR%02d.dat', nsb, fname_prefix{eyes}, run);
            eeg{run} = pop_loadBCI2000({filename}, []);
        end
    end
    
end



