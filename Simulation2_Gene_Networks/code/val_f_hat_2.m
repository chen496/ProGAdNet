function [ee] = val_f_hat_2(z1,y1,a,B,c,D,lambda)

ee = norm(a-B*y1)^2+norm(c-D*y1)^2 + 2*((B'*(B*y1)-B'*a)'*(z1-y1)+(D'*(D*y1)-D'*c)'*(z1-y1)) + norm(z1-y1)^2/lambda;