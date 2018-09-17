%% 模拟退火算法优化单工序调度器所得解函数 -- Matlab实现 %%

function [optimal_result, optimal_produce_num] = SimulatedAnnealingScheduler(init_result, init_num, init_temp, iterate_time, R1, R2, R3, T1, T2, n, W)
optimal_result = init_result;
optimal_produce_num = init_num;
% 在指定的迭代步数中进行循环，进行随机干扰获得近似解，判断是否接受该新解
for i=1:iterate_time
    % 均与分布产生随机数，表示选择的路径点下标
    index = round(0 + (optimal_result.size()-2)*rand(1));
    % 以随机下标作为基准点，向前考虑与其他不同编号的CNC机器路径点进行交换，以RGV路径生成的约束作为条件
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
        % 以均匀分布，随机选择该数组中的单个元素进行交换
        len = length(different_index);
        ran_index = round(1 + (len-1)*rand(1));
        tmp = different_index(ran_index);
        % 取出后的节点则去除
        different_index(ran_index) = [];
        temp_result = optimal_result.clone();
        [temp_result] = SwapCNCID(index, tmp, temp_result);
        % 截取临时处理队列中的前1-tmp位，进行队列后段的舍弃(每一个节点都改变都直接影响到全局路径的生成)
        temp_result = java.util.LinkedList(temp_result.subList(0, tmp+1));
        % 进行队列生成规则与约束条件的检测与校验
        ttmp = temp_result.get(tmp);
        constrain_flag = true;
        for j = tmp-1:-1:0
            jmp = temp_result.get(j);
            if ttmp(2) == jmp(2) && ttmp(4) + ttmp(5) > jmp(4) % 倘若不满足约束条件，则重新随机寻找基准点前的可替换下标
                constrain_flag = false;
            end
        end
        % 成功找到符合约束条件的变化后路径起始节点段，进行启发式拓展
        if constrain_flag == true
            % 进行启发式优先规则的新路径拓展生成
            [new_path, new_product_num] = HeuristicExpand(temp_result, R1, R2, R3, T1, T2, n, W);
            % 拿取新解的产品数，进行评估与取舍
            if new_product_num <= optimal_produce_num
                % 新解产出小于等于之前解的产出，则以一定概率接受此较差的解
                accept_pro = exp((new_product_num - optimal_produce_num) / init_temp);
                rand_temp = rand(1);
                if rand_temp <= accept_pro
                    optimal_result = new_path;
                    optimal_produce_num = new_product_num;
                end
            else
                % 新解产出比之前解产出大，果断接受新解
                optimal_result = new_path;
                optimal_produce_num = new_product_num;
            end
            % 退火的关键 -- 温度减小
            init_temp = init_temp - init_temp / 100;
        end
    end
    if init_temp <= 0
        break;
    end
end

end

