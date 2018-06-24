%% 简化牛顿法逼近数值的平方根，输出收敛精度 %%
function [precision, con] = SimplifiedNewTon(mode, maxError)
result = sqrt(115);
precision = zeros(1000, 1);
step = 0;
conFlag = false;
x0 = 10;
tic;
if mode
    time0 = toc;
    while time0 <= 0.01
        temp0 = round(time0, 6);
        precision(round(temp0*10e4 + 1)) = abs(x0 - (x0*x0-115)/20 - result);
        if(precision(round(temp0*10e4 + 1)) <= maxError && ~conFlag)
            con = sprintf('%.6f', time0);
            conFlag = true;
        end
        x0 = x0 - (x0*x0-115)/20;
        time0 = toc;
    end
else
   for i=1:1000
      temp = x0 - (x0*x0-115)/20;
      precision(step+1) = abs(result - temp);
      if(precision(step+1) <= maxError && ~conFlag)
        con = step;
        conFlag = true;
      end
      x0 = temp;
      step = step + 1; 
   end 
end
end

