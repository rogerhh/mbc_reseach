function out = show_result_func(file)


% This script is used to show the test result of neural networks
DISPLAY = 1;

['~/butterfly_localization/Testdata/', file, '.mat']

load(['~/butterfly_localization/Testdata/', file, '.mat']);
load(['~/butterfly_localization/results/result_', file, '.mat']);

['~/butterfly_localization/loc/', file, '_loc.csv']

loc_file = regexprep(file, '_Month.+Day.+', '_loc');
loc = importdata(['~/butterfly_localization/loc/', loc_file, '.csv'])

lat_fine = interp(lat_grid, 2);
long_fine = interp(long_grid, 2);

lat_fine = lat_fine(1:end-1);
long_fine = long_fine(1:end-1);

[long_cor_grid, lat_cor_grid] = meshgrid(long_grid, lat_grid);
[long_fine_grid, lat_fine_grid] = meshgrid(long_fine, lat_fine);

light_coarse = results';
light_intp = interp2(long_cor_grid,lat_cor_grid,light_coarse,long_fine_grid,lat_fine_grid, 'cubic', 0);
light_intp(light_intp<0) = 0;
   
if DISPLAY == 1
    
    f = figure
    subplot(1,3,1)
    title('Coarse grid')
    surface(long_grid,lat_grid,light_coarse, 'edgecolor', 'None');
    xlabel('longitude')
    ylabel('latitude')
    xlim([long_grid(1), long_grid(end)]);
    ylim([lat_grid(1), lat_grid(end)]);
    hold on
    plot3(loc(2), loc(1), 10000, 'r.', 'MarkerSize', 10);
      
    subplot(1,3,2)
    title('Fine grid')
    surface(long_fine,lat_fine,light_intp, 'edgecolor', 'None')
    xlabel('longitude')
    ylabel('latitude')
    xlim([long_fine(1), long_fine(end)]);
    ylim([lat_fine(1), lat_fine(end)]);
    hold on
    plot3(loc(2), loc(1), 10000, 'r.', 'MarkerSize', 10);
    
    lights = [];
    for j = 1:size(test_light,1)
        mm = light_coarse(:,j) > 0.5;
        if sum(mm)>1
            lights = [lights; squeeze(test_light(j,mm,:))];
        elseif sum(mm)==1
            lights = [lights; squeeze(test_light(j,mm,:))'];
        end
    end
    
    subplot(1,3,3)
    title('Good curves')
    plot(lights');hold on
    plot(120*ones(1,100), linspace(0,2,100), 'linewidth',2);hold on
    plot(360*ones(1,100), linspace(0,2,100), 'linewidth',2);hold on
   
    saveas(f, ['~/butterfly_localization/images/', file, '.jpg'])
    
end

clear all
% close all

end