
function [t] = countnonzero(A)

[p q]=size(A);
t=0;
for i=1:p
    for j=1:q
        if(A(i,j)~=0)
            t=t+1;
        end
    end
end
