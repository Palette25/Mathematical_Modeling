%% 调用各个迭代法程序的主程序Main1 %%

dim = [10, 50, 100, 200];
timeJ4 = zeros(4, 1); %%雅克比迭代法的不同size矩阵对应计算时间
timeGS4 = zeros(4, 1); %%高斯赛德尔迭代法的不同size矩阵对应计算时间
timeS4 = zeros(4, 1); %%SOR法的不同size矩阵对应计算时间
timeCG4 = zeros(4, 1); %%CG法的不同size矩阵对应计算时间
timeC4 = zeros(4, 1); %%列主元消去法的不同size矩阵对应计算时间
timeG4 = zeros(4, 1); %%高斯消元法的不同size矩阵对应计算时间

%% 开始调用，绘制曲线 %%
for i=1:4
    %% 此处为使Jacobi迭代法收敛，均采用A和2D-A皆为对称正定矩阵的随机结果 %%
    [A, b] = Generate(dim(i));
    [timeJ, Ja, signJ] = Jacobi(A, b, dim(i));
    timeJ4(i) = timeJ;
    [timeGS, GS, signG] = GaussSeidel(A, b, dim(i));
    timeGS4(i) = timeGS;
    [timeS, SO, signS] = SOR(A, b, dim(i), 1.3);
    timeS4(i) = timeS;
    [timeCG, CG0, signC] = CG(A, b, dim(i));
    timeCG4(i) = timeCG;
    [timeC, xC] = Column(A, b, dim(i));
    timeC4(i) = timeC;
    [timeG, xG] = Gauss(A, b, dim(i));
    timeG4(i) = timeG;
end

plot(dim, timeG4, 'r-', dim, timeC4, 'b-', dim, timeJ4, 'g-');
hold on;
plot(dim, timeGS4, 'y-', dim, timeS4, 'k-', dim, timeCG4, 'm-');
legend('Gauss', 'Column', 'Jacobi', 'Gauss-Seidel', 'SOR', 'CG');