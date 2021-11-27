
function [x y] = precision_recall(a,true,option)

[p q] = size(a);
b = reshape(a,p*q,1);
t = reshape(true,p*q,1);

tp = 0;
fp = 0;

all = countnonzero(t);
precision = zeros(p*q,1);
recall = zeros(p*q,1);

for i=1:(p*q)
    [temp index] = max(b);
    if t(index)~=0
        tp = tp+1;
    else
        fp = fp+1;
    end
    precision(i) = tp/(tp+fp);
    recall(i) = tp/all;
    b(index) = -0.1;
end

i=1;
k=1;
while i<p*q
    if recall(i+1)~=recall(i)
        true_recall(k) = recall(i);
        true_precision(k) = precision(i);
        i = i+1;
    else
        count = 0;
        for l = i:(p*q-1)
            if recall(l+1)~=recall(l);
                break;
            end
            count =count+1;
        end
        temp_pre = 0;
        for m = i:l
            temp_pre = temp_pre + precision(m);
        end
        temp_pre = temp_pre/(count+1);
        true_recall(k) = recall(l);
        true_precision(k) = temp_pre;
        i = l+1;
    end
    k = k+1;
end

if option==0
    x = true_recall;
    y = true_precision;
else
    x = recall;
    y = precision;
end