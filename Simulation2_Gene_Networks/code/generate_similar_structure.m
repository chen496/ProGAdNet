
function [b matrix] = generate_similar_structure(b , change_rate)

% generate a similar topology structure by the rule:
% a) random pick change entry;
% b) with half probability to change the value of the entry in a) into a
% positive or negative value generated from
% c) random number between [0.5 1]

[m m2] = size(b);

NZ = countnonzero(b);

n = NZ * change_rate;
matrix = b;

for i=1:n
    
    j = randi([1 m]);
    k = randi([1 m]);
    
    if j==k
        continue;
    else
        
        p = rand();
        v = (1+rand())/2;
        
        if matrix(j,k)~=0
            q = rand();
            if q>0.5
                matrix(j,k)=0;
            else
                 if p>0.5
                     matrix(j,k) = matrix(j,k)+v;
                 else
                     matrix(j,k) = matrix(j,k)-v;
                 end
            end 
        else
            if p>0.5
                 matrix(j,k) = v;
            else
                matrix(j,k) = -v;
            end
        end
    end
end