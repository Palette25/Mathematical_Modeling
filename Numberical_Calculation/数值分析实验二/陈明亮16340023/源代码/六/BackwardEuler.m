%% ����ŷ������ - Matlab���� %%
function [result] = BackwardEuler(a, b, h, y0)
x = a + (0:h:b);
y = zeros(b/h+1, 1);
y(1) = y0;
%% ���к���ѭ����� %%
for i=2:b/h+1
   temp = roots([(1-h), -y(i-1), 2*h*x(i)]);
   y(i) = temp(1); %% yn+1���Ƿ���(1-h)y^2 - yn*y + 2*h*xn+1 = 0�Ľ�
end
result = y;
end

