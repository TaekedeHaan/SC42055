function y = opt_func(z, lambda, T, L)

y = T*z(9) + T*L*lambda*(sum(z(1:4)));          % Compute function value at x