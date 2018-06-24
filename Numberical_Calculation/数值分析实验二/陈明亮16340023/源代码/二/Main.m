%% 调用所有求解平方根非线性方程解法的Main函数 %%
time = 0:0.000001:0.001;
maxError = 10e-10;

%% 横坐标为计算时间，各项方法的收敛精度曲线 %%
[BiT, BiTS] = Binary(1, maxError);
[NiT, NiTS] = NewTon(1, maxError);
[SiiT, SiiTS] = SimplifiedNewTon(1, maxError);
[SiT, SiTS] = Secant(1, maxError);

%% 横坐标为迭代步数，各项方法的收敛精度曲线 %%
[BiS, BiSS] = Binary(0, maxError);
[NiS, NiSS] = NewTon(0, maxError);
[SiiS, SiiSS] = SimplifiedNewTon(0, maxError);
[SiS, SiSS] = Secant(0, maxError);

%% 四种方法比较图 %%
grid on;
plot(time(1:100), BiT(1:100), 'r-', time(1:100), NiT(1:100), 'b-');
hold on;
plot(time(1:100), SiiT(1:100), 'g-', time(1:100), SiT(1:100), 'y-');
title('Comparison between four method');
xlabel('Time');
ylabel('Convergence precision');
legend('Dichotomy', 'NewTon', 'Simplified NewTon', 'Secant');