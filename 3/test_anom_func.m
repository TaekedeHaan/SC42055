lambda = 3; % [-] number of lanes
T = 10/3600; % [h] simlation time step
L = 1; % [km] Length segment

% initial cond
z_init(1:4) = 20; %[veh/km]
z_init(5:8) = 90; %[km/h]
z_init(9)  = 0; % initial ramp queue
z_init(10) = 1;
z_init(11) = 120;

f = @(x)opt_func(x, lambda, T, L);

[z, fval] = fmincon(f,z_init);