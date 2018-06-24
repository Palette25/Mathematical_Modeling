%% ���ø��������������������Main1 %%

dim = [10, 50, 100, 200];
timeJ4 = zeros(4, 1); %%�ſ˱ȵ������Ĳ�ͬsize�����Ӧ����ʱ��
timeGS4 = zeros(4, 1); %%��˹���¶��������Ĳ�ͬsize�����Ӧ����ʱ��
timeS4 = zeros(4, 1); %%SOR���Ĳ�ͬsize�����Ӧ����ʱ��
timeCG4 = zeros(4, 1); %%CG���Ĳ�ͬsize�����Ӧ����ʱ��
timeC4 = zeros(4, 1); %%����Ԫ��ȥ���Ĳ�ͬsize�����Ӧ����ʱ��
timeG4 = zeros(4, 1); %%��˹��Ԫ���Ĳ�ͬsize�����Ӧ����ʱ��

%% ��ʼ���ã��������� %%
for i=1:4
    %% �˴�ΪʹJacobi������������������A��2D-A��Ϊ�Գ���������������� %%
    [A, b] = Generate(dim(i));
    [timeJ, Ja, signJ] = Jacobi(A, b, dim(i));
    timeJ4(i) = timeJ;
    [timeGS, GS, signG] = GaussSeidel(A, b, dim(i));
    timeGS4(i) = timeGS;
    [timeS, SO, signS] = SOR(A, b, dim(i), 1.3);
    timeS4(i) = timeS;
    [timeCG, CG0, signC] = CG(A, b, dim(i));
    timeCG4(i) = timeCG;
    [timeC, xC] = Column(A, b, dim(i));
    timeC4(i) = timeC;
    [timeG, xG] = Gauss(A, b, dim(i));
    timeG4(i) = timeG;
end

plot(dim, timeG4, 'r-', dim, timeC4, 'b-', dim, timeJ4, 'g-');
hold on;
plot(dim, timeGS4, 'y-', dim, timeS4, 'k-', dim, timeCG4, 'm-');
legend('Gauss', 'Column', 'Jacobi', 'Gauss-Seidel', 'SOR', 'CG');