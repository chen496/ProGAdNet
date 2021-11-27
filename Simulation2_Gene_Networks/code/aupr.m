
function [k] = aupr(a, b)

[p, ~] = size(a);
k=0;
c = a(1);

for i=2:p
   if a(i-1)~=a(i)
      k = k + b(i-1)*(a(i)-c);
      c = a(i);
   end
end