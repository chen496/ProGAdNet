function [rank] = rank_df_modi_ss_only(b,SS_CYCLE)
% calculate the frequency of the changes of an edge in ProGAdNet method
[m, step2, step1] = size(b);
temp=zeros(m,1);
for i=1:step1
  temp=temp+sum(b(:,:,i),2);
end

rank=temp./(step1*step2*SS_CYCLE);

