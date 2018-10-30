function y = get_cost(x)
% simulation params
lambda = 3;         % [-] # of lanes
T = 10*1/3600;      % [h] simlation time step
L = 1;              % [km] Length segment

y = T*x(9) + T*L*lambda*sum(x(1:4),2);          % Compute function value at x