function b = lassofista(x, y, lambda,warmstart_b)
%y: n x 1 vector, x: n x p matrix, lambda>0
%solve the problem min |y-xb|^2+lambda*|b|_1

tol=1e-5;
MAX_iter=1000;

xtx=x'*x;
xty=x'*y;
s=0.5/trace(xtx);
lambdas=lambda*s;

p=length(x(1,:));
if nargin<4
b=zeros(p,1);
else b=warmstart_b;
end
btemp=zeros(p,1);
b_1=btemp;
iter=0;
error1=1; error2=1;
fstop=0;
fobj_1=0;
while((fstop==0 | error2>tol) & iter<MAX_iter)
      
    btemp = b+(b-b_1)*iter/(iter+3);
    btemp=b;
    b_1=b;
    
    v=btemp-2*s*(xtx*btemp-xty);
    b=max(lambdas,v)+min(-lambdas,v);

    
    if fstop==0
        temp=y-x*b;
        fobj=temp'*temp+lambda*sum(abs(b));
        error1=abs(fobj-fobj_1)/(1+fobj_1);
        if error1<tol
            fstop=1;
            %iter_fstop=iter;
        end
        fobj_1=fobj;
    end
    
    temp=b-b_1;
    error2=sqrt(temp'*temp)/(1+sqrt(b_1'*b_1));
    
    iter=iter+1;
end

