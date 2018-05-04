%% 创建n个网页之间的互相指向的链接数矩阵 %%
store = xlsread('data2.xlsx');

n = input('请输入网页的数量: ');

%%初始化重要度结果数组%%
result = zeros(1, n);
%%初始化各个矩阵%%
H = zeros(n, n);
link = zeros(1, n);
G = zeros(n, n);
%%选定谷歌系数%%
a = 0.85;
J = ones(n, n);
Zero_c = zeros(n, 1);

%%求解重要度算法部分%%
%%首先得到超链接矩阵%%
for i=1:n
    for j=1:n
    if(store(i, j)>0)
        link(i) = link(i)+store(i, j);
    end
    end
end

for i=1:n
    for j=1:n
        if(store(j, i)>0)
            H(i, j) = H(i, j)+store(j, i)/link(j);
        end
    end
end

%%检验得到的结果超链接矩阵，使用随机矩阵优化%%
for i=1:n
    if(isequal(Zero_c, H(:, i))) 
        H(:, i) = H(:, i) + 1/n;
    end
end
        

%%谷歌矩阵求解%%
G = a*H + J*((1-a)/n);
%%谷歌矩阵的特征值以及特征向量,V为特征向量，C为对应的特征值%%
[V, C] = eig(G);

disp(store);
disp(H);
disp(G);
disp(V);
disp(C);