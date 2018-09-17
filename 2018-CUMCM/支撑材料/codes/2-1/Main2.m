%% 测试运行双工序调度器的主函数脚本 %%
[origin_count, produce_count, point_arr, time_arr, produce_arr, cncs_path, rgv_path] = GreedySchedulerTwo(0.018, 0.032, 0.046, 0.455, 0.182, 0.027, 0.032, 0.025);
% 采取模拟退火算法优化优先规则指派方法所得初始解
[optimal_result, optimal_num] = SimulatedAnnealingSchedulerTwo(rgv_path, produce_count, 100, 100, 0.018, 0.032, 0.046, 0.027, 0.032, 0.455, 0.182, 0.025);

x = [];
y = [];
for i=0:99
   ttmp = optimal_result.get(i);
   x = [x, ttmp(1)];
   y = [y, ttmp(2)];
   disp(ttmp(1) + " " + ttmp(2) + " " + ttmp(3)+ " " + ttmp(4)+ " " + ttmp(5));
end
str = [repmat('', 100, 1) num2str(x') repmat(', ', 100, 1) num2str(y')];

plot(x, y, 'r-');
text(x, y, cellstr(str));