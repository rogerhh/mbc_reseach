%% Flash Bulk Read 0p7
y = [read_power(1) read_power(4) read_power(7)];
x = [-10 25 60];
figure(1);
plot(x, y);
title('Flash Bulk Read 0p7');
xlabel('Temp (C)');
ylabel('Power (uW)');
grid on;
axis([-15 65 0 20])

%% Flash Bulk Write 0p7
y = [write_power(1) write_power(4) write_power(7)];
x = [-10 25 60];
figure(2);
plot(x, y);
title('Flash Bulk Write 0p7');
xlabel('Temp (C)');
ylabel('Power (uW)');
grid on;
axis([-15 65 0 20])

%% Flash Bulk Read 1p4
y = [read_power(2) read_power(5) read_power(8)];
x = [-10 25 60];
figure(3);
plot(x, y);
title('Flash Bulk Read 1p4');
xlabel('Temp (C)');
ylabel('Power (uW)');
grid on;
axis([-15 65 0 35])

%% Flash Bulk Write 1p4
y = [write_power(2) write_power(5) write_power(8)];
x = [-10 25 60];
figure(4);
plot(x, y);
title('Flash Bulk Write 1p4');
xlabel('Temp (C)');
ylabel('Power (uW)');
grid on;
axis([-15 65 0 35]);

%% Flash Bulk Read 4p1
y = [read_power(3) read_power(6) read_power(9)];
x = [-10 25 60];
figure(5);
plot(x, y);
title('Flash Bulk Read 4p1');
xlabel('Temp (C)');
ylabel('Power (uW)');
grid on;
axis([-15 65 0 25]);

%% Flash Bulk Write 4p1
y = [write_power(3) write_power(6) write_power(9)];
x = [-10 25 60];
figure(6);
plot(x, y);
title('Flash Bulk Write 4p1');
xlabel('Temp (C)');
ylabel('Power (uW)');
grid on;
axis([-15 65 0 100]);