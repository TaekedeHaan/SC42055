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

% Batery parameters
B = (5+E_1)*10^6;   % Battery cell production/month
B_R = 4E3;          % required cells for model R
B_W = 6E3;          % required cells for model W
B_V = 2*10^3;       % required cells for model V

% Employees at Edison
E = 100 + E_2;      % Available employees
E_h = 160;          % max working hours per employee
C_E = 3000 + 50*E_3;% Monthly salary
E_A = 0:72;         % Additional workers

% Required time to produce model R and W (hours)
T = E*E_h;  % [hr] Available working hours
T_R = 10;   % [hr] Required working hours model R
T_W = 15;   % [hr] Required working hours model W
T_V = 8;    % [hr] Required working hours model V

% Storage space, produced cars ned to be stored for 1 month!
S = (15+E_3)*10^3;  % [m^2] Available space
S_R = 10;           % [m^2] Required space for Model R
S_W = 12;           % [m^2] Required space for Model R
S_V = 8;            % [m^2] Required space for Model R

% Production costs (excluding salaries)
C_R = 30000;    % [eur] Production cost made for model R
C_W = 45000;    % [eur] Production cost made for model W
C_V = 15000; 	% [eur] Production cost made for model V

% Price model R and W
P_R = 55000;    % [eur] Selling price model R
P_W = 75000;    % [eur] Selling price model R
P_V = 45000;    % [eur] Selling price model R

% set optimization otions
options = optimoptions('linprog','Algorithm','dual-simplex','Display','off');

%% question 2
disp('====QUESTION 2====');

% generate materices for optimization
c = -[(P_R-C_R), (P_W-C_W), 0, 0, 0]';
A = [B_R B_W 1 0 0;
     T_R T_W 0 1 0;
     S_R S_W 0 0 1];
b = [B T S]';
lb = [0 0 0 0 0]';
ub = [+Inf +Inf +Inf +Inf +Inf]';

% optimize
x = linprog(c,[], [], A,b,lb,ub, options);

% display results
disp(x)
disp(['profit: ', num2str(-c' * x - C_E * E)]);
%% Question 3
disp('====QUESTION 3====')
Rmax = 1000; % maximum of R sold

% generate materices for optimization
c = -[(P_R-C_R), (P_W-C_W), 0, 0, 0, 0]';
A = [B_R B_W 1 0 0 0;
        T_R T_W 0 1 0 0;
        S_R S_W 0 0 1 0;
        1   0   0 0 0 1];
b = [B T S Rmax]';
lb = [0 0 0 0 0 0]';
ub = [+Inf +Inf +Inf +Inf +Inf +Inf]';

% optimize
x = linprog(c,[], [], A,b,lb,ub, options);

% display result
disp(x)
disp(['profit: ', num2str(-c' * x - C_E * E)]);
%% Question 5
disp('====QUESTION 5====')

% update constants
B = (8 + E_1)*10^6;     % [batterycells/month] Battery production
S = (22 + E_3)*10^3;    % [m^2] storage space
clear x                 % reset x

for i = E_A % loop over possible additional workers
    
    % Update working hours
    E = 100 + E_2 + i;      % total amount of employees
    T_R = 10 - 1/12 * i;    % new manufactoring time R
    T_W = 15 - 1/12 * i;    % new manufactoring time W
    T = E * 160;            % available working hours
    
    % generate matrices for opimization
    c = -[(P_R-C_R), (P_W-C_W), 0, 0, 0, 0]';
    A = [B_R B_W 1 0 0 0;
        T_R T_W 0 1 0 0;
        S_R S_W 0 0 1 0;
        1   0   0 0 0 1];
    b = [B T S Rmax]';
    lb = [0 0 0 0 0 0]';
    ub = [+Inf +Inf +Inf +Inf +Inf +Inf]';

    % optimize
    x(:,i+1) = linprog(c,[], [], A,b,lb,ub, options);
    
    % compute and store profit
    profit(i+1) = -c' * floor(x(:,end)) - C_E * E;
    
end

% display results
[maxProfit, iProfit] = max(profit);
E_A_opt = iProfit - 1; % optimum amount of workers index - 1
disp(['Maximum profit: ', num2str(maxProfit)]);
disp(['Number of aditional workers: ', num2str(E_A_opt)])
disp(x(:, iProfit));

% plot results
figure('position',[500,100,1000,500])
plot(E_A, profit)
xlim([min(E_A), max(E_A)]);
xlabel('Additional employees [-]')
ylabel('Profit [euro]')
saveas(gcf, 'result', 'epsc')

%% Question 6
disp('====QUESTION 6====')
E = 100 + E_2 + E_A_opt; % total amount of employees
T = E * 160;    % available working hours

T_R = 10 - 1/12 * E_A_opt; % new manufactoring time R
T_W = 15 - 1/12 * E_A_opt; % new manufactoring time W

Rmin = 1250;
Wmin = 1000;
Vmin = 1500; % we need at to sell at least 1500 models

% Generate matrices for optimization
c = -[(P_R-C_R), (P_W-C_W), (P_V-C_V), 0, 0, 0, 0, 0, 0]';

A = [B_R,   B_W,    B_V,    1,  0,  0,  0,  0,  0;
    T_R,    T_W,    T_V,    0,  1,  0,  0,  0,  0;
    S_R,    S_W,    S_V,    0,  0,  1,  0,  0,  0;
    1,      0,      0,      0,  0,  0,  -1, 0,  0;
    0,      1,      0,      0,  0,  0,  0,  -1, 0;
    0,      0,      1,      0,  0,  0,  0,  0,  -1];

b = [B T S Rmin, Wmin, Vmin]';
lb = zeros(9,1);
ub = inf(9,1);

% Optimize
x = linprog(c, [], [], A, b, lb, ub, options);

% compute profit
profit = -c' * floor(x) - C_E * E;

% Display results
disp(x);
disp(['Profit with V: ', num2str(profit)]);
%% compute profit without V
% Generate matrices for optimization
c = -[(P_R-C_R), (P_W-C_W), 0, 0, 0, 0, 0]';

A = [B_R,   B_W,    1,  0,  0,  0,  0;
    T_R,    T_W,    0,  1,  0,  0,  0;
    S_R,    S_W,    0,  0,  1,  0,  0;
    1,      0,      0,  0,  0,  -1, 0;
    0,      1,      0,  0,  0,  0,  -1];

b = [B T S Rmin, Wmin]';
lb = zeros(7,1);
ub = inf(7,1);

% optimize
x = linprog(c, [], [], A, b, lb, ub, options);

% compute profit
profit = -c' * floor(x) - C_E * E;

% dsiplay result
disp(x);
disp(['Profit without V: ', num2str(profit)]);