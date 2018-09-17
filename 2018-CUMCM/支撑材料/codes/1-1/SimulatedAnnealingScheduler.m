%% ģ���˻��㷨�Ż���������������ý⺯�� -- Matlabʵ�� %%

function [optimal_result, optimal_produce_num] = SimulatedAnnealingScheduler(init_result, init_num, init_temp, iterate_time, R1, R2, R3, T1, T2, n, W)
optimal_result = init_result;
optimal_produce_num = init_num;
% ��ָ���ĵ��������н���ѭ��������������Ż�ý��ƽ⣬�ж��Ƿ���ܸ��½�
for i=1:iterate_time
    % ����ֲ��������������ʾѡ���·�����±�
    index = round(0 + (optimal_result.size()-2)*rand(1));
    % ������±���Ϊ��׼�㣬��ǰ������������ͬ��ŵ�CNC����·������н�������RGV·�����ɵ�Լ����Ϊ����
    different_index = [];
    history_records = [];
    for k=index-1:-1:0
        if ~ismember(optimal_result.get(k), history_records)
            history_records = [history_records, optimal_result.get(k)];
            different_index = [different_index, k];
        end
    end
    
    constrain_flag = false;
    while ~constrain_flag && ~isempty(different_index)
        % �Ծ��ȷֲ������ѡ��������еĵ���Ԫ�ؽ��н���
        len = length(different_index);
        ran_index = round(1 + (len-1)*rand(1));
        tmp = different_index(ran_index);
        % ȡ����Ľڵ���ȥ��
        different_index(ran_index) = [];
        temp_result = optimal_result.clone();
        [temp_result] = SwapCNCID(index, tmp, temp_result);
        % ��ȡ��ʱ��������е�ǰ1-tmpλ�����ж��к�ε�����(ÿһ���ڵ㶼�ı䶼ֱ��Ӱ�쵽ȫ��·��������)
        temp_result = java.util.LinkedList(temp_result.subList(0, tmp+1));
        % ���ж������ɹ�����Լ�������ļ����У��
        ttmp = temp_result.get(tmp);
        constrain_flag = true;
        for j = tmp-1:-1:0
            jmp = temp_result.get(j);
            if ttmp(2) == jmp(2) && ttmp(4) + ttmp(5) > jmp(4) % ����������Լ�����������������Ѱ�һ�׼��ǰ�Ŀ��滻�±�
                constrain_flag = false;
            end
        end
        % �ɹ��ҵ�����Լ�������ı仯��·����ʼ�ڵ�Σ���������ʽ��չ
        if constrain_flag == true
            % ��������ʽ���ȹ������·����չ����
            [new_path, new_product_num] = HeuristicExpand(temp_result, R1, R2, R3, T1, T2, n, W);
            % ��ȡ�½�Ĳ�Ʒ��������������ȡ��
            if new_product_num <= optimal_produce_num
                % �½����С�ڵ���֮ǰ��Ĳ���������һ�����ʽ��ܴ˽ϲ�Ľ�
                accept_pro = exp((new_product_num - optimal_produce_num) / init_temp);
                rand_temp = rand(1);
                if rand_temp <= accept_pro
                    optimal_result = new_path;
                    optimal_produce_num = new_product_num;
                end
            else
                % �½������֮ǰ������󣬹��Ͻ����½�
                optimal_result = new_path;
                optimal_produce_num = new_product_num;
            end
            % �˻�Ĺؼ� -- �¶ȼ�С
            init_temp = init_temp - init_temp / 100;
        end
    end
    if init_temp <= 0
        break;
    end
end

end

