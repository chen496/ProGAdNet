% x means beta1, y means beta2
function [x, y, tim] = single_problem(a,B,c,D,lambda1,lambda2,warmstart_b1,warmstart_b2)
% solve single problem:
% argmin |y1-x1*b1|^2+|y2-x2*b2|^2+lambda1*(|b1|+|b2|)+lambda2*|b1-b2|
% with fixed lambda1 and lambda2

%we can set a smaller THERS1 and THERS2(1e_5) in real data analysis
THERS1=1e-8;
THERS2=1e-8;
MAX_iter=3000;

BtB = B'*B;
DtD = D'*D;
Bta = B'*a;
Dtc = D'*c;

lambda_k=0.5/(trace(BtB)+trace(DtD));
[p, q] = size(B);

if nargin<7
    warmstart_b1=zeros(q,1);
    warmstart_b2=zeros(q,1);
end
 x=warmstart_b1;
 y=warmstart_b2;
 
x_fu = zeros(q,1);
y_fu = zeros(q,1);
Y_x = zeros(q,1);
Y_y = zeros(q,1);

error1=1; error2=1;
iter=0;
fstop=0;
tim0=0;
while((fstop==0 ||error2>THERS2)&& iter<MAX_iter)
    
    w_k = iter/(iter+3);
    Y_x = x + w_k*(x - x_fu);
    Y_y = y + w_k*(y - y_fu);
    
    v1 = Y_x-2*lambda_k*(BtB*Y_x-Bta);
    v2 = Y_y-2*lambda_k*(DtD*Y_y-Dtc);
    
    lambda1k = lambda_k*lambda1; lambda2k = lambda_k*lambda2;
    
    vplus = (v1+v2)/2; vminus = (v1-v2)/2;
    
    x11 = vplus + max(vminus,lambda2k) - max(-vminus,lambda2k);
    x22 = vplus - max(vminus,lambda2k) + max(-vminus,lambda2k);
    x2 = max(lambda1k,x11) - max(lambda1k,-x11);
    y2 = max(lambda1k,x22) - max(lambda1k,-x22);
    
    x_fu=x;
    y_fu=y;
    x=x2;
    y=y2;
    
    if fstop==0
        tim = norm(a-B*x)^2+norm(c-D*y)^2+lambda1*(norm(x,1)+norm(y,1))+lambda2*norm(x-y,1);
        error1=norm(tim-tim0)/(1+norm(tim0));
        tim0=tim;
    %    error1
        if error1<THERS1
            fstop=1;
            iterfstop=iter;
        end
    end
   
    temp1   = x-x_fu;
    temp2   = y-y_fu;
    error2  = sqrt(temp1'*temp1+temp2'*temp2);
    temp1   = 1+sqrt(x_fu'*x_fu+y_fu'*y_fu);
    error2  = error2/temp1;
   % error2 
    iter=iter+1;
    
end
clear iter
end

