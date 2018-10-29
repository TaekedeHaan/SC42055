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
x_init(1:4) = 20; %[veh/km]
x_init(5:8) = 90; %[km/h]
x_init(9)  = 0; % initial ramp queue
x_init(10) = 1;
x_init(11) = 120;

%% simulation
options = optimoptions('fmincon');

%% Question 3: no ramp metering 
disp('===QUESTION 3====');

% V_SL =120
x_init(11) = 120;

% bounds
lb = [0,    0,      0,      0,      0,      0,      0,      0,      0,      1,  60];
ub = [+inf, +inf,   +inf,   +inf,   +inf,   +inf,   +inf,   +inf,   +inf,   1,  120];

optimize_traffic(x_init, lb, ub, T_vec, '3_no_ramp_V_SLi_120')

% V_SL = 60
x_init(11) = 60;

% bounds
lb = [0,    0,      0,      0,      0,      0,      0,      0,      0,      1,  60];
ub = [+inf, +inf,   +inf,   +inf,   +inf,   +inf,   +inf,   +inf,   +inf,   1,  120];

optimize_traffic(x_init, lb, ub, T_vec, '3_no_ramp_V_SLi_60')

%% 4: ramp metering V_SL = 60
disp('===QUESTION 4====');

% bounds
x_init(11) = 120;

lb = [0,    0,      0,      0,      0,      0,      0,      0,      0,      0,  60];
ub = [+inf, +inf,   +inf,   +inf,   +inf,   +inf,   +inf,   +inf,   20-E_3, 1,  120];

optimize_traffic(x_init, lb, ub, T_vec, '4_full_controll')

%% 3: ramp metering V_SL = 60
% bounds
x_init(11) = 120;

lb = [0,    0,      0,      0,      0,      0,      0,      0,      0,      1,  60];
ub = [+inf, +inf,   +inf,   +inf,   +inf,   +inf,   +inf,   +inf,   +inf, 1,  120];

optimize_traffic(x_init, lb, ub, T_vec, '4_no_control')