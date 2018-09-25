% Meric, 4205558
Da1 = 5;
Da2 = 5;
Da3 = 8;

%Taeke, 4316568
Db1 = 5;
Db2 = 6;
Db3 = 8;

E1 = Da1 + Db1;
E2 = Da2 + Db2;
E3 = Da3 + Db3;

% Maximum monthly Battery cell production
B = (5+E1)*10^6;
B_R = 4E3;
B_W = 6E3;

% Employees at Edison
E = 100 + E2; 
E_h = 160; % max working hours per employee
C_E = 3000 + 50*E3; % Monthly salary (€) independent of hours

% Required time to produce model R and W (hours)
T = E*E_h; % ?????????????
T_R = 10;
T_W = 15;


% Storage space, produced cars ned to be stored for 1 month!
S = (15+E3)*10^3; %available
S_R = 10;         % Required for 1 Model R
S_W = 12;         % Required for 1 Model W

% Production costs (excluding salaries)
C_R = 30000;
C_W = 45000;

% Price model R and W
P_R = 55000;
P_W = 75000;

f = -[-C_E*E_h (P_R-C_R) (P_W-C_W)]'
A = [0 B_R B_W;
     0 T_R T_W;
     0 S_R S_W]
b = [B T S]'
lb = [0 0 0]'
ub = [+Inf +Inf +Inf]'
%atie

f = -[(P_R-C_R) (P_W-C_W)]'
A = [B_R B_W;
     T_R T_W;
     S_R S_W]
b = [B T S]'
lb = [0 0]'
ub = [+Inf +Inf]'

x = linprog(f,A,b,[],[],lb,ub)