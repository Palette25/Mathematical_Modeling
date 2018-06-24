%% 二分法逼近对应熟知的平方根，输出收敛精度 %%
function [precision, con] = Binary(mode, maxError)
result = sqrt(115);
precision = zeros(1000, 1);
con = 0;
step = 0;
conFlag = false;
x = [10;11];
tic
if(mode)
   time0 = toc;
    while time0 <= 0.01
        temp0 = round(time0, 6);
        precision(round(temp0*10e4 + 1)) = abs((x(1)+x(2))/2 - result);
        if(precision(round(temp0*10e4 + 1)) <= maxError && ~conFlag)
            con = sprintf('%.6f', time0);
            conFlag = true;
        end
        if (((x(1)+x(2))/2)^2 - 115)*(x(1)^2-115) < 0
            x(2) = (x(1)+x(2))/2;
        else
            x(1) = (x(1)+x(2))/2;
        end
        time0 = toc;
    end
else
   for i = 1:1:1000
   precision(step+1) = abs((x(1)+x(2))/2 - result);
   if(precision(step+1) <= maxError && ~conFlag)
      con = step;
      conFlag = true;
   end
   if (((x(1)+x(2))/2)^2 - 115)*(x(1)^2-115) < 0
        x(2) = (x(1)+x(2))/2;
   else
        x(1) = (x(1)+x(2))/2;
   end
   step = step + 1; 
   end
end
end

