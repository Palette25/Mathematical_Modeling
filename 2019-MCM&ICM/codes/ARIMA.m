%% Create ARIMA Model to analyse county's drug report growing trends with time sequences
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

%% Step 1. Collect Synethic Opidiods and Heroin's reports number in counties
[~, syn] = xlsread('SyntheticOpioids.xls');
[~, her] = xlsread('Heroin.xls');

ohi_syn = zeros(13, 8, ohi_size);
ken_syn = zeros(13, 8, ken_size);
ten_syn = zeros(13, 8, ten_size);
vir_syn = zeros(13, 8, vir_size);
wes_syn = zeros(13, 8, wes_size);

ohi_her = zeros(8, ohi_size);
ken_her = zeros(8, ken_size);
ten_her = zeros(8, ten_size);
vir_her = zeros(8, vir_size);
wes_her = zeros(8, wes_size);

%% Read in map_2 and map_4
ken_size = size(id_2, 1);
vir_size = size(id_4, 1);

map_2 = zeros(1000, 1);
for i=1:ken_size
   map_2(id_2(i)) = i;
end

map_4 = zeros(1000, 1);
for i=1:vir_size
   map_4(str2num(char(id_4(i)))) = i;
end

%% Clear useless datas and define different syn-drugs id
syn(1,:) = [];
her(1,:) = [];
row_size = size(syn, 1);
row_size_1 = size(her, 1);
syn_drugs = {'Fentanyl';'Pethidine';'Propoxyphene';'Dextropropoxyphene';'Methadone';'Pentazocine';'Buprenorphine';'Nalbuphine';'Tramadol';'Remifentanil';'Butorphanol';'Mitragynine';'Levorphanol'};

for i=1:row_size
   year = str2num(char(syn(i, 1))) - 2010 + 1;
   state_str = char(syn(i, 2));
   county_id = str2num(char(syn(i, 5)));
   drug_kind = char(syn(i, 7));
   drug_id = 0;
   report_num = str2num(char(syn(i, 8)));
   index = round(county_id/2);
   
   for j=1:13
       if isequal(char(syn_drugs(j)), drug_kind)
          drug_id = j;
          break;
       end
   end
   
   switch state_str
       case 'OH'
           ohi_syn(drug_id, year, index) = report_num;
       case 'KY'
           ken_syn(drug_id, year, map_2(county_id)) = report_num;
       case 'PA'
           ten_syn(drug_id, year, index) = report_num;
       case 'VA'
           vir_syn(drug_id, year, map_4(county_id)) = report_num;
       case 'WV'
           wes_syn(drug_id, year, index) = report_num;
   end
end

for i=1:row_size_1
   year = str2num(char(syn(i, 1))) - 2010 + 1;
   state_str = char(syn(i, 2));
   county_id = str2num(char(syn(i, 5)));
   report_num = str2num(char(syn(i, 8)));
   index = round(county_id/2);
   
   switch state_str
       case 'OH'
           ohi_her(year, index) = report_num;
       case 'KY'
           ken_her(year, map_2(county_id)) = report_num;
       case 'PA'
           ten_her(year, index) = report_num;
       case 'VA'
           vir_her(year, map_4(county_id)) = report_num;
       case 'WV'
           wes_her(year, index) = report_num;
   end
end

%% Step 2. For five states, we are here to get sums of all ARIMA aic to decide best q and p
%% And build ARIMA Model
ohi_arima_predict = zeros(14, 8, ohi_size);
ken_arima_predict = zeros(14, 8, ken_size);
ten_arima_predict = zeros(14, 8, ten_size);
vir_arima_predict = zeros(14, 8, vir_size);
wes_arima_predict = zeros(14, 8, wes_size);

p = 1;
q = 1;
for k=1:ohi_size
   for t=1:14
      sequence = zeros(8, 1);
      if t < 14
        for v=1:8
           sequence(v) = ohi_syn(t, v, k);
        end
      else
        for v=1:8
           sequence(v) = ohi_her(v, k);
        end
      end
      z = iddata(sequence);
      model = armax(z, [p q]);
      sequence = [sequence;0];
      yp = predict(model, sequence, 1);
      for temp=1:9
         if yp(temp) < 0
            yp(temp) = 0; 
         end
      end
      for temp=2:9
         ohi_arima_predict(t, temp-1, k) = round(yp(temp)); 
      end
   end
end

for k=1:ken_size
   for t=1:14
      sequence = zeros(8, 1);
      if t < 14
        for v=1:8
           sequence(v) = ken_syn(t, v, k);
        end
      else
        for v=1:8
           sequence(v) = ken_her(v, k);
        end
      end
      z = iddata(sequence);
      model = armax(z, [p q]);
      sequence = [sequence;0];
      yp = predict(model, sequence, 1);
      for temp=1:9
         if yp(temp) < 0
            yp(temp) = 0; 
         end
      end
      for temp=2:9
         ken_arima_predict(t, temp-1, k) = round(yp(temp));
      end
   end
end

for k=1:ten_size
   for t=1:14
      sequence = zeros(8, 1);
      if t < 14
        for v=1:8
           sequence(v) = ten_syn(t, v, k);
        end
      else
        for v=1:8
           sequence(v) = ten_her(v, k);
        end
      end
      z = iddata(sequence);
      model = armax(z, [p q]);
      sequence = [sequence;0];
      yp = predict(model, sequence, 1);
      for temp=1:9
         if yp(temp) < 0
            yp(temp) = 0; 
         end
      end
      for temp=2:9
         ten_arima_predict(t, temp-1, k) = round(yp(temp)); 
      end
   end
end

for k=1:vir_size
   for t=1:14
      sequence = zeros(8, 1);
      if t < 14
        for v=1:8
           sequence(v) = vir_syn(t, v, k);
        end
      else
        for v=1:8
           sequence(v) = vir_her(v, k);
        end
      end
      z = iddata(sequence);
      model = armax(z, [p q]);
      sequence = [sequence;0];
      yp = predict(model, sequence, 1);
      for temp=1:9
         if yp(temp) < 0
            yp(temp) = 0; 
         end
      end
      for temp=2:9
         vir_arima_predict(t, temp-1, k) = round(yp(temp));
      end
   end
end

for k=1:wes_size
   for t=1:14
      sequence = zeros(8, 1);
      if t < 14
        for v=1:8
           sequence(v) = wes_syn(t, v, k);
        end
      else
        for v=1:8
           sequence(v) = wes_her(v, k);
        end
      end
      z = iddata(sequence);
      model = armax(z, [p q]);
      sequence = [sequence;0];
      yp = predict(model, sequence, 1);
      for temp=1:9
         if yp(temp) < 0
            yp(temp) = 0; 
         end
      end
      for temp=2:9
         wes_arima_predict(t, temp-1, k) = round(yp(temp));
      end
   end
end

%% Step 3. Ouput ARIMA Model predict sequence to excel
for i=1:ohi_size
   temp = ohi_arima_predict(:,:,i);
   xlswrite('ARIMA_Ohi.xlsx', temp, i);
end

for i=1:ken_size
   temp = ken_arima_predict(:,:,i);
   xlswrite('ARIMA_Ken.xlsx', temp, i);
end

for i=1:ten_size
   temp = ten_arima_predict(:,:,i);
   xlswrite('ARIMA_Pen.xlsx', temp, i);
end

for i=1:vir_size
   temp = vir_arima_predict(:,:,i);
   xlswrite('ARIMA_Vir.xlsx', temp, i);
end

for i=1:wes_size
   temp = wes_arima_predict(:,:,i);
   xlswrite('ARIMA_Wes.xlsx', temp, i);
end