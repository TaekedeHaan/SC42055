function optimize_traffic(x_init, lb, ub, T_vec, case_name)

[E_1, E_2, E_3] = student_id();
global x_k k

% get k
k_vec = 1:length(T_vec);
k_end = k_vec(end);

% reserve memory
x = nan(k_end, 11);
fval = nan(k_end, 1);

% init
x(1,:) = x_init;
fval(1) = opt_func(x(1,:));

% only display in case of non-convergens
options = optimoptions('fmincon', 'Display', 'notify', 'ConstraintTolerance', 1e-5);

for k = k_vec
   
    % harde beun om gedoe met indexen te voorkomen
    if k == k_end
        break;
    end
    x_k = x(k, :);  
    % disp(x_k);
    
    % [Aeq, beq] = get_eq_const(case_name)
    
    % optimization
    [x(k + 1,1:11), fval(k+1)] = fmincon(@opt_func,x_init,[],[],[],[],lb,ub,@opt_con, options); 
end

%% plot
% system state
figure('Position', [200,200,1000,800])
subplot(3,1,1)
plot(T_vec, x(:,1:4))
ylim([0, 40])
ylabel('density [veh/km]')
title('density')

subplot(3,1,2)
plot(T_vec, x(:,5:8))
hold on
plot(T_vec, x(:,11),'--')
ylim([0, 120])
ylabel('velocity [km/h]')
legend('lane 1', 'lane 2', 'lane 3', 'lane 4', 'V_{SL}')
title('velocity')

subplot(3,1,3)
hold on
yyaxis left
plot(T_vec, x(:,9))
ylim([-0.1, 20 - E_3 + 0.1])
ylabel('queue (veh)')

yyaxis right
ylim([-0.1, 1.1])
plot(T_vec, x(:,10))
ylabel('inlet (-)')

legend('queue (w)', 'inlet (r)')
title('queue')
xlabel('time [h]')

saveas(gcf, ['fig', filesep, 'system_state_', case_name], 'epsc');
saveas(gcf, ['fig', filesep, 'system_state_', case_name], 'jpg');

disp([case_name, ': ', num2str(sum(fval))]);
