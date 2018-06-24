%% 弦截法逼近数值的平方根，输出收敛精度 %%
function [precision, con] = Secant(mode, maxError)
result = sqrt(115);
precision = zeros(1000, 1);
step = 0;
conFlag = false;
con = 0;
x0 = 10;
x1 = 10.5;
tic;
if mode
    time0 = toc;
    while time0 <= 0.01
        temp0 = round(time0, 6);
        temp = x1 - ((x1*x1-115)*(x1-x0)) / ((x1*x1-115) - (x0*x0-115));
        precision(round(temp0*10e4 + 1)) = abs(temp - result);
        if(precision(round(temp0*10e4 + 1)) <= maxError && ~conFlag)
            con = sprintf('%.6f', time0);
            conFlag = true;
            break;
        end
        x0 = x1;
        x1 = temp;
        time0 = toc;
    end
else
   for i=1:1000
      temp = x1 - ((x1*x1-115)*(x1-x0)) / ((x1*x1-115) - (x0*x0-115));
      precision(step+1) = abs(result - temp);
      if(precision(step+1) <= maxError && ~conFlag)
        con = step;
        conFlag = true;
        break;
      end
      x0 = x1;
      x1 = temp;
      step = step + 1; 
   end  
end
end

