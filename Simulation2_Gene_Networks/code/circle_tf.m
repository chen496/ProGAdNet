
function [tf] = circle_tf(tf,c)

[p q] =size(tf);
for i=1:q
    if tf(i)==c
        tf(i) = [];
        break;
    end
end