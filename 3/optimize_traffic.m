function fval = optimize_traffic(x_init, u_init, lb, ub, T_vec, case_name)

[E_1, E_2, E_3] = student_id();

% get k
k_vec = 1:length(T_vec);
k_end = k_vec(end);

% reserve memory
x = nan(k_end, 9);
u = nan(k_end, 2);
fval = nan(k_end, 1);

% set initial cond
z_init = [x_init, u_init];
x(1,:) = x_init;
% fval(1) = get_cost(x_init);


lb_k = repmat(lb,1,k_end);
ub_k = repmat(ub,1,k_end);
u_init_k = repmat(u_init, 1, k_end);
z_init_k = repmat(z_init, 1, k_end);

f = @(z)opt_func(z, k_vec);
nonlcon = @(z)opt_con(z, k_vec);

% [c,ceq] = opt_con(z_init_k, k_vec);

% optimization
switch case_name
    case {'4_full_controll', '3_no_ramp_ga'}     
        options = optimoptions('ga', 'Display', 'diagnose');
        [u, fval] = ga(f,11*k_end,[],[],[],[],lb_k, ub_k, nonlcon, options); 
        
    otherwise
        
        % only display in case of non-convergens
        % options = optimoptions('fmincon', 'Display', 'notify', 'ConstraintTolerance', 1e-5, 'MaxFunctionEvaluations', 1e5);
        [u, fval] = fmincon(f,z_init_k,[],[],[],[],lb_k, ub_k, nonlcon);
end


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
grid on
plot(T_vec, z(:,1:4),'LineWidth', 2)
ylim([0, 40])
ylabel('density [veh/km]')
title('density')

subplot(3,1,2)
grid on
plot(T_vec, z(:,5:8),'LineWidth', 2)
hold on
stairs(T_vec, z(:,11),'--', 'LineWidth', 2)
ylim([0, 120])
ylabel('velocity [km/h]')
legend('lane 1', 'lane 2', 'lane 3', 'lane 4', 'V_{SL}')
title('velocity')

subplot(3,1,3)
grid on
hold on
yyaxis left
plot(T_vec, z(:,9),'LineWidth', 2)
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

save(['data', filesep, case_name],'x', 'u', 'fval');