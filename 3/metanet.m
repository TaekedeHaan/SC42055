function x_new = metanet(x, u, k)

[E_1, E_2, ~] = student_id();

% METANET parameters
tau = 10*1/3600;    % [h]
mu = 80;            % [km^2/h]
C_r = 2000;         % [vec/km lane]
rho_m = 120;        % [veh/km lane]
alpha = 0.1;        % [-]
K = 10;             % [veh/km lane]
a = 2;              % [-]
v_f = 110;          % [km/h]
rho_c = 28;         % [veh/km lane]

% simulation params
lambda = 3;         % [-] # of lanes
T = 10*1/3600;      % [h] simlation time step
L = 1;              % [km] Length segment

%  flow entering the mainline
if k < 12
    q_0k = 7000 + 100*E_1; % [veh/h] if k<12
else
    q_0k = 2000 + 100*E_2; % [veh/h] if k>=12
end

D_r = 1500; %[veh/h]

%  the flow that enters from the controlled on-ramp on segment 4
q_r_all = [u(1)*C_r, D_r + x(9)/T, C_r*(rho_m - x(4))/(rho_m - rho_c)];
% disp(q_r_all);
q_rk = min(q_r_all);

% desired speed
V_max = [120, u(2), u(2), 120];
V_k = min((1+alpha)*V_max, v_f*exp(-1/a*(x(1:4)/rho_c).^a));

% constraints density
x_new(1) = x(1) + T/L*(q_0k/lambda - x(1)*x(5));
x_new(2) = x(2) + T/L*(x(1)*x(5) - x(2)*x(6));
x_new(3) = x(3) + T/L*(x(2)*x(6) - x(3)*x(7));
x_new(4) = x(4) + T/L*(x(3)*x(7) - x(4)*x(8) + q_rk/lambda);

% constraints velocity
x_new(5) = x(5) + T/tau*(V_k(1) - x(5)) - (mu*T)/(tau*L)*(x(2) - x(1))/(x(1) + K);
x_new(6) = x(6) + T/tau*(V_k(2) - x(6)) + T/L*x(6)*(x(5) - x(6)) - (mu*T)/(tau*L)*(x(3) - x(2))/(x(2) + K);
x_new(7) = x(7) + T/tau*(V_k(3) - x(7)) + T/L*x(7)*(x(6) - x(7)) - (mu*T)/(tau*L)*(x(4) - x(3))/(x(3) + K);
x_new(8) = x(8) + T/tau*(V_k(4) - x(8)) + T/L*x(8)*(x(7) - x(8));

% constraints que length
x_new(9) = x(9) + T*(D_r - q_rk);

end