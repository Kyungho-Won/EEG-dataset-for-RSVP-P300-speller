total_online_acc = [];
for nsb=1:55

    
    fname_test = sprintf('./dat/s%02d/P300speller_test.mat', nsb);
    disp(fname_test);
    eeg_test = importdata(fname_test);
    eeg = cell(0);
    sub_online_acc = 0;
    for nRun = 1:length(eeg_test)
        cur_eeg = eeg_test{nRun};
        
        sub_online_acc = sub_online_acc + sum(cur_eeg.text_to_spell==cur_eeg.text_result);
    end
    total_online_acc = cat(1, total_online_acc, sub_online_acc);

end

%%

figure, plot(total_online_acc/28, '.'); box off;
set(gca, 'fontsize', 13);
xlabel('subjects');
ylabel('letter detection accuracy');