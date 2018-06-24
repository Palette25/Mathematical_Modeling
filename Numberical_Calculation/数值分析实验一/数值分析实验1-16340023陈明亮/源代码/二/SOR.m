%% ��γ��ɳڵ�������Matlabʵ�ֳ��� %%

function [time, re, sign] = SOR(A, b, n, w)
tic
x = zeros(n, 1000);
re = zeros(1000, 1); %%ÿһ�����������������
result = A \ b;
sign = 0;
flag = false;
time = 3; %%����3��Ϊ���޼���ʱ�䣬���޷��ڽ����ҵ���??.0001�Ľ⣬��Ϊ����ʱ??

for k=1:1000
	for i=1:n
	   sum1 = 0;
	   sum2 = 0;
	   for j=1:i-1
		  sum1 = sum1 + A(i, j)*x(j ,k+1); 
	   end
	   for j=i:n
		  sum2 = sum2 + A(i, j)*x(j ,k); 
	   end
	   x(i, k+1) = x(i, k) + w*(b(i)-sum1-sum2) / A(i ,i);
	end
end

for i=2:1000
   re(i-1) = norm(x(:,i) - result);
   if re(i-1) < 0.0001 && flag == false
	  sign = i-1;
	  flag = true;
   end
   if re(i-1) < 0.0001 && time==3
		time = toc;
   end
end