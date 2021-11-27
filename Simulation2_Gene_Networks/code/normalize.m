
function [a b] = normalize(a,b)

a  = a * diag(1./sqrt(diag(a'*a)));
b  = b * diag(1./sqrt(diag(b'*b)));