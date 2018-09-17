%% 服从二项分布的CNC机器发生故障概率模型，服从正态分布的机器故障时间指派 %%

function [cnc_state, count] = LossJudger(cnc_state, time_, count)
for i=1:8
    fault_flag = false;
    % 二项分布进行随机数产生，每个随机数实验次数为1，发生事件概率为0.01，判断随机数的值
    r = binornd(1, 0.01, 1, 1);
    if r == 1
        fault_flag = true;
    end

    % 正态分布产生机器故障宕机时间
    time = 0;
    if fault_flag == true
        time = round(normrnd(15, 2, 1));
    end
    
    % 将CNC机器状态数组特定值置为负数，表示宕机时间倒计时
    if time ~= 0
        cnc_state(i) = -1 * (time*60*0.001 + time_);
        count = count + 1;
    end
end
end

