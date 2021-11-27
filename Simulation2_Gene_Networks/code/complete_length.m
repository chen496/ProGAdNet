
function [all] = complete_length(beta,Ng,tf)
all = zeros(Ng,1);
all(tf,:)=beta;