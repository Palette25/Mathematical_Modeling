%% Recursive Least squares - �ݹ���С���˷���ⳬ�����Է�������ƽ� %%
[A, b] = Generate();
maxError = 10e-5;
precision = zeros(1000, 1);
x0 = rand(10, 1); %% ���������ʼȨֵ����x0
P0 = 10e6 * eye(10); %% ������ʼ�ݹ����P0
Q0 = 0;
con = 0;
param = 1;
conFlag = false;
I = eye(10);
for step=1:1000
   temp = x0;
   Q0 = P0*(A(step,:))' / (param+A(step,:)*P0*(A(step,:))');
   P0 = (I - Q0*A(step,:))*P0/param;
   x0 = x0 + Q0*(b(step) - A(step,:)*x0);
   precision(step) = norm(x0 - temp);
   if precision(step) <= maxError && ~conFlag
      con = step;
      conFlag = true;
   end
end
plot(1:1000, precision, 'r-');
ylabel('Convergence Precision');
xlabel(['The Shortest Convergence steps: ', num2str(con), ' steps']);
title('Recursive Least Square Method');