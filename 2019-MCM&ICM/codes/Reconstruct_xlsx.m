%% Reconstruct Part1 result
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

%% Then read final result
ohi_result = zeros(ohi_size, 14);
ken_result = zeros(ken_size, 14);
ten_result = zeros(ten_size, 14);
vir_result = zeros(vir_size, 14);
wes_result = zeros(wes_size, 14);

for i=1:ohi_size
    ohi = xlsread('Final_Ohi.xlsx', i);
    target = ohi(:, 8);
    ohi_result(i, :) = target';
end

for i=1:ken_size
    ken = xlsread('Final_Ken.xlsx', i);
    target = ken(:, 8);
    ken_result(i, :) = target';
end

for i=1:ten_size
    ten = xlsread('Final_Pen.xlsx', i);
    target = ten(:, 8);
    ten_result(i, :) = target';
end

for i=1:vir_size
    vir = xlsread('Final_Vir.xlsx', i);
    target = vir(:, 8);
    vir_result(i, :) = target';
end

for i=1:wes_size
    wes = xlsread('Final_Wes.xlsx', i);
    target = wes(:, 8);
    wes_result(i, :) = target';
end

xlswrite('Rebuild_Ohi.xlsx', ohi_result);
xlswrite('Rebuild_Ken.xlsx', ken_result);
xlswrite('Rebuild_Pen.xlsx', ten_result);
xlswrite('Rebuild_Vir.xlsx', vir_result);
xlswrite('Rebuild_Wes.xlsx', wes_result);


%% Draw heroin's graph
plot(1:vir_size, vir_result(:,14)', 'r-')
title('Drug Type: Heroin  State: Virginia');
xlabel('County Index');