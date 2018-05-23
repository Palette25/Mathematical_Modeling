%% �ſ˱ȵ�������Matlabʵ�ֳ��� %%

function [time, re, sign] = Jacobi(A, b, n)
tic
x = zeros(n, 1000);
re = zeros(1000, 1); %% ÿһ�����������������
result = A \ b;
sign = 0;
flag = false;
time = 3; %%����3��Ϊ���޼���ʱ�䣬���޷��ڽ����ҵ�����0.0001�Ľ⣬��Ϊ����ʱ��

for k=1:1000
   for i=1:n
	  sum = 0;
	  for j=1:n
		  if j~=i
			 sum = sum + A(i, j)*x(j, k); 
		  end
	  end
	  x(i, k+1) = (b(i) - sum) / A(i, i);
   end
end

for i=2:1000
	re(i-1) = norm(x(:,i) - result);
	if re(i-1) < 0.0001 && flag==false
	   sign = i-1;
	   flag = true;
	end
	if re(i-1) < 0.0001 && time==3
		time = toc;
	end
end