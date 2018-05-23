%% 求解对于南山区不同发展阶段的人才，综合量化评价南山区人才吸引力水平 %%
%% 发展前景 %%
workers = xlsread("南山区社会劳动人数");
prodAll = xlsread("南山区生产总值");

%% 行业前景 %%
company = xlsread("南山区企业总数");
greatCom = xlsread("南山区高新企业发展值");

%% 收入 %%
GDPPer = xlsread("南山区人均GDP");
IncomePer = xlsread("南山区人均可支配收入");
SalaPer = xlsread("南山区职工工资发展指数");

%% 居住环境 %%
tran = xlsread("南山区公路交通");
educa = xlsread("南山区教育情况");
stores = xlsread("南山区商业综合体");
welfare = xlsread("南山区社会福利");
price = xlsread("南山区物价指数");
hosp = xlsread("南山区卫生事业");
envir = xlsread("南山区自然环境");

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

%% 由AHP层次分析法，划分的权重向量 %%
%% 0-18岁的人才权重向量 %%
weight1 = [0.0533; 0.1062; 0.0533; 0.1062; 0.0920; 0.1840; 0.1840; 0.0376; 0.0432; 0.0430; 0.0121; 0.0121; 0.0174; 0.0069; 0.0326; 0.0163];
%% 18-35岁的人才权重向量 %%
weight2 = [0.0668;0.1332;0.0688;0.1332;0.0732;0.1332;0.1936;0.0402;0.0411;0.035;0.0116;0.0116;0.0186;0.0093;0.0218;0.0109];
%% 35-60岁的人才权重向量 %%
weight3 = [0.0418;0.0833;0.0418;0.0833;0.0741;0.1839;0.1170;0.0862;0.0804;0.0672;0.0218;0.0218;0.0261;0.014;0.039;0.0195];
%% 60岁以上的人才权重向量 %%
weight4 = [0.0412;0.0821;0.0412;0.0821;0.0921;0.1843;0.1843;0.0707;0.0646;0.0553;0.0141;0.0141;0.0188;0.0094;0.0306;0.0153];

%% 对每个发展阶段的人才进行标准化数据求和 %%
grade = 0.22*result * weight1 + 0.4*result * weight2 + 0.34*result * weight3 + 0.04*result * weight4;

plot(2006:2016, grade, 'r-');