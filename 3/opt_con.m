function [c, ceq] = opt_con(z_new, z_old, k)

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
q_r_all = [z_new(10)*C_r, D_r + z_old(9)/T, C_r*(rho_m - z_old(4))/(rho_m - rho_c)];
% disp(q_r_all);
q_rk = min(q_r_all);

% desired speed
V_max = [120, z_new(11), z_new(11), 120];
V_k = min((1+alpha)*V_max, v_f*exp(-1/a*(z_old(1:4)/rho_c).^a));

% constraints density
ceq(1) = -z_new(1) + z_old(1) + T/L*(q_0k/lambda - z_old(1)*z_old(5));
ceq(2) = -z_new(2) + z_old(2) + T/L*(z_old(1)*z_old(5) - z_old(2)*z_old(6));
ceq(3) = -z_new(3) + z_old(3) + T/L*(z_old(2)*z_old(6) - z_old(3)*z_old(7));
ceq(4) = -z_new(4) + z_old(4) + T/L*(z_old(3)*z_old(7) - z_old(4)*z_old(8) + q_rk/lambda);

% constraints velocity
ceq(5) = -z_new(5) + z_old(5) + T/tau*(V_k(1) - z_old(5)) - (mu*T)/(tau*L)*(z_old(2) - z_old(1))/(z_old(1) + K);
ceq(6) = -z_new(6) + z_old(6) + T/tau*(V_k(2) - z_old(6)) + T/L*z_old(6)*(z_old(5) - z_old(6)) - (mu*T)/(tau*L)*(z_old(3) - z_old(2))/(z_old(2) + K);
ceq(7) = -z_new(7) + z_old(7) + T/tau*(V_k(3) - z_old(7)) + T/L*z_old(7)*(z_old(6) - z_old(7)) - (mu*T)/(tau*L)*(z_old(4) - z_old(3))/(z_old(3) + K);
ceq(8) = -z_new(8) + z_old(8) + T/tau*(V_k(4) - z_old(8)) + T/L*z_old(8)*(z_old(7) - z_old(8));

% constraints que length
ceq(9) = -z_new(9) + z_old(9) + T*(D_r - q_rk);

c(1) = - 1;% always satisfied