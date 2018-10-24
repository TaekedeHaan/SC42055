function y = opt_func(x, L, T, lambda)

y = T*x(9,:) + T*L*lambda*(x(1:4,:));          % Compute function value at x