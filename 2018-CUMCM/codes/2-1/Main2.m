%% 测试运行双工序调度器的主函数脚本 %%
[origin_count, produce_count, point_arr, time_arr, produce_arr, cncs_path, rgv_path] = GreedySchedulerTwo(0.018, 0.032, 0.046, 0.455, 0.182, 0.027, 0.032, 0.026);
% 采取模拟退火算法优化优先规则指派方法所得初始解
%[optimal_result, optimal_num] = SimulatedAnnealingSchedulerTwo(rgv_path, produce_count, 100, 100, 0.018, 0.032, 0.046, 0.027, 0.032, 0.455, 0.182, 0.025);

store = zeros(1000, 7);
count = 0;
scount = 0;
store1 = zeros(500, 4);
for i=0:rgv_path.size()-1
   ttmp = rgv_path.get(i);
   id = ttmp(1);
   if store1(id, 1) == 0
      store1(id,:) = [ttmp(1), ttmp(2), ttmp(4)*1000, (ttmp(4)+ttmp(5))*1000];
   else
      temp = store1(id,:);
      store(id,:) = [temp(1), temp(2), temp(3), temp(4), ttmp(2), ttmp(4)*1000, (ttmp(4)+ttmp(5))*1000];
   end
end

for i=1:length(store)
    tmp = store(i,:);
    disp(tmp(1) + " " +tmp(2) + " " +tmp(3) + " " +tmp(4) + " " +tmp(5) + " " +tmp(6) + " " +tmp(7));
end
