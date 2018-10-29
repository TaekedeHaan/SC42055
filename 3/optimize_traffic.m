function optimize_traffic(z_init, lb, ub, T_vec, case_name)

[E_1, E_2, E_3] = student_id();

% get k
k_vec = 1:length(T_vec);
k_end = k_vec(end);

% reserve memory
x = nan(k_end, 9);
u = nan(k_end, 2);
fval = nan(k_end, 1);

% init
x_init = z_init(1:9);
u_init = z_init(10:11);

%
u(1,:) = u_init;
x(1,:) = x_init;
fval(1) = get_cost(x_init);

% only display in case of non-convergens
% options = optimoptions('fmincon', 'Display', 'notify', 'ConstraintTolerance', 1e-5);
options = optimoptions('ga', 'Display', 'diagnose');
% options = optimoptions('ga','ConstraintTolerance',1e-6,'PlotFcn', @gaplotbestf);

for k = k_vec
   
    % harde beun om gedoe met indexen te voorkomen
    if k == k_end
        break;
    end
    
    % optimization
    f = @(u)opt_func(x(k,:), u, k);
    nonlcon = @(u)opt_con(x(k,:), u, k);
    % [u(k,:), fval(k+1)] = fmincon(f,z_init(10:11),[],[],[],[],lb, ub, nonlcon, options); 
    [u(k,:), fval(k+1)] = ga(f,2,[],[],[],[],lb, ub, nonlcon, options); 
    
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
