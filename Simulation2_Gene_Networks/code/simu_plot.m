function [] = simu_plot(Ng,Sample,varar)

% Purpose: 

% Plot figures to demonstrate performance for simulation data

% Parameters:

% Ng - the number of genes in the network
% Sample - a vector of length of 4, contains the different samples sizes used during simulation
% varar - a vector of length of 2, contains the different variances used during simulation

k=2;   % 2 simulated files are used here

%%% plot P-R curve for different sample sizes

for i=1:4
    leg_df{i} = sprintf('df N=%d', Sample(i));
    leg_la{i} = sprintf('lasso N=%d', Sample(i));
end

for i=1:k
    for j=1:1
        fname = sprintf('simu_result_Ng%dN%d.mat', Ng, Sample(1,j));
        load(fname)
        DF_recall(:,j) = mean(df_recall(:,:,i),2);
        DF_precision(:,j) = mean(df_precision(:,:,i),2);
        LA_recall(:,j) = mean(la_recall(:,:,i),2);
        LA_precision(:,j) = mean(la_precision(:,:,i),2);
    end
    
    bound = max(max(max(DF_precision)))+0.05;
    m1 = figure(i)
    h1=plot(DF_recall(:,1),DF_precision(:,1),'b-')
    hold on;
    h2=plot(LA_recall(:,1),LA_precision(:,1),'b--')
    axis([0 1 0 bound])
    h3=plot(DF_recall(:,2),DF_precision(:,2),'r-')
    hold on;
    h4=plot(LA_recall(:,2),LA_precision(:,2),'r--')
    axis([0 1 0 bound])
    h5=plot(DF_recall(:,3),DF_precision(:,3),'y-')
    hold on;
    h6=plot(LA_recall(:,3),LA_precision(:,3),'y--')
    axis([0 1 0 bound])
    h7=plot(DF_recall(:,4),DF_precision(:,4),'g-')
    hold on;
    h8=plot(LA_recall(:,4),LA_precision(:,4),'g--')
    axis([0 1 0 bound])
    
    
    xlabel('Recall')
    ylabel('Precision')
    tname = sprintf('Average P-R curve for var = %.2f',varar(i));
    title(tname)
    legend([h1 h2 h3 h4 h5 h6 h7 h8],leg_df{1},leg_la{1},leg_df{2},leg_la{2},leg_df{3},leg_la{3},leg_df{4},leg_la{4})
    sname = sprintf('P-R_curve_Ng%dVar%.2f.jpg', Ng, varar(i));
    saveas(m1,sname)
    
end



