function [c,ceq] = opt_con(x, u, k)
[E_1, E_2, E_3] = student_id();
x_new = metanet(x, u, k);

c =  x_new(9) - 20 + E_3; % <= 0
ceq = 0; % always satisfies