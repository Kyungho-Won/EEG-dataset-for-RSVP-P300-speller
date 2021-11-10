load('biosemi32_locs.mat');
dat = data_of_transformed_pen;

labels_ex3 = {'LA', 'RA', 'Nasion'};
labels_all = cat(2, labels_ex3, {biosemi32_locs.labels});

figure, 
plot3(dat(:,1), dat(:,2), dat(:,3), 'r.');
text(dat(:,1), dat(:,2), dat(:,3), labels_all);
grid on;