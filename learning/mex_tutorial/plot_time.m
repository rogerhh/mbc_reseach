figure(1);
hold off;
start_str = '06/25/18-04:00:00';
end_str = '06/25/18-04:00:00';
[t,s] = mex_test(20369361, start_str, end_str);
plot(t,log10(s+1), '-b');

title('Light intensity data for different sensors on 07/07 local time');
xlabel('Seconds after epoch');
ylabel('Log(lux)')