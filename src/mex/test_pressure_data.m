t = 1567861969 : 15 : 1567861969 + 15 * 26448;
plot(t, indoor_data);
hold on;
plot(t, outdoor_data);
plot(t_ws, pres_ws, 'g');

title('Pressure Data');
xlabel('Seconds after epoch (s)');
ylabel('Pressure (hPa)');
legend('Indoor data', 'Outdoor data', 'Weather Station data');