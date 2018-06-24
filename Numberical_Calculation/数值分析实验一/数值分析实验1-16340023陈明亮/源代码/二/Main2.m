%% ���õ�������ͼ������������Main2 %%

dim = 100; %%�ֶ�������Ĵ�С����Ϊplot������ʾ����ͼ
[A, b] = Generate(dim);
w = zeros(10, 1); %%SOR�������ɳ�����
Sp = zeros(10, 1); %%��Ӧ�ɳ����ӵ�SOR�����ٶ�
for i=1:10
   w(i) = 1 + (i-1)*0.1; 
end

%% ��ʼ���ã��������ߣ��˴����Էֱ��ֶ�ע�ͣ����ٵȴ�ʱ�䣩 %%
%%[timeJ, Ja, signJ] = Jacobi(A, b, dim);
%%[timeGS, GS, signG] = GaussSeidel(A, b, dim);
%%[timeS, SO, signS] = SOR(A, b, dim, w);
%%[timeCG, CG0, signC] = CG(A, b, dim);
for i=1:10
   [timeS, SO, signS] = SOR(A, b, dim, w(i));
   Sp(i) = signS;
end

plot(w, Sp, 'r-');
grid on;
xlabel('Relaxation factor w');
ylabel('Converence Speed');
title('Convergence graph of SOR with size = 100 and w from 1.0 to 1.9');