v = importdata('~/mbc_research/data/src/compression_sim/sample_data/SN_20418697_2018-10-29_17_39_10_-0400_sample_times.csv');
a = log10((2 .^ v(:, 2)) / 1577);
figure(1)
hold off
for i = 1:size(v, 1)
    if i == 1 || (v(i, 1) - v(i - 1, 1) == 60)
        plot(v(i, 1), a(i), 'r.')
    elseif (v(i, 1) - v(i - 1, 1) == 120)
        plot(v(i, 1), a(i), 'b.')
    elseif (v(i, 1) - v(i - 1, 1) == 480)
        plot(v(i, 1), a(i), 'g*')
    else
        plot(v(i, 1), a(i), 'm*')
    end
    hold on
end
% plot(v(:, 1), a, '.')
figure(2)
plot(SN2.VarName2, log10(SN2.VarName4));