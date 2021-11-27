function [X1 X2] = generate_data_by_structure(B1,B2,n,variance,var2)

std = sqrt(variance);
std_mod = sqrt(var2);

[p q] = size(B1);

%experimental error
E1 = normrnd(0,1,n,p);
E2 = normrnd(0,1,n,p);

%model error
EE1 = std_mod*normrnd(0,1,n,p);
EE2 = std_mod*normrnd(0,1,n,p);

X1 = EE1 + (E1)*inv(eye(p) - B1);
X2 = EE2 + (E2)*inv(eye(p) - B2);

