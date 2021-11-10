

for nsb = 1:55
    clear EEG
    fdirectory = sprintf('./dat/s%02d/', nsb);
    
    train = importdata([fdirectory 'P300speller_train.mat']);
    test = importdata([fdirectory 'P300speller_test.mat']);
    RSVP = load([fdirectory 'RSVP.mat']);
    senloc = load([fdirectory 'electrodes_position.mat']);
    rest = importdata([fdirectory 'Rest.mat']);
    
    EEG.train = train;
    EEG.test = test;
    EEG.RSVP = RSVP;
    EEG.senloc = senloc;
    EEG.rest = rest;
    
    fname_out = sprintf('F:/Main/matlab_workspace/P3BCI2017_current/Won2021/data/s%02d.mat', nsb);
    save(fname_out, '-v7.3', '-struct', 'EEG');
    disp([fname_out ' saved']);
end







