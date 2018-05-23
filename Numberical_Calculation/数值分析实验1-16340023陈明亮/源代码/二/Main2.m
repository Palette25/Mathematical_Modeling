%% 调用迭代法画图分析的主函数Main2 %%

dim = 100; %%手动调矩阵的大小，因为plot不能显示多张图
[A, b] = Generate(dim);
w = zeros(10, 1); %%SOR迭代的松弛因子
Sp = zeros(10, 1); %%对应松弛因子的SOR迭代速度
for i=1:10
   w(i) = 1 + (i-1)*0.1; 
end

%% 开始调用，绘制曲线（此处可以分别手动注释，减少等待时间） %%
%%[timeJ, Ja, signJ] = Jacobi(A, b, dim);
%%[timeGS, GS, signG] = GaussSeidel(A, b, dim);
%%[timeS, SO, signS] = SOR(A, b, dim, w);
%%[timeCG, CG0, signC] = CG(A, b, dim);
for i=1:10
   [timeS, SO, signS] = SOR(A, b, dim, w(i));
   Sp(i) = signS;
end

plot(w, Sp, 'r-');
grid on;
xlabel('Relaxation factor w');
ylabel('Converence Speed');
title('Convergence graph of SOR with size = 100 and w from 1.0 to 1.9');