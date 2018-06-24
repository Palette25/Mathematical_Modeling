%% �������ι�ʽ�͸�������ɭ��ʽ������ֵ���� - Main�ű� %%
nums = [5;8;17;33];
Tn = zeros(4,1);
Sn = zeros(4,1);

%% �������ι�ʽ����������Ŀ��5,9,17,33 %%
for i=1:4
   Tn(i) = Trapezoid(0, 1, nums(i)); 
end

plot(nums, Tn, 'r-');
grid on;
hold on;

%% ��������ɭ��ʽ����������Ŀ��5,9,17,33 %%
for i=1:4
   Sn(i) = Simpson(0, 1, nums(i)); 
end

plot(nums, Sn, 'b-');
legend({'Trapezoid', 'Simpson'}, 'Location','SouthEast');