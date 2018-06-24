%% 梯形法 - Matlab函数 %%
function [result] = Echelon(a, b, h, y0)
x = a + (0:h:b);
y = zeros(b/h+1, 1);
y(1) = y0;
%% 进行梯形方法求解，将隐式函数转换为方程求解 %%
for i=2:b/h+1
   temp = roots([((1-h/2)*y(i-1)), (x(i-1)*h - (1+h/2)*y(i-1)^2), h*x(i)*y(i-1)]);
   y(i) = temp(1); 
end
result = y;
end

