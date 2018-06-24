%% ���ֲ�ֵ�����Ľ�����㷽�� %%
%% �����Lin - ���Բ�ֵ�����Qua - ���β�ֵ�����Tri - ���β�ֵ���%%
x = [0.32; 0.34; 0.36; 0.38];
y = [0.314567; 0.333487; 0.352274; 0.370920];
R = zeros(3, 1);
x0 = 0.35;

%% ���Բ�ֵ %%
Lin = y(2) + (y(3) - y(2)) * (x0 - x(2)) / (x(3) - x(2));
%% �������Բ�ֵ�ض���� %%
R(1) = 0.5 * y(3) * abs((x0-x(2))*(x0-x(3)));

%% ���β�ֵ %%
Qua = 0;
for i=2:4
   Temp1 = 1;
   Temp2 = 1;
   for j=2:4
       if j ~= i
           Temp1 = Temp1 * (x0 - x(j));
           Temp2 = Temp2 * (x(i) - x(j));
       end
   end
   Qua = Qua + y(i) * Temp1 / Temp2;
end
%% ������β�ֵ�ض���� %%
R(2) = sqrt(1 - y(2)*y(2)) / 6 * abs((x0-x(2))*(x0-x(3))*(x0-x(4)));

%% ���β�ֵ %%
Tri = 0;
for i=1:4
    Temp1 = 1;
    Temp2 = 1;
    for j=1:4
       if j ~= i
          Temp1 = Temp1 * (x0 - x(j));
          Temp2 = Temp2 * (x(i) - x(j));
       end
    end
    Tri = Tri + y(i) * Temp1 / Temp2;
end
%% �������β�ֵ�ض���� %%
R(3) = y(4) / 24 * abs((x0-x(1))*(x0-x(2))*(x0-x(3))*(x0-x(4)));

%% ��ͼ��ʾ %%
plot([Lin;Qua;Tri]);
%% plot(R);
set(gca, 'XTick', 1:3);
set(gca, 'XTickLabel',{'���Բ�ֵ','���β�ֵ','���β�ֵ'});
