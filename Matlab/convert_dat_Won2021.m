for nsb=1:55
    fname_train = sprintf('./dat/s%02d/P300speller_train.mat', nsb);
    disp(fname_train);
    eeg_train = importdata(fname_train);
    eeg = cell(0);
    for nRun = 1:length(eeg_train)
        cur_eeg = eeg_train{nRun};
%         cur_eeg.data = double(cur_eeg.data(1:32, :));
        cur_eeg.data = reref(cur_eeg.data(1:32, :), [], 'keepref', 'on');
%         cur_eeg = rmfield(cur_eeg, 'comment');
        
        eeg{nRun} = cur_eeg;
    end
    save(fname_train, 'eeg');
    
    fname_test = sprintf('./dat/s%02d/P300speller_test.mat', nsb);
    disp(fname_test);
    eeg_test = importdata(fname_test);
    eeg = cell(0);
    for nRun = 1:length(eeg_test)
        cur_eeg = eeg_test{nRun};
%         cur_eeg.data = double(cur_eeg.data(1:32, :));
        cur_eeg.data = reref(cur_eeg.data(1:32, :), [], 'keepref', 'on');
%         cur_eeg = rmfield(cur_eeg, 'comment');
        
        eeg{nRun} = cur_eeg;
    end
    save(fname_test, 'eeg');
end