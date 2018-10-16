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
disp('====QUESTION 2====')
% constants
A = 1 - a1 * dt;
B = [-dt * a2, dt * a2];
c = a1 * dt * T_amb;

% objective function
y = (T_1 - (A*T_0 + B*[Q_out Q_in].' + c))^2; % y(T_1, T_0, a1, dt, Q_in, a2, Q_out, T_amb)
y = expand(y);

k_end = 100 + E_1;
k = 1:k_end;
dt = 3600; % [s]
%% Rewrite inhto normal form
a = [a1, a2];

% compute H
dydx = simplify(jacobian(y,a)); % [1 x 2]
H = simplify(jacobian(dydx, a));

% compute f
F = simplify(dydx - a * H);

%% optimize
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

disp(['a1: ', num2str(a(1))]);
disp(['a2: ', num2str(a(2))]);

%% Question 3
disp('====QUESTION 3====')
clear Q_in
N = 360;
k = 1:N;

Q_max = (100 + E_2)*10^3; %[W]
Q_min = 0;
T_min = 315; % [K]

T_init = 330 + E_3; % [K]
T_amb = repmat(275 + E_1, N, 1); %[K]

a1 = 1.96 * 10^-7;
a2 = 3.80 * 10^-9;

% load data 
temp = readtable('heatDemand.csv');
Q_out = temp.Heat_demand(k);

temp = readtable('inputPrices.csv');
lambda = temp.Price(k); % [eur/MWh]
lambda = lambda /(10^6 * 3600); % [eur/J]

% compute const
A = 1 - a1 * dt;
B = dt * a2 * [-1, 1];
c = a1 * dt * T_amb;

% generate materices fcor optimization
f = [dt * lambda(1:N); zeros(N + 1,1)];
Aeq = [-diag(repmat(B(2),N,1)), -diag(repmat(A,N,1)) + diag(ones(N- 1,1),1), [zeros(N-1,1);1]]; % moving of temp
 
beq = B(1) * Q_out + c;
lb = [zeros(N,1); T_init; repmat(T_min,N,1)];
ub = [repmat(Q_max,N,1); T_init; +Inf(N,1)];
 
% optimize
x = linprog(f,[], [], Aeq,beq,lb,ub);
Q_in = x(1:360);
T = x(361:721);

price1 = Q_in' * dt * lambda;
disp(['price: ', num2str(price1), '[euro]']);

% plot
figure('Position', [100,0,600,1100])
subplot(3,1,1)
plot(Q_in)
title('Q in')
xlabel('time [h]')
ylabel('power [W]')

subplot(3,1,2)
plot(Q_out)
title('Q out')
xlabel('time [h]')
ylabel('power [W]')

subplot(3,1,3)
plot(T)
title('Temperature')
xlabel('time [h]')
ylabel('Temperature [K]')

saveas(gcf, 'result', 'epsc')

%% Question 4
disp('====QUESTION 4====')
cost_add = (0.1+ E_2/10); %[euros/K^2]
T_ref = 323;
T_max = 368;
H = zeros(2*N+1, 2*N+1);
H(end, end) = 2 * cost_add;

f = [dt * lambda(1:N); zeros(N,1); -2*T_ref * cost_add];

lb= [repmat(Q_min, N, 1); T_init; repmat(T_min, N, 1)];
ub= [repmat(Q_max, N, 1); T_init; repmat(T_max, N, 1)];

x = quadprog(H,f,[],[],Aeq,beq,lb,ub);
Q_in = x(1:360);
T = x(361:721);

price1 = Q_in' * dt * lambda + cost_add * (T(end) - T_ref)^2;
price2 = Q_in' * dt * lambda + cost_add*T(end)^2 + cost_add*T_ref^2 - cost_add*2*T(end)*T_ref;

disp(['price1: ', num2str(price1), '[euro]']);
disp(['price2: ', num2str(price2), '[euro]']);
% plot
figure('Position', [100,0,600,1100])
subplot(3,1,1)
plot(Q_in)
title('Q in')
xlabel('time [h]')
ylabel('power [W]')

subplot(3,1,2)
plot(Q_out)
title('Q out')
xlabel('time [h]')
ylabel('power [W]')

subplot(3,1,3)
plot(T)
title('Temperature')
xlabel('time [h]')
ylabel('Temperature [K]')

saveas(gcf, 'result4', 'epsc')