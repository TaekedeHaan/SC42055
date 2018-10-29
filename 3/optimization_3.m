clear all
close all
clc

[E_1, E_2, E_3] = student_id();

%% init const
% sim steps
k_start = 1;
k_end = 61;
k_vec = k_start:k_end;

% time
T = 10/3600; % [h]
T_vec = (k_vec-1) * T;

% initial cond
z_init(1:4) = 20; %[veh/km]
z_init(5:8) = 90; %[km/h]
z_init(9)  = 0; % initial ramp queue
z_init(10) = 1; % required for from
z_init(11) = 120;

%% simulation
options = optimoptions('fmincon');

%% Question 3: no ramp metering 
disp('===QUESTION 3====');

% V_SL =120
z_init(11) = 120;

% bounds
lb = [1,  60];
ub = [1,  120];

optimize_traffic(z_init, lb, ub, T_vec, '3_no_ramp_V_SLi_120')

% V_SL = 60
z_init(11) = 60;

% bounds
lb = [1,  60];
ub = [1,  120];

optimize_traffic(z_init, lb, ub, T_vec, '3_no_ramp_V_SLi_60')

%% 4: Full control
disp('===QUESTION 4====');

% bounds
z_init(11) = 120;

lb = [0,  60];
ub = [1,  120]; % 20-E_3

optimize_traffic(z_init, lb, ub, T_vec, '4_full_controll')

%% 4: No control
% bounds
z_init(11) = 120;

lb = [1,  120];
ub = [1,  120];

optimize_traffic(z_init, lb, ub, T_vec, '4_no_control')