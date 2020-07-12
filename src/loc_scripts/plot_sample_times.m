%%
v1 = importdata('~/mbc_research/data/src/compression_sim/sample_data/SN_20369363_2019-11-08_16_45_11_-0400_sample_times.csv');
v2 = importdata('~/mbc_research/data/src/compression_sim/sample_data/SN_20369363_2019-11-08_16_45_11_-0400_HOBO.csv');

f = figure

hold off;
plot(v1(:, 1), log10(v1(:, 2)), 'r')

hold on;
plot(v2(:, 1), log10(v2(:, 2)), 'b')

start = 1572500000;

for i=1:8
    axis([start+(i-1)*86400 start+i*86400 -3 5]);
    title(['SN 20369363 Day ', num2str(i)]);
    legend('resampled data', 'HOBO data')
    ylabel('log lux')
    saveas(f, ['~/mbc_research/data/src/compression_sim/SN 20369363 Day ', num2str(i), '.jpg'])
end

close all

%%
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

start = 1572500000;

for i=1:8
    axis([start+(i-1)*86400 start+i*86400 -3 5]);
    title(['SN 20369363 Day ', num2str(i)]);
    ylabel('log lux')
    saveas(f, ['~/mbc_research/data/src/compression_sim/SN 20369363 Day ', num2str(i), ' sample times.jpg'])
end

close all