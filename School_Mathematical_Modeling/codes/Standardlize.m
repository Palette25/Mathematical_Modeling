%% ��׼���������ݲ�����˲�������ˮƽ��Matlab����ʵ�� -- ���������� %%
%% ��չǰ�� %%
workers = xlsread("�������Ͷ��˿�");
prodAll = xlsread("������������ֵ");

%% ��ҵǰ�� %%
company = xlsread("��������ҵ����");
greatCom = xlsread("�����и�����ҵ��չֵ");

%% ���� %%
GDPPer = xlsread("�������˾�GDP");
IncomePer = xlsread("�������˾�����");
SalaPer = xlsread("������ְ������ָ��");

%% ��ס���� %%
tran = xlsread("�����н�ͨ");
teachers = xlsread("�����н���ʦ��");
schools = xlsread("������ѧУ");
stores = xlsread("��������ҵ�ۺ���");
welfare = xlsread("��������ḣ��");
price = xlsread("���������");
hosp = xlsread("������ҽ������");
envir = xlsread("��������Ȼ����");

%% ��׼����� %%
result = zeros(38, 16); %% 38�У�16��ָ��
%% 2015��2016�������� %%
develop = zeros(16, 1);

%% ʹ�ù淶����������ʼ���������ٱ�׼�� %%
for i=1:38
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
	 index(9) = JudgeEnvir(envir(i, 2), envir(i, 3), envir(i, 5), envir(i, 7), envir(i, 8)); %%��Ȼ����ָ��
	 index(10) = JudgeWelf(welfare(i, 2), welfare(i, 3), welfare(i, 4), welfare(i, 5), welfare(i, 6), welfare(i, 7)); %%��ᱣ��ָ��
	 index(11) = tran(i, 2) + tran(i, 3); %%��·���˳������
	 index(12) = tran(i, 6) + tran(i, 7); %%�����ָͨ��
	 index(13) = price(i, 2); %%������ˮƽ
	 index(14) = stores(i, 2); %%��ҵ�ۺ�������
	 index(15) = schools(i, 2) + schools(i, 3) + schools(i, 4) + schools(i, 5) + schools(i, 6); %%����ѧУ����
	 index(16) = teachers(i, 2) + teachers(i, 3) + teachers(i, 4) + teachers(i, 5) + teachers(i, 6); %%����ʦ������
	 maxE = max(index);
	 minE = min(index);
	 
	 %% ��׼������ %%
	 for j=1:16
		 result(i, j) = (index(j) - minE) / (maxE - minE);
	 end
	 
	 if i==37
			develop = index;
	 end
end
develop = index ./ develop;
developS = [1.4211;1.4;1.46;1.2326;1.24;1.46;1.45;1.25;1.024;1.18;1.0507;1.1569;1.075;1.3478;1.1;1.1276];
indexS = developS .* index;
resultS = zeros(16, 1);
for j=1:16
		 resultS(j, 1) = (indexS(j) - min(indexS)) / (max(indexS) - min(indexS));
end
%% ���ս�ȡ������2006�굽2016���ʮ���׼��ָ�� %%
result = result(28:38, :);

%% ��ģ���ۺ����۷��õ���Ȩ������ %%
weight = [0.0579; 0.1156; 0.0579; 0.1156; 0.0908; 0.1816; 0.1816; 0.0403; 0.0419; 0.0359; 0.0112; 0.0112; 0.015; 0.0075; 0.024; 0.012];

%% �õ�������ȣ��������˲�����ģ�͵����յ÷� %%
grade = result * weight;
eachGoal = zeros(16, 1);
for i=1:16
	 eachGoal(i) = result(11,i)*weight(i); 
end

gradeS = zeros(12, 1);
for i=1:11
		gradeS(i) = grade(i);
end
gradeS(12, 1) = resultS' * weight;
plot(2006:2016, grade, 'r-');