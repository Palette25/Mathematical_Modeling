%% 双工序调度器的任务估价函数，充分考虑到不同任务对应的请求工序和当前RGV状态的不同，进行有差异的优先级估价 %%

function [queue] = Valuation(rgv_state, rgv_pos, queue, R1, R2, R3, T1, T2)
quit_num = 1000000;  % 为不符合RGV执行条件的任务定义放弃数，数值为十分大的正数，表示代价极高
for i=0:queue.size()-1
    result = 0;
    temp = queue.get(i);
    if rgv_state == 0  % 预处理第一道工序状态只能处理第0种和第1种任务
        if temp(1) == 2
           queue.set(i, [temp(1), temp(2), temp(3), quit_num]);
           continue;
        end
    elseif rgv_state == 1 % 预处理第二道工序状态只能处理第2种任务
        if temp(1) == 0 || temp(1) == 1
           queue.set(i, [temp(1), temp(2), temp(3), quit_num]);
           continue;
        end
    end
    % 首先加上上下料处理时间指标
    if temp(3) == 1
        result = result + T1;
    else
        result = result + T2;
    end
    % 基于RGV机器人到当前任务直线距离的朴素贪心时间指标
    switch abs(rgv_pos - ((temp(2) + (mod(temp(2), 2)~=0))/2-1))
        case {1}
            result = result + R1;
        case {2}
            result = result + R2;
        case {3}
            result = result + R3;
    end
    % 基于假设执行当前任务，对之后的所有任务执行时间综合影响的启发式指标
    temp_rgv_pos = ((temp(2) + (mod(temp(2), 2)~=0))/2-1);
    temp_queue = queue.clone();
    temp_queue.remove(i);
    % 按照距离排序其余其他任务，找出假设运行该点任务之后的最优执行路径，将路径总执行时间作为评估值
    temp_queue = BubbleSort(temp_queue, temp_rgv_pos);
    
    while ~temp_queue.isEmpty()
        tmp = temp_queue.poll();
        tmp_point = ((tmp(2) + (mod(tmp(2), 2)~=0))/2-1);
        switch abs(temp_rgv_pos - tmp_point)
            case {1}
                result = result + R1;
            case {2}
                result = result + R2;
            case {3}
                result = result + R3;
        end
        temp_rgv_pos = tmp_point;
        temp_queue = BubbleSort(temp_queue, temp_rgv_pos);
    end
    queue.set(i, [temp(1), temp(2), temp(3), result]);
end

end

