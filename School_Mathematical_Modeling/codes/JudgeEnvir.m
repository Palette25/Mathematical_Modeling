%% ������Ȼ����ָ������������ %%
function [EIrate] = JudgeEnvir(water, forest, so2, air, days)
%% ʹ����̬����״��ָ��EI���ɻ���ָ�� %%
    EIrate = 0.3*days + 0.2*forest + 0.2*water + 0.1*so2 + 0.2*air;
    
end