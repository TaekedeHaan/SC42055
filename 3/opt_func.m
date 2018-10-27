function y = opt_func(x)
lambda = 4; % [-] number of lanes
T = 10/3600; % [h] simlation time step
L = 1; % [km] Length segment

y = T*x(9) + T*L*lambda*(sum(x(1:4)));          % Compute function value at x