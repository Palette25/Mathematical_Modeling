%% 生成自然环境指数的评估函数 %%
function [EIrate] = JudgeEnvir(water, forest, so2, air, days)
%% 使用生态环境状况指数EI生成环境指数 %%
    EIrate = 0.3*days + 0.2*forest + 0.2*water + 0.1*so2 + 0.2*air;
    
end