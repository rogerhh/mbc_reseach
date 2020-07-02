%% print sunrise time diff
sunrise_diff = csvread('~/mbc_research/data/src/compression_sim/sunrise_time_diff.csv');
sunrise_diff = sunrise_diff ./ 60;
len = size(sunrise_diff, 2);
d = 1:1:len;
f1 = figure(1);
hold off
plot(d, sunrise_diff);
hold on;
plot(d, 32 * ones(1,len), 'r--')
plot(d, -32 * ones(1,len), 'r--')
plot(d, 64 * ones(1,len), 'b--')
plot(d, -64 * ones(1,len), 'b--')
plot(d, 96 * ones(1,len), 'g--')
plot(d, -96 * ones(1,len), 'g--')

title('Sunrise times difference')
xlabel('days')
ylabel('Difference from actual sunrise (min)')

% positive values mean that actual edge is later than predicted edge

saveas(f1, '~/mbc_research/data/src/compression_sim/sunrise_time_diff.jpg');

%% print sunrise time diff
sunset_diff = csvread('~/mbc_research/data/src/compression_sim/sunset_time_diff.csv');
sunset_diff = sunset_diff ./ 60;
len = size(sunset_diff, 2);
d = 1:1:len;
f2 = figure(2);
hold off
plot(d, sunset_diff);
hold on;
plot(d, 32 * ones(1,len), 'r--')
plot(d, -32 * ones(1,len), 'r--')
plot(d, 64 * ones(1,len), 'b--')
plot(d, -64 * ones(1,len), 'b--')
plot(d, 96 * ones(1,len), 'g--')
plot(d, -96 * ones(1,len), 'g--')

title('Sunset times difference')
xlabel('days')
ylabel('Difference from actual sunset (min)')

% positive values mean that actual edge is later than predicted edge

saveas(f2, '~/mbc_research/data/src/compression_sim/sunset_time_diff.jpg');

%% print code diff
code_diff = importdata('~/mbc_research/data/src/compression_sim/code_diff.txt');
f3 = figure(3);
bar(code_diff(:, 1), code_diff(:, 2));

title('Code difference histogram')
xlabel('Code difference')

saveas(f3, '~/mbc_research/data/src/compression_sim/code_diff1.jpg');

axis([-200 200 -500 3000])

saveas(f3, '~/mbc_research/data/src/compression_sim/code_diff2.jpg');