%% ���Ժͼ�¼ÿ����ͬ������Ч�������ű� %%
% 1. ������ӹ�������CNC���������������
[count1, count2, point_arr, time_arr, produce_arr, path1, path2] = GreedySchedulerOne(0.018, 0.032, 0.046, 0.545, 0.027, 0.032, 0.025);
% �������õ������飬ÿ����Сʱ���㣬���ӵ�����ͼ


% ���ȹ۲�����ʽ�����õ������ս⣬����ÿ��CNC�����ϵ���ʷִ�в���
for i=1:1
    temp = path1(i);
    for j=0:temp.size()-1
       ttmp = temp.get(j);
       % disp(ttmp(1) + " " + ttmp(2) + " " + ttmp(3)+ " " + ttmp(4)+ " " + ttmp(5));
    end
end

x = [];
y = [];
for i=0:49
   ttmp = path2.get(i);
   x = [x, ttmp(1)];
   y = [y, ttmp(2)];
   disp(ttmp(1) + " " + ttmp(2) + " " + ttmp(3)+ " " + ttmp(4)+ " " + ttmp(5));
end
str = [repmat('', 50, 1) num2str(x') repmat(', ', 50, 1) num2str(y')];

plot(x, y, 'r-');
text(x, y, cellstr(str));
