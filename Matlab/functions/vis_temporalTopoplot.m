function vis_temporalTopoplot(dat, srate, frames, chanlocs, clim)
nTopo = length(diff(frames));

frame3D = [];
for i=1:length(frames)-1
    frame3D = cat(1, frame3D, [frames(i) frames(i+1)]);
end

if ismatrix(dat)
    for i=1:nTopo        
        begin_points = floor(frame3D(i, 1)/1000*srate)+1;
        end_points = floor(frame3D(i, 2)/1000*srate);
        cur_topo = mean(dat(:, begin_points:end_points), 2);
        
        subplot(1,nTopo, i);
        topoplot(cur_topo, chanlocs, ...
            'emarker', {'.', 'k', 6, 5}, 'numcontour', 4);
        caxis(clim);
    end
else % 3D
    for i=1:size(dat, 3)
        for j=1:nTopo
            begin_points = floor(frame3D(j, 1)/1000*srate)+1;
            end_points = floor(frame3D(j, 2)/1000*srate);
            cur_topo = mean(dat(:, begin_points:end_points, i), 2);
            
            subplot(size(dat,3), nTopo, nTopo*(i-1)+j);
            topoplot(cur_topo, chanlocs, ...
                'emarker', {'.', 'k', 6, 5}, 'numcontour', 4);
            caxis(clim);
        end
    end
end

set(gcf, 'color', 'w');
end