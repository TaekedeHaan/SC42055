function y = opt_func(x, lambda, T, L)

y = T*x(9) + T*L*lambda*(sum(x(1:4)));          % Compute function value at x