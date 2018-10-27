function [c, ceq] = opt_con(x)

qr = min([r*Cr, Dr + x(9)/T, Cr * (rho_m - rho_4)/(rho_m - rho_c)]);

% constraints density
ceq(1) = -x(1) + x_prev(1) + T/(lambda*L)*(q0 - lambda*x_prev(1)*x_prev(5));
ceq(2) = -x(2) + x_prev(2) + T/L*(x_prev(1)*x_prev(5) - x_prev(2)*x_prev(6));
ceq(3) = -x(3) + x_prev(3) + T/L*(x_prev(2)*x_prev(6) - x_prev(3)*x_prev(7));
ceq(4) = -x(4) + x_prev(4) + T/L*(x_prev(3)*x_prev(7) - x_prev(4)*x_prev(8) + qr/lambda);

% constraints velocity
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
ceq(5) = -x(5) + x_prev(5) + T/tau * (V(1) - x_prev(5)) + T/L * x_prev(5) * (x_prev(5) - x_prev(5)) - mu*T/(tau*L)*(x_prev(2)-x_prev(1))/(x_prev(1)+K);
ceq(6) = -x(6) + x_prev(6) + T/tau * (V(2) - x_prev(6)) + T/L * x_prev(6) * (x_prev(5) - x_prev(6)) - mu*T/(tau*L)*(x_prev(3)-x_prev(2))/(x_prev(2)+K);
ceq(7) = -x(7) + x_prev(7) + T/tau * (V(3) - x_prev(7)) + T/L * x_prev(7) * (x_prev(6) - x_prev(7)) - mu*T/(tau*L)*(x_prev(4)-x_prev(3))/(x_prev(3)+K);
ceq(8) = -x(8) + x_prev(8) + T/tau * (V(4) - x_prev(8)) + T/L * x_prev(8) * (x_prev(7) - x_prev(8)) - mu*T/(tau*L)*(x_prev(4)-x_prev(4))/(x_prev(4)+K);

% constraints que length
ceq(9) = -x(9) + x_prev(9) + T * (Dr - qr);
=======
ceq(5) = -x_new(5) + x_k(5) + T/tau*(V_k(1) - x_k(5)) - (mu*T)/(tau*L)*(x_k(2) - x_k(1))/(x_k(1) + K);
ceq(6) = -x_new(6) + x_k(6) + T/tau*(V_k(2) - x_k(6)) + T/L*x_k(6)*(x_k(5) - x_k(6)) - (mu*T)/(tau*L)*(x_k(3) - x_k(2))/(x_k(2) + K);
ceq(7) = -x_new(7) + x_k(7) + T/tau*(V_k(3) - x_k(7)) + T/L*x_k(7)*(x_k(6) - x_k(7)) - (mu*T)/(tau*L)*(x_k(4) - x_k(3))/(x_k(3) + K);
ceq(8) = -x_new(8) + x_k(8) + T/tau*(V_k(4) - x_k(8)) + T/L*x_k(8)*(x_k(7) - x_k(8));

% constraints que length
ceq(9) = -x_new(9) + x_k(9) + T*(D_r - q_rk);

c = -1;% always satisfied
>>>>>>> 84cc53cde55ba2a445f6f6bcf2c68981c592bc50
=======
ceq(5) = -x(5) + x_prev(5) + T/tau * (V(1) - x_prev(5)) + T/L * x_prev(5) * ()

% constraints que length
ceq(9) = -x(9) + x_prev(9) + T * (Dr- qr);
>>>>>>> parent of 84cc53c... Things seem to be working
=======
ceq(5) = -x(5) + x_prev(5) + T/tau * (V(1) - x_prev(5)) + T/L * x_prev(5) * ()

% constraints que length
ceq(9) = -x(9) + x_prev(9) + T * (Dr- qr);
>>>>>>> parent of 84cc53c... Things seem to be working
