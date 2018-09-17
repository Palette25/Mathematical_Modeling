%% ����˫�������ģ�͵�����ʽ������չ����ģ�飬������Ϊ�ض���ģ���˻𷨳�ֵ·����������·�����ģ�� %%

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
   % �ָ���ǰϵͳRGVС��λ�ã������ɵĳ�Ʒ������Ͷ������������Լ�ÿ��CNCλ�ڵ�ǰʱ����ϵ�״̬
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

% ��������Ĺؼ�������8̨CNC�����Ŀɴ��������ͣ��˴���ʼ���������Ϊ����4̨�������߸����һ������ż���߸���ڶ�������
% ��������ṹ�壺struct('demand', 'order', 'type', 'val') -> [a1,a2,a3,a4]
% demand: 0 for begin, 1 for ��һ���������, 2 for �ڶ����������
for i=1:8
   % Ϊ�ɴ����һ�������CNC����������ʼ��������
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
    % ��¼��Сʱ���ɲ�Ʒ�����������������������
    if time/1.8 >= temp_count
        time_arr = [time_arr, time];
        produce_arr = [produce_arr, produce_count];
        temp_count = temp_count + 1;
    end
    % �˴�����˫�����뵥�������������������ϻָ������ļ�⣬�Լ���ȡ���������Լ����������һ��������Ĳ�������ȼ�
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
    % �����Ϲ��̺�ʱ
    temp_T = 0;
    if top(3) == 1
       temp_T = T1;
    else
       temp_T = T2;
    end
    if top(1) == 0
       % �������Ϲ���
       origin_count = origin_count + 1;
       new_rgv_node = [origin_count, top(2), top(3), time, temp_T+n1];
       front_path.addLast(new_rgv_node);
       time = time + temp_T;
       % ת��RGVС���ķ���״̬(ΪԤ�������һ������̬)
        rgv_state = 0;
       % ת����ӦCNC����״̬(���е�һ������̬)��ͬʱ�Թ��Ϸ������и��ʼ��
       cnc_state(top(2)) = time + n1;
       [cnc_state, count] = LossJudger(cnc_state, time, count, produce_count);
    elseif top(1) == 1
        origin_count = origin_count + 1;
        new_rgv_node = [origin_count, top(2), top(3), time, temp_T+n2];
        front_path.addLast(new_rgv_node);
        time = time + temp_T;
        % ת��RGVС���ķ���״̬(ΪԤ������ڶ�������̬)
        rgv_state = 1;
        % ת����ӦCNC����״̬(���е�һ������̬)��ͬʱ�Թ��Ϸ������и��ʼ��
        cnc_state(top(2)) = time + n1;
        [cnc_state, count] = LossJudger(cnc_state, time, count, produce_count);
    else 
        produce_count = produce_count + 1;
        new_rgv_node = [origin_count, top(2), top(3), time, temp_T+n1+W];
       front_path.addLast(new_rgv_node);
        time = time + temp_T;
        % ת��RGVС���ķ���״̬(ΪԤ�����е�һ������̬)
        rgv_state = 0;
        % ת����ӦCNC����״̬(���еڶ�������̬)��ͬʱ�Թ��Ϸ������и��ʼ��
        cnc_state(top(2)) = time + n2;
        [cnc_state, count] = LossJudger(cnc_state, time, count, produce_count);
        % ��ϴ���Ϲ���
        time = time + W;
    end
    else
        % ���������ȴ����ж�
        while ttop(4) >= 1000000 && time <= 28.8
            time = time + 0.001;
            [cnc_state, queue] = CheckStateAndRecoverTwo(cnc_state, queue, time, rgv_pos, cnc_type);
            [cnc_state, queue] = ReceiveDemandAndSortTwo(time, cnc_state, rgv_pos, queue, cnc_type, rgv_state, R1, R2, R3, T1, T2);
            ttop = queue.peek();
        end
    end
    % ������RGV�������
    while queue.isEmpty() && time <= 28.8
       time = time + 0.001;
       [cnc_state, queue] = CheckStateAndRecoverTwo(cnc_state, queue, time, rgv_pos, cnc_type);
       [cnc_state, queue] = ReceiveDemandAndSortTwo(time, cnc_state, rgv_pos, queue, cnc_type, rgv_state, R1, R2, R3, T1, T2);
    end
end
time_arr = [time_arr, time];
produce_arr = [produce_arr, produce_count];

end

