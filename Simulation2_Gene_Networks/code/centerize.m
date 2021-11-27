
function [X Y] = centerize(X,Y)

[m n] = size(X);

X = X - ones(m,1)*mean(X);
Y = Y - ones(m,1)*mean(Y);

