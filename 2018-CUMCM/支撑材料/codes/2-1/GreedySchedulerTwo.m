%% 以启发式优先规则指派算法，结合工序优先级调度策略，两道工序处理调度函数 -- Matlab实现 %%
% 输入参数：R1,R2,R3分别为RGV机器人移动1,2,3个单位所需时间
% n为一台CNC处理一道工序物料所需时间，T1,T2为RGV分别为奇数，偶数CNC上下料时间
% W为清洗一个熟料的时间
function [origin_count, produce_count, point_arr, time_arr, produce_arr, cncs_path, rgv_path] = GreedySchedulerTwo(R1, R2, R3, n1, n2, T1, T2, W)
origin_count = 0; % 记录所用生料数量
produce_count = 0; % 记录生成成品数量
cnc_state = zeros(8, 1); % 表示8台CNC当前状态, 0空闲，1工作
rgv_pos = zeros(1, 1); % 记录RGV的位置
rgv_state = 0; % 记录RGV状态，0为预备服务第一道工序机器的状态，1为预备服务第二道工序机器的状态
cnc_type = [1,2,1,2,1,2,1,2]; % 设定每一台CNC机器的可处理工序类型，此处以1作为第一道工序，2为第二道工序
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

% 两道工序的关键：设置8台CNC机器的可处理工序类型，此处初始情况我们设为两边4台，奇数边负责第一道工序，偶数边负责第二道工序
% 定义数组结构体：struct('demand', 'order', 'type', 'val') -> [a1,a2,a3,a4]
% demand: 0 for begin, 1 for 第一道工序结束, 2 for 第二道工序结束
for i=1:8
   % 为可处理第一道工序的CNC机器发出初始请求任务
   if mod(cnc_type(i), 2) ~= 0
    task = [0, i, mod(i,2)~=0, abs(rgv_pos - ((i + (mod(i, 2)~=0))/2-1))];
   else
    task = [2, i, mod(i,2)~=0, abs(rgv_pos - ((i + (mod(i, 2)~=0))/2-1))];
   end
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
    % 此处引入双工序与单工序的最大差别函数，即故障恢复函数的检测，以及收取请求排序的约束，均考虑一二道工序的差别与优先级
    [cnc_state, queue] = CheckStateAndRecoverTwo(cnc_state, queue, time, rgv_pos, cnc_type);
    [cnc_state, queue] = ReceiveDemandAndSortTwo(time, cnc_state, rgv_pos, queue, cnc_type, rgv_state, R1, R2, R3, T1, T2);
    ttop = queue.peek();
    if ttop(4) < 1000000
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
    % 上下料过程耗时
    temp_T = 0;
    if top(3) == 1
       temp_T = T1;
    else
       temp_T = T2;
    end
    if top(1) == 0
       % 放下生料过程
       origin_count = origin_count + 1;
       [cncs_path, rgv_path] = GainInitResult(cncs_path, rgv_path, origin_count, top(2), top(3), time, temp_T+n1);
       time = time + temp_T;
       % 转换RGV小车的服务状态(为预备服务第一道工序态)
        rgv_state = 0;
       % 转换对应CNC机的状态(运行第一道工序态)，同时对故障发生进行概率检测
       cnc_state(top(2)) = time + n1;
       % [cnc_state, count] = LossJudger(cnc_state, time, count);
    elseif top(1) == 1
        origin_count = origin_count + 1;
        [cncs_path, rgv_path] = GainInitResult(cncs_path, rgv_path, origin_count, top(2), top(3), time, temp_T+n2);
        time = time + temp_T;
        % 转换RGV小车的服务状态(为预备服务第二道工序态)
        rgv_state = 1;
        % 转换对应CNC机的状态(运行第一道工序态)，同时对故障发生进行概率检测
        cnc_state(top(2)) = time + n1;
        % [cnc_state, count] = LossJudger(cnc_state, time, count);
    else 
        produce_count = produce_count + 1;
        [cncs_path, rgv_path] = GainInitResult(cncs_path, rgv_path, produce_count, top(2), top(3), time, temp_T+W+n1);
        time = time + temp_T;
        % 转换RGV小车的服务状态(为预备运行第一道工序态)
        rgv_state = 0;
        % 转换对应CNC机的状态(运行第二道工序态)，同时对故障发生进行概率检测
        cnc_state(top(2)) = time + n2;
        % [cnc_state, count] = LossJudger(cnc_state, time, count);
        % 清洗熟料过程
        time = time + W;
    end
    else
        % 进行阻塞等待的判定
        while ttop(4) >= 1000000 && time <= 28.8
            time = time + 0.001;
            [cnc_state, queue] = CheckStateAndRecoverTwo(cnc_state, queue, time, rgv_pos, cnc_type);
            [cnc_state, queue] = ReceiveDemandAndSortTwo(time, cnc_state, rgv_pos, queue, cnc_type, rgv_state, R1, R2, R3, T1, T2);
            ttop = queue.peek();
        end
    end
    % 无请求，RGV待机情况
    while queue.isEmpty() && time <= 28.8
       time = time + 0.001;
       [cnc_state, queue] = CheckStateAndRecoverTwo(cnc_state, queue, time, rgv_pos, cnc_type);
       [cnc_state, queue] = ReceiveDemandAndSortTwo(time, cnc_state, rgv_pos, queue, cnc_type, rgv_state, R1, R2, R3, T1, T2);
    end
end
time_arr = [time_arr, time];
produce_arr = [produce_arr, produce_count];
disp(count);

end

