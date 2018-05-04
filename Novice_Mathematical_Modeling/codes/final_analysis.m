store = xlsread('end_data.xls');

disp(store);
n = input('��������ҳ�ĸ���: ');
average = zeros(1, 4);

%%���Ƚ�������ָ��ľ�ֵ����%%
for i=1:4
    for j=1:n
        average(i) = average(i) + store(i, j);
    end
    average(i) = average(i) / n;
end

disp(average);
%%��ԭʼ���ݽ��о�ֵ������%%
for i=1:4
    for j=1:n
        store(i, j) = store(i, j)/average(i);
    end
end
disp(store);
%%ȷ������ϵ���ĸ���ϵ��%%
%%������det�ľ���%%
det = zeros(4, n);
a = 10000000;%%��Сֵ%%
b = -1000000;%%���ֵ%%
y = zeros(4, n);

%%����deta����%%
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
%%������ָ���еĹ���ϵ��%%
for i=1:4
    for j=1:n
        y(i, j) = (a+b*0.5)/(det(i, j)+b*0.5);
    end
end

disp(y);
%%������յĹ���ϵ��֮��%%
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

%%�õ����ո���ָ���weightȨֵ%%
w = zeros(1, 4);
for i=1:4
    w(i) = r(i)/sum;
end

disp(w);

%%�������մ�Ȩֵ�ĸ���ָ�����Ҫ�Ƚ��%%
final = zeros(1, n);
for i=1:n
    for j=1:4
        final(i) = final(i) + w(j)*store(j, i);
    end
end

disp(final);