%% ���ָ�������CNC���������ҽ�ԭ�еĽ����������»ָ������������ %%

function [cnc_state, queue] = CheckStateAndRecover(cnc_state, queue, now_time, rgv_pos)
for i=1:8
    if cnc_state(i) < 0 && cnc_state(i) + now_time > 0
        cnc_state(i) = 0;
        new_task = [0, i, mod(i,2)~=0, abs(rgv_pos - ((i + (mod(i, 2)~=0))/2-1))];
        queue.push(new_task);
    end
end

end

