function y_string = pretify(y)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
% pretif

y_string = string(y);
y_string = strrep(y_string,"*"," \cdot ");
y_string = strrep(y_string,"T_1","\bar{T}_{k+1}");
y_string = strrep(y_string,"T_0","\bar{T}_k");
y_string = strrep(y_string,"a1","a_1");
y_string = strrep(y_string,"a2","a_2");
y_string = strrep(y_string,"dt","\Delta t");

y_string = strrep(y_string,"Q_in","\bar{\dot{Q}}_{k}^{in}");
y_string = strrep(y_string,"Q_out","\bar{\dot{Q}}_{k}^{out}");
y_string = strrep(y_string,"T_amb","\bar{T}_{k}^{amb}");

% correct powers
y_string = strrep(y_string,"\bar{\dot{Q}}_{k}^{in}^2","\left (\bar{\dot{Q}}_{k}^{in}\right )^2");
y_string = strrep(y_string,"\bar{\dot{Q}}_{k}^{out}^2","\left (\bar{\dot{Q}}_{k}^{out}\right )^2");
y_string = strrep(y_string,"\bar{T}_{k}^{amb}^2","\left (\bar{T}_{k}^{amb}\right )^2");

end

