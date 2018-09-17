%% 接收CNC结束需求任务，加入等待队列，调用启发式估价函数，并将队列按照value值排序 %%

function [cnc_state, queue] = ReceiveDemandAndSort(now_time, cnc_state, rgv_pos, queue, R1, R2, R3, T1, T2, p1, p2)
% Receive all finish demands
for i=1:8
   if cnc_state(i) > 0 && cnc_state(i) <= now_time
       cnc_state(i) = 0;
       new_task = [1, i, mod(i,2)~=0, abs(rgv_pos - ((i + (mod(i, 2)~=0))/2-1))];
       queue.push(new_task);
   end
end

% Refresh the value of all tasks
queue = Valuation(rgv_pos, queue, R1, R2, R3, T1, T2, p1, p2);

% Sort all task in queue by their values
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

