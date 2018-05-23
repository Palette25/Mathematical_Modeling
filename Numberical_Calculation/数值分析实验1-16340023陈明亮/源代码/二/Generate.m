%% 随机生成对称正定矩阵A，并且符合2D-A也为对称正定矩阵的条件,还有符合独立正态分布的b %%

function [A, b] = Generate(n)

for i=1:20
	b = normrnd(0, 1, n, 1);
	V = diag(unifrnd(0, 1, 1, n));
	U = orth(normrnd(0, 1, n, n));
	A = U' * V * U;
	D = tril(A) + triu(A) - A;
	
	c = eig(2*D - A);
	min = c(1);
	for j=2:n
		if min > c(j)
			min = c(j);
		end
	end
	if min > 0
		break;
	end
end