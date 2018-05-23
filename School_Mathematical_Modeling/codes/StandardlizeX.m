%% ����������˲�������ˮƽ��Matlab����ʵ�� %%
%% ��չǰ�� %%
workers = xlsread("����ȫ����Ͷ���Ա");
prodAll = xlsread("����������ֵ");

%% ��ҵǰ�� %%
company = xlsread("������ҵ����");
greatCom = xlsread("���Ÿ�����ҵ����ֵ");

%% ���� %%
GDPPer = xlsread("�����˾�GDP");
IncomePer = xlsread("�����˾���֧������");
SalaPer = xlsread("����ְ�����ʷ�չָ��");

%% ��ס���� %%
tran = xlsread("���Ź�·��ͨ");
educa = xlsread("���Ž������");
stores = xlsread("��������ҵ�ۺ���");
welfare = xlsread("��������ḣ��");
price = xlsread("���������ָ��");
hosp = xlsread("����������ҵ");
envir = xlsread("��������Ȼָ��");

%% ��׼����� %%
result = zeros(11, 16);

%% ʹ�ù淶����������ʼ���������ٱ�׼�� %%
for i=1:11
	 index = zeros(16, 1);
	 year = workers(i, 1); 
	 index(1) = workers(i, 2)*10; %%�����Ͷ�ָ��
	 index(2) = prodAll(i, 2)*10; %%���о���ָ��
	 index(3) = company(i, 2); %%��ҵ����ָ��
	 index(4) = greatCom(i, 2); %%������ҵ��չָ��
	 index(5) = GDPPer(i, 2); %%�˾�GDPָ��
	 index(6) = SalaPer(i, 2);  %%ְ�����ʷ�չָ��
	 index(7) = IncomePer(i, 2); %%�˾���֧������ָ��
	 index(8) = hosp(i, 2); %%ҽ�����ָ��
	 index(9) = JudgeEnvir(envir(i, 2), envir(i, 3), envir(i, 4), envir(i, 5), envir(i, 6)); %%��Ȼ����ָ��
	 index(10) = JudgeWelf(welfare(i, 2), welfare(i, 3), welfare(i, 4), welfare(i, 5), welfare(i, 6), welfare(i, 7)); %%��ᱣ��ָ��
	 index(11) = tran(i, 2) + tran(i, 3); %%��·���˳������
	 index(12) = tran(i, 4) + tran(i, 5); %%�����ָͨ��
	 index(13) = price(i, 2); %%������ˮƽ
	 index(14) = stores(i, 2); %%��ҵ�ۺ�������
	 index(15) = educa(i, 2); %%����ѧУ����
	 index(16) = educa(i, 3); %%����ʦ������
	 maxE = max(index);
	 minE = min(index);
	 
	 %% ��׼������ %%
	 for j=1:16
		 result(i, j) = (index(j) - minE) / (maxE - minE);
	 end
end

%% ��ģ���ۺ����۷��õ���Ȩ������ %%
weight = [0.0579; 0.1156; 0.0579; 0.1156; 0.0908; 0.1816; 0.1816; 0.0403; 0.0419; 0.0359; 0.0112; 0.0112; 0.015; 0.0075; 0.024; 0.012];
eachGoal = zeros(16, 1);
for i=1:16
	 eachGoal(i) = weight(i) * result(11, i); 
end

%% �õ�������ȣ����������˲�����ģ�͵����յ÷� %%
grade = result * weight;

plot(2006:2016, grade, 'r-')