%% Combine SIS Model Predict datas and ARIMA Predict datas

%% Read origin datas
[id_1, ohi] = xlsread('Ohio.xlsx');
[id_2, ken] = xlsread('Kentucky.xlsx');
[id_3, ten] = xlsread('Pennsylvania.xlsx');
[~, vir] = xlsread('Virginia.xlsx');
[~, wes] = xlsread('West Virginia.xlsx');

id_2(:,2) = [];
id_4 = vir(:,1); id_4(1,:) = []; id_4(1,:) = [];
id_5 = wes(:,1); id_5(1,:) = []; id_5(1,:) = [];

%% Collect every county's size
ohi_size = size(id_1, 1); ken_size = size(id_2, 1);
ten_size = size(id_3, 1); vir_size = size(id_4, 1);
wes_size = size(id_5, 1);

%% Combine every state's SIS and ARIMA model predict data
for i=1:ohi_size
    result = zeros(14, 8);
   %% Read SIS Datas
    [SIS_Ohi] = xlsread('SIS_Ohi.xlsx', i);
    %% Read ARIMA Datas
    [ARIMA_Ohi] = xlsread('ARIMA_Ohi.xlsx', i);
    for j=1:14
       for k=1:8
          result(j, k) = SIS_Ohi(j, k) + ARIMA_Ohi(j, k);
       end
    end
    xlswrite('Final_Ohi.xlsx', result, i);
end

for i=1:ken_size
    result = zeros(14, 8);
   %% Read SIS Datas
    [SIS_Ken] = xlsread('SIS_Ken.xlsx', i);
    %% Read ARIMA Datas
    [ARIMA_Ken] = xlsread('ARIMA_Ken.xlsx', i);
    for j=1:14
       for k=1:8
          result(j, k) = SIS_Ken(j, k) + ARIMA_Ken(j, k);
       end
    end
    xlswrite('Final_Ken.xlsx', result, i);
end

for i=1:ten_size
    result = zeros(14, 8);
   %% Read SIS Datas
    [SIS_Pen] = xlsread('SIS_Pen.xlsx', i);
    %% Read ARIMA Datas
    [ARIMA_Pen] = xlsread('ARIMA_Pen.xlsx', i);
    for j=1:14
       for k=1:8
          result(j, k) = SIS_Pen(j, k) + ARIMA_Pen(j, k);
       end
    end
    xlswrite('Final_Pen.xlsx', result, i);
end

for i=1:vir_size
    result = zeros(14, 8);
   %% Read SIS Datas
    [SIS_Vir] = xlsread('SIS_Vir.xlsx', i);
    %% Read ARIMA Datas
    [ARIMA_Vir] = xlsread('ARIMA_Vir.xlsx', i);
    for j=1:14
       for k=1:8
          result(j, k) = SIS_Vir(j, k) + ARIMA_Vir(j, k);
       end
    end
    xlswrite('Final_Vir.xlsx', result, i);
end

for i=1:wes_size
    result = zeros(14, 8);
   %% Read SIS Datas
    [SIS_Wes] = xlsread('SIS_Wes.xlsx', i);
    %% Read ARIMA Datas
    [ARIMA_Wes] = xlsread('ARIMA_Wes.xlsx', i);
    for j=1:14
       for k=1:8
          result(j, k) = SIS_Wes(j, k) + ARIMA_Wes(j, k);
       end
    end
    xlswrite('Final_Wes.xlsx', result, i);
end
