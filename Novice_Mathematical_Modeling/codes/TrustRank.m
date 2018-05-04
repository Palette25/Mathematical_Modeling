%%TrustRank 算法%%

%%各项数据矩阵的初始化%%
store = xlsread('data2.xlsx');
store_inv = store';
n = input('请输入网页的个数: ');
H = zeros(n, n);
U = zeros(n ,n);
link = zeros(1, n);
link_v = zeros(1, n);

%%每个网页超链接数量总和的计算%%
for i=1:n
    for j=1:n
        link(i) = link(i) + store(i ,j);
        link_v(i) = link_v(i) + store_inv(i, j);
    end
end

for i=1:n
    for j=1:n
        %%经过矩阵转置之后，超链接权重矩阵的构建%%
        if(link_v(i)~=0) 
            U(i, j) = store_inv(i, j)/link_v(i);
        end
        %%初始超链接权重矩阵的构建%%
        if(link(i)~=0)
            H(i, j) = store(i, j)/link(i);
        end
    end
end

disp(U);
disp(H);

%%定义元行向量，以及对应的谷歌系数的确立%%
E = ones(1, n);
S = E;
a = 0.85;

%%采用递归的方法精确化最终的Seed向量，这里采用了20作为递归次数%%
for i=1:20
    S = a.*(S*U)+(1-a).*E/n;
end

%%将得到的结果进行排序，确立种子集合%%
S_s = sort(S, 'descend');
disp(S_s);

m = input('请输入种子集合的元素个数: ');

Seed = zeros(1, m);
for i=1:m
    for j=1:n
        if(S(j)==S_s(i)) 
            Seed(i) = j;
        end
    end
end

disp(Seed);
%%对种子集合中的good or bad种子的确定%%
k = input('请输入good种子的个数: ');
good = Seed(1, 1:k);
v = zeros(1, n);
%%建立good种子行向量%%
for i=1:k
    v(good(i)) = 1/k;
end

%%对最终的可信度行向量的建立，同样采用递归的算法实现%%
r = v;
for i=1:20
    r = a*(r*H)+(1-a)*v;
end

disp(v);
disp(r);