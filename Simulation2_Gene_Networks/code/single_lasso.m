
function [beta] = single_lasso(x,y,lambda1)

ITER=1000;
ERR=1e-4;

[m, n] = size(x);

xtx = x'*x;
xty = x'*y;
B=diag(xtx);
C=-xty;

beta=zeros(n,1);

iter=1;
err=1;

while iter<ITER && err>ERR
    
    temp_beta=beta;
    
    for i=1:n
        
        A=xtx(i,:)*beta-B(i)*beta(i,1);
        p=A+C(i);
        beta(i,1)=(-max(p-lambda1,0)+max(-p-lambda1,0))/B(i);
        
    end
    
    err=norm(beta-temp_beta)/norm(beta);
    iter=iter+1;
end
