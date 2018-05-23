%% PageRank��Matlabʵ�ֳ��� %%
point = xlsread('data.xlsx'); %%����ڵ�߾���
size0 = 75888; 
store1 = sparse(1:size0, 1:size0, 0); %%ʹ��ϡ�����洢
link = zeros(size0, 1); 
H = sparse(1:size0, 1:size0, 0); 
m = size(point, 1);
Zero_c = zeros(size0, 1);
J = sparse(1:size0, 1:size0, 1);
a = 0.85;

for i=1:m
	link(point(i, 1)+1) = link(point(i, 1)+1) + 1;
end

for i=1:m
	if link(point(i, 1)+1) ~= 0
		H(point(i, 1)+1, point(i, 2)+1) =  1 / link(point(i, 1)+1);
	end
end


%%�ݷ���������%%
G = a*H' + J*((1-a)/size0);
x = ones(size0, 1)/size0;
R = zeros(size0, 1);
while norm(x - R) > 0.001
	R = x;
	x = G*x;
end
plot(1:size0, R', 'r-');