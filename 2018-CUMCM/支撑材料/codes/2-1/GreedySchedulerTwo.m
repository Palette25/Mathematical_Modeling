%% ������ʽ���ȹ���ָ���㷨����Ϲ������ȼ����Ȳ��ԣ�������������Ⱥ��� -- Matlabʵ�� %%
% ���������R1,R2,R3�ֱ�ΪRGV�������ƶ�1,2,3����λ����ʱ��
% nΪһ̨CNC����һ��������������ʱ�䣬T1,T2ΪRGV�ֱ�Ϊ������ż��CNC������ʱ��
% WΪ��ϴһ�����ϵ�ʱ��
function [origin_count, produce_count, point_arr, time_arr, produce_arr, cncs_path, rgv_path] = GreedySchedulerTwo(R1, R2, R3, n1, n2, T1, T2, W)
origin_count = 0; % ��¼������������
produce_count = 0; % ��¼���ɳ�Ʒ����
cnc_state = zeros(8, 1); % ��ʾ8̨CNC��ǰ״̬, 0���У�1����
rgv_pos = zeros(1, 1); % ��¼RGV��λ��
rgv_state = 0; % ��¼RGV״̬��0ΪԤ�������һ�����������״̬��1ΪԤ������ڶ������������״̬
cnc_type = [1,2,1,2,1,2,1,2]; % �趨ÿһ̨CNC�����Ŀɴ��������ͣ��˴���1��Ϊ��һ������2Ϊ�ڶ�������
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
    if rel_dis ~= 0
        point_arr = [point_arr, rgv_pos];
    end
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
       [cncs_path, rgv_path] = GainInitResult(cncs_path, rgv_path, origin_count, top(2), top(3), time, temp_T+n1);
       time = time + temp_T;
       % ת��RGVС���ķ���״̬(ΪԤ�������һ������̬)
        rgv_state = 0;
       % ת����ӦCNC����״̬(���е�һ������̬)��ͬʱ�Թ��Ϸ������и��ʼ��
       cnc_state(top(2)) = time + n1;
       % [cnc_state, count] = LossJudger(cnc_state, time, count);
    elseif top(1) == 1
        origin_count = origin_count + 1;
        [cncs_path, rgv_path] = GainInitResult(cncs_path, rgv_path, origin_count, top(2), top(3), time, temp_T+n2);
        time = time + temp_T;
        % ת��RGVС���ķ���״̬(ΪԤ������ڶ�������̬)
        rgv_state = 1;
        % ת����ӦCNC����״̬(���е�һ������̬)��ͬʱ�Թ��Ϸ������и��ʼ��
        cnc_state(top(2)) = time + n1;
        % [cnc_state, count] = LossJudger(cnc_state, time, count);
    else 
        produce_count = produce_count + 1;
        [cncs_path, rgv_path] = GainInitResult(cncs_path, rgv_path, produce_count, top(2), top(3), time, temp_T+W+n1);
        time = time + temp_T;
        % ת��RGVС���ķ���״̬(ΪԤ�����е�һ������̬)
        rgv_state = 0;
        % ת����ӦCNC����״̬(���еڶ�������̬)��ͬʱ�Թ��Ϸ������и��ʼ��
        cnc_state(top(2)) = time + n2;
        % [cnc_state, count] = LossJudger(cnc_state, time, count);
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
disp(count);

end

