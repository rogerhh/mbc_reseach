hold on;
for i = 8:13
data = matrix{i,1};
l = [data.light_intensity];
plot([data.time], log10(l));
end
axis([-inf inf 0 inf]);