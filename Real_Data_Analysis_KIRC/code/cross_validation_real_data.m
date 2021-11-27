function [lambda1,lambda2_mat,twoSE_step1,twoSE_step2,best_point,best_step1,best_step2,CVmeanMatrix] = cross_validation_real_data(y1,x1,y2,x2,STEP1,STEP2,num_folds)

[m,n] = size(x1);

% get the start point of lambda1(lambda1_max)
temp=[x1'*y1; x2'*y2];
temp=abs(temp);
lambda1_max=max(temp);

CVmean=zeros(STEP1,STEP2);
CVstderr=zeros(STEP1,STEP2);
lambda2_mat=zeros(STEP1,STEP2);


%caculate all lambda1(lambda1max to lambda1min)
lambda1_min=lambda1_max/1000;
temp=(log(lambda1_max)-log(lambda1_min))/(STEP1-1);
lambda1_log=log(lambda1_max):-temp:log(lambda1_min);
lambda1=exp(lambda1_log);
 
warmstart_b1=zeros(n,1);
warmstart_b2=zeros(n,1);

b1_mat=zeros(STEP1,STEP2,num_folds,n);
b2_mat=zeros(STEP1,STEP2,num_folds,n);

indices1=crossvalind('Kfold',m,num_folds);
% first loop: lambda1
for step1=1:STEP1

 %caculate all lambda2 given a specific lambda1
 % solve the upper bound of lambda2 and set it equals lambda2_max
    tempy=[y1;y2];
    tempx=[x1;x2];
    beq=lassofista(tempx, tempy, lambda1(step1));

    clear tempy; 
    clear tempx;
    clear fit;
    
    %lambda2_max = bound_solver(y1,x1,y2,x2,temp_index,lambda1);
    temp1=x1'*(y1-x1*beq);
    temp1=sqrt(temp1'*temp1);
    temp2=x2'*(y2-x2*beq);
    temp2=sqrt(temp2'*temp2);
    lambda2_max= lambda1(step1)+2*max([temp1 temp2]);
    
    %caculate all lambda2(lambda2max to lambda2min)
    lambda2_min=lambda2_max/1000;
%     temp=(log(lambda2_max)-log(lambda2_min))/(STEP2-1);
%     lambda2_log=log(lambda2_max):-temp:log(lambda2_min);
    %%%%In this problem, for BRCA data, we found the bound of lambda2_max
    %%%%is very big,so we divided it by 40.
    temp=(log(lambda2_max/40)-log(lambda2_min))/(STEP2-1);
    lambda2_log=log(lambda2_max/40):-temp:log(lambda2_min);
    
    lambda2_mat(step1,:)=exp(lambda2_log);
    
   
    % second loop: lambda2
    for step2 = 1:STEP2
        
        lambda2 =lambda2_mat(step1,step2); 
        pe=zeros(num_folds,1);
        for k=1:num_folds;
            x1_testindex = (indices1 == k);
            x1_trainindex = ~x1_testindex;
            x1_train=x1(x1_trainindex,:);
            y1_train=y1(x1_trainindex,:);
            x1_test=x1(x1_testindex,:);
            y1_test=y1(x1_testindex,:);
         
            x2_train=x2(x1_trainindex,:);
            y2_train=y2(x1_trainindex,:);
            x2_test=x2(x1_testindex,:);
            y2_test=y2(x1_testindex,:);

            % solve single problem:
            % argmin |y1-x1*b1|^2+|y2-x2*b2|^2+lambda1*(|b1|+|b2|)+lambda2*|b1-b2|
            % with fixed lambda1 and lambda2
            if  step1~=1
            warmstart_b1=reshape(b1_mat(step1-1,step2,k,:),n,1);
            warmstart_b2=reshape(b2_mat(step1-1,step2,k,:),n,1);
            end
            [b1, b2] = single_problem(y1_train,x1_train,y2_train,x2_train,lambda1(step1),lambda2,warmstart_b1,warmstart_b2);
       
            b1_mat(step1,step2,k,:)=b1;
            b2_mat(step1,step2,k,:)=b2;
            
            %tempmean(k)=val_f(b1,b2,y1_test, x1_test, y2_test, x2_test);%¼ÆËãmean square 
            temp=y1_test-x1_test*b1;
            pe(k)=temp'*temp;
            temp=y2_test-x2_test*b2;
            pe(k)=pe(k)+temp'*temp;
        end
        warmstart_b1=b1;
        warmstart_b2=b2;
        CVmean(step1,step2)=mean(pe);  
        CVstderr(step1,step2)=std(pe);
        clear pe;
     end
    
   
    
end

%find the minimum cross-validation
CVmeanmin=min(min(CVmean));
best_point=find(CVmean==CVmeanmin,1);
[best_step1,best_step2]=ind2sub(size(CVmean), best_point);

%find the minimum cross-validation
pestderr=CVstderr(best_step1, best_step2);
A1=CVmean(1:(best_step1),1:(best_step2));
 z=min(A1((A1>CVmeanmin+2*pestderr)));
[a,b]=ind2sub(size(A1), find(A1==z));

index=find(a==min(a));
twoSE_step1=min(min(a(index)));
twoSE_step2=min(b(index));

% save the error of cross-validation
CVmeanMatrix=CVmean;
        
        
        
