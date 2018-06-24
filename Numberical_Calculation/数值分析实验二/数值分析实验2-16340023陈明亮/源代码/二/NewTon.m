%% 牛顿法逼近数值的平方根，输出收敛精度 %%
function [precision, con] = NewTon(mode, maxError)
result = sqrt(115);
precision = zeros(1000, 1);
step = 0;
x0 = 10;
con = 0;
conFlag = false;
tic;
if(mode)
   time0 = toc;
    while time0 <= 0.01
        temp0 = round(time0, 6);
        precision(round(temp0*10e4 + 1)) = abs((x0 + 115/x0)/2 - result);
        if(precision(round(temp0*10e4 + 1)) <= maxError && ~conFlag)
            con = sprintf('%.6f', time0);
            conFlag = true;
        end
        x0 = (x0 + 115/x0)/2;
        time0 = toc;
    end
else
   for i = 1:1:1000
   temp = (x0 + 115/x0)/2;
   precision(step+1) = abs(temp - result);
   if(precision(step+1) <= maxError && ~conFlag)
      con = step;
      conFlag = true;
   end
   step = step + 1;
   x0 = temp;
   end
end
end
