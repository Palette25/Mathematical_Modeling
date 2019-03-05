%% Use PLS methods to decide the weight of selected five factors and Part1 values

%% Step 1. Read in five factors sequence and Part1 result
acs_10 = xlsread("ACS_10_5YR_DP02_with_ann.xlsx");
acs_11 = xlsread("ACS_11_5YR_DP02_with_ann.xlsx");
acs_12 = xlsread("ACS_12_5YR_DP02_with_ann.xlsx");
acs_13 = xlsread("ACS_13_5YR_DP02_with_ann.xlsx");
acs_14 = xlsread("ACS_14_5YR_DP02_with_ann.xlsx");
acs_15 = xlsread("ACS_15_5YR_DP02_with_ann.xlsx");
acs_16 = xlsread("ACS_16_5YR_DP02_with_ann.xlsx");

[~,~,nflis] = xlsread('nflis.xlsx', 'Data');
nflis(1,:) = [];

[~, meta] = xlsread('ACS_10_5YR_DP02_metadata.xlsx');
meta(1,:) = []; meta(1,:) = []; meta(1,:) = [];

%% Get origin county datas
[id_1, ohi] = xlsread('Ohio.xlsx');
[id_2, ken] = xlsread('Kentucky.xlsx');
[id_3, ten] = xlsread('Pennsylvania.xlsx');
[~, vir] = xlsread('Virginia.xlsx');
[~, wes] = xlsread('West Virginia.xlsx');

id_2(:,2) = [];
id_4 = vir(:,1); id_4(1,:) = []; id_4(1,:) = [];
id_5 = wes(:,1); id_5(1,:) = []; id_5(1,:) = [];

%%Base on the county size
ohi_size = size(id_1, 1); ken_size = size(id_2, 1);
ten_size = size(id_3, 1); vir_size = size(id_4, 1);
wes_size = size(id_5, 1);

map_2 = zeros(1000, 1);
for i=1:ken_size
   map_2(id_2(i)) = i;
end

map_4 = zeros(1000, 1);
for i=1:vir_size
   map_4(str2num(char(id_4(i)))) = i;
end

%% Record five states county's total drug report
ohi_store = zeros(ohi_size, 7);
ken_store = zeros(ken_size, 7);
ten_store = zeros(ten_size, 7);
vir_store = zeros(vir_size, 7);
wes_store = zeros(wes_size, 7);

for i=1:size(nflis, 1)
    year = cell2mat(nflis(i, 1)) - 2010 + 1;
    state_str = char(nflis(i, 2));
    county_id = str2num(cell2mat(nflis(i, 5)));
    report_num = cell2mat(nflis(i, 9));
    
    switch state_str
        case 'VA'
            if map_4(county_id) > 0
                vir_store(map_4(county_id), year) = report_num;
            end
        case 'OH'
            ohi_store(round(county_id/2), year) = report_num;
        case 'PA'
            ten_store(round(county_id/2), year) = report_num;
        case 'KY'
            ken_store(map_2(county_id), year) = report_num;
        case 'WV'
            wes_store(round(county_id/2), year) = report_num;
    end
end

%% Get origin all kinds drug reports of every county's 2010-2016 col-matrix
origin_result = zeros(7, 5);

for i=1:ken_size
    for j=1:7
       origin_result(j, 1) = origin_result(j, 1) + ken_store(i, j); 
    end
end

for i=1:ohi_size
    for j=1:7
       origin_result(j, 2) = origin_result(j, 2) + ohi_store(i, j); 
    end
end

for i=1:ten_size
    for j=1:7
       origin_result(j, 3) = origin_result(j, 3) + ten_store(i, j); 
    end
end

for i=1:vir_size
    for j=1:7
       origin_result(j, 4) = origin_result(j, 4) + vir_store(i, j); 
    end
end

for i=1:wes_size
    for j=1:7
       origin_result(j, 5) = origin_result(j, 5) + wes_store(i, j); 
    end
end

%% Get five factors' report sequences
target_factors_id = [10,20,60,69,128];
target_factors_val = zeros(7, 5, 5);

for i=1:5
   col = (target_factors_id(i)-1) * 4 + 3;
   sum = 0;
   for countyIndex=1:463
        statics = [acs_10(countyIndex, col);acs_11(countyIndex, col);acs_12(countyIndex, col);acs_13(countyIndex, col);acs_14(countyIndex, col);acs_15(countyIndex, col);acs_16(countyIndex, col)];
        if countyIndex <= ken_size
           target_factors_val(:, 1 ,i) = target_factors_val(:, 1 ,i) + statics;
        elseif countyIndex <= ken_size + ohi_size
            target_factors_val(:, 2 ,i) = target_factors_val(:, 2 ,i) + statics;
        elseif countyIndex <= ken_size + ohi_size + ten_size
            target_factors_val(:, 3 ,i) = target_factors_val(:, 3 ,i) + statics;
        elseif countyIndex <= ken_size + ohi_size + ten_size + vir_size
            target_factors_val(:, 4 ,i) = target_factors_val(:, 4 ,i) + statics;
        else
            target_factors_val(:, 5 ,i) = target_factors_val(:, 5 ,i) + statics;
        end
   end
end


%% Read Part1 results
sis_arima_result = zeros(7, 5);
sis_arima_result(1,:) = origin_result(1,:);

for i=1:ken_size
    result_ken = xlsread('Final_Ken.xlsx', i);
    for j=1:14
       for k=1:6
          if ~isnan(result_ken(j,k))
             sis_arima_result(k+1, 1) = sis_arima_result(k+1, 1) + result_ken(j, k);
          end
       end
    end
end

for i=1:ohi_size
    result_ohi = xlsread('Final_Ohi.xlsx', i);
    for j=1:14
       for k=1:6
          sis_arima_result(k+1, 2) = sis_arima_result(k+1, 2) + result_ohi(j, k);
       end
    end
end

for i=1:ten_size
    result_ten = xlsread('Final_Pen.xlsx', i);
    for j=1:14
       for k=1:6
          if ~isnan(result_ten(j, k))
            sis_arima_result(k+1, 3) = sis_arima_result(k+1, 3) + result_ten(j, k);
          end
       end
    end
end

for i=1:vir_size
    result_vir = xlsread('Final_Vir.xlsx', i);
    for j=1:14
       for k=1:6
          if ~isnan(result_vir(j, k))
            sis_arima_result(k+1, 4) = sis_arima_result(k+1, 4) + result_vir(j, k);
          end
       end
    end
end

for i=1:wes_size
    result_wes = xlsread('Final_Wes.xlsx', i);
    for j=1:14
       for k=1:6
          if ~isnan(result_wes(j, k))
             sis_arima_result(k+1, 5) = sis_arima_result(k+1, 5) + result_wes(j, k);
          end
       end
    end
end

%% Step 2. Combine the five factors sequence and arima-sis result sequence and origin sequence
result = zeros(7, 7);

for i=1:5
    for j=1:5
       result(:,j) = result(:,j) + target_factors_val(:,i,j); 
    end

    result(:,6) = result(:,6) + sis_arima_result(:, i);
    result(:,7) = result(:,7) + origin_result(:, i);
end

%% Begin PLS
mu = mean(result);
sig = std(result);

zs = zscore(result);

a = zs(:, 1:6);
b = zs(:, 7);

ncomp = 2;
[xl, yl, xs, ys, beta, pctvar, mse, stats] = plsregress(a, b, ncomp);
constr = cumsum(pctvar, 2);

n = size(a, 2);
m = size(b, 2);

res(1, :) = mu(n+1:end) + mu(1:n) ./ sig(1:n) * beta(2:end, :) .* sig(n+1:end);
res(2:n+1, :) = (1 ./ sig(1:n))' * sig(n+1:end) .* beta(2:end, :);

res = [];
%% Step 3.Use new model to predict sequence result
c = res(1);
w = res(2:end);

%% Read every county five factors datas
target_factors_county_val = zeros(7, 463, 5);

for i=1:5
   col = (target_factors_id(i)-1) * 4 + 3;
   sum = 0;
   for countyIndex=1:463
        statics = [acs_10(countyIndex, col);acs_11(countyIndex, col);acs_12(countyIndex, col);acs_13(countyIndex, col);acs_14(countyIndex, col);acs_15(countyIndex, col);acs_16(countyIndex, col)];
        target_factors_county_val(:, countyIndex ,i) = statics;
   end
end

%% Read every county ARIMA-SIS model result datas
origin_result = zeros(7, 463);

for i=1:ken_size
    for j=1:7
       origin_result(j, i) = origin_result(j, i) + ken_store(i, j); 
    end
end

for i=1:ohi_size
    for j=1:7
       origin_result(j, i+ken_size) = origin_result(j, i+ken_size) + ohi_store(i, j); 
    end
end

for i=1:ten_size
    for j=1:7
       origin_result(j, i+ken_size+ohi_size) = origin_result(j, i+ken_size+ohi_size) + ten_store(i, j); 
    end
end

for i=1:vir_size
    for j=1:7
       origin_result(j, i+ken_size+ohi_size+ten_size) = origin_result(j, i+ken_size+ohi_size+ten_size) + vir_store(i, j); 
    end
end

for i=1:wes_size
    for j=1:7
       origin_result(j, i+ken_size+ohi_size+ten_size+vir_size) = origin_result(j, i+ken_size+ohi_size+ten_size+vir_size) + wes_store(i, j); 
    end
end

sis_arima_result = zeros(7, 463);
sis_arima_result(1,:) = origin_result(1,:);

for i=1:ken_size
    result_ken = xlsread('Final_Ken.xlsx', i);
    for j=1:14
       for k=1:6
          if ~isnan(result_ken(j,k))
             sis_arima_result(k+1, i) = sis_arima_result(k+1, i) + result_ken(j, k);
          end
       end
    end
end

for i=1:ohi_size
    result_ohi = xlsread('Final_Ohi.xlsx', i);
    for j=1:14
       for k=1:6
          sis_arima_result(k+1, i+ken_size) = sis_arima_result(k+1, i+ken_size) + result_ohi(j, k);
       end
    end
end

for i=1:ten_size
    result_ten = xlsread('Final_Pen.xlsx', i);
    for j=1:14
       for k=1:6
          if ~isnan(result_ten(j, k))
            sis_arima_result(k+1, i+ken_size+ohi_size) = sis_arima_result(k+1, i+ken_size+ohi_size) + result_ten(j, k);
          end
       end
    end
end

for i=1:vir_size
    result_vir = xlsread('Final_Vir.xlsx', i);
    for j=1:14
       for k=1:6
          if ~isnan(result_vir(j, k))
            sis_arima_result(k+1, i+ken_size+ohi_size+ten_size) = sis_arima_result(k+1, i+ken_size+ohi_size+ten_size) + result_vir(j, k);
          end
       end
    end
end

for i=1:wes_size
    result_wes = xlsread('Final_Wes.xlsx', i);
    for j=1:14
       for k=1:6
          if ~isnan(result_wes(j, k))
             sis_arima_result(k+1, i+ken_size+ohi_size+vir_size+ten_size) = sis_arima_result(k+1, i+ken_size+ohi_size+vir_size+ten_size) + result_wes(j, k);
          end
       end
    end
end

%% Define result model with pls result
part2_result = zeros(7, 463);
for i=1:463
   for j=1:7
      temp = round(w(1) * target_factors_county_val(j, i, 1) + w(2) * target_factors_county_val(j, i, 2)+ w(3) * target_factors_county_val(j, i, 3) + w(4) * target_factors_county_val(j, i, 4)+ w(5) * target_factors_county_val(j, i, 5) + w(6) * sis_arima_result(j, i));
      if temp > 0
         part2_result(j, i) = temp;
      else
          part2_result(j, i) = 0;
      end
   end
end
