%% ����n����ҳ֮��Ļ���ָ������������� %%
store = xlsread('data2.xlsx');

n = input('��������ҳ������: ');

%%��ʼ����Ҫ�Ƚ������%%
result = zeros(1, n);
%%��ʼ����������%%
H = zeros(n, n);
link = zeros(1, n);
G = zeros(n, n);
%%ѡ���ȸ�ϵ��%%
a = 0.85;
J = ones(n, n);
Zero_c = zeros(n, 1);

%%�����Ҫ���㷨����%%
%%���ȵõ������Ӿ���%%
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

%%����õ��Ľ�������Ӿ���ʹ����������Ż�%%
for i=1:n
    if(isequal(Zero_c, H(:, i))) 
        H(:, i) = H(:, i) + 1/n;
    end
end
        

%%�ȸ�������%%
G = a*H + J*((1-a)/n);
%%�ȸ���������ֵ�Լ���������,VΪ����������CΪ��Ӧ������ֵ%%
[V, C] = eig(G);

disp(store);
disp(H);
disp(G);
disp(V);
disp(C);