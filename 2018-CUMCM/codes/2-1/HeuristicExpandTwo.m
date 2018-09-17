%% 面向双工序调度模型的启发式规则拓展函数模块，独立出为特定的模拟退火法初值路径以生成新路径解的模块 %%

function [front_path, produce_count] = HeuristicExpandTwo(front_path, R1, R2, R3, T1, T2, n1, n2, W)
lastNode = front_path.getLast();
time = lastNode(4);
origin_count = 0;
produce_count = 0;
count = 0;
rgv_pos = (lastNode(2) + (mod(lastNode(2), 2)~=0))/2-1;
rgv_state = 0;
cnc_type = [1,2,1,2,1,2,1,2];
if cnc_type(lastNode(2)) ~= 0
    rgv_state = 1;
end
cnc_state = zeros(1, 8);
queue = java.util.LinkedList();
time_arr = [];
produce_arr = [];

for i=0:front_path.size()-1
   % 恢复当前系统RGV小车位置，已生成的成品数，和投入的生料数，以及每个CNC位于当前时间点上的状态
   temp = front_path.get(i);
   if mod(cnc_type(temp(2)), 2) ~= 0
      origin_count = origin_count + 1; 
   end
   if temp(4) + temp(5) < time
      if mod(cnc_type(temp(2)), 2) == 0
        produce_count = produce_count + 1;
      end
      cnc_state(temp(2)) = 0;
   else
      cnc_state(temp(2)) = temp(4) + temp(5);
   end
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
       new_rgv_node = [origin_count, top(2), top(3), time, temp_T+n1];
       front_path.addLast(new_rgv_node);
       time = time + temp_T;
       % 转换RGV小车的服务状态(为预备服务第一道工序态)
        rgv_state = 0;
       % 转换对应CNC机的状态(运行第一道工序态)，同时对故障发生进行概率检测
       cnc_state(top(2)) = time + n1;
       [cnc_state, count] = LossJudger(cnc_state, time, count, produce_count);
    elseif top(1) == 1
        origin_count = origin_count + 1;
        new_rgv_node = [origin_count, top(2), top(3), time, temp_T+n2];
        front_path.addLast(new_rgv_node);
        time = time + temp_T;
        % 转换RGV小车的服务状态(为预备服务第二道工序态)
        rgv_state = 1;
        % 转换对应CNC机的状态(运行第一道工序态)，同时对故障发生进行概率检测
        cnc_state(top(2)) = time + n1;
        [cnc_state, count] = LossJudger(cnc_state, time, count, produce_count);
    else 
        produce_count = produce_count + 1;
        new_rgv_node = [origin_count, top(2), top(3), time, temp_T+n1+W];
       front_path.addLast(new_rgv_node);
        time = time + temp_T;
        % 转换RGV小车的服务状态(为预备运行第一道工序态)
        rgv_state = 0;
        % 转换对应CNC机的状态(运行第二道工序态)，同时对故障发生进行概率检测
        cnc_state(top(2)) = time + n2;
        [cnc_state, count] = LossJudger(cnc_state, time, count, produce_count);
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

end

