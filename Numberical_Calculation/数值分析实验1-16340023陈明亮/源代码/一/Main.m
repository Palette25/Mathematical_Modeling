%% �������ֽ����Է������㷨�������� %%

x = [10, 25, 50, 75, 100, 125, 150, 175, 200];
y1 = zeros(9);
y2 = zeros(9);

for i=1:9
    A = randn(x(i));
    b = randn(x(i), 1);
   [y1(i), x1] = Gauss(A, b, x(i));
   [y2(i), x2] = Column(A, b, x(i));
   fprintf("��ǰ���Ծ���A��ά�ȣ�%d\n", x(i));
   fprintf("��˹��Ԫ������Ҫ��ʱ�䣺%fs\t����Ԫ��ȥ������Ҫ��ʱ�䣺%fs\n", y1(i), y2(i));
   result = "false";
   if isequal(x1,x2)==1
       result = "true";
   end
   fprintf("�����㷨�Ľ������x�Ƿ���ȣ�%s\n", result);
end
plot(x, y1, 'r-', x, y2, 'b-');