Data fold:
This is an empty fold that will be used to save the simulated data and simulation results. 

Code fold:
This fold contains the following Matlab scripts and other files:

Sim_network.m : main script that calls function simulation.m to run simulations, calls simu_table.m to put simulation results in a table, and calls function simu_plot.m to plot simulation results.

core functions:
(1)Simulation.m (See "sim_network.m" for example)
Goal: Given a "gold_standard.txt" file containing a gold standard network strucuture, conducting simulations to demonstrate performance
Input: 
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
Output:
 - graphs about performance(Put 4 different sample sizes and 2 different variances): P-R curves (saved as "P-R_curve_Ng***Var***.jpg") and AUPR (saved as "avg_AUPR.jpg")
 - tables about performance AUPR (matrix with each entry: (Sample Size,variance)). (Save as "AUPR_DF.mat" and "AUPR_LA.mat")

Data generation:
(2)generate_similar_structure.m: generate a network changed from the one specified by gold_standard.txt
(3)generate_data_by_structure: generate gene expression data based on two simulated gene networks.

Data processing:
(4)centerize.m: centralize the data
(5)normalize.m: normalize the data

Stability selection and gene network inference:
(6)ss_df.m: infer gene networks with ProGAdNet and stability selection 
(7)ss_my_la.m: infer gene networks with Lasso and stability selection 
(8)rank_df_modi_ss_only.m: counts the changed edges in the gene network inferred by ProGAdNet
(9)rank_la_modi_ss_only.m: counts the changed edges in gene network inferred by Lasso 
(10)complete_length.m: stores the ranked edges 
(11) lassofista.m: solves the Lasso problem

Plot and output:
(12)precision_recall.m: calculate the precision and recalls
(13)aupr.m: calculate AUPR





