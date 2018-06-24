%% 四种方法，解决常微分方程初值问题 - Main脚本 %%
%% 计算区间，以及步长定义 %%
a = 0;
b = 1;
h = 0.1;
y0 = sqrt(1+2*(0:h:b)); %% 该问题的原函数每一步解
y0 = y0';
maxError = 10e-10; %% 收敛精度设定

%% 调用各种解法 - 曲线值比较 %%
%% 1.前向欧拉法 %%
yf = ForwardEuler(a, b, h, 1);
grid on;
%% 2.后向欧拉法 %%
yb = BackwardEuler(a, b, h, 1);
%% 3.梯形法 %%
ye = Echelon(a, b, h, 1);
%% 4.改进欧拉方法 %%
yi = ImprovedEuler(a, b, h ,1);
%% 查看收敛精度 %%
plot(0:h:b, abs(yf-y0), 'r-', 0:h:b, abs(yb-y0), 'b-');
hold on;
plot(0:h:b, abs(ye-y0), 'g-', 0:h:b, abs(yi-y0), 'y-');
title('Four Methods Precision on Exact Solution');
ylabel('Convergence Precision');
xlabel('Steps, with step length: 0.1')
legend({'Forward Euler', 'Backward Euler', 'Echelon', 'Improved Euler'},'Location', 'NorthWest');