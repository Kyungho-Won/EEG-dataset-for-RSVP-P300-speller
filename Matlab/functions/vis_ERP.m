function vis_ERP(t, datA, datB, baseline, area_shade, std_datA, std_datB, opt_std)
% it draws ERP plot with baseline
%
% figure,
% vis_ERP(t, datA, datB, baseline, area_shade)
%
% area_shade: 0:200:1000
shade_color = [0.8 0.8 0.8 0.7; 1 1 1 0.7];
intervals = mean(diff(area_shade));

if strcmpi(opt_std, 'on')
    ERP_with_std(t, datB, std_datB, 'k'); hold on;
    ERP_with_std(t, datA, std_datA, [1 0.5 0]);
else
    plot(t, datB, 'color', 'k', 'linewidth', 4); hold on;
    plot(t, datA, 'color', [1 0.5 0], 'linewidth', 4);
end

set(gca, 'fontsize', 13);
set(gca, 'color', 'w');
xlabel('ms', 'fontsize', 11); ylabel('\muV', 'fontsize', 11);
set(gca, 'YGrid', 'on');
set(gca, 'linewidth', 1);
pbaspect([2 1 1]);

if ~isempty(area_shade)
    % shade for time intervals
    for i=1:length(area_shade)-1
        begin_shade = area_shade(i);
        rectangle('Position', [begin_shade min(get(gca, 'Ylim')) intervals diff(get(gca, 'Ylim'))], ...
            'EdgeColor', 'none', 'FaceColor', shade_color(mod(i,2)+1, :));
    end
    
    % shade for baseline
    rectangle('Position', [baseline(1), min(get(gca, 'Ylim')) diff(baseline) diff(get(gca, 'Ylim'))], ...
        'EdgeColor', 'none', 'FaceColor', [0.5 0.5 0.5, 0.7]); % darker shade
end

h = get(gca, 'Children'); % change display order (forward and backward)
set(gca, 'Children', flip(h));


end

%% subfunctions

% sub function
function ERP_with_std(t, dat, std, m_color)
x = t;
curve1 = (dat + std)';
curve2 = (dat - std)';

x2 = [x, fliplr(x)];
inBetweenArea = [curve1, fliplr(curve2)];
fill(x2, inBetweenArea, m_color, 'facealpha', 0.3, 'edgecolor', 'none'); hold on;
plot(t, dat, 'color', m_color, 'linewidth', 1.5);

end

