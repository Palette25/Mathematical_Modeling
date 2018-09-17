%% 用于两道工序的CNC任务接收和排序函数，引入工序之间的顺序执行约束关系，相应改进队列排序算法 %%

function [cnc_state, queue] = ReceiveDemandAndSortTwo(now_time, cnc_state, rgv_pos, queue, cnc_type, rgv_state, R1, R2, R3, T1, T2)
% Receive all finish demands
for i=1:8
   if cnc_state(i) > 0 && cnc_state(i) <= now_time
       cnc_state(i) = 0;
       % 根据不同的CNC机器，决定其生成的需求任务
       new_task = [];
       if mod(cnc_type(i), 2) == 0
           new_task = [2, i, mod(i,2)~=0, abs(rgv_pos - ((i + (mod(i, 2)~=0))/2-1))];
       else
           new_task = [1, i, mod(i,2)~=0, abs(rgv_pos - ((i + (mod(i, 2)~=0))/2-1))];
       end
       queue.push(new_task);
   end
end

% 当且仅当当前RGV小车的可行任务类型，才会在估值中赋予正确的数值
queue = Valuation(rgv_state, rgv_pos, queue, R1, R2, R3, T1, T2);

% 对于不满足当前小车下一步需要进行的任务类型，在该次排序中必定会放置到任务队列的后半段
for i=0:queue.size()-1
    for j=i+1:queue.size()-1
        temp1 = queue.get(i);
        temp2 = queue.get(j);
        if(temp1(4) > temp2(4))
           temp = queue.get(i);
           queue.set(i, queue.get(j));
           queue.set(j, temp);
        end
    end
end