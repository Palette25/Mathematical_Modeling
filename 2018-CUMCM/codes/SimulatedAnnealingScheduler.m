%% ģ���˻��㷨�Ż���������������ý⺯�� -- Matlabʵ�� %%

function [optimal_result] = SimulatedAnnealingScheduler(init_result, init_temp, iterate_time)
optimal_result = init_result;
% ��ָ���ĵ��������н���ѭ��������������Ż�ý��ƽ⣬�ж��Ƿ���ܸ��½�
for i=1:iterate_time
    % ����ֲ��������������ʾѡ���·�����±�
    index = round(0 + (init_result.size()-1)*rand(1));
    % ������±���Ϊ��׼�㣬��ǰ������������ͬ��ŵ�CNC����·������н�������RGV·�����ɵ�Լ����Ϊ����
    different_index = [];
    history_records = [];
    for i=index-1:-1:0
        if ~ismember(optimal_esult.get(i), history_records)
            history_records = [history_records, optimal_esult.get(i)];
            different_index = [different_index, i];
        end
    end
    
    constrain_flag = false;
    while ~constrain_flag || ~isempty(different_index)
        % �Ծ��ȷֲ������ѡ��������еĵ���Ԫ�ؽ��н���
        len = length(different_index);
        tmp = round(1 + (len-1)*rand(1));
        temp_result = optimal_result.clone();
        [temp_result] = SwapCNCID(index, tmp, temp_result);
        % ��ȡ��ʱ��������е�ǰ1-tmpλ�����ж��к�ε�����(ÿһ���ڵ㶼�ı䶼ֱ��Ӱ�쵽ȫ��·��������)
        temp_result = temp_result.subList(0, tmp+1);
        % ���ж������ɹ�����Լ�������ļ����У��
        ttmp = temp_result.get(tmp);
        for j = tmp-1:-1:0
            jmp = temp_result.get(j);
            if ttmp(2) == jmp(2)
                
            end
        end
        % ��������ʽ���ȹ������·����չ����
        
        % ��ȡ�½�Ĳ�Ʒ��������������ȡ��
        
        % �˻�Ĺؼ� -- �¶ȼ�С
        
    end
    
end

end

