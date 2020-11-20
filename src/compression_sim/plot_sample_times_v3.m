filename = 'SN_20418697_2018-10-29_17_39_10_-0400';
v1 = importdata(['~/mbc_research/data/src/compression_sim/sample_data/', filename, '_light_sample_times.csv']);
v2 = importdata(['~/mbc_research/data/src/compression_sim/sample_data/', filename, '_light_HOBO.csv']);

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

plot(v2(:, 1), log10(v2(:, 2)), 'b')