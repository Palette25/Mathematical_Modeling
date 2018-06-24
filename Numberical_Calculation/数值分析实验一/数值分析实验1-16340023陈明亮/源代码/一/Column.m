%% 列主元消去法的Matlab实现程序 %%
%% 输入 %%
function [time, b] = Column(A, b, n)
tic

for k=1:n-1
	temp = A(k, k);
	ik = k;
	for j=k:n
	   if abs(A(j, k))>abs(temp)
	   end
	end

if ik ~= k
	for j=k:n
	   tt = A(k, j);
	   A(k, j) = A(ik, j);
	   A(ik, j) = tt;
	end
	btemp = b(ik);
	b(ik) = b(k);
	b(k) = btemp;
end
%% 消元计算 %%
for i=k+1:n
   A(i, k) = A(i, k) / A(k, k);
   b(i) = b(i) - A(i, k)*b(k);
   for j=k+1:n
	  A(i, j) = A(i, j) - A(i, k)*A(k, j); 
   end
end
end
%% 回代计算 %%
b(n) = b(n)/A(n, n);
for i=n-1:-1:1
   sum = 0;
   for j=i+1:n
	  sum = sum + A(i, j)*b(j); 
   end
   b(i) = (b(i) - sum) / A(i, i);
end

time = toc;