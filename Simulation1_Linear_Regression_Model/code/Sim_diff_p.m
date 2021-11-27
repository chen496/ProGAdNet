clear;
n=150;
p=200;
k=16;
kc=8;
nvar=0.1;
nstd=sqrt(nvar);
% Nvar=[0.01,0.05,0.1,0.5,1];
 P=[500,800,1000,1500,2000];
%N=[80,100,150,200,250,300];
nrepeat=50; 
for T=1:5 % T=1,2,3,4,5 means N is 80,100,150,200,250,300
path_data=['C:\Users\Administrator\Desktop\Simulation I Linear Regression Model\data_p\k',num2str(T)];
mkdir(path_data)
p=P(T);
s=zeros(nrepeat ,6);
beta1_sst=zeros(k,nrepeat);
beta2_sst=zeros(k+kc/2,nrepeat);
del_beta_sst=zeros(k+kc/2,nrepeat);
time_p=zeros(nrepeat,1);

    for t=1:nrepeat  %%%nrepeat=50 means run 50 rounds of simulation
         %%%% generate beta1 and beta2 %%%%
        bmin=0.5;
        b1=[bmin+rand(k/2,1); -bmin-rand(k/2,1)];
        b1=b1(randperm(k));
        for i=1:kc/2
            temp=2*rand(1)-1;
            if temp>0
                b2(i)=temp+bmin;
            else 
                b2(i)=temp-bmin;
            end
        end
        temp=b1;
        temp(k-kc/2+1:k)=0;
        b2=[temp; b2'];
        
        %%%% generate data %%%%
        x1=randn(n,p);
        x2=randn(n,p);
        y1=x1(:,1:k)*b1+nstd*randn(n,1);
        y2=x2(:,1:k+kc/2)*b2+nstd*randn(n,1);
        
        %%%% save beta1 and beta2  %%%%
        beta1_sst(:,t)=b1;
        beta2_sst(:,t)=b2;
        del_beta_sst(:,t)=b2-[b1;zeros(kc/2,1)];
        clear b1;
        clear b2;
        clear temp;

        %%%%%ProGAdNet
        nstep1=20;
        nstep2=8;
        threshold=1e-5;
        kfolds=5; %%%% 5-folds cross-validation
        [lambda1,lambda2_mat,twoSE_step1,twoSE_step2,best_point,best_step1,best_step2,CVmean] = cross_validation_ProGAdNet(y1,x1,y2,x2,nstep1,nstep2,kfolds);
        %%%% choose the 2_Sd position
        plambda1_2se =lambda1(twoSE_step1);
        plambda2_2se = lambda2_mat(twoSE_step1,twoSE_step2);
        tic;
        %%%% solve the problem when lambda1 and lambda2 are the optimal values
        [b1hat, b2hat, fvalue]=single_problem(y1,x1,y2,x2,plambda1_2se,plambda2_2se);
        time_p(t)=toc;

        b1pd=length(find(b1hat(1:k)~=0))/k;
        temp=b1hat(k+1:end);
        b1fdr=length(find(temp~=0))/length(find(b1hat~=0));

        temp=[b2hat(1:k-kc/2); b2hat(k+1:k+kc/2)];
        b2pd=length(find(temp~=0))/k;
        temp1=[b2hat(k-kc/2+1:k); b2hat(k+kc/2+1:end)];
        b2fdr=length(find(temp1~=0))/length(find(b2hat~=0));

        deltab=b2hat-b1hat;
        temp=deltab(k-kc/2+1:k+kc/2);
        dbpd=length(find(temp~=0))/kc;
        temp1=[deltab(1:k-kc/2); deltab(k+kc/2+1:end)];
        dbfdr=length(find(temp1~=0))/length(find(deltab~=0));
         
        % ppd_fdr is the power of detection and false discovery rate of ProxGAdNet
        ppd_fdr=[b1pd b1fdr; b2pd b2fdr; dbpd dbfdr];
        % gpd_fdr is the power of detection and false discovery rate of glmnet(lasso)
         ppd_fdr

        s(t,:)=[b1pd b1fdr b2pd b2fdr dbpd dbfdr];
        %%%save data for lqa
        %combind the data, the firt column is y
        data=[[y1;y2],[x1;x2]];
        csvwrite([path_data,'\sim_data',num2str(t),'.csv'],data);
        csvwrite([path_data,'\lambda1_',num2str(t),'.csv'],lambda1');
        csvwrite([path_data,'\lambda2_',num2str(t),'.csv'],lambda2_mat);
        
    end

     
    
      csvwrite([path_data,'\n=',num2str(n),'_p=',num2str(p),'_var=',num2str(nvar),'.csv'],s);
      csvwrite([path_data,'\sim_beta1_',num2str(T),'.csv'],beta1_sst);
      csvwrite([path_data,'\sim_beta2_',num2str(T),'.csv'],beta2_sst);
      csvwrite([path_data,'\sim_time_',num2str(T),'.csv'],time_p );

end
