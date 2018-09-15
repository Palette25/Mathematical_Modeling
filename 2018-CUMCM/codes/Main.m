%% 测试和记录每个不同调度器效果的主脚本 %%
% 1. 单工序加工，不含CNC机器故障情况考虑
[count1, count2, point_arr, time_arr, produce_arr, path1, path2] = GreedySchedulerOne(0.018, 0.032, 0.046, 0.545, 0.027, 0.032, 0.025);
% 处理所得到的数组，每隔半小时画点，连接得折线图


% 首先观察启发式搜索得到的最终解，对于每个CNC机器上的历史执行操作
for i=1:1
    temp = path1(i);
    for j=0:temp.size()-1
       ttmp = temp.get(j);
       % disp(ttmp(1) + " " + ttmp(2) + " " + ttmp(3)+ " " + ttmp(4)+ " " + ttmp(5));
    end
end

x = [];
y = [];
for i=0:49
   ttmp = path2.get(i);
   x = [x, ttmp(1)];
   y = [y, ttmp(2)];
   disp(ttmp(1) + " " + ttmp(2) + " " + ttmp(3)+ " " + ttmp(4)+ " " + ttmp(5));
end
str = [repmat('', 50, 1) num2str(x') repmat(', ', 50, 1) num2str(y')];

plot(x, y, 'r-');
text(x, y, cellstr(str));
