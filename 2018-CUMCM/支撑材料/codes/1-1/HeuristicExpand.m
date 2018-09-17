%% 抽取启发式规则生成路径算法，独立出为特定的模拟退火算法随机初值路径以启发式规则生成的新路径解函数 %%

function [front_path, produce_count] = HeuristicExpand(front_path, R1, R2, R3, T1, T2, n, W)
% 依据已经得到的前段路径，恢复当前系统各项状态值
lastNode = front_path.getLast();
time = lastNode(4);
origin_count = 0;
produce_count = 0;
count = 0;
rgv_pos = (lastNode(2) + (mod(lastNode(2), 2)~=0))/2-1;
cnc_state = zeros(1, 8);
queue = java.util.LinkedList();

for i=0:front_path.size()-1
   % 恢复当前系统RGV小车位置，已生成的成品数，和投入的生料数，以及每个CNC位于当前时间点上的状态
   temp = front_path.get(i);
   origin_count = origin_count + 1;
   if temp(4) + temp(5) < time
      produce_count = produce_count + 1;
      cnc_state(temp(2)) = 0;
   else
      cnc_state(temp(2)) = temp(4) + temp(5);
   end
end

% 进行基于当前系统情况的启发式任务执行，记录新生成的路径
% 首先进行任务队列的初始化
for i=1:8
   if cnc_state(i) == 0
      task = [0, i, mod(i,2)~=0, abs(rgv_pos - ((i + (mod(i, 2)~=0))/2-1))];
      queue.push(task);
   end
end
% 然后进行循环处理
while ~queue.isEmpty() && time < 28.8
    [cnc_state, queue] = CheckStateAndRecover(cnc_state, queue, time, rgv_pos);
    [cnc_state, queue] = ReceiveDemandAndSort(time, cnc_state, rgv_pos, queue, R1, R2, R3, T1, T2, 1, 1);
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
    if top(1) == 0
       % 上料过程
       temp_T = 0;
       if top(3) == 1
          temp_T = T1;
       else
          temp_T = T2;
       end
       origin_count = origin_count + 1;
       new_rgv_node = [origin_count, top(2), top(3), time, temp_T+n];
       front_path.addLast(new_rgv_node);
       time = time + temp_T;
       cnc_state(top(2)) = time + n;
       %[cnc_state, count] = LossJudger(cnc_state, time, count);
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
        new_rgv_node = [origin_count, top(2), top(3), time, temp_T+n+W];
        front_path.addLast(new_rgv_node);
        time = time + temp_T;
        cnc_state(top(2)) = time + n;
        %[cnc_state, count] = LossJudger(cnc_state, time, count);
        % 清洗熟料过程
        time = time + W;
    end
    % 无请求，RGV待机情况
    while queue.isEmpty() && time <= 28.8
       time = time + 0.001;
       [cnc_state, queue] = CheckStateAndRecover(cnc_state, queue, time, rgv_pos);
       [cnc_state, queue] = ReceiveDemandAndSort(time, cnc_state, rgv_pos, queue, R1, R2, R3, T1, T2, 1, 1);
    end
end

end

