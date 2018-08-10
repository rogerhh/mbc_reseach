close all;
figure(1);
title('Sunset on 07/05 with different sensors');
xlabel('time (t)');
ylabel('log10(lux)')
hold on;
constr1 = makeConstraint('time', '>=', '07/06/18-00:00:00');
constr2 = makeConstraint('time', '<', '07/06/18-02:00:00');
constr3 = andConstraint(constr1, constr2);
[matrix, time, serial] = selectDatapoints(constr3, 'light');
t = 1530839666;
x1 = [t,t];
y1 = [1,3];
plot(time(1,:), log10(matrix(1,:)));
plot(time(2,:), log10(matrix(2,:)));
plot(time(3,:), log10(matrix(3,:)));
plot(time(4,:), log10(matrix(4,:)));
plot(x1,y1, '--k');

figure(2);
title('Sunset on 07/06 with different sensors');
xlabel('time (t)');
ylabel('log10(lux)')
hold on;
constr1 = makeConstraint('time', '>=', '07/07/18-00:00:00');
constr2 = makeConstraint('time', '<', '07/07/18-02:00:00');
constr3 = andConstraint(constr1, constr2);
[matrix, time, serial] = selectDatapoints(constr3, 'light');
t = 1530926047;
x1 = [t,t];
y1 = [1,3];
plot(time(1,:), log10(matrix(1,:)));
plot(time(2,:), log10(matrix(2,:)));
plot(time(3,:), log10(matrix(3,:)));
plot(time(4,:), log10(matrix(4,:)));
plot(x1,y1, '--k');

%figure(3);
%title('Sunset on 07/07 with different sensors');
%xlabel('time (t)');
%ylabel('log10(lux)')
%hold on;
%constr1 = makeConstraint('time', '>=', '07/08/18-00:00:00');
%constr2 = makeConstraint('time', '<', '07/08/18-02:00:00');
%constr3 = andConstraint(constr1, constr2);
%[matrix, time, serial] = selectDatapoints(constr3, 'light');
%t = 1531012425;
%x1 = [t,t];
%y1 = [1,3];
%plot(time(1,:), log10(matrix(1,:)));
%plot(time(2,:), log10(matrix(2,:)));
%plot(time(3,:), log10(matrix(3,:)));
%plot(time(4,:), log10(matrix(4,:)));
%plot(x1,y1, '--k');