store = xlsread('end_data.xls');

disp(store);
n = input('请输入网页的个数: ');
average = zeros(1, 4);

%%首先建立各项指标的均值数组%%
for i=1:4
    for j=1:n
        average(i) = average(i) + store(i, j);
    end
    average(i) = average(i) / n;
end

disp(average);
%%将原始数据进行均值化处理%%
for i=1:4
    for j=1:n
        store(i, j) = store(i, j)/average(i);
    end
end
disp(store);
%%确定关联系数的各项系数%%
%%首先是det的矩阵%%
det = zeros(4, n);
a = 10000000;%%最小值%%
b = -1000000;%%最大值%%
y = zeros(4, n);

%%建立deta矩阵%%
for i=1:4
    for j=1:n
        det(i, j) = abs(store(1, j)-store(i, j));
        if(det(i, j)<a)
            a = det(i, j);
        end
        if(det(i, j)>b)
            b = det(i, j);
        end
    end
end

disp(det);
%%求解各项指标中的关联系数%%
for i=1:4
    for j=1:n
        y(i, j) = (a+b*0.5)/(det(i, j)+b*0.5);
    end
end

disp(y);
%%求解最终的关联系数之和%%
r = zeros(1, 4);
sum = 0;
for i=1:4
    for j=1:n
        r(i) = r(i) + y(i, j);
    end
    r(i) = r(i)/n;
    sum = sum + r(i);
end
disp(r);

%%得到最终各项指标的weight权值%%
w = zeros(1, 4);
for i=1:4
    w(i) = r(i)/sum;
end

disp(w);

%%量化最终带权值的各项指标的重要度结果%%
final = zeros(1, n);
for i=1:n
    for j=1:4
        final(i) = final(i) + w(j)*store(j, i);
    end
end

disp(final);