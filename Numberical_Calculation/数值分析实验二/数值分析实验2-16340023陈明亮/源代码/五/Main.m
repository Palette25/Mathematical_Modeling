%% 复合梯形公式和复合辛普森公式计算数值积分 - Main脚本 %%
nums = [5;8;17;33];
Tn = zeros(4,1);
Sn = zeros(4,1);

%% 复合梯形公式，采样点数目：5,9,17,33 %%
for i=1:4
   Tn(i) = Trapezoid(0, 1, nums(i)); 
end

plot(nums, Tn, 'r-');
grid on;
hold on;

%% 复合辛普森公式，采样点数目：5,9,17,33 %%
for i=1:4
   Sn(i) = Simpson(0, 1, nums(i)); 
end

plot(nums, Sn, 'b-');
legend({'Trapezoid', 'Simpson'}, 'Location','SouthEast');