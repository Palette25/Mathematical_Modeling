%% ���ַ����������΢�ַ��̳�ֵ���� - Main�ű� %%
%% �������䣬�Լ��������� %%
a = 0;
b = 1;
h = 0.1;
y0 = sqrt(1+2*(0:h:b)); %% �������ԭ����ÿһ����
y0 = y0';
maxError = 10e-10; %% ���������趨

%% ���ø��ֽⷨ - ����ֵ�Ƚ� %%
%% 1.ǰ��ŷ���� %%
yf = ForwardEuler(a, b, h, 1);
grid on;
%% 2.����ŷ���� %%
yb = BackwardEuler(a, b, h, 1);
%% 3.���η� %%
ye = Echelon(a, b, h, 1);
%% 4.�Ľ�ŷ������ %%
yi = ImprovedEuler(a, b, h ,1);
%% �鿴�������� %%
plot(0:h:b, abs(yf-y0), 'r-', 0:h:b, abs(yb-y0), 'b-');
hold on;
plot(0:h:b, abs(ye-y0), 'g-', 0:h:b, abs(yi-y0), 'y-');
title('Four Methods Precision on Exact Solution');
ylabel('Convergence Precision');
xlabel('Steps, with step length: 0.1')
legend({'Forward Euler', 'Backward Euler', 'Echelon', 'Improved Euler'},'Location', 'NorthWest');