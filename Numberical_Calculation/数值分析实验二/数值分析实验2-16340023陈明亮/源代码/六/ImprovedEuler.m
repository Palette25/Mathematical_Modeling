%% �Ľ�ŷ������ - Matlab���� %%
function [result] = ImprovedEuler(a,b,h,y0)
x = a + (0:h:b);
y = zeros(b/h+1, 1);
y(1) = y0;
%% ���иĽ�ŷ��������� %%
for i=2:b/h+1
   yp = y(i-1) + h * (y(i-1) - (2*x(i-1)/y(i-1)));
   yc = y(i-1) + h * (yp - (2*x(i)/yp));
   y(i) = (yp+yc)/2;
end
result = y;
end

