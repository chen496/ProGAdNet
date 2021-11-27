
%%if the beta changed more than 1 fold change, we consider is has changed%%
function [s] = fold_change(x,y,fold_change)
s=zeros(length(x),1);
for i=1:length(x)
    if(((x(i)==0)&&(y(i)~=0))||((x(i)~=0)&&(y(i)==0)))
        if(abs(x(i)-y(i))>max(abs([x y]))*0.2)
            s(i)=1;
        else s(i)=0;
        end
    elseif((x(i)==0)&&(y(i)==0))
        s(i)=0;
    else
            m=abs((y(i)-x(i))/min(y(i),x(i)));
            if m>=fold_change
            s(i)=1;
            else s(i)=0;
            end
    end
end
end