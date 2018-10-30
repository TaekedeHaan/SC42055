function optimize_traffic(x_init, u_init, lb, ub, T_vec, case_name)

[E_1, E_2, E_3] = student_id();

% get k
k_vec = 1:length(T_vec);
k_end = k_vec(end);

% reserve memory
x = nan(k_end, 9);
u = nan(k_end, 2);
fval = nan(k_end, 1);

% set initial cond
x(1,:) = x_init;
% fval(1) = get_cost(x_init);

% only display in case of non-convergens
% options = optimoptions('fmincon', 'Display', 'notify', 'ConstraintTolerance', 1e-5);
options = optimoptions('ga', 'Display', 'diagnose');
% options = optimoptions('ga','ConstraintTolerance',1e-6,'PlotFcn', @gaplotbestf);

lb_k = repmat(lb,1,k_end);
ub_k = repmat(ub,1,k_end);

% optimization
f = @(u)opt_func(x, u, k_vec);
nonlcon = @(u)opt_con(x, u, k_vec);
% [u, fval] = fmincon(f,z_init(10:11),[],[],[],[],lb, ub, nonlcon, options); 
[u, fval] = ga(f,2*k_end,[],[],[],[],lb_k, ub_k, nonlcon, options); 

%% reshape u
u_old = u;
clear u

for k = k_vec
    
    i_1 = 2*(k-1) + 1;
    i_2 = 2*(k-1) + 2;
    
    u(k,:) = u_old([i_1, i_2]);
end

%% compute x
for k = k_vec
    
    if k == k_vec(end)
        break;
    end
    
    x(k+1,:) = metanet(x(k,:), u(k,:), k);
end

z = [x, u];

%% plot
% system state
figure('Position', [200,200,1000,800])
subplot(3,1,1)
plot(T_vec, z(:,1:4))
ylim([0, 40])
ylabel('density [veh/km]')
title('density')

subplot(3,1,2)
plot(T_vec, z(:,5:8))
hold on
stairs(T_vec, z(:,11),'--', 'LineWidth', 2)
ylim([0, 120])
ylabel('velocity [km/h]')
legend('lane 1', 'lane 2', 'lane 3', 'lane 4', 'V_{SL}')
title('velocity')

subplot(3,1,3)
hold on
yyaxis left
plot(T_vec, z(:,9))
ylim([-0.1, 20 - E_3 + 0.1])
ylabel('queue (veh)')

yyaxis right
ylim([-0.1, 1.1])
stairs(T_vec, z(:,10),'LineWidth', 2)
ylabel('inlet (-)')

legend('queue (w)', 'inlet (r)')
title('queue')
xlabel('time [h]')

saveas(gcf, ['fig', filesep, 'system_state_', case_name], 'epsc');
saveas(gcf, ['fig', filesep, 'system_state_', case_name], 'jpg');

disp([case_name, ': ', num2str(sum(fval))]);
