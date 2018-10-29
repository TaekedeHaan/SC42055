function y = opt_func(x, u, k)
x_new = metanet(x, u, k);
y = get_cost(x_new);
end