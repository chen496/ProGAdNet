function [ee] = val_f_2(x1,a,B,c,D)
   
ee = norm(a-B*x1)^2+norm(c-D*x1)^2;
end