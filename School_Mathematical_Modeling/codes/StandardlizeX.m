%% 求解厦门市人才吸引力水平的Matlab程序实现 %%
%% 发展前景 %%
workers = xlsread("厦门全社会劳动人员");
prodAll = xlsread("厦门生产总值");

%% 行业前景 %%
company = xlsread("厦门企业总数");
greatCom = xlsread("厦门高新企业增长值");

%% 收入 %%
GDPPer = xlsread("厦门人均GDP");
IncomePer = xlsread("厦门人均可支配收入");
SalaPer = xlsread("厦门职工工资发展指数");

%% 居住环境 %%
tran = xlsread("厦门公路交通");
educa = xlsread("厦门教育情况");
stores = xlsread("厦门市商业综合体");
welfare = xlsread("厦门市社会福利");
price = xlsread("厦门市物价指数");
hosp = xlsread("厦门卫生事业");
envir = xlsread("厦门市自然指数");

%% 标准化结果 %%
result = zeros(11, 16);

%% 使用规范化方法，开始数据无量纲标准化 %%
for i=1:11
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
	 index(9) = JudgeEnvir(envir(i, 2), envir(i, 3), envir(i, 4), envir(i, 5), envir(i, 6)); %%自然环境指数
	 index(10) = JudgeWelf(welfare(i, 2), welfare(i, 3), welfare(i, 4), welfare(i, 5), welfare(i, 6), welfare(i, 7)); %%社会保障指数
	 index(11) = tran(i, 2) + tran(i, 3); %%公路客运车辆情况
	 index(12) = tran(i, 4) + tran(i, 5); %%轨道交通指数
	 index(13) = price(i, 2); %%社会物价水平
	 index(14) = stores(i, 2); %%商业综合体总数
	 index(15) = educa(i, 2); %%各类学校总数
	 index(16) = educa(i, 3); %%教育师资总数
	 maxE = max(index);
	 minE = min(index);
	 
	 %% 标准化过程 %%
	 for j=1:16
		 result(i, j) = (index(j) - minE) / (maxE - minE);
	 end
end

%% 由模糊综合评价法得到的权重向量 %%
weight = [0.0579; 0.1156; 0.0579; 0.1156; 0.0908; 0.1816; 0.1816; 0.0403; 0.0419; 0.0359; 0.0112; 0.0112; 0.015; 0.0075; 0.024; 0.012];
eachGoal = zeros(16, 1);
for i=1:16
	 eachGoal(i) = weight(i) * result(11, i); 
end

%% 得到各个年度，广州市市人才评估模型的最终得分 %%
grade = result * weight;

plot(2006:2016, grade, 'r-')