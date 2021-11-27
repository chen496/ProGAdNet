This fold contains files for computer simulation with linear regression model.

Data fold:
This is an empty fold that will be used to save the simulated data and simulation results. 

Code fold:
This fold contains the following files:
(1) Sim_diff_noise.m: perform simulation with various noise levels, 
	and generate results in Figure 1 in the paper.

(2) Sim_diff_p.m: perform simulation with various number of variables, 
	and generate results in Figure 2 in the paper. 

These two Matlab scripts will call the following functions in the fold ProGAdNet_code:
single_problem.m, lassofista.m, and cross_validation_ProGAdNet.m. Set the Matlab search path properly before running these scripts.


Remark:
Figures 1 and 2 also include simulation results obtained with software glmnet and lqa. 

- the glmnet software package can be downloaded at https://cran.r-project.org/web/packages/glmnet/index.html

- the lqa software package can be downloaded at https://cran.r-project.org/web/packages/lqa/

