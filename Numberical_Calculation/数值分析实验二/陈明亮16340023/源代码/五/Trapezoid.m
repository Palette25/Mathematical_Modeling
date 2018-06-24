%% �������ι�ʽ - ����[a,b]��Χ��,��������ĿΪnum��sinx/x��ֵ���� %%
function [T] = Trapezoid(a,b,num)
n = num-1; %% ���仮��Ϊn�ȷ�
h = (b-a) / n; %% ÿһ�ݵĿ��
x = a + (0:n)*h; %% ÿ������������
for i=1:n+1
   if x(i) == 0
	  x(i) = 10e-10; %% ������ֵΪ0������� 
   end
end
T1 = sin(x(1)) / x(1) + sin(x(n+1)) / x(n+1);
T2 = 0;

%% ���������㷨 %%
for k=1:n-1
   T2 = T2 + sin(x(k+1)) / x(k+1);
end
T = h*(T1 + 2*T2) / 2;
end

