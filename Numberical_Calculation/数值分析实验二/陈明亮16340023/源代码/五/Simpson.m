%% 复合辛普森公式 - 计算[a,b]范围内,采样点数目为num的sinx/x数值积分 %%
function [S] = Simpson(a,b,num)
n = num-1; %% 区间划分为n等份
h = (b-a) / n; %% 每一份的宽度
x = a + (0:n)*h; %% 每个采样点坐标
for i=1:n+1
   if x(i) == 0
	  x(i) = 10e-10; %% 处理函数值为0的坐标点 
   end
end
S1 = sin(x(1)) / x(1) + sin(x(n+1)) / x(n+1);
S2 = 0;
S3 = 0;

%% 复合辛普森算法 %%
for k=0:n-1
   S3 = S3 + sin(x(k+1)+h/2) / (x(k+1)+h/2); 
   if k > 0
	  S2 = S2 + sin(x(k+1)) / x(k+1);
   end
end
S = h*(S1 + 2*S2 + 4*S3) / 6;
end

