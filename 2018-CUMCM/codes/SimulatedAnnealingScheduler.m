%% 模拟退火算法优化单工序调度器所得解函数 -- Matlab实现 %%

function [optimal_result] = SimulatedAnnealingScheduler(init_result, init_temp, iterate_time)
optimal_result = init_result;
% 在指定的迭代步数中进行循环，进行随机干扰获得近似解，判断是否接受该新解
for i=1:iterate_time
    % 均与分布产生随机数，表示选择的路径点下标
    index = round(0 + (init_result.size()-1)*rand(1));
    % 以随机下标作为基准点，向前考虑与其他不同编号的CNC机器路径点进行交换，以RGV路径生成的约束作为条件
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
        % 以均匀分布，随机选择该数组中的单个元素进行交换
        len = length(different_index);
        tmp = round(1 + (len-1)*rand(1));
        temp_result = optimal_result.clone();
        [temp_result] = SwapCNCID(index, tmp, temp_result);
        % 截取临时处理队列中的前1-tmp位，进行队列后段的舍弃(每一个节点都改变都直接影响到全局路径的生成)
        temp_result = temp_result.subList(0, tmp+1);
        % 进行队列生成规则与约束条件的检测与校验
        ttmp = temp_result.get(tmp);
        for j = tmp-1:-1:0
            jmp = temp_result.get(j);
            if ttmp(2) == jmp(2)
                
            end
        end
        % 进行启发式优先规则的新路径拓展生成
        
        % 拿取新解的产品数，进行评估与取舍
        
        % 退火的关键 -- 温度减小
        
    end
    
end

end

