%%this code is for real data%%
%%n=72, p=4310%%
clear;
fprintf('Make sure the "KIRC_gene_exp_tumor.txt" and "KIRC_gene_exp_normal.txt" network is in the same path..\n\n');
%%please put the gene_exp_1.txt and gene_exp_2.txt into this fold%%
load KIRC_gene_exp_tumor.txt
load KIRC_gene_exp_normal.txt
X1 = KIRC_gene_exp_tumor';
X2 = KIRC_gene_exp_normal';

change_sst=zeros(4310,4310);
%%T means the Tth gene is y, the others are x %%
for T=1:4310

mkdir(['data/k',num2str(T)])
path_data=['data/k',num2str(T),'/'];
y1=X1(:,T);
y2=X2(:,T);
x1=X1(:,[1:T-1 (T+1):4310]);
x2=X2(:,[1:T-1 (T+1):4310]);

%%%%
[n,p]=size(x1);

%%%%%ProGAdNet
nstep1=20;
nstep2=8;
kfolds=5;
[lambda1,lambda2_mat,twoSE_step1,twoSE_step2,best_point,best_step1,best_step2,CVmean] = cross_validation_real_data(y1,x1,y2,x2,nstep1,nstep2,kfolds);

lambda1_2se =lambda1(twoSE_step1);
lambda2_2se = lambda2_mat(twoSE_step1,twoSE_step2);

csvwrite([path_data,'lambda1_',num2str(T),'.csv'],lambda1');
csvwrite([path_data,'lambda2_',num2str(T),'.csv'],lambda2_mat);
csvwrite([path_data,'lambda1_lambda2_2se_',num2str(T),'.csv'],[lambda1_2se lambda2_2se]);
csvwrite([path_data,'CVmean_',num2str(T),'.csv'],CVmean)

change=zeros(4310,1);
for i=1:50
whole_index=randperm(n);
n1=floor(n/2);
index_up=whole_index(1:n1);
index_down=whole_index(n1/2+1:n);

x1_up=x1(index_up,:);
x1_down=x1(index_down,:);
y1_up=y1(index_up,:);
y1_down=y1(index_down,:);

x2_up=x2(index_up,:);
x2_down=x2(index_down,:);
y2_up=y2(index_up,:);
y2_down=y2(index_down,:);


[b1hat, b2hat, ~]=single_problem(y1_up,x1_up,y2_up,x2_up,lambda1_2se,lambda2_2se);
if T==1
B1hat_up=[0;b1hat];
B2hat_up=[0;b2hat];
else
B1hat_up=[b1hat(1:T-1);0;b1hat(T:end)];
B2hat_up=[b2hat(1:T-1);0;b2hat(T:end)];
end

[b1hat, b2hat, fvalue]=single_problem(y1_down,x1_down,y2_down,x2_down,lambda1_2se,lambda2_2se);
if T==1
B1hat_down=[0;b1hat];
B2hat_down=[0;b2hat];
else
B1hat_down=[b1hat(1:T-1);0;b1hat(T:end)];
B2hat_down=[b2hat(1:T-1);0;b2hat(T:end)];
end
change=change+fold_change(B1hat_up,B2hat_up,1)+fold_change(B1hat_down,B2hat_down,1);
change_sst(:,T)=change;
end
%csvwrite([path_fold,'\ss_foldchange_',num2str(T0),'.csv'],change_sst);

end

csvwrite([path_fold,'\ss_foldchange_.csv'],change_sst);


