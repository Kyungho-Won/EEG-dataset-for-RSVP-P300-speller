function out = predictSWLDA(mdl, feature, opt)
% 
% out = predictSWLDA(mdl, feature, opt)
%
% This function predict labels using the trained SWLDA weights
%
% input:
%   - mdl: trained SWLDA model
%   - feature: [trial x features]
%   - opt: 'label' for -1 or 1, 'score' for regression value

predict_SWLDA = feature(:, mdl.INMODEL) * mdl.W(mdl.INMODEL) + mdl.STATS.intercept;

if strcmpi(opt, 'label')
    out = sign(predict_SWLDA);
elseif strcmpi(opt, 'score')
    out = predict_SWLDA;
end

end