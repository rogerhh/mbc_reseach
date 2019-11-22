%% PMU Output
figure(1);
hold off;
plot(supply_v, r_v, '-*');
hold on;
plot(supply_v, v1p2_v, '-*');
plot(supply_v, v0p6_v, '-*');
grid on;
axis([3.6 4.2 0 4.2]);
t = 3.6:0.1:4.2;
y = 3.6 * ones(size(t));
plot(t, y, '--');

y = 1.2 * ones(size(t));
plot(t, y, '--');

y = 0.6 * ones(size(t));
plot(t, y, '--');

legend('Voltage at PMU input', 'V1P2 output', 'V0P6 output');
xlabel('Supply Voltage (V)');
ylabel('Output Voltage (V)');