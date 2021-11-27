function [] = simu_table(Ng,Sample)

% Purpose: 

% Create tables of AUPR to demonstrate performance for simulation data

% Parameters:

% Ng - the number of genes in the network
% Sample - a vector of length of 4, contains the different samples sizes used during simulation
% varar - a vector of length of 2, contains the different variances used during simulation

k=2;   % 2 simulated files are used here

for i=1:4
    
    leg_df{i} = sprintf('df N=%d', Sample(i));
    leg_la{i} = sprintf('lasso N=%d', Sample(i));
end

for i=1:k
    for j=1:4
        fname = sprintf('simu_result_Ng%dN%d.mat', Ng, Sample(1,j));
        load(fname)
        DF_recall(:,i,j) = mean(df_recall(:,:,i),2);
        DF_precision(:,i,j) = mean(df_precision(:,:,i),2);
        LA_recall(:,i,j) = mean(la_recall(:,:,i),2);
        LA_precision(:,i,j) = mean(la_precision(:,:,i),2);
    end 
end

for i=1:k
    for j=1:4
        AUPR_DF(i,j) = aupr(DF_recall(:,i,j), DF_precision(:,i,j));
        AUPR_LA(i,j) = aupr(LA_recall(:,i,j), LA_precision(:,i,j));
    end
end

AUPR_DF = AUPR_DF';
AUPR_LA = AUPR_LA';

save AUPR_DF AUPR_DF
save AUPR_LA AUPR_LA