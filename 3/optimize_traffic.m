function optimize_traffic(x_init, lb, ub, T_vec, case_name)
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
options = optimoptions('fmincon', 'Display', 'notify');

for k = k_vec
    
    % harde beun om gedoe met indexen te voorkomen
    if k == k_end
        break;
    end
    x_k = x(k, :);  
    
    % optimization
    [x(k + 1,1:11), fval(k+1)] = fmincon(@opt_func,x_k,[],[],[],[],lb,ub,@opt_con, options); 
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


saveas(gcf, ['fig', filesep, 'system_state_', case_name], 'epsc');

disp([case_name, ': ', num2str(sum(fval))]);
