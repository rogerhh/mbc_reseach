hold off
%a = importdata('~/Downloads/Pressure sensor calibration summary.xlsx');
pres = importdata('~/Downloads/Time conversion exercise.csv')
for i = 2:4:99
    hold on
    plot(a(:, i), a(:, i + 1))
end
plot(pres(:, 2), pres(:, 3), 'b')
grid on