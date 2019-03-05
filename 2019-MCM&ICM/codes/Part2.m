%% Get Coefficient of correlation and Significant difference between drugReport and social indicators.

%% Step 1. Read in ACS Datas and county drug reports number
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

index = 0;
correlation = zeros(149, 1);
T = zeros(149, 1);

for col = 3: 4: 598   %% differet social indicators.
    index = index + 1;
    for countyIndex = 1 : 463
       statics = [ acs_10(countyIndex, col),acs_11(countyIndex, col),acs_12(countyIndex, col),acs_13(countyIndex, col), acs_14(countyIndex, col), acs_15(countyIndex, col), acs_16(countyIndex, col)  ]; 
       drugReport = zeros(1, 7);
       if countyIndex <= ken_size
          drugReport = ken_store(countyIndex,:);
       elseif countyIndex <= ken_size + ohi_size
           drugReport = ohi_store(countyIndex-ken_size,:);
       elseif countyIndex <= ken_size + ohi_size + ten_size
           drugReport = ten_store(countyIndex-ken_size-ohi_size, :);
       elseif countyIndex <= ken_size + ohi_size + ten_size + vir_size
           drugReport = vir_store(countyIndex-ken_size-ohi_size-ten_size, :);
       else
           drugReport = wes_store(countyIndex-ken_size-ohi_size-ten_size-vir_size, :);
       end
       
       meanStatics = mean(statics);
       meanDrugReport = mean(drugReport);
       
       temp1 = 0;
       temp2 = 0;
       temp3 = 0;
       
       for k = 1: 7
            temp1 = temp1 + (statics(k)-meanStatics)*(statics(k)-meanStatics);
            temp2 = temp2 + (drugReport(k)-meanDrugReport)*(drugReport(k)-meanDrugReport);
            temp3 = temp3 + (statics(k)-meanStatics)*(drugReport(k)-meanDrugReport);
       end
       
       corr = temp3 / (sqrt(temp1*temp2));
       if ~isnan(corr)
           correlation(index) = corr + correlation(index);
           T(index) = correlation(index)*sqrt(7-2)/sqrt(1-correlation(index)) + T(index);
       end 
    end
    correlation(index) = abs(correlation(index));
end

t_index = [];
for i=1:149
    t_index = [t_index;i];
end

result = [];
for i=1:size(t_index, 1)
   result = [result;correlation(t_index(i))];
end

result = sort(result, 'descend');

resultIndex = [];
for i=1:30
    target = result(i);
    for j=1:size(t_index, 1)
       if correlation(t_index(j)) == target
           resultIndex = [resultIndex;t_index(j)]; 
           t_index(j, :) = [];
           break;
       end
    end
end

%% Step 2. Init all society's influence factors
factor_name = cell(149, 1);
index = 0;
for i=1:4:596
    index = index + 1;
    factor_name(index) = meta(i, 2);
end

name = cell(30, 1);
for i=1:30
   name(i) = factor_name(resultIndex(i));
end

