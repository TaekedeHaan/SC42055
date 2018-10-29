function y = opt_func(x, u, k_vec)

y_vec = nan(size(k_vec));

for k = k_vec
    
    y_vec(k) = get_cost(x(k,:));
    
    i_1 = 2*(k-1) + 1;
    i_2 = 2*(k-1) + 2;
    
    x(k+1,:) = metanet(x(k,:), u([i_1, i_2]), k);
end

y = sum(y_vec);