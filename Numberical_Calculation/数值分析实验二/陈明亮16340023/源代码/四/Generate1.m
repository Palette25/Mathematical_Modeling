%% ���ɲ��Կ��ٸ���Ҷ�任�Ĳ�ͬƵ�������ź� %%
function [signals, fre] = Generate1()
N0 = 1024; %% �����źų���Ϊ1024
Fs = 1; %% ����Ƶ��
Dt = 1/Fs;
time = [0:N0-1]*Dt; %% ʱ������
x0 = sin(2*pi*0.24*[0:1023]) + sin(2*pi*0.26*[0:1023]);
signals = [x0, zeros(1, N0-1024)]; %%��������ź�
f0 = 1/(Dt*N0);
fre = [0:ceil((N0-1)/2)]*f0; %% Ƶ������

plot(time(1:200), signals(1:200), 'r-');
end

