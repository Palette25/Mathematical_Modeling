%%TrustRank �㷨%%

%%�������ݾ���ĳ�ʼ��%%
store = xlsread('data2.xlsx');
store_inv = store';
n = input('��������ҳ�ĸ���: ');
H = zeros(n, n);
U = zeros(n ,n);
link = zeros(1, n);
link_v = zeros(1, n);

%%ÿ����ҳ�����������ܺ͵ļ���%%
for i=1:n
    for j=1:n
        link(i) = link(i) + store(i ,j);
        link_v(i) = link_v(i) + store_inv(i, j);
    end
end

for i=1:n
    for j=1:n
        %%��������ת��֮�󣬳�����Ȩ�ؾ���Ĺ���%%
        if(link_v(i)~=0) 
            U(i, j) = store_inv(i, j)/link_v(i);
        end
        %%��ʼ������Ȩ�ؾ���Ĺ���%%
        if(link(i)~=0)
            H(i, j) = store(i, j)/link(i);
        end
    end
end

disp(U);
disp(H);

%%����Ԫ���������Լ���Ӧ�Ĺȸ�ϵ����ȷ��%%
E = ones(1, n);
S = E;
a = 0.85;

%%���õݹ�ķ�����ȷ�����յ�Seed���������������20��Ϊ�ݹ����%%
for i=1:20
    S = a.*(S*U)+(1-a).*E/n;
end

%%���õ��Ľ����������ȷ�����Ӽ���%%
S_s = sort(S, 'descend');
disp(S_s);

m = input('���������Ӽ��ϵ�Ԫ�ظ���: ');

Seed = zeros(1, m);
for i=1:m
    for j=1:n
        if(S(j)==S_s(i)) 
            Seed(i) = j;
        end
    end
end

disp(Seed);
%%�����Ӽ����е�good or bad���ӵ�ȷ��%%
k = input('������good���ӵĸ���: ');
good = Seed(1, 1:k);
v = zeros(1, n);
%%����good����������%%
for i=1:k
    v(good(i)) = 1/k;
end

%%�����յĿ��Ŷ��������Ľ�����ͬ�����õݹ���㷨ʵ��%%
r = v;
for i=1:20
    r = a*(r*H)+(1-a)*v;
end

disp(v);
disp(r);