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

% METANET parameters
tau = 10; % [s]
mu = 80; % [km^2/h]
Cr = 2000; %[vec/km lane]
alpha = 0.1; % [-]
K = 10; % [veh/km lane]
a = 2; % [-]
v_f = 110; % [km/h]
rho_c = 28; %[veh/km lane]

% init
rho_init = 20; %[veh/km]
v_init = 90; %[km/h]
Dr = 1500; %[veh/h] constant ramp deman

%  flow entering the mainline
q0_1 = 7000 + 100 * E1; % [veh/h] if k<12
q0_2 = 2000 + 100 * E2; % [veh/h] if k>=12

%% optimization
x = fmincon(y,x0,A,b,Aeq,beq,lb,ub,nonlcon,options)