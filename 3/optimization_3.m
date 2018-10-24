clear all
close all
clc

close all
clear all
clc

% Meric, 4305558
Da1 = 5;
Da2 = 5;
Da3 = 8;

%Taeke, 4316568
Db1 = 5;
Db2 = 6;
Db3 = 8;

E_1 = (Da1 + Db1)/2;
E_2 = (Da2 + Db2)/2;
E_3 = (Da3 + Db3)/2;

lambda = 4; % [-] number of lanes
T = 10; % [s] simlation time step
L = 1; % [km] Length segment
k_start = 1;
k_end = 61;

% METANET parameters
tau = 10; % [s]
mu = 80; % [km^2/h]
Cr = 2000; %[vec/km lane]
alpha = 0.1; % [-]
K = 10; % [veh/km lane]
a = 2; % [-]
v_f = 110; % [km/h]
rho_c = 28; %[veh/km lane]

% constant ramp demand
Dr = 1500; %[veh/h] 

%  flow entering the mainline
q0_1 = 7000 + 100 * E1; % [veh/h] if k<12
q0_2 = 2000 + 100 * E2; % [veh/h] if k>=12

rho(1:4, 1) = 20; %[veh/km]
v(1:4, 1) = 90;  % [km/h]
w_r(0)  = 0; % initial ramp que
r(14) = 1; % ramp metering rate r(k) 

% rho_5(k) = rho_4(k)
% v_0(k) = v_1(k)

%% init
% x0 Initial point, solvers use the size of x0 to determine the number and size of variables that fun accepts.
x0 = zeros(14,1);

options = optimoptions('fmincon');

for k = k+start:k_end

    lb = [0, 0, 0, 0, 0, 0, 0, 0, 0, 120, 60, 60, 120, 0]';
    ub = [0, 0, 0, 0, 0, 0, 0, 0, 0, 120, 120,120,120, 0]';
    %% optimization
    x(k) = fmincon(@opt_func,x0,[],[],[],[],[],[],@opt_con,options);
end