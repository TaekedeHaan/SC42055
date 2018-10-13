clear all
close all
clc

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

%% Rewrite
% compute h
x = [a1, a2];
dydx = jacobian(y,x);
H = simplify(jacobian(dydx, x));

% compute f
dydx = simplify(jacobian(y,x)); % [1 x 2]
f = simplify(dydx - x * H);


disp(f_string)


%% 
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