%% 共轭梯度法(CG方法)的Matlab实现程序 %%

function [time, re, sign] = CG(A, b, n)
tic
x0 = zeros(n, 1);
result = A \ b;
re = zeros(1000, 1);
r0 = b - A*x0;
p0 = r0;
sign = 0;
flag = false;
time = 3; %%设置3秒为极限计算时间，若无法在解中找到近似0.0001的解，则为极限时间

for k=1:1000
	if isequal(r0, zeros(n, n)) || isequal(p0'*A*p0, zeros(n, n))
	   break; 
	end
	ak = (r0'*r0)/(p0'*A*p0);
	x1 = x0 + ak*p0;
	r1 = r0 - ak*A*p0;
	bk = (r1'*r1)/(r0'*r0);
	p1 = r1 + bk*p0;
	
	%% 将各项k+1的计算结果存回，避免存储多余的项 %%
	x0 = x1;
	re(k) = norm(x0 - result);
	if re(k) < 0.0001 && flag==false
	   sign = k;
	   flag = true;
	end
	if re(k) < 0.0001 && time==3
		time = toc;
	end
	r0 = r1;
	p0 = p1;
end
