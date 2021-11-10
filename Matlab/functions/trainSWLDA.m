function out = trainSWLDA(feature, label, p_enter, n_feature)
% 
% out = trainSWLDA(feature, label, p_enter, n_feature)
%
% This function calculate weight using stepwise linear regression
%
% input:
%   - feature: [trial x features]
%   - label: [trial x 1] -1 or 1
%   - p_enter: p-values for adding SWLDA (default: 0.08)
%   - n_feature: selected feature (default: 60)

[W, SE, PVAL, INMODEL, STATS, NEXTSTEP, HISTORY] = ...
    stepwisefit(feature, label, 'penter', p_enter, 'display', 'off');

if length(find(INMODEL==1)) > n_feature
   [~, sort_ind] = sort(PVAL);
   INMODEL = zeros(1, length(PVAL));
   INMODEL(sort_ind(1:60)) = 1;
   INMODEL = logical(INMODEL);
end

mdl = struct('W', W, 'SE', SE, 'PVAL', PVAL, 'INMODEL', INMODEL, ...
    'STATS', STATS, 'NEXTSTEP', NEXTSTEP, 'HISTORY', HISTORY);
out = mdl;
end