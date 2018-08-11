close all;
figure(1);
hold on;
title('Actual sunrise time vs time light = 100 lux')
xlabel('Sunrise time from daily offset (seconds)');
ylabel('Time when light = 100 lux form daily offset (seconds)');
plot([t1,t2,t3], [t1,t2,t3], 'ok');
axis([2.12 * 10^4, 2.26 * 10^4, 2.12 * 10^4, 2.26 * 10^4]);
legend('Actual Sunrise');
constr1 = makeConstraint('time', '>=', '07/05/18-09:00:00');
constr2 = makeConstraint('time', '<', '07/05/18-11:00:00');
constr3 = makeConstraint('light', '>', 99);
constr4 = makeConstraint('light', '<', 101);
constr5 = makeConstraint('SN', '==', 20369364);
constr6 = andConstraint(constr1, constr2, constr3, constr4, constr5);
[matrix, time, serial] = selectDatapoints(constr6, 'light');
offset = 1530763200;
t1 = 1530785089 - offset;
x0 = [t1, t1];
y0 = [time(1,:)];
y0 = y0 - offset;
plot(x0,y0, 'og');

constr1 = makeConstraint('time', '>=', '07/06/18-09:00:00');
constr2 = makeConstraint('time', '<', '07/06/18-11:00:00');
constr3 = makeConstraint('light', '>', 99);
constr4 = makeConstraint('light', '<', 101);
constr5 = makeConstraint('SN', '==', 20369364);
constr6 = andConstraint(constr1, constr2, constr3, constr4, constr5);
[matrix, time, serial] = selectDatapoints(constr6, 'light');
offset = 1530849600;
t2 = 1530871528 - offset;
x0 = [t2,t2];
y0 = [time(1,:)] - offset;
plot(x0,y0, 'og');

constr1 = makeConstraint('time', '>=', '07/07/18-09:00:00');
constr2 = makeConstraint('time', '<', '07/07/18-11:00:00');
constr3 = makeConstraint('light', '>', 99);
constr4 = makeConstraint('light', '<', 101);
constr5 = makeConstraint('SN', '==', 20369364);
constr6 = andConstraint(constr1, constr2, constr3, constr4, constr5);
[matrix, time, serial] = selectDatapoints(constr6, 'light');
offset = 1530936000;
t3 = 1530957969 - offset;
x0 = [t3,t3];
y0 = [time(1,:)] - offset;
plot(x0,y0, 'og');


constr1 = makeConstraint('time', '>=', '07/05/18-09:00:00');
constr2 = makeConstraint('time', '<', '07/05/18-11:00:00');
constr3 = makeConstraint('light', '>', 99);
constr4 = makeConstraint('light', '<', 101);
constr5 = makeConstraint('SN', '==', 20369365);
constr6 = andConstraint(constr1, constr2, constr3, constr4, constr5);
[matrix, time, serial] = selectDatapoints(constr6, 'light');
offset = 1530763200;
t = 1530785089 - offset;
x0 = [t,t,t];
y0 = [time(1,:)];
y0 = y0 - offset;
plot(x0,y0, 'or');

constr1 = makeConstraint('time', '>=', '07/06/18-09:00:00');
constr2 = makeConstraint('time', '<', '07/06/18-11:00:00');
constr3 = makeConstraint('light', '>', 99);
constr4 = makeConstraint('light', '<', 101);
constr5 = makeConstraint('SN', '==', 20369365);
constr6 = andConstraint(constr1, constr2, constr3, constr4, constr5);
[matrix, time, serial] = selectDatapoints(constr6, 'light');
offset = 1530849600;
t = 1530871528 - offset;
x0 = [t];
y0 = [time(1,:)] - offset;
plot(x0,y0, 'or');

constr1 = makeConstraint('time', '>=', '07/07/18-09:00:00');
constr2 = makeConstraint('time', '<', '07/07/18-11:00:00');
constr3 = makeConstraint('light', '>', 99);
constr4 = makeConstraint('light', '<', 101);
constr5 = makeConstraint('SN', '==', 20369365);
constr6 = andConstraint(constr1, constr2, constr3, constr4, constr5);
[matrix, time, serial] = selectDatapoints(constr6, 'light');
offset = 1530936000;
t = 1530957969 - offset;
x0 = [t];
y0 = [time(1,:)] - offset;
plot(x0,y0, 'or');

constr1 = makeConstraint('time', '>=', '07/05/18-09:00:00');
constr2 = makeConstraint('time', '<', '07/05/18-11:00:00');
constr3 = makeConstraint('light', '>', 198);
constr4 = makeConstraint('light', '<', 202);
constr5 = makeConstraint('SN', '==', 20369361);
constr6 = andConstraint(constr1, constr2, constr3, constr4, constr5);
[matrix, time, serial] = selectDatapoints(constr6, 'light');
offset = 1530763200;
t = 1530785089 - offset;
x0 = [t];
y0 = [time(1,:)];
y0 = y0 - offset;
plot(x0,y0, 'ob');

constr1 = makeConstraint('time', '>=', '07/06/18-09:00:00');
constr2 = makeConstraint('time', '<', '07/06/18-11:00:00');
constr3 = makeConstraint('light', '>', 198);
constr4 = makeConstraint('light', '<', 202);
constr5 = makeConstraint('SN', '==', 20369361);
constr6 = andConstraint(constr1, constr2, constr3, constr4, constr5);
[matrix, time, serial] = selectDatapoints(constr6, 'light');
offset = 1530849600;
t = 1530871528 - offset;
x0 = [t,t];
y0 = [time(1,:)] - offset;
plot(x0,y0, 'ob');

constr1 = makeConstraint('time', '>=', '07/07/18-09:00:00');
constr2 = makeConstraint('time', '<', '07/07/18-11:00:00');
constr3 = makeConstraint('light', '>', 198);
constr4 = makeConstraint('light', '<', 202);
constr5 = makeConstraint('SN', '==', 20369361);
constr6 = andConstraint(constr1, constr2, constr3, constr4, constr5);
[matrix, time, serial] = selectDatapoints(constr6, 'light');
offset = 1530936000;
t = 1530957969 - offset;
x0 = [t,t];
y0 = [time(1,:)] - offset;
plot(x0,y0, 'ob');