function [lambda2] = bound_solver(y1,x1,y2,x2,beta,lambda1)

res1=x1*beta-y1;
res2=x2*beta-y2;

[n p]=size(x1);

for i=1:p
    z1=x1(:,i)';
    z2=x2(:,i)';
    
    m1=z1*res1;
    m2=z2*res2;
    m(i)=max(abs(m1),abs(m2));
    
end

lambda2=lambda1+max(m);