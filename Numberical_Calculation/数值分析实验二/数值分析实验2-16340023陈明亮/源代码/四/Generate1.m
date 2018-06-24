%% 生成测试快速傅里叶变换的不同频率正弦信号 %%
function [signals, fre] = Generate1()
N0 = 1024; %% 正弦信号长度为1024
Fs = 1; %% 采样频率
Dt = 1/Fs;
time = [0:N0-1]*Dt; %% 时间序列
x0 = sin(2*pi*0.24*[0:1023]) + sin(2*pi*0.26*[0:1023]);
signals = [x0, zeros(1, N0-1024)]; %%输出正弦信号
f0 = 1/(Dt*N0);
fre = [0:ceil((N0-1)/2)]*f0; %% 频率序列

plot(time(1:200), signals(1:200), 'r-');
end

