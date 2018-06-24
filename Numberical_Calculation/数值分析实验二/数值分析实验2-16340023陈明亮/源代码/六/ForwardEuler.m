%% ǰ��ŷ������ - Matlab���� %%
function [result] = ForwardEuler(a, b, h, y0)
x = a + (0:h:b);
y = zeros(b/h+1, 1);
y(1) = y0;
%% ����ǰ��ѭ����� %%
for i=2:b/h+1
    y(i) = y(i-1) + h * (y(i-1) - (2*x(i-1)/y(i-1)));
end
result = y;
end

