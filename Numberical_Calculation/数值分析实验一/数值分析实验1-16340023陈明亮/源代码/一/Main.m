%% 调用两种解线性方程组算法的主程序 %%

x = [10, 25, 50, 75, 100, 125, 150, 175, 200];
y1 = zeros(9);
y2 = zeros(9);

for i=1:9
    A = randn(x(i));
    b = randn(x(i), 1);
   [y1(i), x1] = Gauss(A, b, x(i));
   [y2(i), x2] = Column(A, b, x(i));
   fprintf("当前测试矩阵A的维度：%d\n", x(i));
   fprintf("高斯消元法所需要的时间：%fs\t列主元消去法所需要的时间：%fs\n", y1(i), y2(i));
   result = "false";
   if isequal(x1,x2)==1
       result = "true";
   end
   fprintf("两种算法的结果矩阵x是否相等：%s\n", result);
end
plot(x, y1, 'r-', x, y2, 'b-');