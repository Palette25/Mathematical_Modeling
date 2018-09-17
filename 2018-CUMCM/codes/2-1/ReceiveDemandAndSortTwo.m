%% �������������CNC������պ������������빤��֮���˳��ִ��Լ����ϵ����Ӧ�Ľ����������㷨 %%

function [cnc_state, queue] = ReceiveDemandAndSortTwo(now_time, cnc_state, rgv_pos, queue, cnc_type, rgv_state, R1, R2, R3, T1, T2)
% Receive all finish demands
for i=1:8
   if cnc_state(i) > 0 && cnc_state(i) <= now_time
       cnc_state(i) = 0;
       % ���ݲ�ͬ��CNC���������������ɵ���������
       new_task = [];
       if mod(cnc_type(i), 2) == 0
           new_task = [2, i, mod(i,2)~=0, abs(rgv_pos - ((i + (mod(i, 2)~=0))/2-1))];
       else
           new_task = [1, i, mod(i,2)~=0, abs(rgv_pos - ((i + (mod(i, 2)~=0))/2-1))];
       end
       queue.push(new_task);
   end
end

% ���ҽ�����ǰRGVС���Ŀ����������ͣ��Ż��ڹ�ֵ�и�����ȷ����ֵ
queue = Valuation(rgv_state, rgv_pos, queue, R1, R2, R3, T1, T2);

% ���ڲ����㵱ǰС����һ����Ҫ���е��������ͣ��ڸô������бض�����õ�������еĺ���
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