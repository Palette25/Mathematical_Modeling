%% 以启发式优先规则指派算法为核心的，单工序处理调度器函数 -- Matlab实现 %%
% 输入参数：R1,R2,R3分别为RGV机器人移动1,2,3个单位所需时间
% n为一台CNC处理一道工序物料所需时间，T1,T2为RGV分别为奇数，偶数CNC上下料时间
% W为清洗一个熟料的时间
function [origin_count, produce_count, point_arr, time_arr, produce_arr, cncs_path, rgv_path] = GreedySchedulerOne(R1, R2, R3, n, T1, T2, W, p1, p2)
origin_count = 0; % 记录所用生料数量
produce_count = 0; % 记录生成成品数量
cnc_state = zeros(8, 1); % 表示8台CNC当前状态, 0空闲，1工作
rgv_pos = zeros(1, 1); % 记录RGV的位置
point_arr = rgv_pos; % 记录RGV位置移动的数组
time_arr = rgv_pos;
produce_arr = time_arr;
queue = java.util.LinkedList(); % 当前CNC需求任务队列
% 定义当前启发式全局解路径的存储结构，rgv_path为RGV小车移动路径的收集，cncs_path为所有的CNC机器的历史服务结构
rgv_path = java.util.LinkedList();
cncs_path = [];
for i=1:8
   temp_queue = java.util.LinkedList();
   cncs_path = [cncs_path, temp_queue];
end

% 定义数组结构体：struct('demand', 'order', 'type', 'val') -> [a1,a2,a3,a4], 0 in demand for begin, 1 for end
for i=1:8
   task = [0, i, mod(i,2)~=0, abs(rgv_pos - ((i + (mod(i, 2)~=0))/2-1))];
   queue.push(task);
end

time = 0;
temp_count = 1;
count = 0;
while ~queue.isEmpty() && time <= 28.8
    % 记录半小时生成产品数，输出用于描述数据趋势
    if time/1.8 >= temp_count
        time_arr = [time_arr, time];
        produce_arr = [produce_arr, produce_count];
        temp_count = temp_count + 1;
    end
    % 启发式搜索的核心，每次操作收取新任务，以及更新每个任务估价，排序
    [cnc_state, queue] = CheckStateAndRecover(cnc_state, queue, time, rgv_pos);
    [cnc_state, queue] = ReceiveDemandAndSort(time, cnc_state, rgv_pos, queue, R1, R2, R3, T1, T2, p1, p2);
    top = queue.poll();
    rel_dis = abs(rgv_pos - ((top(2) + top(3))/2-1));
    switch rel_dis
        case {1}
            time = time + R1;
        case {2}
            time = time + R2;
        case {3}
            time = time + R3;
    end
    rgv_pos = ((top(2) + top(3))/2-1);
    if rel_dis ~= 0
        point_arr = [point_arr, rgv_pos];
    end
    if top(1) == 0
       % 上料过程
       temp_T = 0;
       if top(3) == 1
          temp_T = T1;
       else
          temp_T = T2;
       end
       origin_count = origin_count + 1;
       [cncs_path, rgv_path] = GainInitResult(cncs_path, rgv_path, origin_count, top(2), top(3), time, temp_T+n);
       time = time + temp_T;
       cnc_state(top(2)) = time + n;
       [cnc_state, count] = LossJudger(cnc_state, time, count, produce_count);
    else
        % 拿取熟料过程
        temp_T = 0;
        if top(3) == 1
           temp_T = T1;
        else
           temp_T = T2;
        end
        produce_count = produce_count + 1;
        % 放下生料过程
        origin_count = origin_count + 1;
        [cncs_path, rgv_path] = GainInitResult(cncs_path, rgv_path, origin_count, top(2), top(3), time, temp_T+W+n);
        time = time + temp_T;
        cnc_state(top(2)) = time + n;
        [cnc_state, count] = LossJudger(cnc_state, time, count, produce_count);
        % 清洗熟料过程
        time = time + W;
    end
    % 无请求，RGV待机情况
    while queue.isEmpty() && time <= 28.8
       time = time + 0.001;
       [cnc_state, queue] = CheckStateAndRecover(cnc_state, queue, time, rgv_pos);
       [cnc_state, queue] = ReceiveDemandAndSort(time, cnc_state, rgv_pos, queue, R1, R2, R3, T1, T2, p1, p2);
    end
end
time_arr = [time_arr, time];
produce_arr = [produce_arr, produce_count];
disp(count);
end

