%% ���Ժͼ�¼ÿ����ͬ������Ч�������ű� %%
% 1. ������ӹ�������CNC���������������
[count1, count2, point_arr, time_arr, produce_arr, path1, path2] = GreedySchedulerOne(0.02, 0.033, 0.046, 0.560, 0.028, 0.031, 0.025, 1, 1);
% �������õ������飬ÿ����Сʱ���㣬���ӵ�����ͼ
% ����ģ���˻��Ż���ĵ�����ӹ�ģ��
%[optimal_result, optimal_produce_num] = SimulatedAnnealingScheduler(path2, count2, 100, 1000, 0.02, 0.033, 0.046, 0.560, 0.028, 0.031, 0.025);
format long;
x = [];
y = [];
start_time = [];
end_time = [];
for i=0:path2.size()-1
   ttmp = path2.get(i);
   x = [x, ttmp(1)];
   y = [y, ttmp(2)];
   disp(ttmp(1) + " " + ttmp(2) + " " + ttmp(4)*1000+ " " + (ttmp(5)+ttmp(4))*1000);
   start_time = [start_time, ttmp(4)*1000];
   end_time = [end_time, (ttmp(4)+ttmp(5))*1000];
end


%p1 = [1];
%p2 = [1];
%product_num = [count2];
%���ȹ���ָ���㷨����Ѳ����ƽ�
%for i=1.1:0.1:2
    %for j=1.1:0.1:2
       %[count1, count2, point_arr, time_arr, produce_arr, path1, path2] = GreedySchedulerOne(0.018, 0.032, 0.046, 0.545, 0.027, 0.032, 0.025, i, j);
       %p1 = [p1, i];
       %p2 = [p2, j];
       %product_num = [product_num, count2];
    %
%end

%plot3(p1, p2, product_num);
%hold on;
%xlabel('��');
%ylabel('��');
%zlabel('Product-Number');
%title('Parameters Check For Value Function')