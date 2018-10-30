function fval = opt_func(z, k_vec)

fval_vec = nan(size(k_vec));

for k = k_vec
    
    x_i_start = 11*(k - 1) + 1;
    x_i_end = 11*(k - 1) + 9;
    
    x = z(x_i_start:x_i_end);
    
    fval_vec(k) = get_cost(x);
end

fval = sum(fval_vec);