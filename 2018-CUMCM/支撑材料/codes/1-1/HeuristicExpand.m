%% ��ȡ����ʽ��������·���㷨��������Ϊ�ض���ģ���˻��㷨�����ֵ·��������ʽ�������ɵ���·���⺯�� %%

function [front_path, produce_count] = HeuristicExpand(front_path, R1, R2, R3, T1, T2, n, W)
% �����Ѿ��õ���ǰ��·�����ָ���ǰϵͳ����״ֵ̬
lastNode = front_path.getLast();
time = lastNode(4);
origin_count = 0;
produce_count = 0;
count = 0;
rgv_pos = (lastNode(2) + (mod(lastNode(2), 2)~=0))/2-1;
cnc_state = zeros(1, 8);
queue = java.util.LinkedList();

for i=0:front_path.size()-1
   % �ָ���ǰϵͳRGVС��λ�ã������ɵĳ�Ʒ������Ͷ������������Լ�ÿ��CNCλ�ڵ�ǰʱ����ϵ�״̬
   temp = front_path.get(i);
   origin_count = origin_count + 1;
   if temp(4) + temp(5) < time
      produce_count = produce_count + 1;
      cnc_state(temp(2)) = 0;
   else
      cnc_state(temp(2)) = temp(4) + temp(5);
   end
end

% ���л��ڵ�ǰϵͳ���������ʽ����ִ�У���¼�����ɵ�·��
% ���Ƚ���������еĳ�ʼ��
for i=1:8
   if cnc_state(i) == 0
      task = [0, i, mod(i,2)~=0, abs(rgv_pos - ((i + (mod(i, 2)~=0))/2-1))];
      queue.push(task);
   end
end
% Ȼ�����ѭ������
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
       % ���Ϲ���
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
        % ��ȡ���Ϲ���
        temp_T = 0;
        if top(3) == 1
           temp_T = T1;
        else
           temp_T = T2;
        end
        produce_count = produce_count + 1;
        % �������Ϲ���
        origin_count = origin_count + 1;
        new_rgv_node = [origin_count, top(2), top(3), time, temp_T+n+W];
        front_path.addLast(new_rgv_node);
        time = time + temp_T;
        cnc_state(top(2)) = time + n;
        %[cnc_state, count] = LossJudger(cnc_state, time, count);
        % ��ϴ���Ϲ���
        time = time + W;
    end
    % ������RGV�������
    while queue.isEmpty() && time <= 28.8
       time = time + 0.001;
       [cnc_state, queue] = CheckStateAndRecover(cnc_state, queue, time, rgv_pos);
       [cnc_state, queue] = ReceiveDemandAndSort(time, cnc_state, rgv_pos, queue, R1, R2, R3, T1, T2, 1, 1);
    end
end

end

