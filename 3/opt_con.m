function [c,ceq] = opt_con(z, k_vec)
[~, ~, E_3] = student_id();

k_end = k_vec(end);

x_init(1:4) = 20; %[veh/km]
x_init(5:8) = 90; %[km/h]
x_init(9)  = 0; % initial ramp queue

% reserve memory
x = nan(k_end, 9);
u = nan(k_end, 2);
c = nan(size(k_vec));
ceq = nan(k_end, 9);
x_con = nan(k_end, 9);

% init con
x_con(1,:) = x_init;

for k = k_vec
    
    x_i_start = 11*(k - 1) + 1;
    x_i_end = 11*(k - 1) + 9;
    u_i_start = 11*(k - 1) + 10;
    u_i_end = 11*(k - 1) + 11;
    
    x(k,:) = z(x_i_start:x_i_end);
    u(k,:) = z(u_i_start:u_i_end);
   
    x_con(k+1,:) = metanet(x(k,:), u(k,:), k);
    
    % constraint
    % c(k) =  x(k, 9) - 20 + E_3; % <= 0
    ceq(k,:) = x(k,:) - x_con(k,:); % = 0
end
c = -1;
end