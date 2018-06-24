%% 1024����ٸ���Ҷ�任�㷨 - Matlabʵ�� %%
N = 1024;  %% ִ��1024��FFT
A1 = zeros(N, 1);
A2 = zeros(N, 1);
w = zeros(N/2, 1);
p = 10;

%% ��ȡ���ɵĲ��������źţ���ʱ������ %%
[signals, fre] = Generate1();

%% Matlab�Դ�����FFT %%
result0 = fft(signals, N)/N;
value0 = abs(result0); %% ��ֵ����
%% �㷨ʵ�� %%
%% ��ʼ��A1��w���� %%
for i0=1:N
   A1(i0) = signals(i0); 
end
for j=1:N/2
   w(j) = exp(-1i*2*pi*(j-1)/N);
end

%% ѭ������ %%
for q=1:p
   if mod(q, 2) == 1
	   for k=0:2^(p-q)-1
		   for j=0:2^(q-1)-1
			  A2(k*2^q+j+1) = A1(k*2^(q-1)+j+1) + A1(k*2^(q-1)+j+2^(p-1)+1);
			  A2(k*2^q+j+2^(q-1)+1) = (A1(k*2^(q-1)+j+1) - A1(k*2^(q-1)+j+2^(p-1)+1))*w(k*2^(q-1)+1);
		   end
	   end
   else
	  for k=0:2^(p-q)-1
		   for j=0:2^(q-1)-1
			  A1(k*2^q+j+1) = A2(k*2^(q-1)+j+1) + A2(k*2^(q-1)+j+2^(p-1)+1);
			  A1(k*2^q+j+2^(q-1)+1) = (A2(k*2^(q-1)+j+1) - A2(k*2^(q-1)+j+2^(p-1)+1))*w(k*2^(q-1)+1);
		   end
	   end
   end
   if q==p
	  break; 
   end
end
if mod(p, 2)==0
   A2(1:N) = A1(1:N); 
end
value = abs(A2);
%% Ƶ����� %%
stem(fre, 2*value0(1:ceil((N-1)/2)+1));
xlabel('Time');
title('1024 Fast Fuourier Transform - Original Time Signals');