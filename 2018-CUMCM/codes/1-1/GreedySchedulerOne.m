%% ������ʽ���ȹ���ָ���㷨Ϊ���ĵģ������������������ -- Matlabʵ�� %%
% ���������R1,R2,R3�ֱ�ΪRGV�������ƶ�1,2,3����λ����ʱ��
% nΪһ̨CNC����һ��������������ʱ�䣬T1,T2ΪRGV�ֱ�Ϊ������ż��CNC������ʱ��
% WΪ��ϴһ�����ϵ�ʱ��
function [origin_count, produce_count, point_arr, time_arr, produce_arr, cncs_path, rgv_path] = GreedySchedulerOne(R1, R2, R3, n, T1, T2, W, p1, p2)
origin_count = 0; % ��¼������������
produce_count = 0; % ��¼���ɳ�Ʒ����
cnc_state = zeros(8, 1); % ��ʾ8̨CNC��ǰ״̬, 0���У�1����
rgv_pos = zeros(1, 1); % ��¼RGV��λ��
point_arr = rgv_pos; % ��¼RGVλ���ƶ�������
time_arr = rgv_pos;
produce_arr = time_arr;
queue = java.util.LinkedList(); % ��ǰCNC�����������
% ���嵱ǰ����ʽȫ�ֽ�·���Ĵ洢�ṹ��rgv_pathΪRGVС���ƶ�·�����ռ���cncs_pathΪ���е�CNC��������ʷ����ṹ
rgv_path = java.util.LinkedList();
cncs_path = [];
for i=1:8
   temp_queue = java.util.LinkedList();
   cncs_path = [cncs_path, temp_queue];
end

% ��������ṹ�壺struct('demand', 'order', 'type', 'val') -> [a1,a2,a3,a4], 0 in demand for begin, 1 for end
for i=1:8
   task = [0, i, mod(i,2)~=0, abs(rgv_pos - ((i + (mod(i, 2)~=0))/2-1))];
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
    % ����ʽ�����ĺ��ģ�ÿ�β�����ȡ�������Լ�����ÿ��������ۣ�����
    [cnc_state, queue] = CheckStateAndRecover(cnc_state, queue, time, rgv_pos);
    [cnc_state, queue] = ReceiveDemandAndSort(time, cnc_state, rgv_pos, queue, R1, R2, R3, T1, T2, p1, p2);
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
    if rel_dis ~= 0
        point_arr = [point_arr, rgv_pos];
    end
    if top(1) == 0
       % ���Ϲ���
       temp_T = 0;
       if top(3) == 1
          temp_T = T1;
       else
          temp_T = T2;
       end
       origin_count = origin_count + 1;
       [cncs_path, rgv_path] = GainInitResult(cncs_path, rgv_path, origin_count, top(2), top(3), time, temp_T+n);
       time = time + temp_T;
       cnc_state(top(2)) = time + n;
       [cnc_state, count] = LossJudger(cnc_state, time, count, produce_count);
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
        [cncs_path, rgv_path] = GainInitResult(cncs_path, rgv_path, origin_count, top(2), top(3), time, temp_T+W+n);
        time = time + temp_T;
        cnc_state(top(2)) = time + n;
        [cnc_state, count] = LossJudger(cnc_state, time, count, produce_count);
        % ��ϴ���Ϲ���
        time = time + W;
    end
    % ������RGV�������
    while queue.isEmpty() && time <= 28.8
       time = time + 0.001;
       [cnc_state, queue] = CheckStateAndRecover(cnc_state, queue, time, rgv_pos);
       [cnc_state, queue] = ReceiveDemandAndSort(time, cnc_state, rgv_pos, queue, R1, R2, R3, T1, T2, p1, p2);
    end
end
time_arr = [time_arr, time];
produce_arr = [produce_arr, produce_count];
disp(count);
end

