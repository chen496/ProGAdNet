This fold contains the following Matlab programs that implement the ProGAdNet algorithm:

(1) single_problem.m: 
% [x, y, tim] = single_problem(y1,X1,y2,X2,lambda1,lambda2,b1,b2)
% solve the single problem:
% argmin_{b1, b2}||y1-X1*b1||^2+||y2-X2*b2||^2+lambda1*(|b1|+|b2|)+lambda2*|b1-b2|
% with fixed lambda1 and lambda2
Input:
 - y1: p*1 vector
 - X1: n*p matrix
 - y2: p*1 vector
 - X2: n*p matrix
 - lambda1: positive constant
 - lambda2: positive constant
 - b1: initial value of b1 
 - b2: initial value of b2
Output:
 - x: estimate of b1
 - y: estimate of b2
 - tim: value of the objective function 

(2) lassofista.m :
%b = lassofista(X, y, lambda,warmstart_b) 
%solve the Lasso problem argmin_b (||y-Xb||^2+lambda*|b|)
Input:
 - X:  n*p matrix
 - y:  p*1 vector
 - lambda: positive constant
 - warmstart_b:  p*1 vector of the initial value of b
Output:
 - b:  estimate of b

(3) cross_validation_ProGAdNet.m :
%[lambda1,lambda2_mat,twoSE_step1,twoSE_step2,best_point,best_step1,best_step2,CVmeanMatrix] = cross_validation_ProGAdNet(y1,x1,y2,x2,STEP1,STEP2,num_folds)
% perform cross validation for ProGAdNet to find optimal values of lambda1 and lambda2
Input:
 - y1: p*1 vector
 - x1: n*p matrix
 - y2: p*1 vector
 - x2: n*p matrix
 - STEP1: number of values of lambda1 
 - STEP2: number of values of lambda2
 - num_folds: the number of folds for cross validation
Output:
 - lambda1: a vector containing all the values of lambda1  
 - lambda2_mat: a matrix whose columns contain lambda2 values for each lambda1 value
 - twoSE_step1: index of the lambda1 value corresponding to the prediction error (PE)
 		that is two standard error (SE) greater than the minimum PE. 
 - twoSE_step2: index of the lambda2 value corresponding to the PE
		that is two SE greater than the minimum PE.  
 - best_step1: index of the lambda1 value corresponding to the minimum PE 
 - best_step2: index of the lambda2 value corresponding to the minimum PE 
 - CVmeanMatrix: matrix containing PEs for all values of (lambda1, lambda2)
