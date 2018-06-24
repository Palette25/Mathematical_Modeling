%% �����������ƽ���������Է��̽ⷨ��Main���� %%
time = 0:0.000001:0.001;
maxError = 10e-10;

%% ������Ϊ����ʱ�䣬������������������� %%
[BiT, BiTS] = Binary(1, maxError);
[NiT, NiTS] = NewTon(1, maxError);
[SiiT, SiiTS] = SimplifiedNewTon(1, maxError);
[SiT, SiTS] = Secant(1, maxError);

%% ������Ϊ����������������������������� %%
[BiS, BiSS] = Binary(0, maxError);
[NiS, NiSS] = NewTon(0, maxError);
[SiiS, SiiSS] = SimplifiedNewTon(0, maxError);
[SiS, SiSS] = Secant(0, maxError);

%% ���ַ����Ƚ�ͼ %%
grid on;
plot(time(1:100), BiT(1:100), 'r-', time(1:100), NiT(1:100), 'b-');
hold on;
plot(time(1:100), SiiT(1:100), 'g-', time(1:100), SiT(1:100), 'y-');
title('Comparison between four method');
xlabel('Time');
ylabel('Convergence precision');
legend('Dichotomy', 'NewTon', 'Simplified NewTon', 'Secant');