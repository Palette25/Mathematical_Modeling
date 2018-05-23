%% 高斯消元法的Matlab实现程序 %%
%% 函数定义 %%
function [time, x] = Gauss(A, b, n)

x = zeros(n, 1);
m = zeros(n, n);
AN = zeros(n, n, n);
AN(:,:,1) = A;
bN = zeros(n, n);
bN(:,1) = b;

tic
%% 消元计算 %%
for k=1:n-1
	for i=k+1:n
		m(i, k) = AN(i, k, k)/AN(k, k, k);
	end
	for t=1:k
		AN(t,:,k+1) = AN(t,:,k);
		bN(t, k+1) = bN(t, k);
	end
	for i=k+1:n
		for j=k+1:n
			AN(i, j, k+1) = AN(i, j, k) - m(i, k)*AN(k, j, k);
		end
		bN(i, k+1) = bN(i, k) - m(i, k)*bN(k, k);
	end
end

%% 回代计算 %%
x(n) = bN(n, n)/AN(n ,n, n);
for i=n-1:-1:1
	sum = 0;
	for j=i+1:n
	   sum = sum + AN(i, j, i)*x(j); 
	end
   x(i) = (bN(i, i) - sum) / AN(i, i, i);
end

time = toc;