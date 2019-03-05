%% Combining the county neighbor relationship between the five states in the United States
%% Build the SIS model to establish a spatial regional opioid drug propagation model

%% Step 1. Read in Five States' County neighbor relationship matrix
[id_1, ohi] = xlsread('Ohio.xlsx');
[id_2, ken] = xlsread('Kentucky.xlsx');
[id_3, ten] = xlsread('Pennsylvania.xlsx');
[~, vir] = xlsread('Virginia.xlsx');
[~, wes] = xlsread('West Virginia.xlsx');

id_2(:,2) = [];
id_4 = vir(:,1); id_4(1,:) = []; id_4(1,:) = [];
id_5 = wes(:,1); id_5(1,:) = []; id_5(1,:) = [];


%% Perform useless words substracting
ohi(:,1) = []; ohi(1,:) = [];
ken(:,1) = []; ken(1,:) = [];
ten(:,1) = []; ten(1,:) = [];
vir(:,1) = []; vir(1,:) = []; vir(1,:) = [];
wes(:,1) = []; wes(1,:) = []; wes(1,:) = [];

%% New every five states basic adjency matrix -- Base on the county size
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

ohi_adj = zeros(ohi_size, ohi_size);
ken_adj = zeros(ken_size, ken_size);
ten_adj = zeros(ten_size, ten_size);
vir_adj = zeros(vir_size, vir_size);
wes_adj = zeros(wes_size, wes_size);

for i=1:ohi_size
    row_index = round(id_1(i)/2);
    str = char(ohi(i));
    str_array = strsplit(str, ',');
    for j=1:size(str_array, 2)
        nei_char = char(str_array(j));
        neiID = str2num(nei_char);
        col_index = round(neiID/2);
        ohi_adj(row_index, col_index) = 1;
    end 
end

row_index = 0;
for i=1:ken_size
    row_index = row_index + 1;
    str = char(ken(i));
    str_array = strsplit(str, ',');
    for j=1:size(str_array, 2)
        nei_char = char(str_array(j));
        neiID = str2num(nei_char);
        col_index = map_2(neiID);
        ken_adj(row_index, col_index) = 1;
    end 
end

for i=1:ten_size
    temp = char(id_3(i));
    row_index = round(temp/2);
    str = char(ten(i));
    str_array = strsplit(str, '£¬');
    for j=1:size(str_array, 2)
        nei_char = char(str_array(j));
        neiID = str2num(nei_char);
        col_index = round(neiID/2);
        ten_adj(row_index, col_index) = 1;
    end 
end

row_index = 0;
for i=1:vir_size
    row_index = row_index + 1;
    str = char(vir(i));
    str_array = strsplit(str, '£¬');
    for j=1:size(str_array, 2)
        nei_char = char(str_array(j));
        neiID = str2num(nei_char);
        col_index = map_4(neiID);
        vir_adj(row_index, col_index) = 1;
    end 
end

for i=1:wes_size
    temp = char(id_5(i));
    temp = str2num(temp);
    row_index = round(temp/2);
    str = char(wes(i));
    str_array = strsplit(str, '£¬');
    for j=1:size(str_array, 2)
        nei_char = char(str_array(j));
        neiID = str2num(nei_char);
        col_index = round(neiID/2);
        wes_adj(row_index, col_index) = 1;
    end 
end

%% Step 2. Read in SyntheticOpioids and Heroin excel records, first consider its exploration between counties
BETA = [0.1, 0.2, 0.3];
GAMMA = [0.3, 0.2, 0.1];
[~, syn] = xlsread('SyntheticOpioids.xls');
[~, her] = xlsread('Heroin.xls');

%% Treat a county as a node, containing beta as opioid transforming rate
%% And gamma as opioid reports decreasing rate

%% Define Synthetic Opioids' transfering process between Counties' reports, beta and gamma matrix
ohi_syn = zeros(8, ohi_size, 4);
ken_syn = zeros(8, ken_size, 4);
ten_syn = zeros(8, ten_size, 4);
vir_syn = zeros(8, vir_size, 4);
wes_syn = zeros(8, wes_size, 4);

%% Define Heroin's transfering process between Counties' reports, beta and gamma matrix
ohi_her = zeros(8, ohi_size, 3);
ken_her = zeros(8, ken_size, 3);
ten_her = zeros(8, ten_size, 3);
vir_her = zeros(8, vir_size, 3);
wes_her = zeros(8, wes_size, 3);

%% Fill beta and gamma matrix using drug reports range threshold
syn(1,:) = [];
her(1,:) = [];
row_size = size(syn, 1);
row_size_1 = size(her, 1);
syn_drugs = {'Fentanyl';'Pethidine';'Propoxyphene';'Dextropropoxyphene';'Methadone';'Pentazocine';'Buprenorphine';'Nalbuphine';'Tramadol';'Remifentanil';'Butorphanol';'Mitragynine';'Levorphanol'};

for i=1:row_size
   year = str2num(char(syn(i, 1))) - 2010 + 1;
   state_str = char(syn(i, 2));
   county_id = str2num(char(syn(i, 5)));
   syn_kind = char(syn(i, 7));
   report_num = str2num(char(syn(i, 8)));
   beta = 0;
   gamma = 0;
   syn_id = 0;
   index = round(county_id/2);
   
   for tt=1:13
      if isequal(char(syn_drugs(tt)), syn_kind)
          syn_id = tt;
          break;
      end
   end
   
   if report_num < 10
       beta = BETA(1);
       gamma = GAMMA(1);
   elseif report_num < 30
       beta = BETA(2);
       gamma = GAMMA(2);
   else
       beta = BETA(3);
       gamma = GAMMA(3);
   end
   
   switch state_str
       case 'OH'
           ohi_syn(year, index, 1) = report_num;
           ohi_syn(year, index, 2) = beta;
           ohi_syn(year, index, 3) = gamma;
           ohi_syn(year, index, 4) = syn_id;
       case 'KY'
           ken_syn(year, map_2(county_id), 1) = report_num;
           ken_syn(year, map_2(county_id), 2) = beta;
           ken_syn(year, map_2(county_id), 3) = gamma;
           ken_syn(year, map_2(county_id), 4) = syn_id;
       case 'PA'
           ten_syn(year, index, 1) = report_num;
           ten_syn(year, index, 2) = beta;
           ten_syn(year, index, 3) = gamma;
           ten_syn(year, index, 4) = syn_id;
       case 'VA'
           vir_syn(year, map_4(county_id), 1) = report_num;
           vir_syn(year, map_4(county_id), 2) = beta;
           vir_syn(year, map_4(county_id), 3) = gamma;
           vir_syn(year, map_4(county_id), 4) = syn_id;
       case 'WV'
           wes_syn(year, index, 1) = report_num;
           wes_syn(year, index, 2) = beta;
           wes_syn(year, index, 3) = gamma;
           wes_syn(year, index, 4) = syn_id;
   end
end

for i=1:row_size_1
   year = str2num(char(her(i, 1))) - 2010 + 1;
   state_str = char(her(i, 2));
   county_id = str2num(char(her(i, 5)));
   report_num = str2num(char(her(i, 8)));
   beta = 0;
   gamma = 0;
   index = round(county_id/2);
   
   if report_num < 10
       beta = BETA(1);
       gamma = GAMMA(1);
   elseif report_num < 30
       beta = BETA(2);
       gamma = GAMMA(2);
   else
       beta = BETA(3);
       gamma = GAMMA(3);
   end
   
   switch state_str
       case 'OH'
           ohi_her(year, index, 1) = report_num;
           ohi_her(year, index, 2) = beta;
           ohi_her(year, index, 3) = gamma;
       case 'KY'
           ken_her(year, map_2(county_id), 1) = report_num;
           ken_her(year, map_2(county_id), 2) = beta;
           ken_her(year, map_2(county_id), 3) = gamma;
       case 'PA'
           ten_her(year, index, 1) = report_num;
           ten_her(year, index, 2) = beta;
           ten_her(year, index, 3) = gamma;
       case 'VA'
           if map_4(county_id) ~= 0
               vir_her(year, map_4(county_id), 1) = report_num;
               vir_her(year, map_4(county_id), 2) = beta;
               vir_her(year, map_4(county_id), 3) = gamma;
           end
       case 'WV'
           wes_her(year, index, 1) = report_num;
           wes_her(year, index, 2) = beta;
           wes_her(year, index, 3) = gamma;
   end
end

%% Step 3. Use Odinary Difference equation to forcast growing and transfering model -- SIS
ohi_syn_result = zeros(13, 8, ohi_size);
ken_syn_result = zeros(13, 8, ken_size);
ten_syn_result = zeros(13, 8, ten_size);
vir_syn_result = zeros(13, 8, vir_size);
wes_syn_result = zeros(13, 8, wes_size);

ohi_her_result = zeros(8, ohi_size);
ken_her_result = zeros(8, ken_size);
ten_her_result = zeros(8, ten_size);
vir_her_result = zeros(8, vir_size);
wes_her_result = zeros(8, wes_size);

%% For Synethic Opioids classification using SIS model forecasting
for i=1:8
   for j=1:ohi_size
      result_report_num = 0;
      src_syn_id = ohi_syn(i, j, 4);
      if src_syn_id == 0
          continue;
      end
      neigh_sum = 0;
      for k=1:ohi_size
         if src_syn_id == ohi_syn(i, k, 4)
             result_report_num = result_report_num + ohi_adj(j, k) * ohi_syn(i, k, 1);
         end
         if ohi_adj(j, k) == 1
            neigh_sum = neigh_sum + 1; 
         end
      end
      ohi_syn_result(src_syn_id, i, j) = round((round(ohi_syn(i, j, 2) * result_report_num - ohi_syn(i, j, 3) * ohi_syn(i, j, 1))) / neigh_sum);
      if ohi_syn_result(src_syn_id, i, j) < 0
          ohi_syn_result(src_syn_id, i, j) = 0;
      end 
   end
end

for i=1:8
   for j=1:ken_size
      result_report_num = 0;
      src_syn_id = ken_syn(i, j, 4);
      if src_syn_id == 0
          continue;
      end
      neigh_sum = 0;
      for k=1:ken_size
         if src_syn_id == ken_syn(i, k, 4)
             result_report_num = result_report_num + ken_adj(j, k) * ken_syn(i, k, 1);
         end
         if ken_adj(j, k) == 1
            neigh_sum = neigh_sum + 1; 
         end
      end
      ken_syn_result(src_syn_id, i, j) = round((round(ken_syn(i, j, 2) * result_report_num - ken_syn(i, j, 3) * ken_syn(i, j, 1))) / neigh_sum);
      if ken_syn_result(src_syn_id, i, j) < 0
          ken_syn_result(src_syn_id, i, j) = 0;
      end 
   end
end

for i=1:8
   for j=1:ten_size
      result_report_num = 0;
      src_syn_id = ten_syn(i, j, 4);
      if src_syn_id == 0
          continue;
      end
      neigh_sum = 0;
      for k=1:ten_size
         if src_syn_id == ten_syn(i, k, 4)
             result_report_num = result_report_num + ten_adj(j, k) * ten_syn(i, k, 1);
         end
         if ten_adj(j, k) == 1
            neigh_sum = neigh_sum + 1; 
         end
      end
      ten_syn_result(src_syn_id, i, j) = round((round(ten_syn(i, j, 2) * result_report_num - ten_syn(i, j, 3) * ten_syn(i, j, 1))) / neigh_sum);
      if ten_syn_result(src_syn_id, i, j) < 0
          ten_syn_result(src_syn_id, i, j) = 0;
      end 
   end
end

for i=1:8
   for j=1:vir_size
      result_report_num = 0;
      src_syn_id = vir_syn(i, j, 4);
      if src_syn_id == 0
          continue;
      end
      neigh_sum = 0;
      for k=1:vir_size
         if src_syn_id == vir_syn(i, k, 4)
             result_report_num = result_report_num + vir_adj(j, k) * vir_syn(i, k, 1);
         end
         if vir_adj(j, k) == 1
            neigh_sum = neigh_sum + 1; 
         end
      end
      vir_syn_result(src_syn_id, i, j) = round((round(vir_syn(i, j, 2) * result_report_num - vir_syn(i, j, 3) * vir_syn(i, j, 1))) / neigh_sum);
      if vir_syn_result(src_syn_id, i, j) < 0
          vir_syn_result(src_syn_id, i, j) = 0;
      end 
   end
end

for i=1:8
   for j=1:wes_size
      result_report_num = 0;
      src_syn_id = wes_syn(i, j, 4);
      if src_syn_id == 0
          continue;
      end
      neigh_sum = 0;
      for k=1:wes_size
         if src_syn_id == wes_syn(i, k, 4)
             result_report_num = result_report_num + wes_adj(j, k) * wes_syn(i, k, 1);
         end
         if wes_adj(j, k) == 1
            neigh_sum = neigh_sum + 1; 
         end
      end
      wes_syn_result(src_syn_id, i, j) = round((round(wes_syn(i, j, 2) * result_report_num - wes_syn(i, j, 3) * wes_syn(i, j, 1))) / neigh_sum);
      if wes_syn_result(src_syn_id, i, j) < 0
          wes_syn_result(src_syn_id, i, j) = 0;
      end 
   end
end

%% For Heroin classification using SIS model forecasting
for i=1:8
   for j=1:ohi_size
      result_report_num = 0;
      neigh_sum = 0;
      for k=1:ohi_size
         result_report_num = result_report_num + ohi_adj(j, k) * ohi_her(i, k, 1);
         if ohi_adj(j, k) == 1
            neigh_sum = neigh_sum + 1; 
         end
      end
      ohi_her_result(i, j) = round((round(ohi_her(i, j, 2) * result_report_num - ohi_her(i, j, 3) * ohi_her(i, j, 1))) / neigh_sum);
      if ohi_her_result(i, j) < 0
          ohi_her_result(i, j) = 0;
      end 
   end
end

for i=1:8
   for j=1:ken_size
      result_report_num = 0;
      neigh_sum = 0;
      for k=1:ken_size
         result_report_num = result_report_num + ken_adj(j, k) * ken_her(i, k, 1);
         if ken_adj(j, k) == 1
            neigh_sum = neigh_sum + 1; 
         end
      end
      ken_her_result(i, j) = round((round(ken_her(i, j, 2) * result_report_num - ken_her(i, j, 3) * ken_her(i, j, 1))) / neigh_sum);
      if ken_her_result(i, j) < 0
          ken_her_result(i, j) = 0;
      end 
   end
end

for i=1:8
   for j=1:ten_size
      result_report_num = 0;
      neigh_sum = 0;
      for k=1:ten_size
         result_report_num = result_report_num + ten_adj(j, k) * ten_her(i, k, 1);
         if ten_adj(j, k) == 1
            neigh_sum = neigh_sum + 1; 
         end
      end
      ten_her_result(i, j) = round((round(ten_her(i, j, 2) * result_report_num - ten_her(i, j, 3) * ten_her(i, j, 1))) / neigh_sum);
      if ten_her_result(i, j) < 0
          ten_her_result(i, j) = 0;
      end 
   end
end

for i=1:8
   for j=1:vir_size
      result_report_num = 0;
      neigh_sum = 0;
      for k=1:vir_size
         result_report_num = result_report_num + vir_adj(j, k) * vir_her(i, k, 1);
         if vir_adj(j, k) == 1
            neigh_sum = neigh_sum + 1; 
         end
      end
      vir_her_result(i, j) = round((round(vir_her(i, j, 2) * result_report_num - vir_her(i, j, 3) * vir_her(i, j, 1))) / neigh_sum);
      if vir_her_result(i, j) < 0
          vir_her_result(i, j) = 0;
      end 
   end
end

for i=1:8
   for j=1:wes_size
      result_report_num = 0;
      neigh_sum = 0;
      for k=1:wes_size
         result_report_num = result_report_num + wes_adj(j, k) * wes_her(i, k, 1);
         if wes_adj(j, k) == 1
            neigh_sum = neigh_sum + 1; 
         end
      end
      wes_her_result(i, j) = round((round(wes_her(i, j, 2) * result_report_num - wes_her(i, j, 3) * wes_her(i, j, 1))) / neigh_sum);
      if wes_her_result(i, j) < 0
          wes_her_result(i, j) = 0;
      end 
   end
end

%% Step 4. Output SIS Model's county opioids drug reports excel tables
for i=1:ohi_size
   temp = ohi_syn_result(:,:,i);
   tt = ohi_her_result(:,i);
   temp = [temp;tt'];
   xlswrite('SIS_Ohi.xlsx', temp, i);
end

for i=1:ken_size
   temp = ken_syn_result(:,:,i);
   tt = ken_her_result(:,i);
   temp = [temp;tt'];
   xlswrite('SIS_Ken.xlsx', temp, i);
end

for i=1:ten_size
   temp = ten_syn_result(:,:,i);
   tt = ten_her_result(:,i);
   temp = [temp;tt'];
   xlswrite('SIS_Pen.xlsx', temp, i);
end

for i=1:vir_size
   temp = vir_syn_result(:,:,i);
   tt = vir_her_result(:,i);
   temp = [temp;tt'];
   xlswrite('SIS_Vir.xlsx', temp, i);
end

for i=1:wes_size
   temp = wes_syn_result(:,:,i);
   tt = wes_her_result(:,i);
   temp = [temp;tt'];
   xlswrite('SIS_Wes.xlsx', temp, i);
end