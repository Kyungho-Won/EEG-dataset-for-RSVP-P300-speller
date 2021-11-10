function out = segment_with_rmbase(data, markers, frame, baseline, srate, out_dim)

ind = find(markers>0);
segmented = [];

for nTrials = 1:length(ind)
    
    % segment EEG based on frame
    begin_frame = ind(nTrials)+floor(frame(1)/1000*srate);
    end_frame = ind(nTrials)+floor(frame(2)/1000*srate)-1;
    
    tmp_frame = data(:, begin_frame:end_frame);
    
    % calculate baseline EEG
    begin_base = ind(nTrials)+floor(baseline(1)/1000*srate);
    end_base = ind(nTrials)+floor(baseline(2)/1000*srate)-1;
    tmp_baseline = data(:, begin_base:end_base);
    
    avg_baseline = mean(tmp_baseline, 2);
    rep_baseline = repmat(avg_baseline, 1, size(tmp_frame, 2));
    
    % rmbase from the segmented EEG
    tmp_Corrected = tmp_frame - rep_baseline;
    segmented = cat(3, segmented, tmp_Corrected);
end

if strcmpi(out_dim, '2D')
    % out dim: [ch x (timextrial)]
    out = reshape(segmented, size(segmented, 1), size(segmented, 2)*size(segmented, 3));
elseif strcmpi(out_dim, '3D')
    % out dim: [ch x time x trial]
    out = segmented;
end

end