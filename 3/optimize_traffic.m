function optimize_traffic(z_init, lb, ub, T_vec, case_name)

lambda = 3; % [-] number of lanes
T = 10/3600; % [h] simlation time step
L = 1; % [km] Length segment

[E_1, E_2, E_3] = student_id();

% get k
k_vec = 1:length(T_vec);
k_end = k_vec(end);

% reserve memory
z = nan(k_end, 11);
fval = nan(k_end, 1);

% init
z(1,:) = [z_init(1:9), nan, nan];
fval(1) = opt_func(z(1,:), lambda, T, L);

% only display in case of non-convergens
options = optimoptions('fmincon', 'Display', 'notify', 'ConstraintTolerance', 1e-5);

for k = k_vec
   
    % harde beun om gedoe met indexen te voorkomen
    if k == k_end
        break;
    end
    
    % optimization
    f = @(x)opt_func(x, lambda, T, L);
    nonlcon = @(x)opt_con(x, z(k,:), k);
    
    [z(k + 1,1:11), fval(k+1)] = fmincon(f,z_init,[],[],[],[],lb, ub, nonlcon, options); 
end

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
plot(T_vec, z(:,11),'--')
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
plot(T_vec, z(:,10))
ylabel('inlet (-)')

legend('queue (w)', 'inlet (r)')
title('queue')
xlabel('time [h]')

saveas(gcf, ['fig', filesep, 'system_state_', case_name], 'epsc');
saveas(gcf, ['fig', filesep, 'system_state_', case_name], 'jpg');

disp([case_name, ': ', num2str(sum(fval))]);
