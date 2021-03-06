
function [] = simulation(N, simu_round, CHANGE_RATE, var1, all_var2, SS_CYCLE , DF_STEP1, DF_STEP2, TILL_STEP)

% Purpose: 

% Simulate experiments about GRN differential inference with given gold standard network structure with Ng genes

% Parameters:

% - gold_standard:  a Ng by Ng square matrix stored the gold structure of the network; should be a square matrix of 0's and 1's
% - N: sample size;
% - *simu_round: times of simulation in the same setting; recommended value = 50
% - *CHANGE_RATE: the poportion of differential edges over the total number of edges; recommended value = 0.1
% - var1: the variance of experimental error; recommended value = 0.1
% - *all_var2: a vector of desired variance level for measurement error; recommended value = [0.05 0.5]'
% - *SS_CYCLE: cycles used when conducting stability selection; recommended value = 100
% - *DF_STEP1: steps to conduct in the direction of \lambda1 in the algorithm; recommended value = 10
% - *DF_STEP2: steps to conduct in the direction of \lambda2 in the algorithm; recommended value = 10
% - *TILL_STEP: how many variables to select in the comparing lasso alogithm; recommended value = 10

fprintf('\nSimulation begins..\n\n\n');
fprintf('Make sure the "gold_standard.txt" network is in the same path..\n\n');

load gold_standard.txt
B1 = gold_standard;

for times = 1:simu_round
    
    fprintf('Simulation Round: %d..\n', times);
    
    % generate the other paired network based on the gold_standard one
    [B1, B2] = generate_similar_structure(B1,CHANGE_RATE);
    
    % Caculate how many different measurement error levels are given
    N_var2 = size(all_var2);
    
    % generate simulated data based on two simulated network structures
    for NN_var2 = 1:N_var2
        [X1_all(:,:,NN_var2), X2_all(:,:,NN_var2)] = generate_data_by_structure(B1,B2,N,var1,all_var2(NN_var2));
    end
    
    % centralize the data(unnormalized)
    for N_df_var=1:N_var2
        [X1, X2] = centerize(X1_all(:,:,N_df_var),X2_all(:,:,N_df_var));
        [X1, X2] = normalize(X1,X2);
        
        X12 = [X1;X2];
        [~, X12] = centerize(X12,X12);
        [~, X12] = normalize(X12,X12);
        [p, ~] = size(X1);
        X3 = X12(1:p,:);
        X4 = X12(p+1:2*p,:);
                
        % get the # of samples and # of genes
        [N, Ng]=size(X1);
        
        % get the full list of genes to be the TF's
        for ttff=1:Ng
            tf1(ttff) = ttff;
        end
        tf2 = tf1;
        
        % 4. SOLVE THE NETWORK
        
        % first loop: for all single problem
        for circle = 1:Ng
            
            % solve the linear system: X*Bi = Xi
            l_tf1 = circle_tf(tf1,circle);
            l_tf2 = circle_tf(tf2,circle);
            
            y1 = X1(:,circle);
            y2 = X2(:,circle);
            
            % extract only the specified columns, if information of TFs is given(If TF not given, the data set remains the same)
            X1m = X1(:,l_tf1);
            X2m = X2(:,l_tf2);
            
            y3 = X3(:,circle);
            y4 = X4(:,circle);
            
            % extract only the specified columns, if information of TFs is given(If TF not given, the data set remains the same)
            X3m = X3(:,l_tf1);
            X4m = X4(:,l_tf2);
              
            % solve the linear system with Stability Selection with 3 parameters(Defined in 1.)
            [b1, b2, b00] = ss_df(y3,X3m,y4,X4m,DF_STEP1,DF_STEP2,SS_CYCLE);
            [b3, b4, b88] = ss_my_la(y1,X1m,y2,X2m,SS_CYCLE,TILL_STEP);
 
            
            % rank the frequencies of none-zero elements in each(lambda1,lambda2) pairs
            [rank_b1_df] = rank_df_modi_ss_only(b1,SS_CYCLE);
            [rank_b2_df] = rank_df_modi_ss_only(b2,SS_CYCLE);
            [rank_deltab_df] = rank_df_modi_ss_only(b00,SS_CYCLE);
            
            [rank_b1_la] = rank_la_modi_ss_only(b3,SS_CYCLE);
            [rank_b2_la] = rank_la_modi_ss_only(b4,SS_CYCLE);
            [rank_deltab_la] = rank_la_modi_ss_only(b88,SS_CYCLE);
            
            % save ranked Bi's, for df method and lasso method
            df1(:,circle) = complete_length(rank_b1_df,Ng,l_tf1);
            df2(:,circle) = complete_length(rank_b2_df,Ng,l_tf2);
            df(:,circle) = complete_length(rank_deltab_df,Ng,l_tf1);
            la1(:,circle) = complete_length(rank_b1_la,Ng,l_tf1);
            la2(:,circle) = complete_length(rank_b2_la,Ng,l_tf2);
            la(:,circle) = complete_length(rank_deltab_la,Ng,l_tf1);
            
            
        end
        
        % 5. SAVE OUTPUT
        
        tf_df1 = df1(tf1,:);
        tf_df2 = df2(tf1,:);
        tf_df = df(tf1,:);
        tf_la1 = la1(tf1,:);
        tf_la2 = la2(tf1,:);
        tf_la = la(tf1,:);
        tf_B1 = B1(tf1,:);
        tf_B2 = B2(tf1,:);
        
        %Calculate the precision and recalls
        [recall_df, precision_df] = precision_recall(tf_df,tf_B1-tf_B2,1);
        [recall_la, precision_la] = precision_recall(tf_la,tf_B1-tf_B2,1);
        
        %Calculate AUPR 
        AUPR_df = aupr(recall_df,precision_df);
        AUPR_la = aupr(recall_la,precision_la);
   
        %Save the precision and recalls for one simulation time 
        df_recall(:,times,N_df_var) = recall_df;
        df_precision(:,times,N_df_var) = precision_df;
        la_recall(:,times,N_df_var) = recall_la;
        la_precision(:,times,N_df_var) = precision_la;
    
        
        %Save AUPR for one simulation time
        df_AUPR(:,times,N_df_var) = AUPR_df;
        la_AUPR(:,times,N_df_var) = AUPR_la;
       
         
    end
end

%save the simulated results in a .mat file, can be used for visualization and other purposes
fname = sprintf('simu_result_Ng%dN%d.mat', Ng,N);
save(fname,'df_recall','la_recall','df_precision','la_precision','df_AUPR','la_AUPR','Ng','N')

fprintf('Simulation done.\n');