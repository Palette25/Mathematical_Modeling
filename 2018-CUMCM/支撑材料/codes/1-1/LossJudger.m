%% ���Ӷ���ֲ���CNC�����������ϸ���ģ�ͣ�������̬�ֲ��Ļ�������ʱ��ָ�� %%

function [cnc_state, count] = LossJudger(cnc_state, time_, count)
for i=1:8
    fault_flag = false;
    % ����ֲ����������������ÿ�������ʵ�����Ϊ1�������¼�����Ϊ0.01���ж��������ֵ
    r = binornd(1, 0.01, 1, 1);
    if r == 1
        fault_flag = true;
    end

    % ��̬�ֲ�������������崻�ʱ��
    time = 0;
    if fault_flag == true
        time = round(normrnd(15, 2, 1));
    end
    
    % ��CNC����״̬�����ض�ֵ��Ϊ��������ʾ崻�ʱ�䵹��ʱ
    if time ~= 0
        cnc_state(i) = -1 * (time*60*0.001 + time_);
        count = count + 1;
    end
end
end

