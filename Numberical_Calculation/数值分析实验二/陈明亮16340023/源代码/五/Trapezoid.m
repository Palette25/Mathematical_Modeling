%% 复合梯形公式 - 计算[a,b]范围内,采样点数目为num的sinx/x数值积分 %%
function [T] = Trapezoid(a,b,num)
n = num-1; %% 区间划分为n等份
h = (b-a) / n; %% 每一份的宽度
x = a + (0:n)*h; %% 每个采样点坐标
for i=1:n+1
   if x(i) == 0
	  x(i) = 10e-10; %% 处理函数值为0的坐标点 
   end
end
T1 = sin(x(1)) / x(1) + sin(x(n+1)) / x(n+1);
T2 = 0;

%% 复合梯形算法 %%
for k=1:n-1
   T2 = T2 + sin(x(k+1)) / x(k+1);
end
T = h*(T1 + 2*T2) / 2;
end

