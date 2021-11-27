function [BETA1, BETA2, BETA] = ss_my_la(y1,x1,y2,x2,SS_CYCLE,TILL_STEP)

stepsize = 0.7;

[m, n] = size(x1);
N =SS_CYCLE/2;

temp=0;
for i=1:n
    amk=max(abs(x1(:,i)'*y1),abs(x2(:,i)'*y2));
    if(temp<amk)
        temp=amk;
    end
end

lambda1=temp;
lambda1_max=2*lambda1;



for step=1:TILL_STEP
    lambda1 = lambda1_max*(stepsize^(step-1));
    
    beta1 = zeros(n,1);
    beta2 = zeros(n,1);
    beta = zeros(n,1);
    
    for i=1:N
        whole_index = randperm(m);
        index1 = whole_index(1:m/2);
        index2 = whole_index(m/2+1:m);
        x1_up = x1(index1,:);
        x1_down = x1(index2,:);
        x2_up = x2(index1,:);
        x2_down = x2(index2,:);
        y1_up = y1(index1,:);
        y1_down = y1(index2,:);
        y2_up = y2(index1,:);
        y2_down = y2(index2,:);
        
        [x1_up, x1_down] = centerize(x1_up,x1_down);
        [x1_up, x1_down] = normalize(x1_up,x1_down);
        [x2_up, x2_down] = centerize(x2_up,x2_down);
        [x2_up, x2_down] = normalize(x2_up,x2_down);
        [y1_up, y1_down] = centerize(y1_up,y1_down);
        [y1_up, y1_down] = normalize(y1_up,y1_down);
        [y2_up, y2_down] = centerize(y2_up,y2_down);
        [y2_up, y2_down] = normalize(y2_up,y2_down);
        
        [tempp_up] = single_lasso(x1_up,y1_up,lambda1);
        [tempp_down] = single_lasso(x1_down,y1_down,lambda1);
        [tempq_up] = single_lasso(x2_up,y2_up,lambda1);
        [tempq_down] = single_lasso(x2_down,y2_down,lambda1);
        
        beta1 = beta1 + count_freq(tempp_up)+count_freq(tempp_down);
        beta2 = beta2 + count_freq(tempq_up)+count_freq(tempq_down);
        beta = beta + count_freq(tempp_up-tempq_up) + count_freq(tempp_down-tempq_down);
    end
    
    % store in 3-dim matrix: prediction_result(bi,lambda1,lambda2)
    BETA1(:,step)=beta1;
    BETA2(:,step)=beta2;
    BETA(:,step)=beta;
    
end


