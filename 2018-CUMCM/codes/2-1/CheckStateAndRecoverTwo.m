%% 双工序的CNC机状态检查与恢复机制，引入多道工序的恢复后任务重新引入队列的概念 %%

function [cnc_state, queue] = CheckStateAndRecoverTwo(cnc_state, queue, time, rgv_pos, cnc_type)
for i=1:8
    if cnc_state(i) < 0 && cnc_state(i) + time > 0
       cnc_state(i) = 0;
       new_task = [];
       if mod(cnc_type(i), 2) ~= 0
           new_task = [0, i, mod(i,2)~=0, abs(rgv_pos - ((i + (mod(i, 2)~=0))/2-1))];
       else
           new_task = [1, i, mod(i,2)~=0, abs(rgv_pos - ((i + (mod(i, 2)~=0))/2-1))];
       end
       queue.push(new_task);
    end
end

end

