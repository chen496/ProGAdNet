function [rank] = rank_la_modi_ss_only(b,SS_CYCLE)
% calculate the frequency of the changes of an edge in Lasso problem
[m, n] = size(b);
rank = zeros(m,1);

rank = rank + sum(b,2)./(n*SS_CYCLE);

