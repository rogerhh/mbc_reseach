close all
hold off
plot(log(table2array(log2(:,1))) / log(2), log(table2array(log2(:,1))) / log(2));
hold on
grid on
plot(log(table2array(log2(:,1))) / log(2), table2array(log2(:,2)));
title('func\_log2(X) output');
legend('(log2(X), log2(X))', '(log2(X), func\_log2(X))');