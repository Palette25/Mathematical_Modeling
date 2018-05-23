%% 标准化所得数据并求解人才吸引力水平的Matlab程序实现 -- 深圳市数据 %%
%% 发展前景 %%
workers = xlsread("深圳市劳动人口");
prodAll = xlsread("深圳市生产总值");

%% 行业前景 %%
company = xlsread("深圳市企业总数");
greatCom = xlsread("深圳市高新企业发展值");

%% 收入 %%
GDPPer = xlsread("深圳市人均GDP");
IncomePer = xlsread("深圳市人均收入");
SalaPer = xlsread("深圳市职工工资指数");

%% 居住环境 %%
tran = xlsread("深圳市交通");
teachers = xlsread("深圳市教育师资");
schools = xlsread("深圳市学校");
stores = xlsread("深圳市商业综合体");
welfare = xlsread("深圳市社会福利");
price = xlsread("深圳市物价");
hosp = xlsread("深圳市医疗卫生");
envir = xlsread("深圳市自然环境");

%% 标准化结果 %%
result = zeros(38, 16); %% 38行，16列指标
%% 2015到2016的增长率 %%
develop = zeros(16, 1);

%% 使用规范化方法，开始数据无量纲标准化 %%
for i=1:38
	 index = zeros(16, 1);
	 year = workers(i, 1); 
	 index(1) = workers(i, 2)*10; %%城市劳动指标
	 index(2) = prodAll(i, 2)*10; %%城市经济指标
	 index(3) = company(i, 2); %%企业总数指标
	 index(4) = greatCom(i, 2); %%高新企业发展指标
	 index(5) = GDPPer(i, 2); %%人均GDP指标
	 index(6) = SalaPer(i, 2);  %%职工工资发展指标
	 index(7) = IncomePer(i, 2); %%人均可支配收入指标
	 index(8) = hosp(i, 2); %%医疗情况指标
	 index(9) = JudgeEnvir(envir(i, 2), envir(i, 3), envir(i, 5), envir(i, 7), envir(i, 8)); %%自然环境指数
	 index(10) = JudgeWelf(welfare(i, 2), welfare(i, 3), welfare(i, 4), welfare(i, 5), welfare(i, 6), welfare(i, 7)); %%社会保障指数
	 index(11) = tran(i, 2) + tran(i, 3); %%公路客运车辆情况
	 index(12) = tran(i, 6) + tran(i, 7); %%轨道交通指数
	 index(13) = price(i, 2); %%社会物价水平
	 index(14) = stores(i, 2); %%商业综合体总数
	 index(15) = schools(i, 2) + schools(i, 3) + schools(i, 4) + schools(i, 5) + schools(i, 6); %%各类学校总数
	 index(16) = teachers(i, 2) + teachers(i, 3) + teachers(i, 4) + teachers(i, 5) + teachers(i, 6); %%教育师资总数
	 maxE = max(index);
	 minE = min(index);
	 
	 %% 标准化过程 %%
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
%% 最终截取深圳市2006年到2016年的十年标准化指标 %%
result = result(28:38, :);

%% 由模糊综合评价法得到的权重向量 %%
weight = [0.0579; 0.1156; 0.0579; 0.1156; 0.0908; 0.1816; 0.1816; 0.0403; 0.0419; 0.0359; 0.0112; 0.0112; 0.015; 0.0075; 0.024; 0.012];

%% 得到各个年度，深圳市人才评估模型的最终得分 %%
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