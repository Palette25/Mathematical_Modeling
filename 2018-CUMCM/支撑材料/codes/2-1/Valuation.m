%% ˫�����������������ۺ�������ֿ��ǵ���ͬ�����Ӧ��������͵�ǰRGV״̬�Ĳ�ͬ�������в�������ȼ����� %%

function [queue] = Valuation(rgv_state, rgv_pos, queue, R1, R2, R3, T1, T2)
quit_num = 1000000;  % Ϊ������RGVִ�����������������������ֵΪʮ�ִ����������ʾ���ۼ���
for i=0:queue.size()-1
    result = 0;
    temp = queue.get(i);
    if rgv_state == 0  % Ԥ�����һ������״ֻ̬�ܴ����0�ֺ͵�1������
        if temp(1) == 2
           queue.set(i, [temp(1), temp(2), temp(3), quit_num]);
           continue;
        end
    elseif rgv_state == 1 % Ԥ����ڶ�������״ֻ̬�ܴ����2������
        if temp(1) == 0 || temp(1) == 1
           queue.set(i, [temp(1), temp(2), temp(3), quit_num]);
           continue;
        end
    end
    % ���ȼ��������ϴ���ʱ��ָ��
    if temp(3) == 1
        result = result + T1;
    else
        result = result + T2;
    end
    % ����RGV�����˵���ǰ����ֱ�߾��������̰��ʱ��ָ��
    switch abs(rgv_pos - ((temp(2) + (mod(temp(2), 2)~=0))/2-1))
        case {1}
            result = result + R1;
        case {2}
            result = result + R2;
        case {3}
            result = result + R3;
    end
    % ���ڼ���ִ�е�ǰ���񣬶�֮�����������ִ��ʱ���ۺ�Ӱ�������ʽָ��
    temp_rgv_pos = ((temp(2) + (mod(temp(2), 2)~=0))/2-1);
    temp_queue = queue.clone();
    temp_queue.remove(i);
    % ���վ��������������������ҳ��������иõ�����֮�������ִ��·������·����ִ��ʱ����Ϊ����ֵ
    temp_queue = BubbleSort(temp_queue, temp_rgv_pos);
    
    while ~temp_queue.isEmpty()
        tmp = temp_queue.poll();
        tmp_point = ((tmp(2) + (mod(tmp(2), 2)~=0))/2-1);
        switch abs(temp_rgv_pos - tmp_point)
            case {1}
                result = result + R1;
            case {2}
                result = result + R2;
            case {3}
                result = result + R3;
        end
        temp_rgv_pos = tmp_point;
        temp_queue = BubbleSort(temp_queue, temp_rgv_pos);
    end
    queue.set(i, [temp(1), temp(2), temp(3), result]);
end

end

