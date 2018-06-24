%% ��������ɭ��ʽ - ����[a,b]��Χ��,��������ĿΪnum��sinx/x��ֵ���� %%
function [S] = Simpson(a,b,num)
n = num-1; %% ���仮��Ϊn�ȷ�
h = (b-a) / n; %% ÿһ�ݵĿ��
x = a + (0:n)*h; %% ÿ������������
for i=1:n+1
   if x(i) == 0
	  x(i) = 10e-10; %% ������ֵΪ0������� 
   end
end
S1 = sin(x(1)) / x(1) + sin(x(n+1)) / x(n+1);
S2 = 0;
S3 = 0;

%% ��������ɭ�㷨 %%
for k=0:n-1
   S3 = S3 + sin(x(k+1)+h/2) / (x(k+1)+h/2); 
   if k > 0
	  S2 = S2 + sin(x(k+1)) / x(k+1);
   end
end
S = h*(S1 + 2*S2 + 4*S3) / 6;
end

