function y = opt_func(x)
lambda = 4; % [-] number of lanes
T = 10; % [s] simlation time step
L = 1; % [km] Length segment

y = T*x(9) + T*L*lambda*(x(1:4));          % Compute function value at x