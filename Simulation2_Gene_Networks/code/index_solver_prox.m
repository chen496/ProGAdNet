function [return_beta] = index_solver_prox(xi1,Xi1,xi2,Xi2,lambda1)

THERS=5e-2;
error=1;
MAX_iter=1000;
iter=0;
beta=0.05;

a=xi1;
B=Xi1;
c=xi2;
D=Xi2;

[p, q] = size(Xi1);
x1_k=zeros(q,1);
x1_k_1=zeros(q,1);
lambda_k_1=1;

while (error>THERS && iter<MAX_iter)
    
    w_k= iter/(iter+3);  
    y1_k = x1_k+w_k*(x1_k-x1_k_1);
    lambda = lambda_k_1;
    
    while 1  
        v1 = y1_k-2*lambda*(B'*(B*y1_k)-B'*a+D'*(D*y1_k)-D'*c);
        lambda1k = 2*lambda*lambda1;   
        z1 = max(lambda1k,v1) + min(-lambda1k,v1);

        if val_f_2(z1,a,B,c,D)<=val_f_hat_2(z1,y1_k,a,B,c,D,lambda)
            break;
        end 
        lambda = beta * lambda;    
    end
    
    lambda_k = lambda; x1_k_p1=z1;
    
   tim(iter+1) = norm(a-B*x1_k)^2+norm(c-D*x1_k)^2+2*lambda1*norm(x1_k,1);
    
    if iter~=0    
        error = norm(tim(iter+1)-tim(iter));    
    end
    
    iter=iter+1;
    
    x1_k = x1_k_p1;
    x1_k_1 = x1_k;
   
end
return_beta = x1_k_p1;