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

E_1 = Da1 + Db1;
E_2 = Da2 + Db2;
E_3 = Da3 + Db3;

% const
syms a1 a2 dt 

% time
syms T_0 T_1 Q_in Q_out T_amb

%% problem
% constants
A = 1 - a1 * dt;
B = [-dt * a2, dt * a2];
ck = a1 * dt * T_amb;

% objective function
y = (T_1 - (A*T_0 + B*[Q_out Q_in].' + ck))^2; % y(T_1, T_0, a1, dt, Q_in, a2, Q_out, T_amb)
y = expand(y);

k_end = 100 + E_1;
k = 1:k_end;
dt = 3600; % [s]
%% Rewrite
% compute h
a = [a1, a2];
dydx = jacobian(y,a);
H = simplify(jacobian(dydx, a));

% compute f
dydx = simplify(jacobian(y,a)); % [1 x 2]
F = simplify(dydx - a * H);

% read data
temp = readtable('measurements.csv');

% select colls
Q_in = permute(temp.Qin(k), [3, 2, 1]);
Q_out = permute(temp.Qout(k), [3, 2, 1]);
T_0 = permute(temp.T(k), [3, 2, 1]);
T_1 = permute(temp.T(k+1), [3, 2, 1]);
T_amb = permute(temp.Tamb(k), [3, 2, 1]);

% substitue and convert to double
F_num = double(subs(F));
H_num = double(subs(H));

% sum
F_num = sum(F_num,3);
H_num = sum(H_num,3);

a = quadprog(H_num,F_num);
% constants

disp(a);

A = 1 - a(1) * dt;
B = [-dt * a(2), dt * a(2)];
ck = a1 * dt * T_amb;


%% Question 3
N = 360;
Q_in_max = 100 + E_2; %[kW]
T_1 = 330 + E_3; % [K]
T_amb = 275 + E_1; %[K]
T_min = 315; % [K]
a1 = 1.96 * 10^-7;
a2 = 3.80 * 10^-9;

% compute const
A = 1 - a(1) * dt;
B = [-dt * a(2), dt * a(2)];
ck = a1 * dt * T_amb;

% load data 
temp = readtable('heatDemand.csv');
Q_out = temp.Heat_demand;
temp = readtable('inputPrices.csv');
lambda = temp.Price; % [eur/MWh]
lambda = lambda * 10^-3 / 3600; % [eur/kWs]

% generate materices for optimization
% c = [dt * lambda, -1, 0, 0]';
% A = [ones(1,N), zeros(1,N), 0, 1, 0;
%      ones(1,N), zeros(1,N), 0, 0, 0;
%      B(2)*ones(1,N), A*ones(1,N), 0, 0, -1];
% b = [0. Q_in_max, T_min - c - B(1) Q_oout]';
% lb = [0 0 0 0 0]';
% ub = [+Inf +Inf +Inf +Inf +Inf]';
% 
% % optimize
% x = linprog(c,[], [], A,b,lb,ub, options);


%% 
% disp(pretify(y));
% dfda1 = jacobian(f,a1);
% h11 = jacobian(dfda1,a1); 
% h11 = simplify(h11);
% 
% dfda2 = jacobian(f,a2);
% h22 = jacobian(dfda2,a2); 
% h22 = simplify(h22);
% 
% h21 = jacobian(dfda1,a2); 
% h21 = simplify(h21);
% h12 = h21;
% 
% H = [h11, h12; h21, h22];