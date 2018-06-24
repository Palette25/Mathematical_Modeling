%% 雅克比迭代法的Matlab实现程序 %%

function [time, re, sign] = Jacobi(A, b, n)
tic
x = zeros(n, 1000);
re = zeros(1000, 1); %% 每一步迭代结果的相对误差
result = A \ b;
sign = 0;
flag = false;
time = 3; %%设置3秒为极限计算时间，若无法在解中找到近似0.0001的解，则为极限时间

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