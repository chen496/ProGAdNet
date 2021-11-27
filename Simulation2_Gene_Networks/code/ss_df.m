function [BETA1, BETA2, BETA] = ss_df(y1,x1,y2,x2,STEP,STEP2,SS_CYCLE)

% set up stepsize in lambda1 and lambda2 directions
stepsize = 0.7;
stepsize2 = 0.8;

[m, n] = size(x1);
N =SS_CYCLE/2;

% get the start point of lambda1(lambda1_max), by strong rules
temp=0;
for i=1:n
    amk=max(abs(x1(:,i)'*y1),abs(x2(:,i)'*y2));
    if(temp<amk)
        temp=amk;
    end
end

lambda1=temp;
lambda1_max=2*lambda1;


% first loop: lambda1
for step=1:STEP
    
    %step
    
    lambda1 = lambda1_max*(stepsize^(step-1));
    
    % solve the upper bound of lambda2 and set it equals lambda2_max
    temp_index = index_solver_prox(y1,x1,y2,x2,lambda1);
    lambda2_max = bound_solver(y1,x1,y2,x2,temp_index,lambda1);
    
    % second loop: lambda2
    for step2 = 1:STEP2
        
        lambda2 = lambda2_max*(stepsize2^(step2-1));
        beta1 = zeros(n,1);
        beta2 = zeros(n,1);
        beta = zeros(n,1);
        
        % third loop: split data by stability selection, and solve the problem
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
            
            % solve single problem:
            % argmin |y1-x1*b1|^2+|y2-x2*b2|^2+lambda1*(|b1|+|b2|)+lambda2*|b1-b2|
            % with fixed lambda1 and lambda2
            [tempp_up, tempq_up] = single_problem(y1_up,x1_up,y2_up,x2_up,lambda1,lambda2);
            
            % solve for the rest half data
            [tempp_down, tempq_down] = single_problem(y1_down,x1_down,y2_down,x2_down,lambda1,lambda2);
            
            % store the frequency of predicted column
            beta1 = beta1 + count_freq(tempp_up)+count_freq(tempp_down);
            beta2 = beta2 + count_freq(tempq_up)+count_freq(tempq_down);
            beta = beta + count_freq(tempp_up-tempq_up) + count_freq(tempp_down-tempq_down);
        end
        
        % store in 3-dim matrix: prediction_result(bi,lambda1,lambda2)
        BETA1(:,step2,step)=beta1;
        BETA2(:,step2,step)=beta2;
        BETA(:,step2,step)=beta;
    end
end

