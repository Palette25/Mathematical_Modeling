%% 多种插值方法的结果计算方法 %%
%% 输出：Lin - 线性插值结果，Qua - 二次插值结果，Tri - 三次插值结果%%
x = [0.32; 0.34; 0.36; 0.38];
y = [0.314567; 0.333487; 0.352274; 0.370920];
R = zeros(3, 1);
x0 = 0.35;

%% 线性插值 %%
Lin = y(2) + (y(3) - y(2)) * (x0 - x(2)) / (x(3) - x(2));
%% 计算线性插值截断误差 %%
R(1) = 0.5 * y(3) * abs((x0-x(2))*(x0-x(3)));

%% 二次插值 %%
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
%% 计算二次插值截断误差 %%
R(2) = sqrt(1 - y(2)*y(2)) / 6 * abs((x0-x(2))*(x0-x(3))*(x0-x(4)));

%% 三次插值 %%
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
%% 计算三次插值截断误差 %%
R(3) = y(4) / 24 * abs((x0-x(1))*(x0-x(2))*(x0-x(3))*(x0-x(4)));

%% 画图显示 %%
plot([Lin;Qua;Tri]);
%% plot(R);
set(gca, 'XTick', 1:3);
set(gca, 'XTickLabel',{'线性插值','二次插值','三次插值'});
