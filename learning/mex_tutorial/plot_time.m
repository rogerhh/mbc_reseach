figure(1);
hold off;
start_str = '07/08/18-00:00:00';
end_str = '07/08/18-02:00:00';
[t,s] = mex_test(20369364, start_str, end_str);
plot(t,log10(s+1), '-b');
hold on;
[t,s] = mex_test(20369365, start_str, end_str);
plot(t,log10(s+1), '-r');
[t,s] = mex_test(20369366, start_str, end_str);
plot(t,log10(s+1), '-g');
time = 1531012425;
x = [time, time];
y = [0, 3.5];
plot(x,y, '--k');

title('Light intensity data for different sensors on 07/07 local time');
xlabel('Seconds after epoch');
ylabel('Log(lux)')