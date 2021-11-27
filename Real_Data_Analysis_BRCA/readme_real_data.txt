Data fold: 
(1) BRCA_gene_exp_tumor.txt: matrix of 4310 x 113 that contains expression data of 4310 genes in 113 breast tumor samples

(2) BRCA_gene_exp_normal.txt: matrix of 4310 x 113 that contains expression data of 4310 genes in 113 matched normal tissue samples

(3) BRCA_gene4310 name and ID.xlsx:  list of 4310 genes


Code fold: 
(1) Realdata_ProGAdNet.m: the main script for data analysis; stability selection is used in this script. 

(2) cross_validation_real_data: cross validation for real data

(3) foldchange.m: implement the following criteria for finding changed network edges: (1) |b_{ji}-\tilde b_{ji}|>min(|b_{ji}|,|\tilde b_{ji}|), and (2)|b_{ji}-\tilde b_{ji}|>T, where T is the 20 percentile of all |b_{ji}|'s and |\tilde b_{ji}|'s. 
 

Remark:
- Realdata_ProGAdNet.m will call other functions in the ProGAdNet_code fold. Set Matlab search path properly before running Realdata_ProGAdNet.m.  

