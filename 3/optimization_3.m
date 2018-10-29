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
global x_k k
x_init(1:4) = 20; %[veh/km]
x_init(5:8) = 90; %[km/h]
x_init(9)  = 0; % initial ramp que
x_init(10) = 1;
x_init(11) = 120;
%x_init(11) = 250;

%% simulation
options = optimoptions('fmincon');

% bounds
lb = [0,    0,      0,      0,      0,      0,      0,      0,      0,      1,  120];
ub = [+inf, +inf,   +inf,   +inf,   +inf,   +inf,   +inf,   +inf,   +inf,   1,  120];

% init x
x = nan(k_end, 11);
x(1,:) = x_init;

for k = k_vec
    
    % harde beun om gedoe met indexen te voorkomen
    if k == k_end
        break;
    end
    x_k = x(k, :);  
    
    % optimization
    [x(k + 1,1:11), fval(k+1)] = fmincon(@opt_func,x_k,[],[],[],[],lb,ub,@opt_con); 
end

%% plot
% system state
figure('Position', [200,200,1000,500])
subplot(3,1,1)
plot(T_vec, x(:,1:4))
title('density')

subplot(3,1,2)
plot(T_vec, x(:,5:8))
hold on
plot(T_vec, x(:,11),'--')
legend('lane 1', 'lane 2', 'lane 3', 'lane 4', 'V_{SL}')
title('velocity')

subplot(3,1,3)
plot(T_vec, x(:,9))
hold on
plot(T_vec, x(:,10))
legend('queue (w)', 'inlet (r)')
title('queue')
