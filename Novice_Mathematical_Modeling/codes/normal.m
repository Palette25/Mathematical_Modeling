data = xlsread('fuck.xlsx');
y = zeros(1, 18);

for i=1:18
    y(i) = 100*(i-0.5)/18;
end

plot(y, data);
