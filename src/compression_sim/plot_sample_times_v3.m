arr = dir('~/mbc_research/data/src/compression_sim/sample_data/*light_sample_times*')
filename = arr(1).name;
v1 = importdata(['~/mbc_research/data/src/compression_sim/sample_data/', filename]);

f = figure
hold off
for i=1:size(v1, 1)
    if i == 1 | v1(i, 1) - v1(i - 1, 1) == 60
        plot(v1(i, 1), log10(v1(i, 2)), 'r.')
    elseif v1(i, 1) - v1(i - 1, 1) == 120
        plot(v1(i, 1), log10(v1(i, 2)), 'b.')
    elseif v1(i, 1) - v1(i - 1, 1) == 480
        plot(v1(i, 1), log10(v1(i, 2)), 'g*')
    else
        plot(v1(i, 1), log10(v1(i, 2)), 'm*')
    end
    hold on
end