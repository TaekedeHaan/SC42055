function [c,ceq] = opt_con(x, u, k_vec)
[~, ~, E_3] = student_id();

c = nan(size(k_vec));

for k = k_vec
    
    % constraint
    c(k) =  x(k, 9) - 20 + E_3; % <= 0
    
    i_1 = 2*(k-1) + 1;
    i_2 = 2*(k-1) + 2;
    
    x(k+1,:) = metanet(x(k,:), u([i_1, i_2]), k);
end

ceq = 0; % always satisfies

end